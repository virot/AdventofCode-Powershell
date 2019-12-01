# Day 1 - Part 1
$testmasses = @(12,14,1969,100756)
$masses = @'
'@ -split "`r`n"
$testmasses | ForEach {[math]::Floor($_/3)-2}
$masses | ForEach {[math]::Floor($_/3)-2}|Measure-Object -Sum

# Day 1 - Part 2
$testmasses = @(14,1969,100756)
$requiredfuelitems = $masses | ForEach `
{
  $requiredfuel = @()
  $mass = $_
  #$requiredfuel += ([math]::Floor($mass/3)-2)
  While (([math]::Floor($mass/3)-2) -gt 0)
  {
    $mass = ([math]::Floor($mass/3)-2)
    $requiredfuel += $mass
  }
  $requiredfuel|measure-object -sum
}
$requiredfuelitems|measure-object sum -sum