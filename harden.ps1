# Check for Administrator privileges and relaunch as admin if needed
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting script as Administrator..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
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
      function User-Auditing {
    Write-Host "`n--- Starting: User Auditing ---`n"
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
}
     "Admin Auditing"
         function Admin-Auditing {
        Write-Host "`n--- Starting: Administrator Group Auditing ---`n"
        $adminGroup = Get-LocalGroupMember -Group "Administrators"
        foreach ($member in $adminGroup) {
            $prompt = "Is '$($member.Name)' an Authorized Administrator? (Y/n): "
            $answer = Read-Host -Prompt $prompt
            if ($answer -eq "" -or $answer -match "^[Yy]$") {
                Write-Host "'$($member.Name)' kept in Administrators group."
            } elseif ($answer -match "^[Nn]$") {
                try {
                    Remove-LocalGroupMember -Group "Administrators" -Member $member.Name -ErrorAction Stop
                    Write-Host "'$($member.Name)' removed from Administrators group."
                } catch {
                    Write-Host "Failed to remove '$($member.Name)': $_"
                }
            } else {
                Write-Host "Invalid input. '$($member.Name)' kept in Administrators group."
            }
        }
    }
     "Account Policies"
         function Account-Policies {
        Write-Host "`n--- Starting: Account Policies ---`n"
    }
     "Local Policies"
        function Local-Policies {
        Write-Host "`n--- Starting: Local Policies ---`n"
    } 
     "Defensive Countermeasures"
        function Defensive-Countermeasures {
        Write-Host "`n--- Starting: Defensive Countermeasures ---`n"
    } 
    "Uncategorized OS Settings"
        function Uncategorized-OS-Settings {
        Write-Host "`n--- Starting: Uncategorized OS Settings ---`n"
    }
     "Service Auditing"
        function Service-Auditing {
        Write-Host "`n--- Starting: Service Auditing ---`n"
    }
    "OS Updates"
        function OS-Updates {
        Write-Host "`n--- Starting: OS Updates ---`n"
    }
     "Application Updates"
        function Application-Updates {
        Write-Host "`n--- Starting: Application Updates---`n"
    }
    "Prohibited Files"
        function Prohibited-Files {
        Write-Host "`n--- Starting: Prohibited Files ---`n"
    }
    "Unwanted Software"
        function Unwanted-Software {
        Write-Host "`n--- Starting: Unwanted Software ---`n"
    }
     "Malware"
        function Malware {
        Write-Host "`n--- Starting: Malware ---`n"
    }
    "Application Security Settings"
        function Application-Security-Settings {
        Write-Host "`n--- Starting: Application Security Settings ---`n"
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
            "4" { Admin-Auditing } 
            "5" { Account-Policies } 
            "6" { Local-Policies }
            "7" { Defensive-Countermeasures }
            "8" { Uncategorized-OS-Settings }
            "9" { Service-Auditing }
            "10" { OS-Updates }
            "11" { Application-Updates }
            "12" { Prohibited-Files }
            "13" { Unwanted-Software }
            "14" { Malware }
            "15" { Application-Security-Settings }
            "16" { Write-Host "`nExiting..."; break menu }  # leave the do{} loop
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