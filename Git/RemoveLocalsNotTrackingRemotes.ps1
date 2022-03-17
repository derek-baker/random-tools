# SOURCE: https://stackoverflow.com/questions/7726949/remove-tracking-branches-no-longer-on-remote/62353475#answer-62353475
# USAGE: './RemoveLocalsNotTrackingRemotes.ps1 -repoDir 'c:\src\ecommerce'
param(
    [Parameter(Mandatory=$true)]
    [string] $repoDir
)

#Requires -Version 5.0
$ErrorActionPreference = "Stop";
Set-StrictMode -Version 'Latest'

[string] $initialLocation = Get-Location
try {
    Set-Location $repoDir
    # Prune deleted remoted branches
    git fetch --prune

    # Get all branches and their corresponding remote status
    # Deleted remotes will be marked [gone]
    git branch -v | ` # Find branches marked [gone], capture branchName
        Select-String -Pattern '^  (?<branchName>\S+)\s+\w+ \[gone\]' | `
            ForEach-Object { 
                # Delete the captured branchname.
                git branch -D $_.Matches[0].Groups['branchName']
            }
}
catch {
    $_
}
finally {
    Set-Location $initialLocation
}
