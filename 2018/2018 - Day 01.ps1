# Day 1 - Step 1
$changes = @'
'@ -split "`r`n" -replace '\+'
$testchanges = @'
+1
-2
+3
+1
'@ -split "`r`n" -replace '\+'
$testchanges_1 = @(1,-1)
$testchanges_2 = @(3,3,4,-2,-4)
$testchanges_3 = @(-6,3,8,5,-6)
$testchanges_4 = @(+7,+7,-2,-7,-4)

$testchanges |measure-object -Sum|select -exp sum
$changes |measure-object -Sum|select -exp sum

# Day 1 - Step 2
$seenFreq = @()
$currentFreq = 0
While ($seenFreq -notcontains $currentFreq) {
  $changes | ForEach {
    if ($seenFreq -notcontains $currentFreq) {
      $seenFreq += $currentFreq
      $currentFreq += $_
      #Write-Host "New frequency: $currentFreq"
    }
    else
    {
      Write-Host "Found used frequency: $currentFreq"
      break
    }
  }
}