param(
    [string] $moduleName
)


$filePath = "$(System.DefaultWorkingDirectory)\Extracted\Module\$moduleName.psd1";

$file = Get-Content $filePath;

[version] $version = [regex]::matches($file, "\s*ModuleVersion\s=\s'(\d*.\d*.\d*)'\s*").groups[1].value;

Write-Host "Updating module version number to $version"

[version] $newVersion = "{0}.{1}.{2}" -f $version.Major, $version.Minor, ($version.Build + 1);

Update-ModuleManifest -Path $filePath -ModuleVersion $newVersion -Verbose;