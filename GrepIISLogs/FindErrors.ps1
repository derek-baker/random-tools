

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0


function FindErrors(
    [string] $filepath
) {    
    $log = Get-Content $Filepath 
    $rows = $log.Split([Environment]::NewLine)
    $dataRows = $rows | Where-Object { 
        ($_.Length -gt 148) `
        -and `
        ($_ -notlike "*favicon.ico*") `
        -and `
        ($_ -notlike "*login.aspx*")        
    } 
    $nonOks = $dataRows | Where-Object { 
        # ($_ -like "*404 0 0*") `
        # -or `
        ($_ -like "*500 0 0*")
    }

    $nonOks | ForEach-Object { $_; Write-Host "`n`n"}
}

Clear-Host

Write-Host -ForegroundColor Yellow "`n`nErrors from 2020"
$logs = Get-ChildItem $PSScriptRoot\LogFiles | Where-Object { $_.Name -like "u_ex20*" } 
foreach ($log in $logs) { FindErrors -filepath $log.FullName }

Write-Host -ForegroundColor Yellow "`n`nErrors from 2019"
$logs = Get-ChildItem $PSScriptRoot\LogFiles | Where-Object { $_.Name -like "u_ex19*" } 
foreach ($log in $logs) { FindErrors -filepath $log.FullName }

# Write-Host -ForegroundColor Yellow "`n`nErrors from 2020"
# $logs = Get-ChildItem $PSScriptRoot\LogFiles | Where-Object { $_.Name -like "u_ex20*" } 
# foreach ($log in $logs) { FindErrors -filepath $log.FullName }

