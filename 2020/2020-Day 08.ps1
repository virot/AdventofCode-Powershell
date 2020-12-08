$program = @'
'@ -split "`r`n"

#Star 1
$ip = 0
$accumulator = 0
$visitedIP = @()
While ($ip -lt $program.Count -and $visitedIP -notcontains $ip){
  $visitedIP += $ip
  Write-Host "Running $($program[$ip])`t`tIP:[$ip]`tACC:[$accumulator]"
  Switch ($program[$ip] -replace '^([a-z]{3}).*','$1'){
    'nop' {
        $ip += 1
    }
    'acc' {
        $accumulator += [int]($program[$ip] -replace '^[a-z]{3}[^+-]*([0-9+-])','$1')
        $ip += 1
    }
    'jmp' {
        $ip += [int]($program[$ip] -replace '^[a-z]{3}[^+-]*([0-9+-])','$1')
    }
  }
}

$accumulator

#Star 2
ForEach ($fix in 0..($program.Count-1))
{
  $ip = 0
  $accumulator = 0
  $visitedIP = @()
  if ($program[$fix] -match '^(nop|jmp).*')
  {
    Write-Host "Trying to change ip $($fix): $($program[$fix])"
    While ($ip -lt $program.Count -and $visitedIP -notcontains $ip){
      $visitedIP += $ip
      #Write-Host "Running $($program[$ip])`t`tIP:[$ip]`tACC:[$accumulator]"
      if ($ip -ne $fix)
      {
        Switch ($program[$ip] -replace '^([a-z]{3}).*','$1'){
          'nop' {
              $ip += 1
          }
          'acc' {
              $accumulator += [int]($program[$ip] -replace '^[a-z]{3}[^+-]*([0-9+-])','$1')
              $ip += 1
          }
          'jmp' {
              $ip += [int]($program[$ip] -replace '^[a-z]{3}[^+-]*([0-9+-])','$1')
          }
        }
      }
      else
      {
        Switch ($program[$ip] -replace '^([a-z]{3}).*','$1'){
          'jmp' {
              $ip += 1
          }
          'nop' {
              $ip += [int]($program[$ip] -replace '^[a-z]{3}[^+-]*([0-9+-])','$1')
          }
        }
      }
    }
  }
  if ($ip -ge $program.Count){
    Write-Host -ForegroundColor Green "Found it.. change ip=$ip; Acc=$accumulator" 
    break;
  }
}