param(
    [string] $connectionString,
    [string] $containerName,
    [string] $blobName,
    [string] $outputFileName 
)

az storage blob download --connection-string $connectionString --container-name $containerName --name $blobName --file $outputFileName