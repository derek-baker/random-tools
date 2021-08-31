param(
    $scriptPath = "$PSScriptRoot\RemoveLocalsNotTrackingRemotes.ps1",
    $reposRoot,
    $exclude 
)

#Requires -Version 5.0
$ErrorActionPreference = "Stop";
Set-StrictMode -Version 'Latest'

foreach ($dir in (Get-ChildItem -Path $reposRoot)) {
    if ($dir.FullName -eq $exclude) { continue }
    # $dir
    & $scriptPath -repoDir $dir.FullName
}


