#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Run this script as root."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    echo "Usage: $0 <username> <password>"
    echo "Usage: $0 <username> <password> sudo"
    echo "Usage: $0 <username> <password> wheel"
    exit 1
fi

USERNAME="$1"
PASSWORD="$2"
ALLOW_SUDO="$3"
# ALLOW_SUDO must be "sudo" for making user a sudoers

# Validate username
if ! [[ "$USERNAME" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
    echo "[ERROR] Invalid username: $USERNAME"
    exit 1
fi

# Check whether user already exists
if id "$USERNAME" >/dev/null 2>&1; then
    echo "[ERROR] User already exists: $USERNAME"
    exit 1
fi

# Create user with home directory and Bash shell
useradd \
    --create-home \
    --shell /bin/bash \
    "$USERNAME"

echo
echo "Setting password for user: $USERNAME"
if [[ -z "$PASSWORD" ]]; then
    passwd "$USERNAME"
else
    printf '%s:%s\n' "$USERNAME" "$PASSWORD" | chpasswd
fi
unset PASSWORD

# Making Sudoers user
if [[ "$ALLOW_SUDO" == "sudo" ]]; then
    sudo echo "$USERNAME   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
fi
if [[ "$ALLOW_SUDO" == "wheel" ]]; then
    sudo usermod -aG wheel $USERNAME
fi


echo
echo "[OK] User created successfully."
echo "[INFO] Username: $USERNAME"
echo "[INFO] Home: /home/$USERNAME"
echo "[INFO] Shell: /bin/bash"
if [[ "$ALLOW_SUDO" == "sudo" ]]; then
    echo "[INFO] is_Sudoers: true"
else
    echo "[INFO] is_Sudoers: false"
fi
if [[ "$ALLOW_SUDO" == "wheel" ]]; then
    echo "[INFO] is_wheel: true"
else
    echo "[INFO] is_wheel: false"
fi
echo

