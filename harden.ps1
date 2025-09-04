# Display the computer's hostname
Write-Host "Hostname: $env:COMPUTERNAME"
# Display the Windows version
Write-Host "Windows Version:" 
Get-ComputerInfo | Select-Object -Property WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer
