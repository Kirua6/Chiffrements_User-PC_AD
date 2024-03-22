# Mise à jour des types de chiffrement Active Directory

Ce dépôt contient des scripts PowerShell conçus pour sécuriser les types de chiffrement sur les comptes d'utilisateurs et d'ordinateurs dans Active Directory. Ces scripts permettent d'éliminer l'utilisation de chiffrements faibles (RC4, DES, Triple DES) au profit de chiffrements plus forts (AES 128, AES 256), c'est notamment utile pour Kerberos.

## Scripts inclus

- **Transformation_Chiffrement_Ordinateurs_vfinal.ps1** - Met à jour les types de chiffrement pour les comptes d'ordinateurs dans une OU spécifiée.
- **Transformation_Chiffrement_Utilisateurs_vfinal.ps1** - Met à jour les types de chiffrement pour les comptes d'utilisateurs dans une OU spécifiée.
- **Transfo_Chiffrement_Auto_Ordi-Users_vfinal.ps1** - Script combiné pour être exécuté au démarrage de l'ordinateur via GPO, appliquant les modifications à tous les comptes dans les OUs spécifiées.

## Prérequis

- Module Active Directory pour PowerShell.
- Droits administratifs sur les objets AD cibles.

## Utilisation

Choix 1, Utiliser les scripts manuels : lancer le script **Ordinateurs** ou **Utilisateurs**, sélectionner l'OU et appuyer sur Executer
Choix 2, Automatiser par GPO au démarrage les chiffrements avec le script **Auto_Ordi-Users**

## Fiche tutorielle pour le choix 2

**Mise en place par GPO d'un script PowerShell automatique**

1. **Création d'une GPO**:
   - Dans Gestion de stratégie de groupe, créez une nouvelle GPO et liez-la à l'OU souhaitée (il est bien sûr souhaitable que les ordinateurs et Utilisateurs soient impacté par cette GPO).

2. **Configuration de la GPO**:
   - Modifiez la GPO avec un clic droit, pour exécuter le script au démarrage ou à l'ouverture de session.
   - Configuration Ordinateur -> Stratégie -> Paramètres Windows -> Scripts -> Démarrage
   - Ajouter votre script dans Scripts Powershell -> copier le fichier Transfo_Chiffrement_Auto_Ordi-Users_vfinal.ps1 dans Startup, puis le choisir
   - Configuration Utilisateur -> Stratégie -> Paramètres Windows -> Scripts -> Démarrage
   - Ajouter votre script dans Scripts Powershell -> copier le fichier Transfo_Chiffrement_Auto_Ordi-Users_vfinal.ps1 dans Logon, puis le choisir

3. **Test et déploiement**:
   - Forcer en premier lieu une synchro des GPO avec la commande Powershell "gpupdate /force"
   - Testez la GPO pour tester son fonctionnement (exemple: utiliser cette commande avant et après pour voir les résultats Get-ADObject -Filter {UserAccountControl -band 0x200000 -or msDs-supportedEncryptionTypes -band 3} ).

4. **Surveillance et maintenance**:
   - Surveillez l'application de la GPO et mettez à jour les scripts ou les paramètres selon les besoins.

## Contribuer

Les contributions à ce projet sont bienvenues. N'hésitez pas à forker le dépôt, apporter vos modifications et soumettre une pull request.

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](https://github.com/Kirua6/Chiffrements_User-PC_AD/blob/main/LICENSE) pour plus de détails.

