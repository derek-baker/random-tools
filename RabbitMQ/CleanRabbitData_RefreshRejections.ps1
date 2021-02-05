param(
    $inputFile = "$PSScriptRoot\queue_data.txt",
    $outputFile = "$PSScriptRoot\object_keys.txt"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";

Clear-Content -Path $outputFile

$lines = Select-String -Path $inputFile -Pattern @('objectKey', 'objectType') | Get-Unique
 
$lines | ForEach-Object {
    $cleanLine = 
        $_.Line.Replace('"objectKey": "', '').Replace('",', '').Replace("`n", '')
    $cleanLine =
        '<Key>' + $cleanLine.Replace('"objectType": "', '').Replace('",', '').Replace("`n", '').Trim() + '</Key>'
    Add-Content -Path $outputFile -Value $cleanLine
} 