param(
    $userName = 'baker'
)
         
Add-Type -AssemblyName System.DirectoryServices.AccountManagement            
$ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain            
$user = [System.DirectoryServices.AccountManagement.Principal]::FindByIdentity($ct,$userName)            
$user.GetGroups() | Out-Null
$info = $user.GetAuthorizationGroups() 

$info | ForEach-Object { 
    Write-Host "`n`n"
    Write-Host $_.Name
    Write-Host $_.StructuralObjectClass
    Write-Host $_.GroupScope
    Write-Host $_.Description
    Write-Host $_.Members
}