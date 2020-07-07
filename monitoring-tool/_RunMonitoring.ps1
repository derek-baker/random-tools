param(
    [string] $targetBaseUrl,
    [string] $smtpServer,
    [string] $emailFrom,
    [string] $emailTo,
    [string] $emailSubject,
    [string[]] $ccList = @($emailTo, $emailTo)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0


function RunCypress([string] $cypressBaseUrl = $targetBaseUrl) {
    $Env:CYPRESS_BASE_URL = $cypressBaseUrl
    [string] $originalDir = (Get-Location).Path
    Set-Location "$PSScriptRoot\Cypress"
    & npm run cypress:run
    Set-Location $originalDir
}


function SendEmail(
    [string] $screenShotsDir = "$PSScriptRoot\Cypress\cypress\screenshots\home.spec.ts"
) {
    $screenshots = Get-ChildItem -Path $screenShotsDir | Where-Object { $_.Extension -eq '.png' }
    $filePaths = @()
    foreach ($shot in $screenshots) {
        $filePaths += $shot.FullName
    }
    Send-MailMessage `
        -From $emailFrom `
        -To $emailTo `
        -Cc $ccList `
        -Subject $emailSubject `
        -Body 'See attachments' `
        -Attachments $filePaths `
        -DeliveryNotificationOption OnFailure `
        -SmtpServer $smtpServer `
        -Verbose
        # -Port 25
        
    foreach ($filepath in $filePaths) {
        Remove-Item -Path $filepath -Force -Verbose
    }
}


RunCypress
SendEmail
