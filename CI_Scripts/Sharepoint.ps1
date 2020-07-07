param(
    $username,
    $password,
    $siteUrl,
    $SharepointVersion # <== Look this up in the Gallery
)

$nugetProvider = Get-PackageProvider -Name "NuGet" -ErrorAction SilentlyContinue

if ($null -eq $nugetProvider) {
    Write-Host "NuGet package provider has not found. Installing..."
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -Verbose
}
else {
    Write-Host "Found NuGet package provider"
}

$pnpModule = Get-InstalledModule -Name $SharepointVersion -ErrorAction SilentlyContinue

if ($null -eq $pnpModule) {
    Write-Host "PnP-PowerShell module has not installed. Installing..."
    Install-Module $SharepointVersion -Force -Scope CurrentUser -Verbose 
}
else {
    Write-Host "Found $SharepointVersion module"
    Write-Host "Importing $SharepointVersion module"
    Import-Module $SharepointVersion
}

$secstr = New-Object -TypeName System.Security.SecureString
$password.ToCharArray() | ForEach-Object { $secstr.AppendChar($_) }
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr
Write-Host "Connecting to SharePoint Online. Site url: $($siteUrl). Username: $($username)"
Connect-PnPOnline -Url $siteUrl -Credentials $cred -Verbose
Write-Host "Connected."

try {
    $splib = "Shared Documents/<SOME>/<FOLDER>"  
    Add-PnPFil -Path "$PSScriptRoot\TODO.txt" -Folder $splib -Verbose 
}
catch {
    Write-Host -ForegroundColor 'Red' 'ERROR. DETAILS BELOW.'
    Write-Host $_
    exit 1
}


