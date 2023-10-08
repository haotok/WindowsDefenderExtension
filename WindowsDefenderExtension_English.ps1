﻿# Load the necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Defender Extension'
$form.Size = New-Object System.Drawing.Size(500,600)

# Add a progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(50,300)
$progressBar.Size = New-Object System.Drawing.Size(300,20)

$form.Controls.Add($progressBar)

# Add the title
$label = New-Object System.Windows.Forms.Label
$label.Text = "WELCOME TO WINDOWS DEFENDER EXTENSION"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(40,20)
$form.Controls.Add($label)


$bytes = [Convert]::FromBase64String($base64ImageString)
$memoryStream = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
$memoryStream.Write($bytes, 0, $bytes.Length)
$image = [System.Drawing.Image]::FromStream($memoryStream)

$pictureBox = New-Object Windows.Forms.PictureBox
$pictureBox.Size = $image.Size
$pictureBox.Image = $image

# And then, add $pictureBox to your form as usual

# Load the image locally
$image = [System.Drawing.Image]::FromFile($imagePath)

$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Size = New-Object System.Drawing.Size(320,240)
$pictureBox.Location = New-Object System.Drawing.Point(40,60)
$pictureBox.SizeMode = 'Zoom'
$pictureBox.Image = $image
$form.Controls.Add($pictureBox)

