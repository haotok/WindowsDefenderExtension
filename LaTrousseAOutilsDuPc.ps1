##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uK1
##Nc3NCtDXThU=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4NI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjofG5iZk2XnrT2EXSsCIsqKo1L2I7eX5qDbcfZ8HXRpyjiyc
##Kc/BRM3KXhU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
# Vérifie si le script est exécuté avec des privilèges d'administrateur
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relance le script en tant qu'administrateur
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File $($PSCommandPath)" -Verb RunAs
    exit
}
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$form = New-Object System.Windows.Forms.Form
$form.Text = "LA TROUSSE A OUTIL DU PC"
$form.Width = 1000
$form.Height = 650

#VIDER LA CORBEILLE DU PC#

$button = New-Object System.Windows.Forms.Button
$button.Text = "VIDER LA CORBEILLE"
$button.Width = 100
$button.Height = 50
$button.Location = New-Object System.Drawing.Point(50,50)
$button.ForeColor = [System.Drawing.Color]::Salmon
$button.Add_Click({
    
    $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Import-Module Microsoft.PowerShell.Management
            Clear-RecycleBin -Confirm:$false
                } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
                     break
}

})
    


#METTRE A JOUR LE PC#

$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "METTRE A JOUR LE PC"
$button2.Width = 100
$button2.Height = 50
$button2.Location = New-Object System.Drawing.Point(150,50)
$button2.ForeColor = [System.Drawing.Color]::Brown
$button2.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Mise à jour en cours, regardez votre console powershell pour voir où ça en est. CLIQUEZ SUR OK.")
    Function Check-WindowsUpdate {
    [CmdletBinding()]
    param ()
    $Session = New-Object -ComObject Microsoft.Update.Session
    $Searcher = $Session.CreateupdateSearcher()
    $SearchResult = $Searcher.Search("IsInstalled=0 and Type='Software'")
    $UpdatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
    foreach ($Update in $SearchResult.Updates) {
        $UpdatesToDownload.Add($Update)
    }
    $Downloader = $Session.CreateUpdateDownloader()
    $Downloader.Updates = $UpdatesToDownload
    $Downloader.Download()
    $UpdatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
    foreach ($Update in $SearchResult.Updates) {
        $UpdatesToInstall.Add($Update)
    }
    $Installer = $Session.CreateUpdateInstaller()
    $Installer.Updates = $UpdatesToInstall
    $InstallationResult = $Installer.Install()
}
Check-WindowsUpdate

    $session = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $searchResult = $searcher.Search("IsInstalled=0 and Type='Software'")

    $updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl

    foreach ($update in $searchResult.Updates)
    {
        $updatesToDownload.Add($update)
    }

    if ($updatesToDownload.Count -eq 0)
    {
        Write-Host "Aucune mise à jour disponible."
    }
    else
    {
        $downloader = $session.CreateUpdateDownloader()
        $downloader.Updates = $updatesToDownload
        $downloader.Download()
        $installer = $session.CreateUpdateInstaller()
        $installer.Updates = $updatesToDownload
        $result = $installer.Install()

    Write-Host "Résultat de l'installation : $result"
    }
        [System.Windows.Forms.MessageBox]::Show("Le pc a été mis à jour! Mais on ne sait jamais allez voir comme même dans Windows Update")
    })

    $button2.Add_Click({control.exe /name Microsoft.WindowsUpdate})

##Mettre à jour la base de donnée virales##

$button3 = New-Object System.Windows.Forms.Button
$button3.Text = "METTRE A JOUR LA BASE DE DONNEE VIRALES"
$button3.Width = 130
$button3.Height = 70
$button3.Location = New-Object System.Drawing.Point(250,50)
$button3.ForeColor = [System.Drawing.Color]::Violet
$button3.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Update-MpSignature
     [System.Windows.Forms.MessageBox]::Show("La base de donnée virale a été mise à jour!")
        } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}

})

