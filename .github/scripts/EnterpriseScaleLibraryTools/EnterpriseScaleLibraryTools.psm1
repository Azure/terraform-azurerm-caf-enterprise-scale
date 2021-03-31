#!/usr/bin/pwsh

#########################################
# Module dependencies and configuration #
#########################################

$ErrorActionPreference = "Stop"
# Set-StrictMode -Version 3.0
[System.Version]$azAccountsVersion = "2.2.3"

$module = Get-Module Az.Accounts
if ($null -ne $module -and $module.Version -lt $azAccountsVersion) {
    Write-Error "This module requires Az.Accounts version $azAccountsVersion. An earlier version of Az.Accounts is imported in the current PowerShell session. Please open a new session before importing this module. This error could indicate that multiple incompatible versions of the Azure PowerShell cmdlets are installed on your system. Please see https://aka.ms/azps-version-error for troubleshooting information." -ErrorAction Stop
}
elseif ($null -eq $module) {
    Import-Module Az.Accounts -MinimumVersion $azAccountsVersion -Scope Global
}

############################################
# Custom enum data sets used within module #
############################################

enum PolicyDefinitionPropertiesMode {
    All
    Indexed
}

enum PolicyAssignmentPropertiesEnforcementMode {
    Default
    DoNotEnforce
}

enum PolicyAssignmentIdentityType {
    None
    SystemAssigned
}

enum PolicySetDefinitionPropertiesPolicyType {
    NotSpecified
    BuiltIn
    Custom
    Static
}

enum GetFileNameCaseModifier {
    ToString
    ToLower
    ToUpper
}

################################
# Variables used within module #
################################

[Int]$jsonDepth = 100

