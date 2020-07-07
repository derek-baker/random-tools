(New-Object System.DirectoryServices.DirectorySearcher(
    "(&(objectCategory=User)(samAccountName=$('baker')))"
)).FindOne().GetDirectoryEntry().memberOf
