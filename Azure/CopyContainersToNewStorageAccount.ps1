# To view keys for a given storage account 
# az storage account keys list --account-name $sourceStorageAccount.Name --resource-group $sourceStorageAccount.ResourceGroup
# az storage account keys list --account-name $destinationStorageAccount.Name --resource-group $destinationStorageAccount.ResourceGroup

# USAGE: 
param(
    $sourceStorageAccount = [PSCustomObject] @{
        Name = 'TODO'
        ResourceGroup = 'TODO'
        Key = 'TODO'
    },
    $destinationStorageAccount = [PSCustomObject] @{
        Name = 'TODO'
        ResourceGroup = 'TODO'
        Key = 'TODO'
    }
)

#Requires -Version 5.1
$ErrorActionPreference = "Stop";
Set-StrictMode -Version 'Latest'

# Get list JSON of containers for account
# $containers = 
#     az storage container list --account-name $sourceStorageAccount.Name `
#         | ConvertFrom-Json

# Create many containers in new account
# $containers | ForEach-Object {
#     az storage container create --name $_.name --account-name $destinationStorageAccount.Name
# }

# Create one containers in new account
az storage container create --name 'specsheet' --account-name $destinationStorageAccount.Name


# To copy many containers
# $containers | ForEach-Object {
#     az storage blob copy start-batch `
#         --account-key $destinationStorageAccount.Key `
#         --account-name $destinationStorageAccount.Name `
#         --destination-container $_.name `
#         --source-account-name $sourceStorageAccount.Name `
#         --source-account-key $sourceStorageAccount.Key `
#         --source-container $_.name 
#         # --dryrun
# }

# To copy one container
az storage blob copy start-batch `
    --account-key $destinationStorageAccount.Key `
    --account-name $destinationStorageAccount.Name `
    --destination-container 'specsheet' `
    --source-account-name $sourceStorageAccount.Name `
    --source-account-key $sourceStorageAccount.Key `
    --source-container 'specsheet' 
    # --dryrun