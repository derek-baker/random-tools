param(
    $server = 'fny-sql-app1',
    $sql  = "SELECT top 1 cast([XMLRequest] as text) FROM [PI-Interface].[dbo].[XMLArchive] where RequestDateTime between '2021-08-24 08:10:00' and '2021-08-24 08:13:40.590' and ObjectType = 'Order' and objectkey = '0102419239'",
    $maxLength = 280000,
    $outputFile = "$PSScriptRoot\badXml.xml"
)

(invoke-sqlcmd -ServerInstance $sql -Query $sql -MaxCharLength).Column1 | Out-File $outputFile -Force -Verbose