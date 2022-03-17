$data = @()
foreach($line in (Get-Content -Path .\20200412.log)) {
    $obj = ConvertFrom-Json $line
    $msg = ConvertFrom-Json $obj.message
    foreach($prop in $msg.PsObject.Properties) {        
        $obj | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $prop.Value
        
        $obj.psobject.properties.remove('message')
    }
    $data += $obj
}

# $data | ForEach-Object { $_ }

$data | Out-GridView
