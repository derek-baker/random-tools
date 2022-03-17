param(
    $sqlInstance = 'TO DO',
    $acceptableOwners = @('sa', '', $null),
    $acceptableOwnerFuzzy = "*\sa-*"
)

function InstallDbaTools(
    [Parameter(mandatory=$false)]
    [string] $moduleName = 'dbatools',

    [Parameter(mandatory=$false)]
    [version] $version = '1.1.9'
) {
    [PSCustomObject] $dbatools = @{ ModuleName="$moduleName"; ModuleVersion="$version" }
    
    if ($null -eq (Get-Module -FullyQualifiedName $dbatools -ErrorAction SilentlyContinue)) {        
        Install-Module $moduleName `
            -MaximumVersion $version `
            -Scope CurrentUser `
            -Force `
            -AllowClobber `
            -SkipPublisherCheck
    }
    Get-Module -ListAvailable -Refresh | Out-Null
}

InstallDbaTools

Import-Module dbatools

Test-DbaDbOwner -SqlInstance $sqlInstance `
    | Select-Object -Property SqlInstance, Database, CurrentOwner `
    | Where-Object { (-not ($acceptableOwners -contains $_.CurrentOwner)) -and (-not ($_.CurrentOwner -like $acceptableOwnerFuzzy)) } 
