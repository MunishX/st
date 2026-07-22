#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Run this script as root."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME="$1"
PASSWORD="$2"

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

echo
echo "[OK] User created successfully."
echo "[INFO] Username: $USERNAME"
echo "[INFO] Home: /home/$USERNAME"
echo "[INFO] Shell: /bin/bash"
echo

