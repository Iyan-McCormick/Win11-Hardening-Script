# Define menu options
$menuOptions = @(
    "Document the system"
    # Define functions for each option
    function Document-System {
        Write-Host "`n--- Starting: Document the system ---`n"
    }
    "Enable updates"
    function Enable-Updates {
        Write-Host "`n--- Starting: Enable updates ---`n"
    }
    "User Auditing"
    # Loop through every local user account and prompt for authorization
$localUsers = Get-LocalUser | Where-Object { $_.Name -ne "Administrator" -and $_.Name -ne "DefaultAccount" -and $_.Name -ne "Guest" }
foreach ($user in $localUsers) {
    $prompt = "Is '$($user.Name)' an Authorized User? (Y/n): "
    $answer = Read-Host -Prompt $prompt
    if ($answer -eq "" -or $answer -match "^[Yy]$") {
        Write-Host "'$($user.Name)' kept."
    } elseif ($answer -match "^[Nn]$") {
        try {
            Remove-LocalUser -Name $user.Name -ErrorAction Stop
            Write-Host "'$($user.Name)' deleted."
        } catch {
            Write-Host "Failed to delete '$($user.Name)': $_"
        }
    } else {
        Write-Host "Invalid input. '$($user.Name)' kept."
    }
}
    function User-Auditing {
        Write-Host "`n--- Starting: User Auditing ---`n"
    }
    # Menu loop
    :menu do {
        Write-Host "`nSelect an option:`n"
        for ($i = 0; $i -lt $menuOptions.Count; $i++) {
            Write-Host "$($i + 1). $($menuOptions[$i])"
        }
    
        $selection = Read-Host "`nEnter the number of your choice"
    
        switch ($selection) {
            "1" { Document-System }
            "2" { Enable-Updates }
            "3" { User-Auditing }
            "4" { Write-Host "`nExiting..."; break menu }  # leave the do{} loop
            default { Write-Host "`nInvalid selection. Please try again." }
        }
    } while ($true)
    "Exit"
)
# Display the computer's hostname
Write-Host "Hostname: $env:COMPUTERNAME"
# Display the Windows version
Write-Host "Windows Version:" 
Get-ComputerInfo | Select-Object -Property WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer

