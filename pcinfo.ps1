$FullName = Read-Host "Fullname"
$PropertyNumber = Read-Host "Property No."

# Device type
$choice = Read-Host "Select Device Type [1]Laptop [2]Desktop:"
if ($choice -eq "1") {
    $deviceType = "Laptop"
} elseif ($choice -eq "2") {
    $deviceType = "Desktop"
} else {
    $deviceType = "Unknown"
}

# Motherboard + UUID
$mb = Get-CimInstance Win32_BaseBoard
$uuid = (Get-CimInstance Win32_ComputerSystemProduct).UUID
$mbmodel = $mb.Product + " | " + $uuid

# CPU (brand + model)
$cpuInfo = Get-CimInstance Win32_Processor
$cpu = $cpuInfo.Name

# RAM (separate sticks)
$ramList = Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
    $brand = $_.Manufacturer
    $capacity = [math]::Round($_.Capacity / 1GB)
    $serial = $_.SerialNumber
    "$brand ${capacity}GB SN:$serial"
}
$ram = ($ramList -join " | ")

# STORAGE (brand + capacity + type + serial)
$storageList = Get-CimInstance Win32_DiskDrive | ForEach-Object {
    $brand = $_.Model
    $capacity = [math]::Round($_.Size / 1GB)
    $type = if ($_.MediaType) { $_.MediaType } else { "Unknown" }
    $serial = $_.SerialNumber
    "$brand ${capacity}GB $type SN:$serial"
}
$storage = ($storageList -join " | ")

# GPU (brand + VRAM if available)
$gpuList = Get-CimInstance Win32_VideoController | ForEach-Object {
    $name = $_.Name
    $vram = if ($_.AdapterRAM) { [math]::Round($_.AdapterRAM / 1GB) } else { "?" }
    "$name ${vram}GB"
}
$gpu = ($gpuList -join " | ")

# OS
$os = (Get-CimInstance Win32_OperatingSystem).Caption

Invoke-RestMethod -Uri "YOUR_WEB_APP_URL" -Method POST -Body @{
    fullname = $FullName
    propertynumber = $PropertyNumber
    devicetype = $deviceType 
    pc = $env:COMPUTERNAME
    mbmodel = $mbmodel
    cpu = $cpu
    ram = $ram
    storage = $storage
    gpu = $gpu
    windows = $os
}
