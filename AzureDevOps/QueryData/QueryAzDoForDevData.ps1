# https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work-items/list?view=azure-devops-rest-5.0
# Query by WIQL: https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/wiql/query-by-wiql?view=azure-devops-server-rest-5.0'
# WIQL syntax: https://docs.microsoft.com/en-us/azure/devops/boards/queries/wiql-syntax?toc=%2Fvsts%2Fwork%2Ftrack%2Ftoc.json&bc=%2Fvsts%2Fwork%2Ftrack%2Fbreadcrumb%2Ftoc.json&view=azure-devops&viewFallbackFrom=azure-devops-server-rest-5.0
# Expand: https://docs.microsoft.com/en-us/rest/api/azure/devops/wit/work-items/list?view=azure-devops-rest-5.0#workitemexpand
param(
    #[Parameter(Mandatory=$true)]
    [string] $azDoUrl = 'TO DO',

    #[Parameter(Mandatory=$true)]
    [string] $projectCollection = 'TO DO',

    #[Parameter(Mandatory=$true)]
    [string] $project = 'TO DO',

    [string] $targetUser = '@Me' 
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.1

function SliceArray([int[]] $idList, [int] $size = 200) {
    [string[]] $slicedArrays = @()
    $index = 0

    while (($size * $index) -lt $idList.Length) {
        $group = $idList | Select-Object -First $size -skip ($size * $index)
        $slicedArrays += $group -join ","
        $index++
    }
    return $slicedArrays 
}

$azDoCollectionUrl = "$azDoUrl/$projectCollection"

try {
    $urlForWorkItemRefs = "$azDoCollectionUrl/_apis/wit/wiql?api-version=5.0"
    $body = ConvertTo-Json -InputObject @{ 
        query = "SELECT * FROM WorkItems Where [Assigned to] = $targetUser AND [State] <> 'Removed' AND [Microsoft.VSTS.Common.ClosedDate] >= @StartOfDay('-365d')"
    }
    
    # @type {id, url}
    $workItemRefsArray = (Invoke-RestMethod -Uri $urlForWorkItemRefs -Method POST -body $body -ContentType 'application/json' -UseDefaultCredentials).workItems
    
    $idArray = ($workItemRefsArray.id)
    $slicedIdArrays = SliceArray($idArray)
    
    $i = 0
    $slicedIdArrays | ForEach-Object {
        # The list of IDs is capped at 200 for this endpoint
        $urlForWorkItemDetails = "$azDoCollectionUrl/_apis/wit/workitems?ids=$_&api-version=5.0" 

        # @type {count, value: {fields}}
        $workItemDetails = Invoke-RestMethod -Uri $urlForWorkItemDetails -Method GET -ContentType 'application/json' -UseDefaultCredentials
        
        # Note that the line below effectively maps one array to another
        $workItemDetails.value.fields `
            | Select-Object -Property 'System.AssignedTo', 'System.IterationPath', 'System.AreaPath', 'System.WorkItemType', 'System.Parent', 'System.Title', 'Microsoft.VSTS.Scheduling.Effort', 'System.State', 'System.Reason', 'Microsoft.VSTS.Common.ClosedDate' `
            | Sort-Object -Property Microsoft.VSTS.Common.ClosedDate `
            | Export-Csv -Path "$PSScriptRoot/data_.csv" -Append -NoTypeInformation
            # | ConvertTo-Json | Out-File "$PSScriptRoot/data_$i.json" -Force

        $i += 1
    }
}
catch {
    $_ 
}

