# This script is to clean up after failed E2E tests. It will delete all management groups and resource groups that start with the specified prefix.

# This filter is for safety, replace with the start of the ID for the runs you want to delete without impacting other runs
$filters = @(
  "hashiconf-sub-vending",
  "avm-res-authorization-roleassignment",
  "root-piranha",
  "ox-alz-root",
  "root-raptor",
  "glider-alz-root",
  "Enterprise-Scale",
  "e2e-test-cglccqrhmz",
  "e2e-test-qjiwmwbvos",
  "e2e-test-naoawvutfb",
  "e2e-test-jovacoxblp",
  "lfni1wmu",
  "chitsa1n",
  "e2e-test-maqilulmew",
  "e2e-test-souvvezrrb",
  "e2e-test-brgayempso",
  "e2e-test-fkazvydndn",
  "e2e-test-iwzoqxfiem",
  "e2e-test-dgelbtarrb",
  "e2e-test-xonfqgboql",
  "e2e-test-zudkugieeh",
  "e2e-test-xrimnnxetj",
  "e2e-test-dolljzkxks",
  "e2e-test-itpfuivnul",
  "e2e-test-btkidndxld",
  "e2e-test-bmsnfwyndx",
  "e2e-test-fpyyjsoezi",
  "e2e-test-eyxyknxygb",
  "e2e-test-ggjqinnmrk",
  "e2e-test-nhikgbadoj",
  "e2e-test-szjhjphmrl",
  "e2e-test-iwqprsfoyd",
  "e2e-test-zhaqsxqpum",
  "e2e-test-qyhevrhnsc",
  "e2e-test-aboemjacou",
  "e2e-test-yneiwxhxhe",
  "e2e-test-cvbvqgdbhg",
  "e2e-test-ypxltbdaut",
  "e2e-test-kuhlucteus",
  "e2e-test-ndrmevzfyf",
  "e2e-test-awlpgjfsvt",
  "e2e-test-bfnbkdvmjj",
  "e2e-test-grefiddptu",
  "e2e-test-sbxcwcofnj",
  "e2e-test-mvhsgubssj",
  "e2e-test-gmhvwmmqvo",
  "e2e-test-founxmcuwn",
  "e2e-test-dtkrmutwra",
  "e2e-test-xjnthpqklb",
  "e2e-test-lqyhicoayr",
  "e2e-test-duryevxfel",
  "e2e-test-argamdfiqj",
  "e2e-test-ukpdxvaliy",
  "e2e-test-kipowtjurw",
  "e2e-test-zdrmobmnnt",
  "e2e-test-ygsanqrukh",
  "e2e-test-lnxuqkarxh",
  "e2e-test-wuqveboblb",
  "e2e-test-zosuwckpgl",
  "e2e-test-qbrejtkiot",
  "e2e-test-mlbpdnozrb",
  "e2e-test-upjqcxazim",
  "e2e-test-zqdeubombs",
  "e2e-test-yvrlujqnrt",
  "e2e-test-ubaifeijmd",
  "e2e-test-oabmyzefgi",
  "e2e-test-atsuctrcql",
  "e2e-test-atnodnredf",
  "e2e-test-otzrsisddf",
  "e2e-test-zvayuisakl",
  "e2e-test-illrlfkonj",
  "n5itwyk7",
  "bfz9e4la"
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