#LANCER CC CLEANER#

$button4 = New-Object System.Windows.Forms.Button
$button4.Text = "LANCER CC CLEANER"
$button4.Width = 130
$button4.Height = 70
$button4.Location = New-Object System.Drawing.Point(380,50)
$button4.ForeColor = [System.Drawing.Color]::Magenta
$button4.Add_Click({
        $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Start-Process -filepath "C:\Program Files\CCleaner\CCleaner64.exe"
        [System.Windows.Forms.MessageBox]::Show("Et voici!")
        } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}
    
})

#Vérification et réparation des fichiers systèmes en intégrale#

$button5 = New-Object System.Windows.Forms.Button
$button5.Text = "LANCER UNE VERIFICATION ET REPARATION DES FICHIERS SYSTEMES EN INTEGRALE"
$button5.Width = 190
$button5.Height = 100
$button5.Location = New-Object System.Drawing.Point(510,50)
$button5.ForeColor = [System.Drawing.Color]::Orange
$button5.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    $params = @("/c", "sfc /scannow")
    $command = "cmd.exe"
    Start-Process -FilePath $command -ArgumentList $params -Verb RunAs
    [System.Windows.Forms.MessageBox]::Show("La vérification système intégrale a été lancée. 
    Il est conseillé de ne pas fermer la fenêtre de commande pendant la vérification.")
        } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}

})

#Réparer les bugs en réparant l'image windows#

$button6 = New-Object System.Windows.Forms.Button
$button6.Text = "REPARER LES BUGS EN REPARANT L'IMAGE WINDOWS"
$button6.Width = 200
$button6.Height = 110
$button6.Location = New-Object System.Drawing.Point(700,50)
$button6.ForeColor = [System.Drawing.Color]::Green
$button6.Add_Click({
     $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    $params = @("/c", "dism /online /cleanup-image /restorehealth")
    $command = "cmd.exe"
    Start-Process -FilePath $command -ArgumentList $params -Verb RunAs
    [System.Windows.Forms.MessageBox]::Show("La réparation de l'image windows a été lancée.
     Il est conseillé de ne pas fermer la fenêtre de commande pendant la vérification.")
        } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}

})

#Lancer une analyse antivirus rapide
$button7 = New-Object System.Windows.Forms.Button
$button7.Text = "LANCER UNE ANALYSE ANTIVIRUS RAPIDE"
$button7.Width = 150
$button7.Height = 110
$button7.Location = New-Object System.Drawing.Point(50,120)
$button7.ForeColor = [System.Drawing.Color]::Blue
$button7.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("VOULEZ-VOUS CONTINUER?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    [System.Windows.Forms.MessageBox]::Show("Analyse rapide lancée...")
    [System.Windows.Forms.MessageBox]::Show("Regardez l'avancé du scan dans powershell. Appuyer sur OK.")
    Start-MpScan -ScanType QuickScan
    
        } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}

})

#Lancer une analyse antivirus longue#
$button8 = New-Object System.Windows.Forms.Button
$button8.Text = "LANCER UNE ANALYSE ANTIVIRUS COMPLETE"
$button8.Width = 150
$button8.Height = 110
$button8.Location = New-Object System.Drawing.Point(200,120)
$button8.ForeColor = [System.Drawing.Color]::Red
$button8.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("VOULEZ-VOUS CONTINUER?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            [System.Windows.Forms.MessageBox]::Show("Analyse complète lancée...Regardez l'avancé du scan dans powershell. Appuyez sur Ok.")
             Start-MpScan -scantype FullScan
                 } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
                        break
}
        
})