# Add a start button
$startButton = New-Object System.Windows.Forms.Button
$startButton.Text = "START"
$startButton.Location = New-Object System.Drawing.Point(150,320)
$startButton.Add_Click({

$progressBar.Minimum = 0
$progressBar.Maximum = 17 # Total number of steps in the script
$progressBar.Value = 0

# _______________________________________SYSTEM SECURITY CHECK WITH POWERSHELL__________________________

"----- SYSTEM SECURITY CHECK -----" | Out-File -FilePath $path -Append

##### Check if the Windows Firewall is enabled ####

"`nChecking the Windows Firewall :" | Out-File -FilePath $chemin -Append
$firewallStatus = (Get-NetFirewallProfile -PolicyStore Local).Enabled
if ($firewallStatus -contains $false) {
    "Warning: The Windows Firewall is disabled ." | Out-File -FilePath $path -Append
} else {
    "The Windows Firewall is enabled." | Out-File -FilePath $path -Append
}

 $progressBar.Value = 1


##### Check if an antivirus is present and active ######

$antivirus = Get-CimInstance -Namespace "root\SecurityCenter2" -ClassName "AntiVirusProduct"

if ($antivirus) {
    if ($antivirus.productState -eq 266240) { # This number represents "AV up to date"
        Write-Log "--------An antivirus is active and up-to-date.-----------" | Out-File -FilePath $path -Append
    } else {
        Write-Log "-----------------Warning: No antivirus is active or up-to-date.-----------------" | Out-File -FilePath $path -Append
    }
} else {
    Write-Log "-----------------Warning: No antivirus is detected on this computer.-----------------" | Out-File -FilePath $path -Append
}

$progressBar.Value = 2


##### Check if automatic updates are enabled. ####

"`nChecking for automatic updates:" | Out-File -FilePath $path -Append
$autoUpdateStatus = (Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU").AUOptions
if ($autoUpdateStatus -eq 4) {
    "Automatic updates are enabled." | Out-File -FilePath $path -Append
} else {
    "------------Warning: automatic updates are not enabled.-----------------" | Out-File -FilePath $path -Append
}

$progressBar.Value = 3

# Set the log file path.
$path = "$env:USERPROFILE\VERIF_SYSTEME.txt"

# Function to write messages to the log file.
function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $Message | Out-File -FilePath $path -Append
    Write-Host $Message
}

# Checking if there are pending security updates in Windows Update.
Write-Log "-----------------Checking if there are pending security updates in Windows Update :-----------------"
$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()
$Criteria = "IsInstalled=0 and Type='Software' and IsHidden=0 and CategoryIDs contains 'e6cf1350-c01b-414d-a61f-263d14d133b4'"
$SearchResult = $Searcher.Search($Criteria).Updates

if ($SearchResult.Count -gt 0) {
    foreach ($Update in $SearchResult) {
        Write-Log "Update pending : $($Update.Title)"
    }
} else {"-----------------No security update pending.-----------------" | Out-File -FilePath $path -Append
}

$progressBar.Value = 4

##### Checking administrator accounts. ######
$adminAccounts = Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.SID -like "S-1-5-21-*-500" }

if ($adminAccounts) {
    Write-Log "-----------Warning: The following administrator accounts are activated:----------"
    $adminAccounts | ForEach-Object { Write-host "Compte: $($_.Name)" }
$adminAccounts | ForEach-Object { "Compte: $($_.Name)" | Out-File -FilePath $path -Append }

} else {
    "-----------------No administrator account is activated.-----------------" | Out-File -FilePath $path -Append
}

$progressBar.Value = 5

# Checking for suspicious connections on your PC

Write-Log "`nChecking for suspicious connections on your PC:"
$suspiciousPorts = @(4444, 31337, 445, 25, 1433, 3389, 139, 135, 137, 53, 6666, 6669, 7000, 80)
$connections = Get-NetTCPConnection | Where-Object { $_.State -eq "Established" }
foreach ($connection in $connections) {
    $localPort = $connection.LocalPort
    $remotePort = $connection.RemotePort
    if ($suspiciousPorts -contains $localPort -or $suspiciousPorts -contains $remotePort) {
        Write-Log "Suspicious connection detected:" -ForegroundColor Red
        Write-Log "Local: $($connection.LocalAddress):$localPort"
        Write-Log "Remote: $($connection.RemoteAddress):$remotePort"
        Write-Log "CHECK IF THESE OPEN PORTS ARE LEGITIMATE AND USEFUL WITH THE COMMAND: #Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }"
        Write-Log "----------------------------------------"
    }
}

$progressBar.Value = 6

# Checking specific ports
Write-Log "`nChecking specific ports:"
$portsDescriptions = @{
    25 = "Port 25 (SMTP): Used to send unsolicited emails (spam) and spread malware through malicious attachments."
    1433 = "Port 1433 (MS-SQL): Targeted in attacks aimed at Microsoft SQL Server databases."
    3389 = "Port 3389 (RDP): Used for remote desktop access (Remote Desktop Protocol); frequently targeted by brute-force and exploitation attacks."
    139 = "Ports 139 (NetBIOS) and 445 (SMB): Used for Windows file sharing (Server Message Block); frequently targeted by ransomware attacks and for spreading worms like WannaCry."
    135 = "Ports 135, 137-139 (RPC): Used for the RPC (Remote Procedure Call) protocol and NetBIOS; often targeted for denial-of-service attacks or to exploit vulnerabilities in Windows."
    53 = "Port 53 (DNS): Used by the DNS service; can be used for malicious tunneling traffic or to redirect traffic to malicious DNS servers."
    6666 = "Ports 6666-6669, 7000 (IRC): Used by IRC (Internet Relay Chat) servers; can be used by malware to establish command and control connections."
    80 = "Ports 80 (HTTP) and 443 (HTTPS): Used for regular web traffic, but also used by malware to communicate with command and control servers via custom communication protocols."
    4444 = "This port is associated with malicious activities such as being used by certain malware to establish command and control connections with compromised systems. It can also be used to establish reverse shell connections allowing attackers to remotely control a system. Some exploits specifically target port 4444 to exploit known vulnerabilities in applications or services."
    31337 = "This port is often associated with hacking activities and the underground computing culture. Like other ports, port 31337 can be exploited to target known vulnerabilities and conduct attacks against target systems. Its use is often linked to illicit activities and intrusion attempts."
}

foreach ($port in $portsDescriptions.Keys) {
    if (Test-NetConnection -ComputerName localhost -Port $port -InformationLevel Quiet) {
        $message = $portsDescriptions[$port]
        Write-Log "Open port: $port - $message"
    }
}

Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' } | Out-File -FilePath $path -Append

Get-NetTCPConnection | Out-File -FilePath $path -Append

$progressBar.Value = 7

##### Vérification des dossiers partagés #####

$sharedFolders = Get-SmbShare | Where-Object -Property Name -ne 'IPC$'

if ($sharedFolders) {
    Write-Log "Attention: Les dossiers partagés suivants ont été trouvés :"
    $sharedFolders | ForEach-Object { Write-host "Dossier: $($_.Name)" }
    $sharedFolders | ForEach-Object { "Dossier: $($_.Name)" | Out-File -FilePath $path -Append }

} else {

    "-----------------Aucun dossier partagé n'a été trouvé.-----------------" | Out-File -FilePath $path -Append
}


$progressBar.Value = 8

# Checking UAC activation
Write-Log "`nChecking UAC activation:" -ForegroundColor Yellow
$UACStatusCheck = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").EnableLUA
if ($UACStatusCheck -eq 0) {
    Write-Log "Warning: UAC (User Account Control) is disabled."
    $alertMessage = "-----------------To enable UAC, please open the Control Panel, click on 'User Accounts', then click on 'Change User Account Control settings' and move the slider upwards.-----------------"
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup($alertMessage, 0, "-----------------UAC disabled-----------------", 0x1)
} else {
    Write-Log "-----------------UAC (User Account Control) is enabled.-----------------"
}

$progressBar.Value = 9


# Checking BitLocker activation
Write-Log "`nChecking BitLocker activation:"
$BitLockerActivationStatus = Get-BitLockerVolume -MountPoint C:
if ($BitLockerActivationStatus.ProtectionStatus -ne "On") {
    Write-Log "-----------------Warning: BitLocker is not enabled on the system drive. PLEASE ENABLE IT FOR SECURITY REASONS.-----------------"
} else {
    Write-Log "-----------------BitLocker is enabled on the system drive.-----------------"
}

$progressBar.Value = 10


# Checking the service
$checkedServiceName = "Telnet, LPD Service, RemoteRegistry"
Write-Log "`nChecking the service $checkedServiceName"
try {
    $currentServiceStatus = Get-Service | Where-Object { $_.Name -eq $checkedServiceName -and $_.Status -eq "Running" }
    if ($currentServiceStatus) {
        Write-Log "-----------------Warning: The service $checkedServiceName is running.-----------------"
    } else {
        Write-Log "-----------------The service $checkedServiceName is not running.-----------------"
    }
}
catch {
    Write-Log "Error while querying the service $checkedServiceName."
    Write-Log "Error details: $_"
}

$progressBar.Value = 11


# Checking scheduled tasks
Write-Log "`nChecking scheduled tasks:"
$allScheduledTasks = Get-ScheduledTask
$potentialRiskyFolders = @("%AppData%", "%Temp%", "C:\Users\Public")
$detectedSuspiciousTask = $false

$allScheduledTasks | ForEach-Object {
    $currentTaskName = $_.TaskName
    $currentTaskActions = $_.Actions

    $currentTaskActions | ForEach-Object {
        if ($_.Id -eq 'Execute') {
            foreach ($folder in $potentialRiskyFolders) {
                if ($_.Execute -like "*$folder*") {
                    Write-Log "Suspicious task: $currentTaskName"
                    Write-Log "Suspicious path: $($_.Execute)"
                    $detectedSuspiciousTask = $true
                }
            }
        }
    }

    $currentTaskTriggers = $_ | Get-ScheduledTask | Select-Object -ExpandProperty Triggers

    foreach ($trigger in $currentTaskTriggers) {
        if ($trigger.Repetition.Duration -eq 'PT1M') {
            Write-Log "Suspicious task: $currentTaskName"
            Write-Log "Suspicious frequency: Every minute"
            $detectedSuspiciousTask = $true
        }
    }
}

if (!$detectedSuspiciousTask) {
    Write-Log "-----------------No suspicious tasks found.-----------------"
}

$progressBar.Value = 12


##### Updating the virus database. ####
    update-mpsignature

$progressBar.Value = 13

# Check if the network is using a non-SSL WSUS update

"Checking if the network is using a non-SSL WSUS update:" | Out-File -FilePath $path -Append

try {
    $verification = Get-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate' -Name 'WUServer'
    if ($verification.WUServer -match 'http://') {
        "-----------------WSUS updates configured to use HTTP, vulnerable to man-in-the-middle attacks.-----------------" | Out-File -FilePath $path -Append
    } else {
        "-----------------WSUS updates configured to use HTTPS, more secure if the key exists. But it doesn't exist. No connection to a WSUS server is configured on the device.-----------------" | Out-File -FilePath $path -Append
    }
} catch {
   "<<<<<<<<<<<<<<This registry key does not exist, or there are no WSUS updates configured>>>>>>>>>>>>>" | Out-File -FilePath $path -Append
}

$progressBar.Value = 14


# Checking if the 'AlwaysInstallElevated' option is enabled

"Checking if the 'AlwaysInstallElevated' option is enabled:" | Out-File -FilePath $path -Append
try {
    $verificationHKCU = Get-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer' -Name 'AlwaysInstallElevated'
    $verificationHKLM = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer' -Name 'AlwaysInstallElevated'
    if ($verificationHKCU -and $verificationHKLM) {
        "Warning: The 'AlwaysInstallElevated' option is enabled in both HKCU and HKLM, this can be a security vulnerability." | Out-File -FilePath $path -Append
    } else {
        "----------------- 'AlwaysInstallElevated' is either disabled or partially enabled, which is safer.-----------------" | Out-File -FilePath $path -Append
    }
} catch {
   "-----------------Unable to find the specified registry key or value, 'AlwaysInstallElevated' is likely disabled.-----------------" | Out-File -FilePath $path -Append
}

$progressBar.Value = 15


# Checking read/write permissions for all paths and all local users
Write-Log "Checking read/write permissions for all paths and all local users"
$paths = $env:path -split ';'
foreach ($singlePath in $paths) {
    try {
        $permissions = Get-Acl -Path $singlePath -ErrorAction Stop
        foreach ($permission in $permissions.Access) {
            if ($permission.FileSystemRights -band [System.Security.AccessControl.FileSystemRights]::Modify -and
                ($permission.IdentityReference.Value -eq 'Everyone' -or
                 $permission.IdentityReference.Value -eq 'NT AUTHORITY\Authenticated Users' -or
                 $permission.IdentityReference.Value -eq 'All' -or
                 $permission.IdentityReference.Value -eq "$env:USERDOMAIN\$env:USERNAME")) {
                if ($permission.IdentityReference.Value -eq '2AB4B02F-7385-4\WDAGUtilityAccount') {
                    Write-Log "-----------------$singlePath has modify permissions for $($permission.IdentityReference.Value). This is expected, as this account is used by Windows Defender Application Guard.-----------------" | Out-File -FilePath $path -Append

                } else {
                    Write-Log "-----------------$singlePath has modify permissions for $($permission.IdentityReference.Value)-----------------" | Out-File -FilePath $path -Append

                    Write-Warning ">>>>>>>>>Warning: This can be dangerous, as this means that $($permission.IdentityReference.Value) can modify files in this path." | Out-File -FilePath $path -Append

                }
            }
        }
    } catch {
        Write-Log ">>>>>>>>>Unable to fetch permissions for $singlePath"
    }
}

$progressBar.Value = 16


# Checking for CVE-2019-1388 vulnerability
"Checking for CVE-2019-1388 vulnerability:" | Out-File -FilePath $path -Append

# Retrieve system information
$systemInfo = Get-WmiObject -Class Win32_OperatingSystem

# Extract version number and build number
$version = $systemInfo.Version
$build = $systemInfo.BuildNumber

# List of vulnerable versions
$vulnerableVersions = @(
    @{Version="6.1"; Build="7601"},  # Windows 7 SP1 / Windows 2008r2
    @{Version="6.2"; Build="9200"},  # Windows 8
    @{Version="6.3"; Build="9600"},  # Windows 8.1 / Windows 2012r2
    @{Version="10.0"; Build="10240"},  # Windows 10 1511
    @{Version="10.0"; Build="14393"}   # Windows 10 1607 / Windows 2016
)

# Check if the system is vulnerable
$isVulnerable = $false
foreach ($vulnerableVersion in $vulnerableVersions) {
    if ($version -eq $vulnerableVersion.Version -and $build -eq $vulnerableVersion.Build) {
        $isVulnerable = $true
        break
    }
}

if ($isVulnerable) {
    ">>>>>>>>>>>>>>>This system is potentially vulnerable to the CVE-2019-1388 flaw." | Out-File -FilePath $path -Append

} else {
    ">>>>>>>>>>>>>>>This system does not appear to be vulnerable to the CVE-2019-1388 flaw." | Out-File -FilePath $path -Append
}

$progressBar.Value = 17


# Check if secure boot is enabled
$secureBootStatus = Confirm-SecureBootUEFI

if ($secureBootStatus -eq $true) {
    ">>>>>>>>>>>>>>>>>>>The computer's secure boot is enabled." | Out-File -FilePath $path -Append
} else {
    ">>>>>>>>>>>>>>>>>>>The computer's secure boot is disabled." | Out-File -FilePath $path -Append
}


# Run the log file.
Start-Process $path

$form.close()
        	
	break
#----------------------------------------------------------------------------

})

# Add the controls to the form.
$form.Controls.Add($startButton)

#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Define the path of the log file.
$path = "$env:USERPROFILE\VERIF_SYSTEME.txt"

# Displaying the form : "Windows Defender Extension"
$form.ShowDialog()

#----------------------------------------------------------------------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms

# Creating the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "System Security, what would you like to repair?"
$form.Size = New-Object System.Drawing.Size(750,500) # I've slightly increased the width to fit the buttons
$form.StartPosition = 'CenterScreen'

###### Open firewall options ######

# Creating a button to open Windows Defender Firewall
$openFirewallButton = New-Object System.Windows.Forms.Button
$openFirewallButton.Location = New-Object System.Drawing.Point(50, 100) # Moved a bit to the left to fit both buttons
$openFirewallButton.Size = New-Object System.Drawing.Size(200,40)
$openFirewallButton.Text = "Open Windows Defender Firewall"
$openFirewallButton.Add_Click({
    Start-Process "control.exe" -ArgumentList "firewall.cpl"
})
$form.Controls.Add($openFirewallButton)

##### Open Windows Defender ######

$openDefenderButton = New-Object System.Windows.Forms.Button
$openDefenderButton.Location = New-Object System.Drawing.Point(260, 100) # Positioned next to the first button
$openDefenderButton.Size = New-Object System.Drawing.Size(200,40)
$openDefenderButton.Text = "Open Windows Defender"
$openDefenderButton.Add_Click({
    Start-Process "ms-settings:windowsdefender"
})
$form.Controls.Add($openDefenderButton)

