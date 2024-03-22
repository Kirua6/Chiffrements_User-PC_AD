# Mise à jour des types de chiffrement Active Directory

Ce dépôt contient des scripts PowerShell conçus pour sécuriser les types de chiffrement sur les comptes d'utilisateurs et d'ordinateurs dans Active Directory. Ces scripts permettent d'éliminer l'utilisation de chiffrements faibles (RC4, DES, Triple DES) au profit de chiffrements plus forts (AES 128, AES 256), c'est notamment utile pour Kerberos.

## Scripts inclus

- **Transformation_Chiffrement_Ordinateurs_vfinal.ps1** - Met à jour les types de chiffrement pour les comptes d'ordinateurs dans une OU spécifiée.
- **Transformation_Chiffrement_Utilisateurs_vfinal.ps1** - Met à jour les types de chiffrement pour les comptes d'utilisateursdans une OU spécifiée.
- **Transfo_Chiffrement_Auto_Ordi-Users_vfinal.ps1** - Script combiné pour être exécuté au démarrage de l'ordinateur via GPO, appliquant les modifications à tous les comptes dans les OUs spécifiées.

## Prérequis

- Module Active Directory pour PowerShell.
- Droits administratifs sur les objets AD cibles.

## Utilisation

Choix 1, Utiliser les scripts manuels : lancer le script **Ordinateurs** ou **Utilisateurs**, sélectionner l'OU et appuyer sur Executer
Choix 2, Automatiser par GPO au démarrage les chiffrements avec le script **Auto_Ordi-Users**:

