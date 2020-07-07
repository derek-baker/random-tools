param(
    [string] $powershellGalleryApiKey
)

#Requires -Version 5.0
$ErrorActionPreference = "Stop";
Set-StrictMode -Version 'Latest'

[string] $scriptPath = "$PSScriptRoot\azdo_helpers\PublishModule.ps1"
[string] $scriptArgs = "$powershellGalleryApiKey"

& powershell.exe -File $scriptPath $scriptArgs