[Regex]$regex_schema_deploymentParameters = "http[s]?:\/\/schema\.management\.azure\.com\/schemas\/([0-9-]{10})\/deploymentParameters\.json#"
[Regex]$regex_schema_managementGroupDeploymentTemplate = "http[s]?:\/\/schema\.management\.azure\.com\/schemas\/([0-9-]{10})\/managementGroupDeploymentTemplate\.json#"
[Regex]$regex_doubleLeftSquareBrace = "(?<=`")(\[\[)"

#############################
# ProviderApiVersions Class #
#############################

# [ProviderApiVersions] class is used to create cache of latest API versions for all Azure Providers.
# This can be used to retrieve the latest or stable API version in string format.
# Can also output the API version as a param string for use within a Rest API request.
# To minimise the number of Rest API requests needed, this class creates a cache and populates.
# it with all results from the request. The cache is then used to return the requested result.
# Need to store and lookup the key in lowercase to avoid case sensitivity issues while providing
# better performance as allows using ContainsKey method to search for key in cache.
# Should be safe to ignore case as Providers are not case sensitive.
class ProviderApiVersions {

    # Public class properties
    [String]$Provider
    [String]$ResourceType
    [String]$Type
    [Array]$ApiVersions

    # Static properties
    hidden static [String]$ProvidersApiVersion = "2020-06-01"

    # Default empty constructor
    ProviderApiVersions() {
    }

    # Default constructor using PSCustomObject to populate object
    ProviderApiVersions([PSCustomObject]$PSCustomObject) {
        $this.Provider = $PSCustomObject.Provider
        $this.ResourceType = $PSCustomObject.ResourceType
        $this.Type = $PSCustomObject.Type
        $this.ApiVersions = $PSCustomObject.ApiVersions
    }

    # Static method to get Api Version using Type
    static [Array] GetByType([String]$Type) {
        if ([ProviderApiVersions]::Cache.Count -lt 1) {
            [ProviderApiVersions]::UpdateCache()
        }
        $private:ProviderApiVersionsFromCache = [ProviderApiVersions]::SearchCache($Type)
        return $private:ProviderApiVersionsFromCache.ApiVersions
    }

    # Static method to get latest Api Version using Type
    static [String] GetLatestByType([String]$Type) {
        $private:GetLatestByType = [ProviderApiVersions]::GetByType($Type) |
        Sort-Object -Descending |
        Select-Object -First 1
        return $private:GetLatestByType
    }

    # Static method to get latest stable Api Version using Type
    # If no stable release, will return latest
    static [String] GetLatestStableByType([String]$Type) {
        $private:GetByType = [ProviderApiVersions]::GetByType($Type)
        $private:GetLatestStableByType = $private:GetByType |
        Where-Object { $_ -Match "^[0-9-]{10}$" } |
        Sort-Object -Descending |
        Select-Object -First 1
        if ($private:GetLatestStableByType) {
            return $private:GetLatestStableByType.ToString()
        }
        else {
            return [ProviderApiVersions]::GetLatestByType($Type).ToString()
        }
    }

    static [String[]] ListTypes() {
        if ([ProviderApiVersions]::Cache.Count -lt 1) {
            [ProviderApiVersions]::UpdateCache()
        }
        $private:ShowCacheTypes = [ProviderApiVersions]::ShowCache().Type | Sort-Object
        return $private:ShowCacheTypes
    }

    # Static property to store cache of ProviderApiVersions using a threadsafe
    # dictionary variable to allow caching across parallel jobs
    # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object#example-14--using-thread-safe-variable-references
    static [System.Collections.Concurrent.ConcurrentDictionary[String, ProviderApiVersions]]$Cache

    # Static method to show all entries in Cache
    static [ProviderApiVersions[]] ShowCache() {
        return ([ProviderApiVersions]::Cache).Values
    }

    # Static method to show all entries in Cache matching the specified type using the specified release type
    static [ProviderApiVersions[]] SearchCache([String]$Type) {
        return [ProviderApiVersions]::Cache[$Type.ToString().ToLower()]
    }

    # Static method to return [Boolean] for Resource Type in Cache query using the specified release type
    static [Boolean] InCache([String]$Type) {
        if ([ProviderApiVersions]::Cache) {
            $private:CacheKeyLowercase = $Type.ToString().ToLower()
            $private:InCache = ([ProviderApiVersions]::Cache).ContainsKey($private:CacheKeyLowercase)
            if ($private:InCache) {
                Write-Verbose "[ProviderApiVersions] Resource Type found in Cache [$Type]"
            }
            else {
                Write-Verbose "[ProviderApiVersions] Resource Type not found in Cache [$Type]"
            }
            return $private:InCache
        }
        else {
            # The following prevents needing to initialize the cache
            # manually if not exist on first attempt to use
            [ProviderApiVersions]::InitializeCache()
            return $false
        }
    }

    # Static method to update Cache using current Subscription from context
    static [Void] UpdateCache() {
        $private:SubscriptionId = (Get-AzContext).Subscription.Id
        [ProviderApiVersions]::UpdateCache($private:SubscriptionId)
    }

    # Static method to update Cache using specified SubscriptionId
    static [Void] UpdateCache([String]$SubscriptionId) {
        $private:Method = "GET"
        $private:Path = "/subscriptions/$subscriptionId/providers?api-version=$([ProviderApiVersions]::ProvidersApiVersion)"
        $private:PSHttpResponse = Invoke-AzRestMethod -Method $private:Method -Path $private:Path
        $private:PSHttpResponseContent = $private:PSHttpResponse.Content
        $private:Providers = ($private:PSHttpResponseContent | ConvertFrom-Json).value
        if ($private:Providers) {
            [ProviderApiVersions]::InitializeCache()
        }
        foreach ($private:Provider in $private:Providers) {
            Write-Verbose "[ProviderApiVersions] Processing Provider Namespace [$($private:Provider.namespace)]"
            foreach ($private:Type in $private:Provider.resourceTypes) {
                # Check for latest ApiVersions and add to cache
                [ProviderApiVersions]::AddToCache(
                    $private:Provider.namespace.ToString(),
                    $private:Type.resourceType.ToString(),
                    $private:Type.ApiVersions
                )
            }
        }
    }

    # Static method to add provider instance to Cache
    hidden static [Void] AddToCache([String]$Provider, [String]$ResourceType, [Array]$ApiVersions) {
        Write-Debug "[ProviderApiVersions] Adding [$($Provider)/$($ResourceType)] to Cache"
        $private:AzStateProviderObject = [PsCustomObject]@{
            Provider     = "$Provider"
            ResourceType = "$ResourceType"
            Type         = "$Provider/$ResourceType"
            ApiVersions  = $ApiVersions
        }
        $private:CacheKey = "$Provider/$ResourceType"
        $private:CacheKeyLowercase = $private:CacheKey.ToString().ToLower()
        $private:CacheValue = [ProviderApiVersions]::new($private:AzStateProviderObject)
        $private:TryAdd = ([ProviderApiVersions]::Cache).TryAdd($private:CacheKeyLowercase, $private:CacheValue)
        if ($private:TryAdd) {
            Write-Verbose "[ProviderApiVersions] Added Resource Type to Cache [$private:CacheKey]"
        }
    }

    # Static method to initialize Cache
    # Will also reset cache if exists
    static [Void] InitializeCache() {
        Write-Verbose "[ProviderApiVersions] Initializing Cache (Empty)"
        [ProviderApiVersions]::Cache = [System.Collections.Concurrent.ConcurrentDictionary[String, ProviderApiVersions]]::new()
    }

    # Static method to clear all entries from Cache
    static [Void] ClearCache() {
        [ProviderApiVersions]::InitializeCache()
    }

    # Static method to save all entries from Cache to filesystem
    static [Void] SaveCacheToDirectory() {
        [ProviderApiVersions]::SaveCacheToDirectory("./")
    }

    # Static method to save all entries from Cache to filesystem
    static [Void] SaveCacheToDirectory([String]$Directory) {
        if ([ProviderApiVersions]::Cache.Count -lt 1) {
            [ProviderApiVersions]::UpdateCache()
        }
        $private:saveCachePath = "$Directory/ProviderApiVersions"
        [ProviderApiVersions]::Cache |
        ConvertTo-Json -Depth 10 -Compress |
        Out-File -FilePath "$($private:saveCachePath).json" `
            -Force
        try {
            Compress-Archive -Path "$($private:saveCachePath).json" `
                -DestinationPath "$($private:saveCachePath).zip" `
                -Force
        }
        finally {
            Remove-Item -Path "$($private:saveCachePath).json" `
                -Force
        }
    }

    # Static method to load all entries from filesystem to Cache
    static [Void] LoadCacheFromDirectory() {
        [ProviderApiVersions]::LoadCacheFromDirectory("./")
    }

    # Static method to load all entries from filesystem to Cache
    static [Void] LoadCacheFromDirectory([String]$Directory) {
        [ProviderApiVersions]::ClearCache()
        $private:loadCachePath = "$Directory/ProviderApiVersions"
        Expand-Archive -Path "$($private:loadCachePath).zip" `
            -DestinationPath "$Directory" `
            -Force
        try {
            $private:loadCacheObject = Get-Content `
                -Path "$($private:loadCachePath).json" `
                -Force |
            ConvertFrom-Json
            foreach ($key in $private:loadCacheObject.psobject.Properties.Name) {
                $private:value = $private:loadCacheObject."$key"
                ([ProviderApiVersions]::Cache).TryAdd($key, $private:value)
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
        finally {
            Remove-Item -Path "$($private:loadCachePath).json" `
                -Force
        }
    }

}

class ESLTBase : System.Collections.Specialized.OrderedDictionary {

    ESLTBase(): base() {}

    [String] ToString() {
        if ($this.GetType() -notin "String", "Boolean", "Int") {
            return $this | ConvertTo-Json -Depth 1 -WarningAction SilentlyContinue | ConvertFrom-Json
        }
        else {
            return $this
        }
    }

}

class PolicyAssignmentProperties : ESLTBase {
    [String]$displayName = ""
    [Object]$policyDefinitionId = ""
    [String]$scope = ""
    [String[]]$notScopes = @()
    [Object]$parameters = @{}
    [String]$description = ""
    [Object]$metadata = @{}
    [String]$enforcementMode = "Default"

    PolicyAssignmentProperties(): base() {}

    PolicyAssignmentProperties([Object]$that): base() {
        $this.displayName = $that.displayName
        $this.policyDefinitionId = $that.policyDefinitionId
        $this.scope = $that.scope
        $this.notScopes = $that.notScopes ?? $this.notScopes
        $this.parameters = $that.parameters ?? $this.parameters
        $this.description = $that.description ?? $that.displayName
        $this.metadata = $that.metadata ?? $this.metadata
        $this.enforcementMode = ([PolicyAssignmentPropertiesEnforcementMode]($that.enforcementMode ?? $this.enforcementMode)).ToString()
    }

}

class PolicyAssignmentIdentity : ESLTBase {
    [String]$type = "None"

    PolicyAssignmentIdentity(): base() {}

    PolicyAssignmentIdentity([Object]$that): base() {
        $this.type = ([PolicyAssignmentIdentityType]($that.type ?? $this.type)).ToString()
    }

}

class PolicyDefinitionProperties : ESLTBase {
    [String]$policyType = "NotSpecified"
    [String]$mode = ""
    [String]$displayName = ""
    [String]$description = ""
    [Object]$metadata = @{}
    [Object]$parameters = @{}
    [Object]$policyRule = @{}

    PolicyDefinitionProperties(): base() {}

    PolicyDefinitionProperties([Object]$that): base() {
        $this.policyType = ([PolicySetDefinitionPropertiesPolicyType]($that.policyType ?? $this.policyType)).ToString()
        $this.mode = ([PolicyDefinitionPropertiesMode]($that.mode)).ToString()
        $this.displayName = $that.displayName
        $this.description = $that.description ?? $that.displayName
        $this.metadata = $that.metadata ?? $this.metadata
        $this.parameters = $that.parameters ?? $this.parameters
        $this.policyRule = $that.policyRule
    }

}

class PolicySetDefinitionPropertiesPolicyDefinitions : ESLTBase {
    [String]$policyDefinitionReferenceId = ""
    [String]$policyDefinitionId = ""
    [Object]$parameters = @{}
    [Array]$groupNames = @()

    PolicySetDefinitionPropertiesPolicyDefinitions(): base() {}

    PolicySetDefinitionPropertiesPolicyDefinitions([Object]$that): base() {
        $this.policyDefinitionReferenceId = $that.policyDefinitionReferenceId
        $this.policyDefinitionId = $that.policyDefinitionId
        $this.parameters = $that.parameters ?? $this.parameters
        $this.groupNames = $that.groupNames ?? $this.groupNames
    }

}

class PolicySetDefinitionPropertiesPolicyDefinitionGroup : ESLTBase {
    [String]$name = ""
    [String]$displayName = ""
    [String]$category = ""
    [String]$description = ""
    [String]$additionalMetadataId = ""

    PolicySetDefinitionPropertiesPolicyDefinitionGroup(): base() {}

    PolicySetDefinitionPropertiesPolicyDefinitionGroup([Object]$that): base() {
        $this.name = $that.name
        $this.displayName = $that.displayName
        $this.category = $that.category
        $this.description = $that.description
        $this.additionalMetadataId = $that.additionalMetadataId
    }

}

class PolicySetDefinitionProperties : ESLTBase {
    [String]$policyType = "NotSpecified"
    [String]$displayName = ""
    [String]$description = ""
    [Object]$metadata = @{}
    [Object]$parameters = @{}
    [Array]$policyDefinitions = @()
    [Array]$policyDefinitionGroups = $null

    PolicySetDefinitionProperties(): base() {}

    PolicySetDefinitionProperties([Object]$that): base() {
        $this.policyType = ([PolicySetDefinitionPropertiesPolicyType]($that.policyType ?? $this.policyType)).ToString()
        $this.displayName = $that.displayName ?? ""
        $this.description = $that.description ?? $that.displayName
        $this.metadata = $that.metadata ?? $this.metadata
        $this.parameters = $that.parameters ?? $this.parameters
        $this.policyDefinitions = foreach ($policyDefinition in $that.policyDefinitions) {
            [PolicySetDefinitionPropertiesPolicyDefinitions]::new($policyDefinition)
        }
        $this.policyDefinitionGroups = foreach ($policyDefinitionGroup in $that.policyDefinitionGroups) {
            [PolicySetDefinitionPropertiesPolicyDefinitionGroup]::new($that.policyDefinitionGroups)
        }
    }

}

class RoleAssignmentProperties : ESLTBase {
    RoleAssignmentProperties(): base() {}
}

class RoleDefinitionPropertiesPermissions {
    [String[]]$actions = @()
    [String[]]$notActions = @()
    [String[]]$dataActions = @()
    [String[]]$notDataActions = @()

    RoleDefinitionPropertiesPermissions(): base() {}

    RoleDefinitionPropertiesPermissions([Object]$that): base() {
        $this.actions = $that.actions ?? $this.actions
        $this.notActions = $that.notActions ?? $that.notActions
        $this.dataActions = $that.dataActions ?? $this.dataActions
        $this.notDataActions = $that.notDataActions ?? $this.notDataActions
    }

}

class RoleDefinitionProperties : ESLTBase {
    [String]$roleName = ""
    [String]$description = ""
    [String]$type = "customRole"
    [Array]$permissions = @()
    [Array]$assignableScopes = @()

    RoleDefinitionProperties(): base() {}

    RoleDefinitionProperties([Object]$that): base() {
        $this.roleName = $that.roleName
        $this.description = $that.description ?? $that.roleName
        $this.type = $that.type ?? $this.type
        $this.permissions = @(
            [PolicyAssignmentIdentity]::new($that.permissions[0])
        )
        $this.assignableScopes = $that.assignableScopes ?? $this.assignableScopes
    }

}

class ArmTemplateResource : ESLTBase {

    # Public class properties
    # Need to declare base object properties with default values to set order
    [String]$name = ""
    [String]$type = ""
    [String]$apiVersion = ""
    [Object]$scope = $null # Needs to be declared as object to avoid null returning empty string in JSON output
    [Object]$properties = @{}

    # Hidden static class properties
    hidden static [GetFileNameCaseModifier]$GetFileNameCaseModifier = "ToLower" # Default to make lowercase
    hidden static [Regex]$regexReplaceFileNameCharacters = "\W" # Default to replace all non word characters
    hidden static [String]$GetFileNameSubstituteCharacter = "_"
    hidden static [Regex]$regexExtractProviderId = "\/providers\/(?!.*\/providers\/)[\/\w-.]+"

    ArmTemplateResource(): base() {}

    ArmTemplateResource([PSCustomObject]$that): base() {
        $this.name = $that.name
        $this.type = $that.ResourceType ?? $that.type
        $this.apiVersion = $that.apiVersion
        $this.scope = if ($that.scope.Length -gt 0) { $that.scope } else { $null }
        $this.properties = $that.properties
    }

    # Initialize [ArmTemplateResource] object
    [Void] SetApiVersion([String]$ResourceType) {
        $this.apiVersion = [ProviderApiVersions]::GetLatestStableByType($ResourceType)
    }

    # Update resource values as per requirements for Terraform Module
    # for Cloud Adoption Framework Enterprise Scale
    [Object] ToTemplateFile() {
        if ($this.type -eq "Microsoft.Authorization/policyAssignments") {
            $this.properties.scope = "`${current_scope_resource_id}"
            $this.properties.policyDefinitionId = "`${root_scope_resource_id}/"
            $this.location = "`${default_location}"
        }
        if ($this.type -eq "Microsoft.Authorization/policyDefinitions") {
            $this.properties.policyType = "Custom"
        }
        if ($this.type -eq "Microsoft.Authorization/policySetDefinitions") {
            $this.properties.policyType = "Custom"
            foreach ($policyDefinition in $this.properties.policyDefinitions) {
                $regexMatches = [ArmTemplateResource]::regexExtractProviderId.Matches($policyDefinition.policyDefinitionId)
                if ($regexMatches.Index -gt 0) {
                    $policyDefinition.policyDefinitionId = "`${root_scope_resource_id}$($regexMatches.Value)"
                }
                else {
                    $policyDefinition.policyDefinitionId = $regexMatches.Value
                }
            }
        }
        return $this
    }

    [String] GetFileName() {
        $fileName = $this.GetFileName("")
        return $fileName
    }

    [String] GetFileName([String]$Prefix) {
        $fileNameBase = $this.name.$([ArmTemplateResource]::GetFileNameCaseModifier)()
        $fileNameBase = [ArmTemplateResource]::regexReplaceFileNameCharacters.Replace($fileNameBase, [ArmTemplateResource]::GetFileNameSubstituteCharacter)
        $fileName = $Prefix + $fileNameBase
        return $fileName
    }

}

class PolicyAssignment : ArmTemplateResource {

    # Need to re-declare base object properties with default values to maintain order
    [String]$name = ""
    [String]$type = ""
    [String]$apiVersion = ""
    [String]$scope = ""
    [Object]$properties = @{}
    [String]$location = ""
    [Object]$identity = @{}

    PolicyAssignment(): base() {}

    PolicyAssignment([PSCustomObject]$that): base($that) {
        $this.type = "Microsoft.Authorization/policyAssignments"
        $this.SetApiVersion($this.type)
        $this.location = $that.location
        $this.identity = [PolicyAssignmentIdentity]::new($that.identity)
        $this.properties = [PolicyAssignmentProperties]::new($this.properties)
    }

}

class PolicyDefinition : ArmTemplateResource {

    PolicyDefinition(): base() {}

    PolicyDefinition([PSCustomObject]$that): base($that) {
        $this.type = "Microsoft.Authorization/policyDefinitions"
        $this.SetApiVersion($this.type)
        $this.properties = [PolicyDefinitionProperties]::new($this.properties)
    }

}

class PolicySetDefinition : ArmTemplateResource {

    PolicySetDefinition(): base() {}

    PolicySetDefinition([PSCustomObject]$that): base($that) {
        $this.type = "Microsoft.Authorization/policySetDefinitions"
        $this.SetApiVersion($this.type)
        $this.properties = [PolicySetDefinitionProperties]::new($this.properties)
    }

}

class RoleAssignment : ArmTemplateResource {

    RoleAssignment(): base() {}

    RoleAssignment([PSCustomObject]$that): base($that) {
        $this.type = "Microsoft.Authorization/roleAssignments"
        $this.SetApiVersion($this.type)
        $this.properties = [RoleAssignmentProperties]::new($this.properties)
    }
}

class RoleDefinition : ArmTemplateResource {

    RoleDefinition(): base() {}

    RoleDefinition([PSCustomObject]$that): base($that) {
        $this.type = "Microsoft.Authorization/roleDefinitions"
        $this.SetApiVersion($this.type)
        $this.properties = [RoleDefinitionProperties]::new($this.properties)
    }

}


function ProcessObjectByResourceType {
    [CmdletBinding()]
    [OutputType([Object])]
    param (
        [Object]$ResourceObject,
        [String]$ResourceType
    )
    try {
        switch ($ResourceType.ToLower()) {
            "microsoft.authorization/policyassignments" {
                $outputObject = [PolicyAssignment]::new($ResourceObject)
            }
            "microsoft.authorization/policydefinitions" {
                $outputObject = [PolicyDefinition]::new($ResourceObject)
            }
            "microsoft.authorization/policysetdefinitions" {
                $outputObject = [PolicySetDefinition]::new($ResourceObject)
            }
            "microsoft.authorization/roleassignments" {
                $outputObject = [RoleAssignment]::new($ResourceObject)
            }
            "microsoft.authorization/roledefinitions" {
                $outputObject = [RoleDefinition]::new($ResourceObject)
            }
            Default {
                Write-Warning "Unsupported resource type: $($ResourceType)"
                $outputObject = $ResourceObject
            }
        }
    }
    catch [System.Management.Automation.RuntimeException] {
        Write-Error $_.Exception.Message
    }

    return $outputObject

}

function RemoveEscaping {
    [CmdletBinding()]
    param (
        [Object]$InputObject
    )

    # A number of sources store the required definition in variables
    # which use escaping for ARM functions so they are correctly
    # processed within copy_loops. These may need to be removed when
    # converting to a native ARM template.
    $output = $InputObject |
    ConvertTo-Json -Depth $jsonDepth |
    ForEach-Object { $_ -replace $regex_doubleLeftSquareBrace, "[" } |
    ConvertFrom-Json

    return $output
}

function GetObjectByResourceTypeFromJson {
    [CmdletBinding()]
    [OutputType([Object])]
    param (
        [String]$Id,
        [String[]]$InputJSON
    )

    # Try catch is used to gracefully handle type conversion errors when the input contains invalid JSON
    try {
        $objectFromJson = $InputJSON | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw $_.Exception.Message
    }

    # The following block handles processing files in the format generated by the AzOps output
    # e.g. azopsreference/ folder in Azure/Enterprise-Scale repository
    if ($regex_schema_deploymentParameters.IsMatch($objectFromJson."`$schema")) {
        if ($objectFromJson.parameters.input.value.ResourceType) {
            ProcessObjectByResourceType `
                -ResourceObject ($objectFromJson.parameters.input.value) `
                -ResourceType ($objectFromJson.parameters.input.value.ResourceType)
        }
    }
    # The following block handles processing files in the format used by the ES reference deployments
    # e.g. docs/reference/<scenario>/armTemplates/auxiliary/ folder in Azure/Enterprise-Scale repository
    elseif ($regex_schema_managementGroupDeploymentTemplate.IsMatch($objectFromJson."`$schema")) {
        foreach ($policyDefinition in $objectFromJson.variables.policies.policyDefinitions) {
            ProcessObjectByResourceType `
                -ResourceObject (RemoveEscaping -InputObject $policyDefinition) `
                -ResourceType ("Microsoft.Authorization/policyDefinitions")
        }
        foreach ($policySetDefinition in $objectFromJson.variables.initiatives.policySetDefinitions) {
            ProcessObjectByResourceType `
                -ResourceObject (RemoveEscaping -InputObject $policySetDefinition) `
                -ResourceType ("Microsoft.Authorization/policySetDefinitions")
        }
    }
    # The following block handles processing generic files where the source content is unknown
    # High probability of incorrect format if this happens.
    else {
        Write-Warning "Unable to find converter for input object: $Id"
        # return $objectFromJson
    }

}

function ProcessFile {
    [CmdletBinding()]
    param (
        [String]$FilePath
    )

    $content = Get-Content -Path $FilePath

    $output = GetObjectByResourceTypeFromJson `
        -Id $FilePath `
        -InputJSON $content

    return $output
}

function Invoke-UseCacheFromModule {
    param (
        [String]$Directory = "./"
    )
    [ProviderApiVersions]::LoadCacheFromDirectory($Directory)
}

function ConvertTo-LibraryArtifact {
    [CmdletBinding()]
    param (
        [String[]]$InputPath,
        [String]$InputFilter = "*.json",
        [String]$OutputPath = "./",
        [String]$FileNamePrefix = "",
        [String]$FileNameSuffix = ".json",
        [Switch]$AsTemplate,
        [Switch]$Recurse
    )
    $inputFiles = foreach ($path in $InputPath) {
        Get-ChildItem -Path $path -Recurse:$Recurse -Filter $InputFilter
    }

    [Object[]]$outputItems = foreach ($inputFile in $inputFiles) {
        $content = ProcessFile `
            -FilePath $inputFile.FullName
        foreach ($item in $content | Where-Object { $_ }) {
            [PSCustomObject]@{
                InputFilePath  = $inputFile.FullName
                OutputFilePath = ($OutputPath + "/" + $item.GetFileName($FileNamePrefix) + $FileNameSuffix) -replace "//", "/"
                OutputTemplate = $AsTemplate ? $item.ToTemplateFile() : $item
            }
        }
    }

    return $outputItems

}

function Export-LibraryArtifact {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [String[]]$InputPath,
        [String]$InputFilter = "*.json",
        [String[]]$TypeFilter = @(),
        [String]$OutputPath = "./",
        [String]$FileNamePrefix = "",
        [String]$FileNameSuffix = ".json",
        [Switch]$AsTemplate,
        [Switch]$Recurse
    )

    $libraryArtifacts = ConvertTo-LibraryArtifact `
        -InputPath $InputPath `
        -InputFilter $InputFilter `
        -OutputPath $OutputPath `
        -FileNamePrefix $FileNamePrefix `
        -FileNameSuffix $FileNameSuffix `
        -AsTemplate:$AsTemplate `
        -Recurse:$Recurse

    if ($TypeFilter.Length -eq 0) {
        Write-Verbose "Using default TypeFilter. Will process all valid resource types."
        $TypeFilter = [ProviderApiVersions]::ListTypes()
    }
    else {
        Write-Verbose "Using custom TypeFilter. Will process the following resource types:`n $($TypeFilter.foreach({" - " + $_ +"`n"}))"
    }

    foreach ($libraryArtifact in $libraryArtifacts) {
        $libraryArtifactMessage = ("Processing file... `n" + `
                " - Input  : $($libraryArtifact.InputFilePath) `n" + `
                " - Output : $($libraryArtifact.OutputFilePath)")

        if ($libraryArtifact.OutputTemplate.type -in $TypeFilter) {
            if ($PSCmdlet.ShouldProcess($libraryArtifact.OutputFilePath)) {
                $libraryArtifactFile = $libraryArtifact.OutputTemplate |
                ConvertTo-Json -Depth $jsonDepth |
                New-Item -Path $libraryArtifact.OutputFilePath -ItemType File -Force
                $libraryArtifactMessage += "`n [COMPLETE]"
                Write-Verbose $libraryArtifactMessage
                Write-Information "Output File : $($libraryArtifactFile.FullName) [COMPLETE]" -InformationAction Continue
            }
        }
        else {
            $libraryArtifactMessage += "`n [SKIPPING] Resource Type not in TypeFilter."
            Write-Verbose $libraryArtifactMessage
        }
    }
}

# Create alias(es) for Functions
# New-Alias -Name "example" -Value "Invoke-ExampleFunction"

$aliasesToExport = @()
$functionsToExport = @(
    "ConvertTo-LibraryArtifact"
    "Export-LibraryArtifact"
    "Invoke-UseCacheFromModule"
)

# Export module members
Export-ModuleMember -Function $functionsToExport -Alias $aliasesToExport