#Mettre à jour les applications du Microsoft Store
$button9 = New-Object System.Windows.Forms.Button
$button9.Text = "LANCER MICROSOFT STORE ET METTRE A JOUR LES APPLICATIONS"
$button9.Width = 160
$button9.Height = 110
$button9.Location = New-Object System.Drawing.Point(350,120)
$button9.ForeColor = [System.Drawing.Color]::Indigo
$button9.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("VOULEZ-VOUS CONTINUER?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
   Start-Process ms-windows-store:
        [System.Windows.Forms.MessageBox]::Show("Et voici!")
            } else { [System.Windows.Forms.MessageBox]::Show("CA MARCHE!")
             break
}

})

#Mettre à jours ses pilotes

$button10 = New-Object System.Windows.Forms.Button
$button10.Text = "METTRE A JOUR LES PILOTES"
$button10.Width = 140
$button10.Height = 110
$button10.Location = New-Object System.Drawing.Point(510,150)
$button10.Add_Click({
    $drivers = Get-WmiObject -Class Win32_PnPSignedDriver
    foreach ($driver in $drivers) {
    if($driver.Status -eq "OK") {
        Update-Driver -Name $driver.DeviceName -Force -Verbose
    }
}
        [System.Windows.Forms.MessageBox]::Show("CERTAINS PILOTES MIS A JOUR, POUR LES AUTRES VEUILLEZ ALLER DANS WINDOWS UPDATE.")
})

#Redémarrer l'ordinateur
$button11 = New-Object System.Windows.Forms.Button
$button11.Text = "REDEMARRER L'ORDINATEUR"
$button11.Width = 100
$button11.Height = 110
$button11.Location = New-Object System.Drawing.Point(800,400)
$button11.ForeColor = [System.Drawing.Color]::Teal
$font = New-Object System.Drawing.Font("Bodoni MT",8,[System.Drawing.FontStyle]::Bold)
$button11.Font = $font

$button11.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Restart-Computer
            } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}

})

#Tester le disque dur
$button12 = New-Object System.Windows.Forms.Button
$button12.Text = "VERIFIER LE DISQUE DUR"
$button12.Width = 100
$button12.Height = 110
$button12.Location = New-Object System.Drawing.Point(50,230)
$button12.ForeColor = [System.Drawing.Color]::Olive
$button12.Add_Click({
    $params = @("/c", "chkdsk /F /V")
    $command = "cmd.exe"
    Start-Process -FilePath $command -ArgumentList $params -Verb RunAs
})

#Supprimer les fichiers temporaires 
$button13 = New-Object System.Windows.Forms.Button
$button13.Text = "SUPPRIMER LES FICHIERS TEMPORAIRES DU DISQUE DUR"
$button13.Width = 110
$button13.Height = 110
$button13.Location = New-Object System.Drawing.Point(150,230)
$button13.ForeColor = [System.Drawing.Color]::Lime
$button13.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force

              } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}

})          

#Désinstaller un logiciel du PC
$button14 = New-Object System.Windows.Forms.Button
$button14.Text = "SUPPRIMER UN LOGICIEL DU PC"
$button14.Width = 110
$button14.Height = 110
$button14.Location = New-Object System.Drawing.Point(260,230)
$button14.ForeColor = [System.Drawing.Color]::RoyalBlue 
$button14.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Veuillez aller dans la console powershell et taper un logiciel à désinstaller. CLIQUEZ SUR OK.")
    $searchTerm = Read-Host "Enter search term for software to uninstall"
    $software1 = Get-AppxPackage | Where-Object {$_.Name -like "*$searchTerm*"}
    $software2 = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*$searchTerm*"}
    Remove-AppxPackage -Package $software1.PackageFullName
    Remove-AppxPackage -Package $software2.PackageFullName

        if (!$software1.PackageFullName -and !$software2.PackageFullName) {
        [System.Windows.Forms.MessageBox]::Show("La désinstallation du logiciel n'a pas réussi. Je vais ouvrir le panneau de configuration où vous pourrez désinstaller ce logiciel...")
        Start-Process control appwiz.cpl
}
            
})

