
Function Invoke-AoCDay5
{
  param([int]$invalue,[int[]]$Program)
  Process
  {
    $i = 0
#    :program For($i=0; $i -lt $program.count; $i += 4){
    :program While($i -lt $program.count){
      write-host "debug pP=$i, inst=$(($i..($i+3)|%{$program[$_]}) -join ',')"
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

      Write-Host "ARGS: $arg1, $arg2, $arg3, DIRECT: $param1PI,$param2PI,$param3PI"
      switch ($program[$i] % 100)
      {
        1 {
          Write-Host "$($i.tostring('0000')): ADD $($arg1) + $($arg2) DST: $($program[$i+3])"
          $program[$program[$i+3]] = $arg1 + $arg2
          $i += 4
        }
        2 {
          Write-Host "$($i.tostring('0000')): MUL $($arg1) * $($arg2) DST: $($program[$i+3])"
          $program[$program[$i+3]] = $arg1 * $arg2
          $i += 4
        }
        3 {
          $program[$program[$i+1]] = $invalue
          write-host "Input $invalue => $($program[$program[$i+1]])"
          $i += 2
        }
        4 {
          Write-Host "Output $($program[$program[$i+1]])"
          $i += 2
        }
        5 {
          write-host "$($i.tostring('0000')): JumpNonZero $arg1, $arg2"
          if ($arg1 -ne 0){$i = $arg2}else{$i+=3}

        }
        6 {
          write-host "$($i.tostring('0000')): JumpZero $arg1, $arg2"
          if ($arg1 -eq 0){$i = $arg2}else{$i+=3}
        }
        7 {
          write-host "$($i.tostring('0000')): GT $arg1, $arg2"
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
          write-host "$($i.tostring('0000')): EQ $arg1, $arg2"
          if ($arg1 -eq $arg2){
            $program[$program[$i+3]] = 1
          }
          else
          {
            $program[$program[$i+3]] = 0
          }
          $i += 4
        }
        99 {
          #Write-Host "Ending program"
          write-host "$($i.tostring('0000')): PROGRAM COMPLETE"
          break program
        }
        default {Throw "Program broken tried to execute bad stuff, $($Program[$i])"}
      }
    }
  }
}

#Invoke-AoCDay5 -Program @(1002,4,3,4,33) -invalue 1
Invoke-AoCDay5 -invalue 4 -Program 3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9
Invoke-AoCDay5 -invalue 0 -Program 3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99

