#!/bin/bash

# Check for root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with root privileges."
    exit 1
fi

# Function to back up a file
backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp -p "$file" "${file}.bak"
        echo "Backup of $file completed."
    else
        echo "The file $file was not found. Creating a new file."
        touch "$file"
    fi
}

# Configure kernel parameters via GRUB
echo "Configuring kernel parameters in GRUB..."
GRUB_FILE="/etc/default/grub"
KERNEL_PARAMS="l1tf=full,force page_poison=on pti=on slab_nomerge=yes slub_debug=FZP \
    spec_store_bypass_disable=seccomp spectre_v2=on mds=full,nosmt mce=0 page_alloc.shuffle=1 \
    rng_core.default_quality=500"

backup_file "$GRUB_FILE"

# Update GRUB_CMDLINE_LINUX
if grep -q '^GRUB_CMDLINE_LINUX=' "$GRUB_FILE"; then
    sed -i "/^GRUB_CMDLINE_LINUX=/ s|\"$| $KERNEL_PARAMS\"|" "$GRUB_FILE"
else
    echo "GRUB_CMDLINE_LINUX=\"$KERNEL_PARAMS\"" >> "$GRUB_FILE"
fi

# Add a comment to the GRUB file
if ! grep -q '# Parameters added by hardening script' "$GRUB_FILE"; then
    echo "# Parameters added by hardening script" >> "$GRUB_FILE"
fi

# Update GRUB
if command -v update-grub &> /dev/null; then
    update-grub
elif command -v grub2-mkconfig &> /dev/null; then
    grub2-mkconfig -o /boot/grub2/grub.cfg
else
    echo "Error: GRUB update command not found."
    exit 1
fi

echo "GRUB configuration updated."

# Configure kernel parameters in /etc/sysctl.conf
echo "Configuring kernel parameters in /etc/sysctl.conf..."
SYSCTL_FILE="/etc/sysctl.conf"

backup_file "$SYSCTL_FILE"

# Kernel parameters list
kernel_params=(
    "kernel.dmesg_restrict=1"
    "kernel.kptr_restrict=2"
    "kernel.pid_max=65536"
    "kernel.perf_cpu_time_max_percent=1"
    "kernel.perf_event_max_sample_rate=1"
    "kernel.perf_event_paranoid=2"
    "kernel.randomize_va_space=2"
    "kernel.sysrq=0"
    "kernel.unprivileged_bpf_disabled=1"
    "kernel.panic_on_oops=1"
    "kernel.modules_disabled=1"
    "kernel.yama.ptrace_scope=1"
)

for param in "${kernel_params[@]}"; do
    if ! grep -q "^${param%%=*}" "$SYSCTL_FILE"; then
        echo "$param" >> "$SYSCTL_FILE"
    fi
done

# Apply sysctl parameters (suppress errors)
if ! sysctl -p 2>/dev/null; then
    echo "Some errors were encountered while applying sysctl parameters."
fi

echo "Kernel parameters applied successfully."

# Display currently loaded modules
echo "Currently loaded modules:"
lsmod

# Network hardening
read -p "Would you like to start network hardening using kernel modules? (Y/N): " resp
resp=${resp^^}  # Convert to uppercase

if [[ "$resp" == "Y" ]]; then
    echo "Configuring network parameters..."

    network_params=(
        "net.core.bpf_jit_harden=2"
        "net.ipv4.ip_forward=0"
        "net.ipv4.conf.all.accept_local=0"
        "net.ipv4.conf.all.accept_redirects=0"
        "net.ipv4.conf.default.accept_redirects=0"
        "net.ipv4.conf.all.secure_redirects=0"
        "net.ipv4.conf.default.secure_redirects=0"
        "net.ipv4.conf.all.accept_source_route=0"
        "net.ipv4.conf.default.accept_source_route=0"
        "net.ipv4.conf.all.arp_filter=1"
        "net.ipv4.conf.all.arp_ignore=2"
        "net.ipv4.conf.default.rp_filter=1"
        "net.ipv4.conf.all.rp_filter=1"
        "net.ipv4.tcp_syncookies=1"
        "net.ipv6.conf.default.disable_ipv6=1"
        "net.ipv6.conf.all.disable_ipv6=1"
    )

    for param in "${network_params[@]}"; do
        if ! grep -q "^${param%%=*}" "$SYSCTL_FILE"; then
            echo "$param" >> "$SYSCTL_FILE"
        fi
    done

    if ! sysctl -p 2>/dev/null; then
        echo "Some errors were encountered while applying network parameters."
    fi

    echo "Network parameters applied successfully."
else
    echo "Network hardening canceled."
fi

# File system hardening
read -p "Would you like to harden file system parameters? (Y/N): " resp2
resp2=${resp2^^}  # Convert to uppercase

if [[ "$resp2" == "Y" ]]; then
    echo "Configuring file system parameters..."

    file_params=(
        "fs.protected_hardlinks=1"
        "fs.protected_symlinks=1"
        "fs.protected_fifos=2"
        "fs.protected_regular=2"
        "fs.suid_dumpable=0"
    )

    for param in "${file_params[@]}"; do
        if ! grep -q "^${param%%=*}" "$SYSCTL_FILE"; then
            echo "$param" >> "$SYSCTL_FILE"
        fi
    done

    if ! sysctl -p 2>/dev/null; then
        echo "Some errors were encountered while applying file system parameters."
    fi

    echo "File system parameters applied successfully."
else
    echo "File system hardening canceled."
fi

echo "Kernel hardening is complete. A reboot may be necessary to apply all changes."
