$inputs = @'
'@ -split "`r`n"

#Star 1
$Result = ForEach ($row in $inputs)
{
  $null, $low, $high, $char, $password = [regex]::Split($row, '([0-9]*)\s*-\s*([0-9]*)\s*([^:]*)\s*:\s*')
  $justchar = ($password -replace "[^$char]*").length
  $justchar -ge $low -and $justchar -le $high
}

$Result|Group-OBject -NoElement

#Star 2
$Result = ForEach ($row in $inputs)
{
  $null, [int]$low, [int]$high, $char, $password = [regex]::Split($row, '([0-9]*)\s*-\s*([0-9]*)\s*([^:]*)\s*:\s*')
  $password[$low-1] -ne $password[$high-1] -and ($password[$low-1] -eq $char -or $password[$high-1] -eq $char)
}

$Result|Group-OBject -NoElement
