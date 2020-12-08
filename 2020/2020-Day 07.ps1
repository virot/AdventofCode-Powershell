$rulesin = @'
'@ -split "`r`n"

$rules = @{}
$rulesin | %{$in, $out = [regex]::Split($_, '\s*bags contain\s*'); $rules[$in]=$out}
$ourbag = 'shiny gold bag'

# star 1
$possiblebags = @($ourbag)
$oldpossiblebags = @()
While( $possiblebags.count -ne $oldpossiblebags.Count)
{
  #Write-Host "Start: $($possiblebags.count)"
  $oldpossiblebags = $possiblebags
  $possiblebags = @()
  ForEach ($bag in $rules.Keys)
  {
    ForEach($testadbag in $oldpossiblebags)
    {
      if ($rules[$bag] -match "$testadbag")
      {
        $possiblebags += $bag
        #Write-Host "Adding $bag"
      }
    }
  }
  $possiblebags += $ourbag
  $possiblebags = $possiblebags|Sort-Object -Unique
}

Write-Host "Star1 answer: $($possiblebags.count-1)"

# star 2
$ourbag = 'shiny gold'
$countedbags = @()
$nextround = @($ourbag)
While($nextround.count -gt 0){
  $newround = @()
  ForEach($bag in $nextround)
  {
    $countedbags += $bag
    if ($rules[$bag] -ne 'no other bags.')
    {
      #Write-Host "going through $($rules[$bag])"
      ForEach ($newbag in ($rules[$bag] -split ','))
      {
        #write-host "$newbag"
        $null, $count, $color = [regex]::Match($newbag,'\s*([0-9]*)\s*(.*) bag.*')|select -exp groups
        1..$count.ToString()| ForEach {
          $newround += $color.ToString()
        }
        #Write-host  "$($count.ToString()) X $($color.ToString())"
      }
    }
  }
  $nextround = $newround
}

Write-Host "Star2 answer: $($countedbags.Count-1)"