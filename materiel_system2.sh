#!/bin/bash

# ASCII Art
echo "  _ _                    _                   _            _                             _       _   "
echo " | ()                  | |                 | |          ()                           (_)     | |  "
echo " | |_ _ __  _   ___  __ | |__   __ _ _ __ _| | ___ _ __  _ _ __   __ _   ___  ___ _ __ _ _ __ | | "
echo " | | | '_ \\| | | \\ \\/ / | '_ \\ / \` | '/ _\` |/ _ \\ ' \\| | '_ \\ / \` | / __|/ __| '| | ' \\| __|"
echo " | | | | | | || |>  <  | | | | (| | | | (| |  __/ | | | | | | | (| | \\__ \\ (| |  | | |) | | "
echo " |||| ||\\,//\\\\ || ||\\,||  \\,|\\|| |||| ||\\, | |/\\||  || ./ \\|"
echo "                                                                   __/ |                 | |        "
echo "                                                                  |/                  ||         "
echo
echo "             .--.  "
echo "            |o_o | "
echo "            |:_/ | "
echo "           //   \\ \\ "
echo "          (|     | )"
echo "         /'\\_   _/\\'"
echo "         \\)=(/"
echo
echo "############################################"
echo "#      Script par Soukaina et Manal       #"
echo "############################################"
echo

# Fonction pour afficher le menu principal
display_menu() {
    echo "========================================="
    echo "          Linux Hardening Menu           "
    echo "========================================="
    echo "1. Configuration matérielle"
    echo "2. Configuration système"
    echo "3. Quitter"
    echo "========================================="
    read -p "Veuillez choisir une option : " choice
}

# Fonction pour la configuration matérielle
configure_hardware() {
    echo "========================================="
    echo "      Configuration Matérielle           "
    echo "========================================="
    echo "1. Support matériel"
    echo "2. BIOS/UEFI"
    echo "3. Démarrage sécurisé UEFI"
    echo "4. Retour au menu principal"
    echo "========================================="
    read -p "Veuillez choisir une option : " hw_choice

    case $hw_choice in
        1) echo "Affichage des informations sur le support matériel..."; lshw ;;
        2) echo "Affichage des options BIOS/UEFI..."; dmidecode -t bios ;;
        3) echo "Vérification du démarrage sécurisé UEFI..."; mokutil --sb-state ;;
        4) return ;;
        *) echo "Option invalide." ;;
    esac
}

# Fonction pour la configuration système
configure_system() {
    echo "========================================="
    echo "       Configuration Système             "
    echo "========================================="
    echo "1. Partitionnement"
    echo "2. Comptes d'accès"
    echo "3. Contrôle d'accès"
    echo "4. Gestion des fichiers et répertoires"
    echo "5. Gestion des paquets"
    echo "6. Retour au menu principal"
    echo "========================================="
    read -p "Veuillez choisir une option : " sys_choice

    case $sys_choice in
        1) echo "Affichage des informations sur le partitionnement..."; fdisk -l ;;
        2) echo "Affichage des comptes d'accès..."; cat /etc/passwd ;;
        3) echo "Affichage des droits d'accès..."; ls -l ;;
        4) echo "Affichage des fichiers sensibles..."; find / -type f -perm 600 ;;
        5) echo "Gestion des paquets..."; sudo apt update && sudo apt upgrade ;;
        6) return ;;
        *) echo "Option invalide." ;;
    esac
}

# Boucle principale du script
while true; do
    display_menu

    case $choice in
        1) configure_hardware ;;
        2) configure_system ;;
        3) echo "Merci d'avoir utilisé le script."; exit 0 ;;
        *) echo "Option invalide." ;;
    esac
done
