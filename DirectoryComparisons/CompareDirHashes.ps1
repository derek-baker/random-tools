$SourceHash = Get-ChildItem -recurse X:\Folder\ | Get-FileHash
$TargetHash = Get-ChildItem -recurse Y:\Folder\ | Get-FileHash
Compare-Object $SourceHash.Hash $TargetHash.Hash