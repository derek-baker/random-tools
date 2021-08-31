param(
    
)

#Requires -Version 5.0
$ErrorActionPreference = "Stop";
Set-StrictMode -Version 'Latest'


$uri = 'https://<HOST>/<REPORT_SERVERNAME>/Pages/ReportViewer.aspx?%2F<FOLDER>%2F<REPORT_NAME>&rs:Format=PDF'
$userAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2;)"

# Invoke-WebRequest -Uri $url -Method GET 

$wc = New-Object System.Net.WebClient
$wc.UseDefaultCredentials = $true
$wc.Headers.Add("user-agent", $userAgent)
$wc.DownloadFile($uri, "$PSScriptRoot\test.pdf")
$wc.DownloadFile($uri, "$PSScriptRoot\test.txt")


# $file.GetType()
# $file | Out-File -FilePath './test.pdf' -Force