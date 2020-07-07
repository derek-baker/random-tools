param(
    [Parameter(mandatory=$true)]
    [string] $emailUser
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0

$cred = Get-Credential -UserName $emailUser -Message 'Enter Outlook email credentials (EX: <user>@<domain>)'
Send-MailMessage `
    -From $emailUser `
    -To $emailUser `
    -Subject $emailSubject `
    -SmtpServer 'smtp.office365.com' `
    -UseSsl `
    -Port 587 `
    -Credential $cred 
    