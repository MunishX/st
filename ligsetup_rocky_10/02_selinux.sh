#!/bin/bash

# cd /tmp && rm -rf 02_seli* && wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/02_selinux.sh && chmod +x 02_selinux.sh && ./02_selinux.sh

###############################################################################
# Disable SELinux (temporary + permanent)
###############################################################################
selinux_disable() {

    # Disable immediately (if currently enforcing/permissive)
    if command -v setenforce >/dev/null 2>&1; then
        setenforce 0 2>/dev/null || true
    fi

    local cfg="/etc/selinux/config"

    if [[ -f "$cfg" ]]; then

        if grep -qE '^[[:space:]]*SELINUX=' "$cfg"; then
            sed -ri \
                's/^[[:space:]]*SELINUX=.*/SELINUX=disabled/' \
                "$cfg"
        else
            echo "SELINUX=disabled" >> "$cfg"
        fi

    else
        echo "SELINUX=disabled" > "$cfg"
    fi

    echo ""
    echo "SELINUX: disabled"
    echo "Reboot is required for persistent selinux disable."
    echo ""
}

###############################################################################
# Enable SELinux (Enforcing)
###############################################################################
selinux_enable() {

    local cfg="/etc/selinux/config"

    if [[ -f "$cfg" ]]; then
        if grep -qE '^[[:space:]]*SELINUX=' "$cfg"; then
            sed -ri \
                's/^[[:space:]]*SELINUX=.*/SELINUX=enforcing/' \
                "$cfg"
        else
            echo "SELINUX=enforcing" >> "$cfg"
        fi
    else
        echo "SELINUX=enforcing" > "$cfg"
    fi

    if command -v setenforce >/dev/null 2>&1; then
        setenforce 1 2>/dev/null || true
    fi
    
    echo ""
    echo "SELINUX: enabled"
    echo "Reboot is required for persistent selinux enable."
    echo ""
}

selinux_status() {
    echo ""
    echo "SELINUX status: "
    if command -v getenforce >/dev/null 2>&1; then
        getenforce
    else
        echo "Unknown"
    fi
    echo ""
}


###############################################################################
# WORK
###############################################################################

selinux_status

selinux_disable
# reboot required for permanent disable

#selinux_enable

