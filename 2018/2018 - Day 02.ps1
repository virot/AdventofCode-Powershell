$boxes = @'
'@ -split "`r`n"
$testboxes = @'
abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab
'@ -split "`r`n"

# Day 2 - Step 1
$numberOfThrees = 0
$numberOfTwos = 0

forEach ($box in $boxes) {
  $stats = $box -split "" |?{$_ -ne ''}|Group-Object
  if ($Null -ne ($stats|?{$_.count -eq 2})){
    $numberOfTwos += 1
  }
  if ($Null -ne ($stats|?{$_.count -eq 3})){
    $numberOfThrees += 1
  }
}
Write-Host "Checksum: $($numberOfThrees*$numberOfTwos)"

# Day 2 - Step 2
$testboxes = @'
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
'@ -split "`r`n"

$templist = ForEach ($box in $boxes) {
  ForEach ($i in 0..($box.Length-1))
  {
    $right = $box.length-1-$i
    "$i,$($box -replace "^(.{$i}).(.{$right})","`$1`$2")"
  }
}

$boxesToFind = $templist|group |?{$_.count -gt 1}|select -first 1 -exp name
