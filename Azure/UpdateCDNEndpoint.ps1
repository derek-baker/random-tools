# DOCS: https://docs.microsoft.com/en-us/cli/azure/cdn/endpoint?view=azure-cli-latest

# USAGE: 
param(
    [string] $resourceGroup = 'TO_DO',
    [string] $profileName = 'TO_DO'
)

#Requires -Version 5.1
$ErrorActionPreference = "Stop";
Set-StrictMode -Version 'Latest'

# To list endoints
# az cdn endpoint list --resource-group $resourceGroup --profile-name $profileName

az cdn endpoint update --set origins[0].name="TEST" --resource-group $resourceGroup --profile-name $profileName

