class IntCodeComputer {
    hidden [System.Collections.ArrayList]$Program = @()
    hidden [int]$ProgramPointer=0
    hidden [System.Collections.ArrayList]$Inputdata = @()
    [int]$Output
    [IntComputerStatus]$Status=[IntComputerStatus]::NewlyCreated

    IntCodeComputer(){
    }

    IntCodeComputer([int[]]$Program){
            ForEach($Instruction in $Program) {
            $this.Program.add($Instruction)|Out-Null
        }
        $this.Run()
    }
    IntCodeComputer([int[]]$Program, [int[]]$Inputdata){
        ForEach($Instruction in $Program) {
            $this.Program.add($Instruction)|Out-Null
        }
        ForEach($In in $Inputdata) {
            $this.Inputdata.add($In)|Out-Null
        }
        $this.run()
    }
    IntCodeComputer([int[]]$Program, [int[]]$Inputdata, [int]$ProgramPointer){
        ForEach($Instruction in $Program) {
            $this.Program.add($Instruction)|Out-Null
        }
        ForEach($In in $Inputdata) {
            $this.Inputdata.add($In)|Out-Null
        }
        $this.ProgramPointer = $ProgramPointer
        $this.run()
    }

    AddInput ([int[]]$Inputdata)
    {
        ForEach($In in $Inputdata) {
            $this.Inputdata.add($In)|Out-Null
        }
        $this.run()
    }

