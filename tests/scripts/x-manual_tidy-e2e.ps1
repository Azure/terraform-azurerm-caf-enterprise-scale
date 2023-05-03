# This script is to clean up after failed E2E tests. It will delete all management groups and resource groups that start with the specified prefix.

# This filter is for safety, replace with the start of the ID for the runs you want to delete without impacting other runs
$filters = @(
    "463u20kp",
    "8zdf1q2o",
    "9mpgz7qk",
    "pxrhm8ks"
)

Write-Information "Deleting Management Groups" -InformationAction Continue

foreach($filter in $filters)
{
    Write-Information "Finding management groups for $filter" -InformationAction Continue
    $entities = az account management-group entities list | ConvertFrom-Json
    $managementGroups = $entities | Where-Object { $_.type -eq "Microsoft.Management/managementGroups" -and $_.name.StartsWith($filter) }

    Write-Information "Found $($managementGroups.Length) management groups for $filter" -InformationAction Continue

    while($managementGroups.Count -gt 0)
    {
        foreach( $managementGroup in $managementGroups | Where-Object { $_.numberOfChildGroups -eq 0 })
        {
            if($managementGroup.displayName -ne "Tenant Root Group")
            {
                if($managementGroup.numberOfChildren -gt 0)
                {
                    foreach($child in $entities | Where-Object { $_.parent.id -eq $managementGroup.id })
                    {
                        Write-Information "Moving Subscription $($child.displayName)" -InformationAction Continue
                        az account management-group subscription remove --name $managementGroup.name  --subscription $child.name
                    }
                }

                Write-Information "Deleting management group $($managementGroup.displayName)" -InformationAction Continue
                az account management-group delete --name $managementGroup.name
            }
        }

        $entities = az account management-group entities list | ConvertFrom-Json
        $managementGroups = $entities | Where-Object { $_.type -eq "Microsoft.Management/managementGroups" -and $_.name.StartsWith($filter) }
    }
}

foreach($filter in $filters)
{
    $subscriptions = @(
        "csu-tf-connectivity-1",
        "csu-tf-connectivity-2",
        "csu-tf-connectivity-3",
        "csu-tf-connectivity-4",
        "csu-tf-management-1",
        "csu-tf-management-2",
        "csu-tf-management-3",
        "csu-tf-management-4"
    )

    foreach($sub in $subscriptions)
    {
        az account set --subscription $sub
        $rgs = az group list | ConvertFrom-Json | Where-Object { $_.name.StartsWith($filter) }

        foreach($rg in $rgs)
        {
            Write-Information "Deleting resource group $($rg.name) from subscription $sub" -InformationAction Continue
            az group delete --resource-group $rg.name --yes --no-wait
        }
    }
}
