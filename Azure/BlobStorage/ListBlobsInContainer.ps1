param(
    $storageAccountConnectionString,
    $containerName = 'xmldata'
)

$rawJson = az storage blob list --container-name $containerName --connection-string $storageAccountConnectionString 
$rawJson | ConvertFrom-Json | ForEach-Object { $_.name } | Out-File "./Test.txt"	

# Alternatively,
# az storage blob list --connection-string $storageAccountConnectionString --container-name 'xmldata'