#Réparer le registre
$button15 = New-Object System.Windows.Forms.Button
$button15.Text = "REPARER ET NETTOYER LE REGISTRE"
$button15.Width = 110
$button15.Height = 110
$button15.Location = New-Object System.Drawing.Point(370,230)
$button15.ForeColor = [System.Drawing.Color]::chocolate
$button15.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Voulez-vous continuer?", "Titre", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Clear empty registry keys
        Get-ChildItem -Path "HKCU:\" -Recurse | Where-Object { !$_.GetValueNames() } | Remove-ItemProperty -Force
        # Clear missing shared DLL references
        $files = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDLLs"
        $missingFiles = $files | Where-Object { !(Test-Path $_.PSPath) }
        $missingFiles | ForEach-Object { Remove-Item -Path $_.PSPath -Force }
        # Clear unused file extensions
        $files = Get-ChildItem -Path "C:\" -Recurse
        $extensions = $files | Group-Object Extension
        $unusedExtensions = $extensions | Where-Object { $_.Count -eq 0 }
        $unusedExtensions | ForEach-Object { 
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$($_.Name)" -Recurse -Force
        [System.Windows.Forms.MessageBox]::Show("Ca na peut-être pas tout effacé, veuillez utiliser CCleaner pour nettoyer le registre correctement si c'est le cas")
}


             } else { [System.Windows.Forms.MessageBox]::Show("Ca marche!")
             break
}
})


#Tout indexer et rechercher n'importe quoi sur le disque C:
$button16 = New-Object System.Windows.Forms.Button
$button16.Text = "RECHERCHER QUELQUE CHOSE SUR LE DISQUE C:"
$button16.Width = 110
$button16.Height = 110
$button16.Location = New-Object System.Drawing.Point(50,340)
$button16.ForeColor = [System.Drawing.Color]::firebrick
$button16.Add_Click({
[System.Windows.Forms.MessageBox]::Show("Cet outil vous permettra de rechercher n'importe quoi sur le disque dur C: - Mais je vous préviens ceci peut être assez long, (10 min d'indexation)")
   # Indexation des fichiers sur le disque C:
$files = Get-ChildItem C:\ -Recurse -force | Sort-Object LastWriteTime

# Enregistrement des résultats dans un fichier texte
$files | Out-File -FilePath "C:\fileIndex.txt"

# Recherche dans l'index des fichiers
$searchTerm = $null
while ($searchTerm -eq $null) {
  $searchTerm = Read-Host "Entrez le terme à rechercher"
  if ($searchTerm -eq "") {
    Write-Host "Veuillez entrer un terme de recherche valide"
    $searchTerm = $null
  }
}
$searchResults = Select-String -Path "C:\fileIndex.txt" -Pattern $searchTerm

# Afficher les résultats de la recherche
$searchResults | Select-Object -ExpandProperty Line

})

#LANCER GLARY UTILITIES
$button17 = New-Object System.Windows.Forms.Button
$button17.Text = "LANCER GLARY UTILITIES"
$button17.Width = 100
$button17.Height = 100
$button17.Location = New-Object System.Drawing.Point(160,340)
$button17.ForeColor = [System.Drawing.Color]::fire
$button17.Add_Click({
    Start-Process -filepath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Glary Utilities 5"
    [System.Windows.Forms.MessageBox]::Show("Et voici!")
})

$form.Controls.Add($button)
$form.Controls.Add($button2)
$form.Controls.Add($button3)
$form.Controls.Add($button4)
$form.Controls.Add($button5)
$form.Controls.Add($button6)
$form.Controls.Add($button7)
$form.Controls.Add($button8)
$form.Controls.Add($button9)
$form.Controls.Add($button10)
$form.Controls.Add($button11)
$form.Controls.Add($button12)
$form.Controls.Add($button13)
$form.Controls.Add($button14)
$form.Controls.Add($button15)
$form.Controls.Add($button16)
$form.Controls.Add($button17)
$form.ShowDialog()
