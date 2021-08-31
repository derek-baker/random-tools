param(
    [string] $server, 
    [string] $sql, 
    [int] $maxLength = 280000,
    [string] $outputFile = "$PSScriptRoot\data.txt"
)

(invoke-sqlcmd -ServerInstance $server -Query $sql -MaxCharLength $maxLength).Column1 | Out-File $outputFile -Force -Verbose