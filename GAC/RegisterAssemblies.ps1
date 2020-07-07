param(
    [string[]] $assemblies
)

[System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") 

$publish = New-Object System.EnterpriseServices.Internal.Publish 

foreach ($assembly in $assemblies) {
    $publish.GacInstall("$PSScriptRoot\$assembly")
}
