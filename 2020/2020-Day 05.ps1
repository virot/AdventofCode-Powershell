$boarding = @'
'@ -split "`r`n"

#Star 1
$passes = ForEach ($pass in $boarding){
  [Convert]::ToInt32(($pass -replace '(B|R)','1' -replace '(F|L)','0'),2)
}
$passes|Sort-Object -Descending |select -first 1

#Star 2
$passes|Sort-Object  |select -first 1
ForEach($test in (6..813))
{
  if ($passes -contains ($test -1) -and $passes -contains ($test +1) -and $passes -notcontains $test){
   write-host "Sit down in $test"
  }
}