# Day 5 - Step 1

$input_test = 'dabAcCaCBAcCcaDA'
$input_data = ''


$string = $input_data
function react-string{
param ([string]$string)
  Process
  {
    For($i = 0; $i -lt $string.Length; $i++)
    {
      if ($string[$i] -cne $string[$i+1] -and $string[$i] -eq $string[$i+1])
      {
        Write-Progress -Activity "Finding reactions" -Status "$i of $($string.Length)" -ParentId 1
        #Write-Host "Removing stuff $($string[$i])$($string[$i+1])"
        $string = $string.Remove($i,2)
        #Write-Host "New string: $($string.Length)"
        if ($i -gt 20)
        {
          $i -= 20
        }
        else
        {
          $i = -1
        }
      }
    }
    return $string.Length
  }
}
react-string -string $input_data

# Day 5 - Step 2
$stringFull = $input_data
$alts = $string -split ''|?{$_ -ne ''}|Group-Object -NoElement |Sort-Object|select -exp name
$lowest = 10000
$lowest_alt = ''
ForEach ($alt in $alts)
{
  Write-Progress -id 1 -Status "$alt / $($alts.count)" -Activity "Going through all the Alts"
  $return = react-string -string (-join ($input_data -split ''|?{$_ -ne '' -and $_ -ne $alt}))
  if ($return -lt $lowest)
  {
    $lowest = $return
    $lowest_alt = $alt
  }
}
$lowest_alt