--------------ENGLISH--------------------
-Windows Defender PowerShell Script Extension-

This PowerShell script I've created acts as an extension for Windows Defender. Its primary goal is to enhance the security of the Windows operating system by automating several essential checks.

Features
Security Check:

- Checks if the Windows Firewall is enabled.
- Checks if Windows Defender is activated.
- Checks if automatic updates are turned on.
- Checks for pending security updates in Windows Update.
- Verifies administrator accounts.
- Scans for suspicious connections on your PC.
- Scans specific ports to detect potential malicious activities. (Example: Port 25 for SMTP, Port 3389 for RDP, etc.)
- Checks the status of UAC (User Account Control) activation.
- Verifies BitLocker activation for data security.
- Checks the status of specific services such as Telnet, LPD Service, RemoteRegistry.
- Scans scheduled tasks for potential suspicious activities.
- Updates the viral database for up-to-date protection.
- Checks if the network uses a non-SSL WSUS update.
- Checks if the AlwaysInstallElevated option is enabled, which could allow elevated installations without UAC notification.
- Scans read/write permissions for all paths and all local users.

Report:

At the end of the checks, a .txt report is generated to provide a detailed overview of the findings.
User Interface:

The script also offers a simplified user interface with buttons for quick access to firewall settings, Windows Defender, Windows Update, PC user management, computer management, and user account control settings.

How to Use:
- Run the script with administrator privileges.
- Follow the on-screen instructions.
- At the end of the checks, review the generated report for detailed information.
- Use the user interface for quick access to essential PC settings.
  
Contribution:
Feel free to submit pull requests to enhance the script or report issues through the "Issues" section.

------------------------FRANCAIS--------------------------
# Extension Windows Defender PowerShell Script

Ce script PowerShell que j'ai créé agit comme une extension pour Windows Defender. Son principal objectif est d'améliorer la sécurité du système d'exploitation Windows en automatisant plusieurs vérifications essentielles.

## Fonctionnalités

- **Vérification de la sécurité** :
    - Vérifie si le Pare-feu Windows est activé.
    - Vérifie si Windows Defender est activé.
    - Vérifie si les mises à jour automatiques sont activées.
    - Vérifie s'il y a des mises à jour de sécurité en attente dans Windows Update.
    - Vérification des comptes d'administrateur.
    - Vérification des connexions suspectes sur votre PC.
    - Vérification des ports spécifiques pour détecter d'éventuelles activités malveillantes. (Exemple : Port 25 pour SMTP, Port 3389 pour RDP, etc.)
    - Vérification de l'activation de l'UAC (User Account Control).
    - Vérification de l'activation de BitLocker pour la sécurité des données.
    - Vérification de l'état des services spécifiques tels que Telnet, LPD Service, RemoteRegistry.
    - Vérification des tâches planifiées pour détecter d'éventuelles tâches suspectes.
    - Mise à jour de la base de données virales pour une protection à jour.
    - Vérifie si le réseau utilise une mise à jour WSUS non SSL.
    - Vérifie si l'option AlwaysInstallElevated est activée, qui pourrait permettre des installations élevées sans notification UAC.
    - Vérifications des autorisations de lecture/écriture pour tous les chemins et tous les utilisateurs en local.

- **Rapport** :
    - À la fin des vérifications, un rapport `.txt` est généré pour fournir un aperçu détaillé des résultats.

- **Interface utilisateur** :
    - Le script fournit également une interface utilisateur simplifiée avec des boutons permettant d'accéder rapidement aux options du pare-feu, à Windows Defender, à Windows Update, à la gestion des utilisateurs du PC, à la gestion de l'ordinateur et aux paramètres de contrôle de compte utilisateurs.

## Comment utiliser

1. Exécutez le script avec des privilèges d'administrateur.
2. Suivez les instructions à l'écran.
3. À la fin des vérifications, consultez le rapport généré pour obtenir des informations détaillées.
4. Utilisez l'interface utilisateur pour accéder rapidement aux paramètres essentiels de votre PC.

## Contribution

N'hésitez pas à soumettre des pull requests pour améliorer le script ou à signaler des problèmes via la section "Issues".