##### Open Windows Update #####

$openUpdateButton = New-Object System.Windows.Forms.Button
$openUpdateButton.Location = New-Object System.Drawing.Point(50, 50)
$openUpdateButton.Size = New-Object System.Drawing.Size(200,40)
$openUpdateButton.Text = "Open Windows Update"
$openUpdateButton.Add_Click({
    Start-Process "ms-settings:windowsupdate"
})
$form.Controls.Add($openUpdateButton)

##### Open PC User Management #####

$openUserButton = New-Object System.Windows.Forms.Button
$openUserButton.Location =  New-Object System.Drawing.Point(260, 50)
$openUserButton.Size = New-Object System.Drawing.Size(200,40)
$openUserButton.Text = "Open PC User Management"
$openUserButton.Add_Click({
    Start-Process "control.exe" -ArgumentList "userpasswords2" -Verb runAs
})

$form.Controls.Add($openUserButton)

##### Open Computer Management #####

$openComputerMgmtButton = New-Object System.Windows.Forms.Button
$openComputerMgmtButton.Location = New-Object System.Drawing.Point(470, 50)
$openComputerMgmtButton.Size = New-Object System.Drawing.Size(200,40)
$openComputerMgmtButton.Text = "Open Computer Management"
$openComputerMgmtButton.Add_Click({
    Start-Process "compmgmt.msc" -Verb runAs
})

$form.Controls.Add($openComputerMgmtButton)

##### Open User Account Control Settings #####

$openUACSettingsButton = New-Object System.Windows.Forms.Button
$openUACSettingsButton.Location = New-Object System.Drawing.Point(470, 100)
$openUACSettingsButton.Size = New-Object System.Drawing.Size(200,40)
$openUACSettingsButton.Text = "Open User Account Control Settings"
$openUACSettingsButton.Add_Click({
    Start-Process "UserAccountControlSettings.exe"
})

$form.Controls.Add($openUACSettingsButton)

$form.ShowDialog()



