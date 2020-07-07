# USAGE: .\_GenerateSelfSignedCertInTrustedRoot.ps1 -certFriendlyName 'Cert for X' -fullyQualifiedHostname 'osw-agqpisvcs.novelis.biz' -certPass 'TODO'
param(
    [Parameter(Mandatory=$true)]
    [string] $certFriendlyName,

    [Parameter(Mandatory=$true)]
    [string] $fullyQualifiedHostname,

    [Parameter(Mandatory=$true)]
    [string] $certPass
)


Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0


[string] $certStoreLocation = 'Cert:\LocalMachine'


# function RemoveOldCerts(
#     [Parameter(Mandatory=$true)]
#     [string] $siteName,

#     [Parameter(Mandatory=$false)]
#     [string] $storeLocation = $certStoreLocation
# ) {
#     Get-ChildItem "$storeLocation\My" |
#         Where-Object { $_.Subject -like "*$siteName" } |
#             Remove-Item -Force -Verbose

#     Get-ChildItem "$storeLocation\Root" |
#         Where-Object { $_.Subject -like "*$siteName" } |
#             Remove-Item -Force -Verbose
# }



function CreateSelfSignedCert(
    [Parameter(Mandatory=$true)]
    [string] $friendlyName,

    [Parameter(Mandatory=$true)]
    [string] $siteName,

    [Parameter(Mandatory=$false)]
    [string] $storeLocation = $certStoreLocation,

    [Parameter(Mandatory=$false)]
    [int] $certValidDays = 36500
){    
    $certificate = New-SelfSignedCertificate `
        -FriendlyName $friendlyName `
        -DnsName $siteName `
        -CertStoreLocation "$storeLocation\My" `
        -NotAfter $((Get-Date).AddDays($certValidDays)) `
        -Verbose

    $certThumbPrint = $certificate.Thumbprint

    $returnObj = [PSCustomObject] @{
        ThumbPrint = $certThumbPrint;
    }
    return $returnObj;
}


function ExportCert(
    [Parameter(Mandatory=$true)]
    [string] $certThumbPrint,

    [Parameter(Mandatory=$true)]
    [string] $certPass,

    [Parameter(Mandatory=$true)]
    [string] $workDir,

    [Parameter(Mandatory=$false)]
    [string] $storeLocation = $certStoreLocation
){    
    $certificatePath = "$storeLocation\My\$certThumbPrint"
    $secureString = ConvertTo-SecureString -String $certPass -Force -AsPlainText

    $tempDir = "$workDir\pfx_temp"
    $pfxFilePath = "$tempDir\temp.pfx"    
    if( (Test-Path -Path $tempDir) -eq $false ){
        New-Item -ItemType Directory -Path $tempDir -Verbose | Out-Null
    }
    # ...so export it...
    $fileInfo = Export-PfxCertificate `
        -FilePath $pfxFilePath `
        -Cert $certificatePath `
        -Password $secureString `
        -Verbose
    Write-Host "$fileInfo"
    
    return $pfxFilePath
}


function ImportCertToRoot(
    [Parameter(Mandatory=$true)]
    [string] $pfxPath,

    [Parameter(Mandatory=$true)]
    [string] $certPass,

    [Parameter(Mandatory=$false)]
    [string] $storeLocation = $certStoreLocation
) {
    $secureString = ConvertTo-SecureString -String $certPass -Force -AsPlainText
    Write-Host "Attempting to import cert from: $pfxPath"
    Import-PfxCertificate `
        -FilePath $pfxPath `
        -CertStoreLocation "$storeLocation\Root" `
        -Password $secureString `
        -Verbose | Out-Null
    
    Remove-Item -Path $pfxPath -Force -Verbose
}


# # REF: https://vineetyadav.com/development/net/configure-self-hosted-webapi-in-windows-service-to-use-ssl.html#bind-ssl
# # NOTE: The appId is application identifier to refer to http and should remain  the same on all Windows hosts.
# # DOCS: https://docs.microsoft.com/en-us/windows-server/networking/technologies/netsh/netsh-http#add-sslcert
# # INFO: https://stackoverflow.com/questions/9722273/using-netsh-on-powershell-fails-with-error-the-parameter-is-incorrect
# function ConfigureSslForPortOnHost(
#     [Parameter(Mandatory=$true)]
#     [string] $port,

#     [Parameter(Mandatory=$true)]
#     [string] $certThumbPrint
# ) {
#     Write-Host -ForegroundColor Yellow "Attempting to add ssl rule using NETSH. Using cert with thumbprint: $($certThumbPrint)"
    
#     Invoke-Expression "netsh http delete sslcert ipport=0.0.0.0:$port"
#     Invoke-Expression "netsh http add sslcert ipport=0.0.0.0:$port appid='{214124cd-d05b-4309-9af9-9caa44b2b74a}' certhash=$($certThumbPrint)"    
# }


[string] $certSubject = $fullyQualifiedHostname
# RemoveOldCerts -siteName $certSubject

[PSCustomObject] $cert = CreateSelfSignedCert -friendlyName $certFriendlyName -siteName $certSubject 

$pfxPath = ExportCert -certThumbPrint $cert.ThumbPrint -certPass $certPass -workDir $PSScriptRoot

ImportCertToRoot -pfxPath $pfxPath -certPass $certPass

# ConfigureSslForPortOnHost -port $backEndPort -certThumbPrint $cert.ThumbPrint