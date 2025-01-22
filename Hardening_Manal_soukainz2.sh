#!/bin/bash

# ASCII Art
echo "  _ _                    _                   _            _                             _       _   "
echo " | ()                  | |                 | |          ()                           (_)     | |  "
echo " | |_ _ __  _   ___  __ | |__   __ _ _ __ _| | ___ _ __  _ _ __   __ _   ___  ___ _ __ _ _ __ | | "
echo " | | | '_ \| | | \ \/ / | '_ \ / \` | '/ _\` |/ _ \ ' \| | '_ \ / \` | / __|/ __| '| | ' \| __|"
echo " | | | | | | || |>  <  | | | | (| | | | (| |  __/ | | | | | | | (| | \__ \ (| |  | | |) | | "
echo " |||| ||\,//\\ || ||\,||  \|\|| |||| ||\, | |/\||  || ./ \|"
echo "                                                                   __/ |                 | |        "
echo "                                                                  |/                  ||         "
echo
echo "             .--.  "
echo "            |o_o | "
echo "            |:_/ | "
echo "           //   \\ \ "
echo "          (|     | )"
echo "         /'\\_   _/\\'"
echo "         \)=(/"
echo
echo "############################################"
echo "#      Script de Manal&Soukaina - Menu       #"
echo "############################################"
echo

# Fonction pour afficher le menu principal
display_main_menu() {
    echo "========================================="
    echo "        Menu Principal de Durcissement    "
    echo "========================================="
    echo "1. Durcissement Matérielet système"
    echo "2. Durcissement Service "
    echo "3. Durcissement du Noyau"
    echo "4. Quitter"
    echo "========================================="
    read -p "Veuillez choisir une option : " choice
}

# Fonction pour exécuter un script donné
execute_script() {
    local script_name=$1
    if [[ -f "$script_name" ]]; then
        echo "Exécution de $script_name..."
        bash "$script_name"
    else
        echo "Erreur : Le script $script_name n'existe pas dans le répertoire courant."
    fi
}

# Boucle principale du script
while true; do
    display_main_menu

    case $choice in
        1)
            execute_script "materiel_system.sh"
            ;;
        2)
            execute_script "service.sh"
            ;;
        3)
            execute_script "kernel.sh"
            ;;
        4)
            echo "Merci d'avoir utilisé ce script. Au revoir !"
            exit 0
            ;;
        *)
            echo "Option invalide. Veuillez réessayer."
            ;;
    esac

    # Demander à l'utilisateur s'il souhaite continuer ou quitter
    echo
    read -p "Voulez-vous exécuter un autre script ? (Y/N) : " continue_choice
    continue_choice=${continue_choice^^} # Convertir en majuscules

    if [[ "$continue_choice" != "Y" ]]; then
        echo "Merci d'avoir utilisé ce script. Au revoir !"
        exit 0
    fi

done
