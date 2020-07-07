# EXAMPLE USAGE: 
# NOTE: This script should 'exit 1' to fail the build where appropriate.
param(
    [string] $nameOfBuildToStart,
    [string] $tfsUrl,
    [string] $projectCollection,
    [string] $project
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0

# if ($null -eq (Get-Module -Name VSTeam -ErrorAction SilentlyContinue)) {
#     Install-Module -Name VSTeam -Force -Scope CurrentUser
# }
# Set-VSTeamAccount -Account $azureDevopsAccount -PersonalAccessToken $token

$tfsUrl = "$tfsUrl/$projectCollection/$project"
$buildsUrl = $tfsUrl + '/_apis/build/builds?api-version=2.0'
$buildDefsUrl = $tfsUrl + '/_apis/build/definitions?api-version=2.0'
$buildLog =  "$tfsUrl/_apis/build/builds"

try {
    $buildDefinitions = (Invoke-RestMethod -Uri ($buildDefsUrl) -Method GET -UseDefaultCredentials).Value
    $buildDefinitions | Where-Object { $_.name -eq $nameOfBuildToStart } | ForEach-Object {
        Write-Host "`n`n"
        Write-Host $_

        # Build body
        $body = '{ "definition": { "id": '+ $_.id + '}, reason: "Manual", priority: "Normal" }' 

        # Print build name
        Write-Output "Queueing $($_.name)" 

        # Trigger new build 
        $result = Invoke-RestMethod -Method Post -Uri $buildsUrl -ContentType 'application/json' -Body $body -Verbose -UseDefaultCredentials
        $result
    }
}
catch {
    $_ | Out-File "$PSScriptRoot\ErrorLog_$(get-date -f yyyy-MM-dd-ss).log"
}

