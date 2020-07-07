param(
    [Parameter(Mandatory=$true)]
    [string] $certFriendlyName,

    [Parameter(Mandatory=$true)]
    [string] $fullyQualifiedHostname,

    [Parameter(Mandatory=$true)]
    [string] $backEndPort,
    
    [Parameter(Mandatory=$true)]
    [string] $certPass,

    [Parameter(Mandatory=$false)]
    [bool] $removeOldCerts = $false,

    [Parameter(Mandatory=$false)]
    [string] $certStoreLocation = 'Cert:\LocalMachine'
)


Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0
#Requires -RunAsAdministrator


function RemoveOldCerts(
    [Parameter(Mandatory=$true)]
    [string] $issuedBy,

    [Parameter(Mandatory=$true)]
    [string] $certFriendlyName,

    [Parameter(Mandatory=$false)]
    [string] $storeLocation = $certStoreLocation
) {
    [string[]] $locations = @('My', 'Root', 'WebHosting')
    foreach ($location in $locations) {
        $certs = Get-ChildItem "$storeLocation\$location" | Where-Object { 
            ($_.Subject -like "*$issuedBy") `
            -and `
            ($_.FriendlyName -eq $certFriendlyName)
        }        
        $certs | ForEach-Object {
            Remove-Item -Path $_.PSPath -Force -Verbose    
        }    
    }
}


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
    
    return $pfxFilePath
}


function ImportCertToStore(
    [Parameter(Mandatory=$true)]
    [string] $storeName,

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
        -CertStoreLocation "$storeLocation\$storeName" `
        -Password $secureString `
        -Verbose | Out-Null
}


# REF: https://vineetyadav.com/development/net/configure-self-hosted-webapi-in-windows-service-to-use-ssl.html#bind-ssl
# NOTE: The appId is application identifier to refer to http and should remain  the same on all Windows hosts.
# DOCS: https://docs.microsoft.com/en-us/windows-server/networking/technologies/netsh/netsh-http#add-sslcert
# INFO: https://stackoverflow.com/questions/9722273/using-netsh-on-powershell-fails-with-error-the-parameter-is-incorrect
function ConfigureSslForPortOnHost(
    [Parameter(Mandatory=$true)]
    [string] $port,

    [Parameter(Mandatory=$true)]
    [string] $certThumbPrint
) {
    Write-Host -ForegroundColor Yellow "Attempting to add configure encryption on port $port with thumbprint: $($certThumbPrint)"
    
    Invoke-Expression "netsh http delete sslcert ipport=0.0.0.0:$port"
    Invoke-Expression "netsh http add sslcert ipport=0.0.0.0:$port appid='{214124cd-d05b-4309-9af9-9caa44b2b74a}' certhash=$($certThumbPrint) certstorename=Root"    
}


[string] $certSubject = $fullyQualifiedHostname
if ($removeOldCerts -eq $true) {
    RemoveOldCerts -issuedBy $certSubject -certFriendlyName $certFriendlyName
}

[PSCustomObject] $cert = CreateSelfSignedCert -friendlyName $certFriendlyName -siteName $certSubject 

# NOTE: For some reason, strongly typing the result below (via [string]) results in weird behavior (<PATH> <PATH>)
$pfxPath = ExportCert -certThumbPrint $cert.ThumbPrint -certPass $certPass -workDir $PSScriptRoot

ImportCertToStore -storeName 'Root' -pfxPath $pfxPath -certPass $certPass
ImportCertToStore -storeName 'WebHosting' -pfxPath $pfxPath -certPass $certPass

ConfigureSslForPortOnHost -port $backEndPort -certThumbPrint $cert.ThumbPrint

# As a best practice, don't leave the PFX lying around
Remove-Item -Path $pfxPath -Force -Verbose -ErrorAction SilentlyContinue
