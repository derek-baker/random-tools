param(
    [string] $siteUrl
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0

function testUrl(
    [Parameter(mandatory=$true)]
    [string] $url
) {
    [int] $statusCode = -1
    try
    {
        $statusCode = (Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive).StatusCode
    }
    catch [Net.WebException]
    {
        $statusCode = $_.Exception.Response.StatusCode
    }
    catch {
        $_
    }
    return $statusCode
}

[int] $statusCode = testUrl -url $siteUrl
if ($statusCode -ne 200) {
    Write-Host "Reponse code was $statusCode. Please investigate. URL: $url"
    exit 1
}
Write-Host -ForegroundColor Green "Site appears to be up at: $siteUrl"