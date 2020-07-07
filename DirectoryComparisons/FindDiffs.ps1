# PURPOSE: Compare files in two directories
param(
    [string] $absPathToDirA,
    [string] $absPathToDirB
)

$ErrorActionPreference = "Stop";
Set-StrictMode -Version Latest

# Clean unwanted files
# Get-ChildItem -Path $absPathToDirB | Where-Object { $_.Extension -eq '.pyc' } | ForEach-Object { Remove-Item -Path $_.FullName }

# Get list of files from DirA
$filenameArray = Get-ChildItem -Path $absPathToDirA | Where-Object { $_.Extension -eq '.py' } | Select-Object -Property Name

# Iterate through file list
$filenameArray | ForEach-Object {
    # Diff equivalent files in DirA and DirB
    if ((Test-Path -Path "$absPathToDirB\$($_.Name)") -eq $true ) { 
        if((Get-FileHash "$absPathToDirA\$($_.Name)").hash  -ne (Get-FileHash "$absPathToDirB\$($_.Name)").hash) {
            Write-Host -ForegroundColor 'Yellow' "`n`nFile is different: $($_.Name)"
        }
        $comparison = Compare-Object -ReferenceObject $(Get-Content "$absPathToDirA\$($_.Name)") -DifferenceObject $(Get-Content "$absPathToDirB\$($_.Name)")    
        if ($comparison -ne $null) {
            Write-Host -ForegroundColor 'Green' "$($_.Name) comparison"
            $comparison
        }
    }
    Start-Sleep -Seconds 1
}
    


