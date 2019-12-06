#0823
measure-command{
$program_example = @(1,9,10,3,2,3,11,0,99,30,40,50)
$program_example_2 = @(1,0,0,0,99)
$program_input = @(1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,6,19,1,9,19,23,2,23,10,27,1,27,5,31,1,31,6,35,1,6,35,39,2,39,13,43,1,9,43,47,2,9,47,51,1,51,6,55,2,55,10,59,1,59,5,63,2,10,63,67,2,9,67,71,1,71,5,75,2,10,75,79,1,79,6,83,2,10,83,87,1,5,87,91,2,9,91,95,1,95,5,99,1,99,2,103,1,103,13,0,99,2,14,0,0)

$program = $program_input
$program[1] = 12
$program[2]=2
Function Invoke-AoCDay2
{
  param([int[]]$Program)
  Process
  {
    :program For($i=0; $i -lt $program.count; $i += 4){
      switch ($program[$i])
      {
        1 {
          #Write-Host "Adding $($program[$program[$i+1]]) + $($program[$program[$i+2]])"
          $program[$program[$i+3]] = $program[$program[$i+1]] + $program[$program[$i+2]]
        }
        2 {
          #Write-Host "Multiplying $($program[$program[$i+1]]) x $($program[$program[$i+2]])"
          $program[$program[$i+3]] = $program[$program[$i+1]] * $program[$program[$i+2]]
        }
        99 {
          #Write-Host "Ending program"
          return $program[0]
        }
        default {Throw "Program broken tried to execute bad stuff"}
      }
    }
  }
}
$program[0]

#Day 02 - Step 2

:noun ForEach ($noun in 0..99)
{
  ForEach ($verb in 0..99)
  {
    $program = $program_input
    $program[1] = $noun
    $program[2] = $verb
    if ((Invoke-AoCDay2 -Program $program) -eq 19690720)
    {
      Write-Host "Noun $noun, Verb: $verb"
      break noun
    }
  }
}

}