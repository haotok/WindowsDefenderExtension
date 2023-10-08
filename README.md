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