    Run ()
    {
        $this.status = [IntComputerStatus]::Running
        $ProofOfLife = 0
        :program While($ProofOfLife++ -lt 1000 -and $this.ProgramPointer -lt $this.Program.Count){
            Write-Verbose "debug programPointer=$($this.ProgramPointer), inst=$(($this.ProgramPointer..($this.ProgramPointer+4)|ForEach-Object{$this.program[$_]}) -join ',')"
            [char]$param1PI = $this.program[$this.ProgramPointer].tostring('00000')[2]
            [char]$param2PI = $this.program[$this.ProgramPointer].tostring('00000')[1]
            [char]$param3PI = $this.program[$this.ProgramPointer].tostring('00000')[0]
#Implement Absolute vaules
            if (($this.ProgramPointer+1) -ge $this.program.count) {
                [int]$arg1 = -10000
            }
            elseif ($param1PI -eq '0') {
                [int]$arg1 = $this.program[$this.program[$this.ProgramPointer+1]]
            }
            else {
                [int]$arg1 = $this.program[$this.ProgramPointer+1]
            }
            if (($this.ProgramPointer +2) -ge $this.program.count) {
                [int]$arg2 = -10000
            }
            elseif ($param2PI -eq '0') {
                [int]$arg2 = $this.program[$this.program[$this.ProgramPointer+2]]
            }
            else {
                [int]$arg2 = $this.program[$this.ProgramPointer+2]
            }
            if (($this.ProgramPointer +3) -ge $this.program.count) {
                [int]$arg3 = -100000
            }
            elseif ($param3PI -eq '0') {
                [int]$arg3 = $this.program[$this.program[$this.ProgramPointer +2]]
            }
            else {
                [int]$arg3 = $this.program[$this.ProgramPointer +2]
            }
            Write-Verbose "INST: $($this.program[$this.ProgramPointer] % 100) ARGS: $arg1, $arg2, $arg3, DIRECT: $param1PI,$param2PI,$param3PI"
#Main program
            switch ($this.program[$this.ProgramPointer] % 100)
            {
                1   {
                    $DestinationPointer = $this.program[$this.ProgramPointer+3]
                    Write-Verbose "$($this.ProgramPointer.tostring('0000')): ADD $($arg1) + $($arg2) DST: $($DestinationPointer)"
                    $this.Program[$DestinationPointer]= ($arg1 + $arg2)
                    $this.ProgramPointer += 4
                }
                2   {
                    $DestinationPointer = $this.program[$this.ProgramPointer+3]
                    Write-Verbose "$($this.ProgramPointer.tostring('0000')): MUL $($arg1) * $($arg2) DST: $($DestinationPointer)"
                    $this.program[$DestinationPointer] = $arg1 * $arg2
                    $this.ProgramPointer += 4
                }
                # 3 - Input
                3   {
                    write-verbose "$($this.inputdata.count) counter for input"
                    if ($this.Inputdata.count -ge 1)
                    {
                        $DestinationPointer = $this.program[$this.ProgramPointer+1]
                        write-Verbose "Input POINT:$DestinationPointer => OLD:$($this.program[$DestinationPointer]) NEW:$($this.inputdata[0])"
                        $this.program[$DestinationPointer] = $this.inputdata[0] #$invalue[$inputcounter]
                        $this.inputdata.RemoveAt(0)
                        $this.ProgramPointer += 2
                    }
                    else {
                        $this.status = [IntComputerStatus]::MissingInput
                        break program
                    }
                }
                # 4 - Output
                4   {
                    $SourcePointer = $this.program[$this.ProgramPointer+1]
                    Write-Verbose "Output ($($SourcePointer)) $($this.program[$SourcePointer])"
                    $this.ProgramPointer += 2
                    $this.status = [IntComputerStatus]::OutputAvailable
                    $this.Output = $($this.program[$SourcePointer])
                    break program
                }
                5   {
                    Write-Verbose "$($this.ProgramPointer.tostring('0000')): JumpNonZero $arg1, $arg2"
                    if ($arg1 -ne 0){$this.ProgramPointer = $arg2}else{$this.ProgramPointer+=3}

                }
                6   {
                    Write-Verbose "$($this.programpointer.tostring('0000')): JumpZero $arg1, $arg2"
                    if ($arg1 -eq 0){$this.ProgramPointer = $arg2}else{$this.ProgramPointer+=3}
                }
                7   {
                    $DestinationPointer = $this.program[$this.ProgramPointer+3]
                    Write-Verbose "$($this.programpointer.tostring('0000')): LT $arg1, $arg2"
                    if ($arg1 -lt $arg2){
                    $this.program[$DestinationPointer] = 1
                    }
                    else
                    {
                    $this.program[$DestinationPointer] = 0
                    }
                    $this.ProgramPointer += 4
                }
                8 {
                    $DestinationPointer = $this.program[$this.ProgramPointer+3]
                    Write-Verbose "$($this.programpointer.tostring('0000')): EQ $arg1, $arg2, DEST=$DestinationPointer"
                    if ($arg1 -eq $arg2){
                    $this.program[$this.program[$this.ProgramPointer+3]] = 1
                    }
                    else
                    {
                    $this.program[$this.program[$this.ProgramPointer+3]] = 0
                    }
                    $this.ProgramPointer += 4
                }
                #99 - End program
                99 {
                    #Write-Host "Ending program"
                    Write-Verbose "$($this.programpointer.tostring('0000')): PROGRAM COMPLETE"
                    $this.status = [IntComputerStatus]::Completed
                    break program
                }
                default {
                    $this.status = [IntComputerStatus]::Failed
                    Throw "Program broken tried to execute bad stuff, $($this.Program[$this.ProgramPointer])"
                    break program
                }
            }
        }
    }  
}

enum IntComputerStatus{
  Completed = 0
  OutputAvailable = 1
  MissingInput = 2
  Failed = -1
  NewlyCreated = -2
  Running = 3
}

#$test = [IntCodeComputer]::new(@(1,9,10,3,2,3,11,0,99,30,40,50))

#$Test = [IntCodeComputer]::new(@(3,9,8,9,10,9,4,9,99,-1,8))
#$Test.AddInput(8)
#$Test.status
#$Test.Output
#$Test = [IntCodeComputer]::new(@(3,9,8,9,10,9,4,9,99,-1,8),@(9))
#$Test.Output
$Test = [IntCodeComputer]::new(@(3,3,1107,-1,8,3,4,3,99),@(7))
$Test.Output
$Test = [IntCodeComputer]::new(@(3,3,1108,-1,8,3,4,3,99),@(9))
$Test.Output
$Test.Status
$test.run()
$test.status
#$Test.Program


#[IntCodeComputer]::new
#$test.ProgramPointer