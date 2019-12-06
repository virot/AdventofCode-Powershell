
$password = [System.Collections.ArrayList]@()


$passwords = 1..999999|?{($_.tostring('000000')|?{($_[0] -eq $_[1] -or $_[1] -eq $_[2] -or $_[2] -eq $_[3] -or $_[3] -eq $_[4] -or $_[4] -eq $_[5]) -and ($_[1] -ge $_[0] -and $_[2] -ge $_[1] -and $_[3] -ge $_[2] -and $_[4] -ge $_[3] -and $_[5] -ge $_[4])})}
$passwords.count
$passwords|?{$_ -match "[$(($_ -Split('')|?{$_ -ne ''}|group -NoElement|?{$_.count -eq 2}|select -exp name) -join '')x]{2}"}|measure-object
