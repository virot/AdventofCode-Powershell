$values = @'
'@ -split "`r`n"|ForEach {[int]$_}

#star 1
:outer For ($i = 0; $i -lt $values.Count; $i++)
{
  :inner For ($j = $i+1; $j -lt $values.Count; $j++)
  {
    if (($values[$i] + $values[$j]) -eq 2020)
    {
      Write-Host "Found result: $($values[$i]) x $($values[$j]) = $($values[$i] * $values[$j])"
      break outer
    }
  } 
}

#star 2
measure-command{
:v1 For ($v1 = 0; $v1 -lt $values.Count; $v1++)
{
  :v2 For ($v2 = $v1+1; $v2 -lt $values.Count; $v2++)
  {
    :v3 For ($v3 = $v2+1; $v3 -lt $values.Count; $v3++)
    {
      if (($values[$v1] + $values[$v2] + $values[$v3]) -eq 2020)
      {
        Write-Host "Found result: $($values[$v1]) x $($values[$v2]) x $($values[$v3]) = $($values[$v1] * $values[$v2] * $values[$v3])"
        break v1
      }
    } 
  }
}
}

Measure-Command{
#Two start optimized
$values = $values|sort-object
:v1 For ($v1 = 0; $v1 -lt $values.Count; $v1++)
{
  :v2 For ($v2 = $v1+1; $v2 -lt $values.Count; $v2++)
  {
    :v3 For ($v3 = $v2+1; ($v3 -lt $values.Count -and ($values[$v1] + $values[$v2] + $values[$v3]) -le 2020); $v3++)
    {
      if (($values[$v1] + $values[$v2] + $values[$v3]) -eq 2020)
      {
        Write-Host "Found result: $($values[$v1]) x $($values[$v2]) x $($values[$v3]) = $($values[$v1] * $values[$v2] * $values[$v3])"
        break v1
      }
    } 
  }
}
}