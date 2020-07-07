# PURPOSE: Set all DBs on an instance to a desired recovery model.
#          Note that after the change, you may still want to shrink some DBs in SSMS (Tasks > Shrink > DB) if you still have space issues.
param(
    [string] $instance,
    [string] $desiredRecoveryModel = 'Simple'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0


function GetRecoveryModes(
    [string] $db = $instance,
    [string] $recoveryModel = $desiredRecoveryModel
) {    
    $dbsSetToSimple = Get-DbaDbRecoveryModel -SqlInstance $db | `
        Where-Object {
            $_.RecoveryModel -ne $recoveryModel
        }
    return $dbsSetToSimple
}


Import-Module dbatools -Force 

GetRecoveryModes | Set-DbaDbRecoveryModel -RecoveryModel Simple -Confirm:$false # -WhatIf