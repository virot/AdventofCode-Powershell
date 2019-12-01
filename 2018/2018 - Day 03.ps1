$testpatches = @'
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
'@ -split "`r`n"

$patches = @'
'@ -split "`r`n"
$cloth = @{}



ForEach ($patch in $patches) {
  $id = $patch -replace "#([\d]*).*","`$1"
  $rowx = $patch -replace "[^@]*@\s*([^,]*),.*","`$1"
  $coly = $patch -replace "[^@]*@\s*[^,]*,([^:]*):.*","`$1"
  $lenx = $patch -replace "[^:]*:\s*([^x]*).*","`$1"
  $leny = $patch -replace "[^x]*x\s*([\d]*).*","`$1"

  ForEach ($row in ($rowx..([int]$rowx+$lenx-1)))
  {
    if ($cloth.ContainsKey($row) -eq $false)
    {
      $cloth[$row]=@{}
    }
    ForEach ($col in ($coly..([int]$coly+[int]$leny-1)))
    {
      if ($cloth[$row].ContainsKey($col) -eq $false)
      {
        $cloth[$row][$col] = 0
      }
      $cloth[$row][$col] += 1
      #Write-host "$id, $row x $col"
    }
  }
}

$cloth.Values.values|?{$_ -gt 1}|measure-object

# Day 3 - Part 2

:patch ForEach ($patch in $patches) {
  $id = $patch -replace "#([\d]*).*","`$1"
  $rowx = $patch -replace "[^@]*@\s*([^,]*),.*","`$1"
  $coly = $patch -replace "[^@]*@\s*[^,]*,([^:]*):.*","`$1"
  $lenx = $patch -replace "[^:]*:\s*([^x]*).*","`$1"
  $leny = $patch -replace "[^x]*x\s*([\d]*).*","`$1"

  ForEach ($row in ($rowx..([int]$rowx+$lenx-1)))
  {
    ForEach ($col in ($coly..([int]$coly+[int]$leny-1)))
    {
      if ($cloth[$row][$col] -gt 1)
      {
        continue patch
      }
    }
  }
  Write-Host "Woho its ID: $id"
}
