param(
    $sqlInstance = 'WebAppsSqlDevQa',
    $database = 'OnSiteStoreDev',
    $env = 'Dev',
    $scripts = (Get-ChildItem -Path 'C:\src\OnSiteStore' | Where-Object { $_.Name -like "Setup*.$env.sql"})
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

$scripts | ForEach-Object {
    $script = $_
    Invoke-DbaQuery -File $script -SqlInstance $sqlInstance -Database $database 
}
