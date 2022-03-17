# SOURCE: https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/powershell?view=azure-devops-2019
# SYNOPSIS:
# Look for a 0.0.0.0 pattern in the build number.
# If found use it to version the assemblies.
#
# For example, if the 'Build number format' build pipeline parameter 
# $(BuildDefinitionName)_$(Year:yyyy).$(Month).$(DayOfMonth)$(Rev:.r)
# then your build numbers come out like this:
# "Build HelloWorld_2013.07.19.1"
# This script would then apply version 2013.07.19.1 to your assemblies.

# NOTE: Should target pre-build artifacts

param(
    [string] $assemblyTitle,

    # Regular expression pattern to find the version in the build number 
    # and then apply it to the assemblies
    $versionRegex = "\d+\.\d+\.\d+\.\d+"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop";
	
# If this script is NOT running on a build server, remind user to 
# set environment variables so that this script can be debugged
if (-not ($Env:BUILD_SOURCESDIRECTORY -and $Env:BUILD_BUILDNUMBER)) {
    Write-Error "You must set the following environment variables"
    Write-Error "to test this script interactively."
    Write-Host '$Env:BUILD_SOURCESDIRECTORY - For example, enter something like:'
    Write-Host '$Env:BUILD_SOURCESDIRECTORY = "C:\code\FabrikamTFVC\HelloWorld"'
    Write-Host '$Env:BUILD_BUILDNUMBER - For example, enter something like:'
    Write-Host '$Env:BUILD_BUILDNUMBER = "Build HelloWorld_0000.00.00.0"'
    exit 1
    # EX: 
    #   $Env:BUILD_SOURCESDIRECTORY = "$PWD\NovelisDataBuilder.Service\NovelisDataBuilder.Service"
    #   $Env:BUILD_BUILDNUMBER = 2.0.0.0
}
	
# Make sure path to source code directory is available
if (-not $Env:BUILD_SOURCESDIRECTORY) {
    Write-Error ("BUILD_SOURCESDIRECTORY environment variable is missing.")
    exit 1
}
elseif (-not (Test-Path $Env:BUILD_SOURCESDIRECTORY)) {
    Write-Error "BUILD_SOURCESDIRECTORY does not exist: $Env:BUILD_SOURCESDIRECTORY"
    exit 1
}
Write-Verbose "BUILD_SOURCESDIRECTORY: $Env:BUILD_SOURCESDIRECTORY"
	
# Make sure there is a build number
if (-not $Env:BUILD_BUILDNUMBER) {
    Write-Error ("BUILD_BUILDNUMBER environment variable is missing.")
    exit 1
}
Write-Verbose "BUILD_BUILDNUMBER: $Env:BUILD_BUILDNUMBER"
	
# Get and validate the version data
$versionData = [regex]::matches($Env:BUILD_BUILDNUMBER, $versionRegex)
switch ($versionData.Count) {
    0 { 
        Write-Error "Could not find version number data in BUILD_BUILDNUMBER."2
        exit 1
    }
    1 { 
        # 
    }
    default { 
        Write-Warning "Found more than instance of version data in BUILD_BUILDNUMBER." 
        Write-Warning "Will assume first instance is version."
    }
}
$newVersion = $versionData[0]
Write-Verbose "Version: $newVersion"
	
# Apply the version to the assembly property files
$files = Get-ChildItem $Env:BUILD_SOURCESDIRECTORY -Recurse -Include @("*Properties*", $assemblyTitle) | `
    Where-Object { 
        $_.PSIsContainer 
    } | ForEach-Object { 
        Get-ChildItem -Path $_.FullName -Recurse -include AssemblyInfo.* 
    }
if ($files) {    
    Write-Host "Will apply $newVersion to files: "
    Write-Host -ForegroundColor Yellow $files
    foreach ($file in $files) {
        $filecontent = Get-Content($file)
        attrib $file -r
        $filecontent -replace $VersionRegex, $newVersion | Out-File $file
        Write-Verbose "$file.FullName - version applied"
    }
}
else {
    Write-Warning "Found no files."
}