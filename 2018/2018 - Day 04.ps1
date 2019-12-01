#Day 4 - Step 1
$schedulerawtest = @'
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:46] wakes up
[1518-11-04 00:36] falls asleep
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
'@ -split "`r`n" |Sort-Object

$scheduleraw = @'
'@ -split "`r`n" |Sort-Object


$schedule = @()

ForEach($row in $scheduleraw)
{
  $time = Get-Date ($row -replace '^\[([^\]]*).*','$1')
  $message = $row -replace "^[^\]]*\]\s*"
  if ($message -like 'Guard*')
  {
    $guardid = $message -replace "[^#]*#[^\d]*([\d]*).*",'$1'
  }
  elseif ($message -like 'falls asleep')
  {
    $sleeptime = $time
  }
  elseif ($message -like 'wakes up')
  {
    #Write-Host "Guard: $guardid, started:$sleeptime, ended: $(($time - $sleeptime).Minutes)"
    $schedule += $true|select @{l='id';e={$guardid}},@{l='start';e={$sleeptime}},@{l='sleeptime';e={($time - $sleeptime).Minutes}} 
  }
}

$sleeper = $schedule|Group-Object id|ForEach {
  $_|select name,@{l='sleeptime';e={($_.group |Measure-Object -Sum sleeptime).sum}}
}|sort -Descending sleeptime|select -first 1 name

$popularminute = $schedule |?{$_.id -eq $sleeper.name}|%{$_.start.minute..($_.start.minute+$_.sleeptime-1)}|group-object -NoElement|sort -Descending count|select -first 1|select -exp name

Write-Host "Answer: $([int]$popularminute*[int]$sleeper.Name)"

# Day 5 - Part 2
$allminutes = ForEach ($entry in $schedule) {$entry.start.minute..($entry.start.minute+$entry.sleeptime-1)|%{"$($entry.id)_$_"}}
$allminutes |group-object -NoElement|sort -Descending count|select -first 1|select -exp name|%{Write-Host "Answer: $([int]($_ -split "_"|select -first 1)*($_ -split "_"|select -first 1 -skip 1))"}

