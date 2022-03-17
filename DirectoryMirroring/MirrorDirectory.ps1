param(
    $fixtureDir = "$PSScriptRoot\Fixtures",
    $srcToMirror = "$fixtureDir\Src",
    $destMirror = "$fixtureDir\Dest",
    $targetIngest = "$fixtureDir\Ingest",
    $createFixtures = $false
)


Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
#Requires -Version 5.0


function CreateFixtures(
    $fixtureDirectory = $fixtureDir,
    $source = $srcToMirror,
    $destination = $destMirror
) {
    New-Item -ItemType Directory -Path $fixtureDirectory -Force -Verbose
    New-Item -ItemType Directory -Path $source -Force -Verbose
    New-Item -ItemType Directory -Path $destination -Force -Verbose
    New-Item -ItemType Directory -Path $targetIngest -Force -Verbose
    
    New-Item -ItemType File -Path "$source\file1.csv" -Force -Verbose
    New-Item -ItemType File -Path "$source\file2.csv" -Force -Verbose
    New-Item -ItemType File -Path "$source\file3.csv" -Force -Verbose

    New-Item -ItemType File -Path "$destination\file2.csv" -Force -Verbose
}

function MirrorDirs(
    $source = $srcToMirror,
    $destination = $destMirror
) {
    Robocopy.exe $source $destination /MIR
}


if ($createFixtures -eq $true) {
    CreateFixtures
}


MirrorDirs

$filesToCopy = Get-ChildItem -Path $destMirror `
    | Where-Object { 
        (Test-Path -Path $_.FullName -PathType Container) -eq $false
    } 

$filesToCopy | ForEach-Object {
    $filename = $_.Name
    $copyResults = Copy-Item -Path $_.FullName -Destination "$targetIngest\$filename" -Verbose -PassThru 
    $copyResults | Out-File -FilePath "$PSScriptRoot\LastRunCopies.txt"
}

(Get-Date) | Out-File -FilePath "$PSScriptRoot\LastRunTime.txt"
