param(
    [string] $connectionString,
    [string] $containerName = 'xmldata',
    [string] $blobName = 'SearchPromoteDataDEV.xml',
    [string] $outputFileName = 'SearchPromoteDataDEV.xml' 
)

az storage blob download --connection-string $connectionString --container-name $containerName --name $blobName --file $outputFileName