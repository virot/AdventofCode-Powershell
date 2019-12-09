
Function Invoke-IntCodeComputer
{
  param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({@('int16','int32','int64','uint16','uint32','uint64','array') -contains $_.GetType().Name})]
    $invalue,
    [Parameter(Mandatory=$true)]
    [int[]]$Program
  )
  Process
  {
    $inputcounter=0
    $i = 0
#    :program For($i=0; $i -lt $program.count; $i += 4){
    :program While($i -lt $program.count){
      write-verbose "debug pP=$i, inst=$(($i..($i+3)|%{$program[$_]}) -join ',')"
      $param1PI = $program[$i].tostring('00000')[2]
      $param2PI = $program[$i].tostring('00000')[1]
      $param3PI = $program[$i].tostring('00000')[0]
      if (($i+1) -ge $program.count)
      {
        $arg1 = -10000
      }
      elseif ($param1PI -eq '0') {
        $arg1 = $program[$program[$i+1]]
      }
      else {
        $arg1 = $program[$i+1]
      }
      
      if (($i +2) -ge $program.count)
      {
        $arg2 = -10000
      }
      elseif ($param2PI -eq '0') {
        $arg2 = $program[$program[$i+2]]
      }
      else {
        $arg2 = $program[$i+2]
      }
      
      if (($i +3) -ge $program.count)
      {
        $arg3 = -100000
      }
      elseif ($param3PI -eq '0') {
        $arg3 = $program[$program[$i+2]]
      }
      else {
        $arg3 = $program[$i+2]
      }

      Write-verbose "ARGS: $arg1, $arg2, $arg3, DIRECT: $param1PI,$param2PI,$param3PI"
      switch ($program[$i] % 100)
      {
        1 {
          Write-verbose "$($i.tostring('0000')): ADD $($arg1) + $($arg2) DST: $($program[$i+3])"
          $program[$program[$i+3]] = $arg1 + $arg2
          $i += 4
        }
        2 {
          Write-verbose "$($i.tostring('0000')): MUL $($arg1) * $($arg2) DST: $($program[$i+3])"
          $program[$program[$i+3]] = $arg1 * $arg2
          $i += 4
        }
# 3 - Input
        3 {
          $program[$program[$i+1]] = $invalue[$inputcounter]
          $inputcounter += 1
          write-verbose "Input $invalue => $($program[$program[$i+1]])"
          $i += 2
        }
# 4 - Output
        4 {
          Write-Verbose "Output $($program[$program[$i+1]])"
          $retval = $($program[$program[$i+1]])
          $i += 2
        }
        5 {
          Write-Verbose "$($i.tostring('0000')): JumpNonZero $arg1, $arg2"
          if ($arg1 -ne 0){$i = $arg2}else{$i+=3}

        }
        6 {
          Write-Verbose "$($i.tostring('0000')): JumpZero $arg1, $arg2"
          if ($arg1 -eq 0){$i = $arg2}else{$i+=3}
        }
        7 {
          Write-Verbose "$($i.tostring('0000')): GT $arg1, $arg2"
          if ($arg1 -lt $arg2){
            $program[$program[$i+3]] = 1
          }
          else
          {
            $program[$program[$i+3]] = 0
          }
          $i += 4
        }
        8 {
          Write-Verbose "$($i.tostring('0000')): EQ $arg1, $arg2"
          if ($arg1 -eq $arg2){
            $program[$program[$i+3]] = 1
          }
          else
          {
            $program[$program[$i+3]] = 0
          }
          $i += 4
        }
#99 - End program
        99 {
          #Write-Host "Ending program"
          Write-Verbose "$($i.tostring('0000')): PROGRAM COMPLETE"
          return $retval
          break program
        }
        default {Throw "Program broken tried to execute bad stuff, $($Program[$i])"}
      }
    }
  }
}

#Invoke-AoCDay5 -Program @(1002,4,3,4,33) -invalue 1
Invoke-IntCodeComputer -invalue 4,0 -Program 3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9
Invoke-IntCodeComputer -invalue 0 -Program 3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99

$phasesettings = @()
ForEach($i0 in 0..4)
{
ForEach($i1 in 0..4)
{
ForEach($i2 in 0..4)
{
ForEach($i3 in 0..4)
{
ForEach($i4 in 0..4)
{
  if ((@($i0,$i1,$i2,$i3,$i4)|group-object|?{$_.count -eq 1}).Count -eq 5)
  {$phasesettings += "$i0$i1$i2$i3$i4"}
}
}
}
}
}

$program = @(3,8,1001,8,10,8,105,1,0,0,21,38,55,68,93,118,199,280,361,442,99999,3,9,1002,9,2,9,101,5,9,9,102,4,9,9,4,9,99,3,9,101,3,9,9,1002,9,3,9,1001,9,4,9,4,9,99,3,9,101,4,9,9,102,3,9,9,4,9,99,3,9,102,2,9,9,101,4,9,9,102,2,9,9,1001,9,4,9,102,4,9,9,4,9,99,3,9,1002,9,2,9,1001,9,2,9,1002,9,5,9,1001,9,2,9,1002,9,4,9,4,9,99,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99)

$MaximumTrust = 0
$MaximumTrustSettings = ''
ForEach ($trustsettings in $phasesettings)
{
  $intermediate = 0
  ForEach ($trust in ($trustsettings -split ""|?{$_ -ne ''}))
  {
     $intermediate = Invoke-IntCodeComputer -invalue @([int]$trust,$intermediate) -Program $program
  }
  if ($intermediate -gt $MaximumTrust)
  {
    $MaximumTrustSettings = $trustsettings
    $MaximumTrust = $intermediate
  }
}
Write-Host "Max Trust $MaximumTrust @ $MaximumTrustSettings"

<#Debug
Invoke-IntCodeComputer -invalue @(1,4321) -Program 3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0
#>