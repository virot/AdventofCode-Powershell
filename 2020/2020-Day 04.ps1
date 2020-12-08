$passports = @'
'@ -split "`r`n`r`n"

$Passports = ForEach ($passport in $passports)
{
  $temp = @{}
  ForEach($pair in ($passport -replace "`r`n",' ' -split "\ " |?{$_ -ne ''}))
  {
    $tempname, $tempvalue = $pair -split ':'
    $temp[$tempname] = $tempvalue
  }
  $temp
}

$report = ForEach ($passport in $passports)
{
  $heightvalue, $cminch = [regex]::split($passport['hgt'],'(cm|in)')
  $passport['byr'] -ge 1920 -and $passport['byr'] -le 2002 -and $passport['iyr'] -ge 2010 -and $passport['iyr'] -le 2020 -and $passport['eyr'] -ge 2020 -and $passport['eyr'] -le 2030 -and $passport['hcl'] -match '^\#[0-9a-f]{6}$' -and @('amb','blu','brn','gry','grn','hzl','oth') -contains $passport['ecl'] -and $passport['pid'] -match '^[0-9]{9}$' -and (($cminch -eq 'cm' -and $heightvalue -ge 150 -and $heightvalue -le 193) -or ($cminch -eq 'in' -and $heightvalue -ge 59 -and $heightvalue -le 76))
}
$report|group-object