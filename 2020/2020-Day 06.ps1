$answers = @'
'@ -split "`r`n`r`n"

$answers = @'
abc

a
b
c

ab
ac

a
a
a
a

b
'@ -split "`r`n`r`n"



#Star 1
$answers | ForEach{($_ -split "(.)" |?{$_ -notmatch '^\s*$'}|Sort-Object -Unique).count}|Measure-Object -Sum

#Star 2
$result = ForEach ($answer in $answers){([array]($answer -split "(.)" |?{$_ -notmatch '^\s*$'}|Group-Object -NoElement|?{$_.count -eq (($answer -split "`r`n").count)})).count}
$result |measure-object -Sum
