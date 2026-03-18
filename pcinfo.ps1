$FullName=Read-Host "Fullname"
$PropertyNumber=Read-Host "Property No."
$mb=Get-CimInstance Win32_BaseBoard
$cpu=(Get-CimInstance Win32_Processor).Name
$ram = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB, 0)
$os=(Get-CimInstance Win32_OperatingSystem).Caption
$gpu=(Get-CimInstance Win32_VideoController).Name

$disks=Get-PhysicalDisk|ForEach-Object{
($_.FriendlyName+' '+$_.MediaType+' '+[math]::Round($_.Size/1GB)+'GB')
}

Invoke-RestMethod -Uri "https://script.google.com/a/macros/deped.gov.ph/s/AKfycbxIqOkQz6kjZdg6eFIoZSLN5Y9vHVxojEHebb2eOijuFFlUF3qb6aJzN5u2Sx8IXzzdRg/exec" -Method POST -Body @{
fullname = $FullName
propertynumber = $PropertyNumber
pc=$env:COMPUTERNAME
mbbrand=$mb.Manufacturer
mbmodel=$mb.Product
cpu=$cpu
ram=$ram
storage=($disks -join ' | ')
gpu=$gpu
windows=$os
}
