param(
    [Parameter(Mandatory=$true)]
    $certThumb
)

Set-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Address="*";Transport="HTTPS"} -ValueSet @{CertificateThumbprint=$certThumb}