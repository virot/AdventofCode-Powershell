class IntCodeComputer {
    hidden [System.Collections.ArrayList]$Program = @()
    hidden [int]$ProgramPointer=0
    hidden [System.Collections.ArrayList]$Inputdata = @()
    [int64]$Output
    hidden [int]$Relative=0
    [IntComputerStatus]$Status=[IntComputerStatus]::NewlyCreated

    IntCodeComputer(){
    }

    IntCodeComputer([int64[]]$Program){
            ForEach($Instruction in $Program) {
            $this.Program.add([int64]$Instruction)|Out-Null
        }
        0..1000|ForEach-Object {$this.Program.add([int64]0)|Out-Null}
        $this.Run()
    }
    IntCodeComputer([int64[]]$Program, [int[]]$Inputdata){
        ForEach($Instruction in $Program) {
            $this.Program.add([int64]$Instruction)|Out-Null
        }
        ForEach($In in $Inputdata) {
            $this.Inputdata.add($In)|Out-Null
        }
        0..1000|ForEach-Object {$this.Program.add([int64]0)|Out-Null}
        $this.run()
    }
    IntCodeComputer([int64[]]$Program, [int[]]$Inputdata, [int]$ProgramPointer){
        ForEach($Instruction in $Program) {
            $this.Program.add([int64]$Instruction)|Out-Null
        }
        ForEach($In in $Inputdata) {
            $this.Inputdata.add($In)|Out-Null
        }
        $this.ProgramPointer = $ProgramPointer
        0..1000|ForEach-Object {$this.Program.add([int64]0)|Out-Null}
        $this.run()
    }

    AddInput ([int[]]$Inputdata)
    {
        ForEach($In in $Inputdata) {
            $this.Inputdata.add($In)|Out-Null
        }
        $this.run()
    }

    hidden [int64]GetPointerForArgument ([int]$Argument) {
        if (($this.ProgramPointer + $Argument +1) -gt $this.Program.Count) {throw "Reading outside of memory"}
        $ParamType = $this.program[$this.ProgramPointer].tostring('00000')[3-$Argument]
        switch ($ParamType) {
            '0' {return ($this.program[$this.ProgramPointer+$Argument])}
            '1' {return ($this.ProgramPointer+$Argument)}
            '2' {return ($this.Relative+($this.program[$this.ProgramPointer+$Argument]))}
            default {throw "Not correctly formated Operation"}
        }
        return $false
    }

    hidden [int64]GetValueForArgument ([int]$Argument) {
        if (($this.ProgramPointer + $Argument +1) -gt $this.Program.Count) {throw "Reading outside of memory"}
        $ParamType = $this.program[$this.ProgramPointer].tostring('00000')[3-$Argument]
        switch ($ParamType) {
            '0' {return ($this.program[$this.program[$this.ProgramPointer+$Argument]])}
            '1' {return ($this.program[$this.ProgramPointer+$Argument])}
            '2' {return ($this.program[$this.Relative+$this.program[$this.ProgramPointer+$Argument]])}
            default {throw "Not correctly formated Operation"}
        }
        return $false
        return $this.program[$this.GetPointerForArgument($Argument)]
    }

    Run ()
    {
        $this.status = [IntComputerStatus]::Running
        $ProofOfLife = 0
        :program While($ProofOfLife++ -lt 100000 -and $this.ProgramPointer -lt $this.Program.Count){
            Write-verbose "$($this.programpointer.tostring('0000')) debug inst=$(($this.ProgramPointer..($this.ProgramPointer+4)|ForEach-Object{$this.program[$_]}) -join ','), PRoof:$ProofOfLife, Rel:$($this.Relative)"
#Main program
            switch ($this.program[$this.ProgramPointer] % 100)
            {
                1   {
                    $arg1 = $this.GetValueForArgument(1)
                    $arg1_p = $this.GetPointerForArgument(1)
                    $arg2 = $this.GetValueForArgument(2)
                    $arg2_p = $this.GetPointerForArgument(2)
                    $arg3_p = $this.GetPointerForArgument(3)
                    $DestinationPointer = $this.program[$this.ProgramPointer+3]
                    Write-verbose "$($this.ProgramPointer.tostring('0000')): $($arg1) ($arg1_p) + $($arg2) ($arg2_p)= ($($arg3_p))"
                    $this.Program[$arg3_p]= ($arg1 + $arg2)
                    $this.ProgramPointer += 4
                }
                2   {
                    $arg1 = $this.GetValueForArgument(1)
                    $arg1_p = $this.GetPointerForArgument(1)
                    $arg2 = $this.GetValueForArgument(2)
                    $arg2_p = $this.GetPointerForArgument(2)
                    $arg3_p = $this.GetPointerForArgument(3)
                    $DestinationPointer = $this.program[$this.ProgramPointer+3]
                    Write-verbose "$($this.ProgramPointer.tostring('0000')): $($arg1) ($arg1_p) x $($arg2) ($arg2_p)= ($($arg3_p))"
                    $this.program[$arg3_p] = $arg1 * $arg2
                    $this.ProgramPointer += 4
                }
# 3 - Input
                3   {
                    if ($this.Inputdata.count -ge 1)
                    {
                        $arg1_p = $this.GetPointerForArgument(1)
                        Write-Verbose "($this.programpointer.tostring('0000')): INPUT $arg1_p => OLD:$($this.program[$arg1_p]) NEW:$($this.inputdata[0])"
                        $this.program[$arg1_p] = $this.inputdata[0]
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
                    $arg1 = $this.GetValueForArgument(1)
                    $arg1_p = $this.GetPointerForArgument(1)
                    $SourcePointer = $this.program[$this.ProgramPointer+1]
                    Write-verbose "($this.programpointer.tostring('0000')): Output ($($arg1_p)) $($arg1)"
                    $this.ProgramPointer += 2
                    $this.status = [IntComputerStatus]::OutputAvailable
                    $this.Output = $arg1
                    break program
                }
# 5 - Jump on Non Zero
                5   {
                    $arg1 = $this.GetValueForArgument(1)
                    $arg1_p = $this.GetPointerForArgument(1)
                    $arg2 = $this.GetValueForArgument(2)
                    Write-verbose "$($this.ProgramPointer.tostring('0000')): JumpOnNonZero $arg1 ($arg1_p) DEST: $arg2"
                    if ($arg1 -ne 0){$this.ProgramPointer = $arg2}else{$this.ProgramPointer+=3}

                }
# 6 - Jump on Zero
                6   {
                    $arg1 = $this.GetValueForArgument(1)
                    $arg1_p = $this.GetPointerForArgument(1)
                    $arg2 = $this.GetValueForArgument(2)
                    $arg2_p = $this.GetPointerForArgument(2)
                    $arg3_p = $this.GetPointerForArgument(3)
                    Write-verbose "$($this.programpointer.tostring('0000')): JumpOnZero $arg1 ($arg1_p) DEST: $arg2"
                    if ($arg1 -eq 0){$this.ProgramPointer = $arg2}else{$this.ProgramPointer+=3}
                }
                7   {
                    $arg1 = $this.GetValueForArgument(1)
                    $arg1_p = $this.GetPointerForArgument(1)
                    $arg2 = $this.GetValueForArgument(2)
                    $arg2_p = $this.GetPointerForArgument(2)
                    $arg3_p = $this.GetPointerForArgument(3)
                    $DestinationPointer = $this.program[$this.ProgramPointer+3]
                    Write-verbose "$($this.programpointer.tostring('0000')): $arg1 ($arg1_p) -lt $arg2 ($arg2_p), ($arg3_p)=$([int]($arg1 -lt $arg2))"
                    $this.program[$arg3_p] = [int]($arg1 -lt $arg2)
                    $this.ProgramPointer += 4
                }
                8 {
                    $arg1 = $this.GetValueForArgument(1)
                    $arg1_p = $this.GetPointerForArgument(1)
                    $arg2 = $this.GetValueForArgument(2)
                    $arg2_p = $this.GetPointerForArgument(2)
                    $arg3_p = $this.GetPointerForArgument(3)
                    Write-verbose "$($this.programpointer.tostring('0000')): $arg1 ($arg1_p) -eq $arg2 ($arg2_p), ($arg3_p)=$([int]($arg1 -eq $arg2))"
                    $this.program[$arg3_p] = [int]($arg1 -eq $arg2)
                    $this.ProgramPointer += 4
                }
# 9 - Change Relative mode
                9   {
                    $arg1 = $this.GetValueForArgument(1)
                    Write-verbose "$($this.programpointer.tostring('0000')): Change relative pointer $($this.Relative) - $arg1 =$($this.Relative + $arg1)"
                    $this.Relative += $this.GetValueForArgument(1)
                    $this.ProgramPointer += 2
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