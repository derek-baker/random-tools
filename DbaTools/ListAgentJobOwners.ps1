param(
    $sqlInstance = 'TO DO',
    $desiredOwnder = 'sa'
    # $database = 'TO_DO',
    # $env = 'TO_DO',
    # $scripts = (Get-ChildItem -Path 'TO_DO' | Where-Object { $_.Name -like "Setup*.$env.sql"})
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

Get-DbaAgentJob -SqlInstance $sqlInstance | Where-Object { $_.OwnerLoginName -ne $desiredOwnder }
