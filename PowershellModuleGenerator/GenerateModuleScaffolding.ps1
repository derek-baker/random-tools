# DOCS: http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/
#       https://github.com/RamblingCookieMonster/PSStackExchange
#       https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7
#       https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7
param(
    $moduleFolder = "$PSScriptRoot\ModuleStaging",
    $moduleName,
    $Author,
    $Description
)


Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0


# Create the module and private function directories
New-Item $moduleFolder\$moduleName -ItemType Directory -Force
New-Item $moduleFolder\$moduleName\Private -ItemType Directory -Force
New-Item $moduleFolder\$moduleName\Public -ItemType Directory -Force
New-Item $moduleFolder\$moduleName\en-US -ItemType Directory -Force # For about_Help files 
New-Item $moduleFolder\Tests -ItemType Directory -Force

#Create the module and related files
New-Item "$moduleFolder\$moduleName\$moduleName.psm1" -ItemType File -Force
New-Item "$moduleFolder\$moduleName\en-US\about_$moduleName.help.txt" -ItemType File -Force
New-Item "$moduleFolder\Tests\$moduleName.Tests.ps1" -ItemType File -Force


$pathToModuleDefinition = "$moduleFolder\$moduleName\$moduleName.psd1"
New-ModuleManifest `
    -Path $pathToModuleDefinition `
    -RootModule "$moduleName.psm1" `
    -Description $Description `
    -PowerShellVersion 5.0 `
    -Author $Author 

Test-ModuleManifest $pathToModuleDefinition

# TODO: Copy module to: "$Env:UserProfile\Documents\WindowsPowerShell\Modules\$moduleName";

# TODO: Copy the public/exported functions into the public folder, private functions into private folder


