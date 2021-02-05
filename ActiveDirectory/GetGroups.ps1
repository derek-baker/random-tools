(New-Object System.DirectoryServices.DirectorySearcher(
    "(&(objectCategory=User)(samAccountName=$('dbaker')))"
)).FindOne().GetDirectoryEntry().memberOf
