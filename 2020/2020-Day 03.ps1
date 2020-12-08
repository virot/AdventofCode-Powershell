$map = @'
'@ -split "`r`n"

#Star 1
$result = For($row = 0; $row -lt $map.Count; $row++)
{
 $map[$row][(($row * 3) % $map[0].length)]
}
$result|Group-Object -NoElement 

#Star 2
$tot = 1
ForEach($dist in @(@{'right'=1;'down'=1},@{'right'=3;'down'=1},@{'right'=5;'down'=1},@{'right'=7;'down'=1},@{'right'=1;'down'=2}))
{
  $result = For($row = 0; $row -lt $map.Count; $row = $row + $dist['down'])
  {
   $map[$row][((($row / $dist['down']) * $dist['right']) % $map[0].length)]
  }
  $tot *= ($result | Where-Object {$_ -eq '#'}).count
}
$tot