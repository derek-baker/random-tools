get-childitem -path cert: -recurse  | where-object {$_.thumbprint -eq ''} | select *

