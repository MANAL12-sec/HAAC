#!/bin/bash
echo "This script configures critical services with minimal permissions to enhance security."
 echo
# verification of the root priviledges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with root privileges."
    exit 1
fi

# Function to configure minimum priviledge
configurer_service() {
    local service="$1"
    echo "configure minimum priviledge for the service : $service"
    systemctl stop "$service" 2>/dev/null
    systemctl disable "$service" 2>/dev/null

    # Applying constraints via systemd
    local service_file="/etc/systemd/system/$service.service.d/override.conf"
    mkdir -p "$(dirname "$service_file")"
    cat <<EOL > "$service_file"
[Service]
PrivateTmp=true
NoNewPrivileges=true
ProtectSystem=full
ProtectHome=true
CapabilityBoundingSet=
EOL
    systemctl daemon-reload
    echo "Configuration système for $service are applied"
}

# Disable non-essential service features
echo "Disable non-essential service features..."

#  Services to configure
services_critiques=(
    "postfix"        # SMTP
    "ntpd"           # NTP
    "haldaemon"      # HAL daemon
    "cups"           # Printing service
    "avahi-daemon"   # Network publication service
    "xserver"        # Serveur X
)

for service in "${services_critiques[@]}"; do
    configurer_service "$service"
done

# Configure minimal permissions on critical executables
echo "Configuring minimal permissions on critical executables..."

executables_restrictifs=(
    "/usr/sbin/ntpd"
    "/usr/sbin/postfix"
    "/usr/sbin/named"
    "/usr/sbin/rpcbind"
    "/usr/sbin/cupsd"
    "/usr/bin/dbus-daemon"
    "/usr/sbin/avahi-daemon"
)

for exe in "${executables_restrictifs[@]}"; do
    if [ -f "$exe" ]; then
        chmod 750 "$exe"
        chown root:root "$exe"
        echo "Permissions de $exe configurées avec succès."
    fi
done

# Configure minimal permissions on critical executables
echo "Configuring PAM to strengthen authentication mechanisms..."
cat <<EOL > /etc/security/pwquality.conf
minlen=12
dcredit=3
ucredit=3
lcredit=3
ocredit=1
maxrepeat=2
EOL

if ! grep -q 'pam_unix.so.*obscure.*yescrypt.*rounds=11' /etc/pam.d/common-password; then
    sed -i '/pam_unix.so/ s/$/ obscure yescrypt rounds=11/' /etc/pam.d/common-password
    echo "PAM policy updated in /etc/pam.d/common-password."
fi


#Preparing logging configuration with auditd (not enabled by default)
echo "Preparing logging configuration with auditd (not enabled by default)..."
cat <<EOL > /etc/audit/rules.d/hardening.rules
-w /etc/ -p wa
-w /sbin/ -p x
-w /bin/kmod -p x
-a exit,always -S mount -S umount2
-a exit,always -S unlink -S rmdir -S rename
-e 2
EOL
echo "Logging configuration via auditd is ready but disabled. Use the option to enable it manually via systemctl."

# Option to activate logging 
while true; do
    echo
    echo "Options of logging auditd :"
    echo "1. Activate and start logging"
    echo "2. Check auditd status"
    echo "3. Skip and continue the script "
    read -rp "Choose an Option (1, 2, or 3) : " choix

    case $choix in
        1)
            echo "Enabling logging via auditd..."
            systemctl enable auditd
            systemctl restart auditd
            echo "Logging enabled and restarted."
            break
            ;;
        2)
            echo "Auditd logging status:"
            systemctl status auditd
            ;;
        3)
            echo "Logging left disabled."
            break
            ;;
        *)
            echo "Invalid option, please choose 1, 2, or 3.."
            ;;
    esac
done

# Display list of active services
while true; do
    echo
    echo "Options to list active services:"
    echo "1. List active services"
    echo "2. skip this step"
    read -rp " Choose an option (1 or 2): " choix

    case $choix in
        1)
            echo "List of active services on the system:"
            systemctl list-units --type=service
            break
            ;;
        2)
            echo "Step skipped."
            break
            ;;
        *)
            echo "Invalid option, please choose 1 or 2."
            ;;
    esac
done

echo "Service hardening is complete"
