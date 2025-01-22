# System Hardening Project

This project is the result of an **End-of-Module** assignment, which I worked on with my friend in the **Hardening** module. The goal is to automate the hardening of a Linux system by following the recommendations of **ANSSI** (French National Agency for the Security of Information Systems). 

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [materiel_system2.sh](#materiel_system2sh)
    - [Hardware Configuration](#hardware-configuration)
    - [System Configuration](#system-configuration)
3. [kernel2.sh](#kernel2sh)
    - [Root Privilege Verification](#root-privilege-verification)
    - [GRUB Configuration](#grub-configuration)
    - [Kernel Parameter Configuration](#kernel-parameter-configuration)
    - [Network Hardening](#network-hardening)
    - [Filesystem Hardening](#filesystem-hardening)
    - [Backup and Restore](#backup-and-restore)
4. [Service2.sh](#srvice2sh)
    - [Root Privileges Check](#root-privileges-check)
    - [Minimal Privilege Configuration for Services](#minimal-privilege-configuration-for-services)
    - [Permissions Adjustment on Executables](#permissions-adjustment-on-executables)
    - [PAM Configuration](#pam-configuration)
    - [Optional Active Services List](#optional-active-services-list)
5. [Usage](#usage)
6. [Important Notes](#important-notes)

---

## Project Overview

This project aims to automate the hardening of a Linux system by applying security best practices and suggestions from **ANSSI**. It includes a variety of scripts for configuring the system securely, adjusting kernel parameters, and ensuring critical services are running with minimal privileges.

---

## **materiel_system2.sh**

### **Hardware Configuration**

This script provides hardware configuration functionalities:

- **View hardware details** using `lshw`.
- **Display BIOS/UEFI information** with `dmidecode`.
- **Check UEFI Secure Boot status** using `mokutil`.

### **System Configuration**

The system configuration functionalities include:

- **Examine disk partitioning** using `fdisk`.
- **Review system accounts and permissions**.
- **Identify sensitive files** and manage packages via `apt`.

The script provides an interactive menu and guides the user through essential system hardening steps.

---

## **kernel2.sh**

This script is focused on **kernel hardening** and improving system security.

### **Root Privilege Verification**

Ensures the script is executed with root privileges.

### **GRUB Configuration**

- Updates **GRUB kernel parameters** to address security vulnerabilities like Spectre, Meltdown, and others.
- Includes **automated GRUB updates**.

### **Kernel Parameter Configuration**

- Modifies `/etc/sysctl.conf` to apply secure kernel settings.
- Disables **module loading** and enables **address space randomization**.

### **Network Hardening**

- Configures network parameters to prevent **spoofing** and **redirects**.
- Interactive option to apply these changes.

### **Filesystem Hardening**

- Restricts hardlink and symlink behavior.
- Disables **dumpable SUID files** and other security measures.

### **Backup and Restore**

- Automatically **backs up configuration files** before making changes.

---

## **Service2.sh**

This script focuses on hardening critical services by applying the **principle of least privilege**.

### **Root Privileges Check**

Verifies that the script is executed with root privileges.

### **Minimal Privilege Configuration for Services**

Configures critical services like `postfix`, `ntpd`, `haldaemon`, `cups`, `avahi-daemon`, and `xserver` to run with **minimal permissions** using `systemd`.

### **Permissions Adjustment on Executables**

Configures minimal permissions on critical executables to prevent unauthorized access.

### **PAM Configuration**

Strengthens authentication mechanisms by configuring **password quality rules** and enhancing **PAM settings**.

### **Optional Active Services List**

Offers the option to **list active services** on the system for review.

---

## **Usage**

1. **Clone the repository**:  
   `git clone https://github.com/MANAL12-sec/HAAC.git`

2. **Change into the project directory**:  
   `cd HAAC`

3. **Execute the main script with root privileges**:  
   `sudo ./Hardening_Manal_soukainz2.sh`
   
   Alternatively, individual scripts can be executed separately or collectively through the main script. Refer to specific sections for more details on their usage.

---

## **Important Notes**

- Make sure to run the scripts with **root privileges** for proper execution.
- **Review the services** and configurations being modified to avoid disabling necessary system services.
- After running the kernel hardening script, **reboot the system** to apply all changes.

---




