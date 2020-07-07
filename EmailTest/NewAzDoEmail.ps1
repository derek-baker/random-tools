Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0


function BuildRunAsCredential(
    [Parameter(mandatory=$true)]
    [string] $runAsUser,

    [Parameter(mandatory=$true)]
    [string] $runAsUserPass
) {
    $securePassword = ConvertTo-SecureString $runAsUserPass -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential $runAsUser, $securePassword
    return $credential
}


function BuildEmailBody(
    [Parameter(mandatory=$true)]
    [string] $subject = $emailSubject,

    [Parameter(mandatory=$false)]
    [string] $releaseDefinitionName = '$(Release.DefinitionName)',

    [Parameter(mandatory=$false)]
    [string] $releaseUrl = '$(Release.ReleaseWebURL)',

    [Parameter(mandatory=$false)]
    [string] $releaseRequestedFor = '$(Release.RequestedFor)',

    [Parameter(mandatory=$false)]
    [string] $releaseDeploymentRequestedFor = '$(Release.Deployment.RequestedFor)',
    
    [Parameter(mandatory=$false)]
    [string] $releaseEnvironmentName = '$(Release.EnvironmentName)'
) {
    [string] $email = @"
        RE: $subject

        Release.DefinitionName: $releaseDefinitionName
        Release.ReleaseWebURL: $releaseUrl
        Release.RequestedFor: $releaseRequestedFor
        Release.Deployment.RequestedFor: $releaseDeploymentRequestedFor
        Release.EnvironmentName: $releaseEnvironmentName
"@
    return $email
}



[string] $emailSubject = 'AzureDevops Release Failed'
[string] $emailBody = BuildEmailBody -subject $emailSubject

[System.Management.Automation.PSCredential] $cred = BuildRunAsCredential `
    -runAsUser '$(EmailUser)' `
    -runAsUserPass '$(EmailUserPass)'

Send-MailMessage `
    -From '$(EmailUser)' `
    -To '$(EmailUser)' `
    -Subject $emailSubject `
    -Body $emailBody `
    -SmtpServer 'smtp.office365.com' `
    -UseSsl `
    -Port 587 `
    -Credential $cred 
    