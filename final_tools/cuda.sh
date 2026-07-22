#!/bin/bash

set -e

CUDA_DOMAIN_SUB="developer"
CUDA_DOMAIN_MAIN="nvidia.com"
CUDA_DIR="cuda-downloads"
CUDA_DOWNLOAD_PAGE="https://$CUDA_DOMAIN_SUB.$CUDA_DOMAIN_MAIN/$CUDA_DIR"

detect_os()
{
    if [ ! -f /etc/os-release ]; then
        echo "[ERROR] /etc/os-release not found."
        exit 1
    fi

    . /etc/os-release

    case "$ID" in

        rhel)
            case "${VERSION_ID%%.*}" in
                8|9|10)
                    CUDA_PAGE_DISTRO="RHEL"
                    CUDA_PAGE_VERSION="${VERSION_ID%%.*}"
                    CUDA_PACKAGE_CODE="rhel${VERSION_ID%%.*}"
                    CUDA_PACKAGE="rpm"
                    ;;
                *)
                    echo "[ERROR] Unsupported RHEL version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        rocky)
            case "${VERSION_ID%%.*}" in
                8|9|10)
                    CUDA_PAGE_DISTRO="Rocky"
                    CUDA_PAGE_VERSION="${VERSION_ID%%.*}"
                    CUDA_PACKAGE_CODE="rhel${VERSION_ID%%.*}"
                    CUDA_PACKAGE="rpm"
                    ;;
                *)
                    echo "[ERROR] Unsupported Rocky Linux version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        almalinux)
            case "${VERSION_ID%%.*}" in
                8|9|10)
                    CUDA_PAGE_DISTRO="AlmaLinux"
                    CUDA_PAGE_VERSION="${VERSION_ID%%.*}"
                    CUDA_PACKAGE_CODE="rhel${VERSION_ID%%.*}"
                    CUDA_PACKAGE="rpm"
                    ;;
                *)
                    echo "[ERROR] Unsupported AlmaLinux version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        ol)
            case "${VERSION_ID%%.*}" in
                8|9)
                    CUDA_PAGE_DISTRO="Oracle Linux"
                    CUDA_PAGE_VERSION="${VERSION_ID%%.*}"
                    CUDA_PACKAGE_CODE="rhel${VERSION_ID%%.*}"
                    CUDA_PACKAGE="rpm"
                    ;;
                *)
                    echo "[ERROR] Unsupported Oracle Linux version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        opensuse-leap)
            case "${VERSION_ID%%.*}" in
                15)
                    CUDA_PAGE_DISTRO="openSUSE"
                    CUDA_PAGE_VERSION="15"
                    CUDA_PACKAGE_CODE="opensuse15"
                    CUDA_PACKAGE="rpm"
                    ;;

                16)
                    CUDA_PAGE_DISTRO="openSUSE"
                    CUDA_PAGE_VERSION="16"
                    CUDA_PACKAGE_CODE="suse16"
                    CUDA_PACKAGE="rpm"
                    ;;

                *)
                    echo "[ERROR] Unsupported openSUSE Leap version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        sles)
            case "${VERSION_ID%%.*}" in
                15)
                    CUDA_PAGE_DISTRO="SLES"
                    CUDA_PAGE_VERSION="15"
                    CUDA_PACKAGE_CODE="sles15"
                    CUDA_PACKAGE="rpm"
                    ;;

                16)
                    CUDA_PAGE_DISTRO="SLES"
                    CUDA_PAGE_VERSION="16"
                    CUDA_PACKAGE_CODE="suse16"
                    CUDA_PACKAGE="rpm"
                    ;;

                *)
                    echo "[ERROR] Unsupported SLES version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        ubuntu)
            case "$VERSION_ID" in
                22.04)
                    CUDA_PAGE_DISTRO="Ubuntu"
                    CUDA_PAGE_VERSION="2204"
                    CUDA_PACKAGE_CODE="ubuntu2204"
                    ;;

                24.04)
                    CUDA_PAGE_DISTRO="Ubuntu"
                    CUDA_PAGE_VERSION="2404"
                    CUDA_PACKAGE_CODE="ubuntu2404"
                    ;;

                26.04)
                    CUDA_PAGE_DISTRO="Ubuntu"
                    CUDA_PAGE_VERSION="2604"
                    CUDA_PACKAGE_CODE="ubuntu2604"
                    ;;

                *)
                    echo "[ERROR] Unsupported Ubuntu version: $VERSION_ID"
                    exit 1
                    ;;
            esac

            CUDA_PACKAGE="deb"
            ;;

        debian)
            case "${VERSION_ID%%.*}" in
                12)
                    CUDA_PAGE_DISTRO="Debian"
                    CUDA_PAGE_VERSION="12"
                    CUDA_PACKAGE_CODE="debian12"
                    ;;

                13)
                    CUDA_PAGE_DISTRO="Debian"
                    CUDA_PAGE_VERSION="13"
                    CUDA_PACKAGE_CODE="debian13"
                    ;;

                *)
                    echo "[ERROR] Unsupported Debian version: $VERSION_ID"
                    exit 1
                    ;;
            esac

            CUDA_PACKAGE="deb"
            ;;

        fedora)
            case "${VERSION_ID%%.*}" in
                44)
                    CUDA_PAGE_DISTRO="Fedora"
                    CUDA_PAGE_VERSION="44"
                    CUDA_PACKAGE_CODE="fedora44"
                    CUDA_PACKAGE="rpm"
                    ;;

                *)
                    echo "[ERROR] Unsupported Fedora version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        kylin)
            case "$VERSION_ID" in
                11)
                    CUDA_PAGE_DISTRO="KylinOS"
                    CUDA_PAGE_VERSION="11"
                    CUDA_PACKAGE_CODE="kylin11"
                    CUDA_PACKAGE="rpm"
                    ;;

                *)
                    echo "[ERROR] Unsupported KylinOS version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        azurelinux)
            case "$VERSION_ID" in
                3.0|3)
                    CUDA_PAGE_DISTRO="Azure Linux"
                    CUDA_PAGE_VERSION="3"
                    CUDA_PACKAGE_CODE="azl3"
                    CUDA_PACKAGE="rpm"
                    ;;

                *)
                    echo "[ERROR] Unsupported Azure Linux version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;

        amzn)
            case "$VERSION_ID" in
                2023)
                    CUDA_PAGE_DISTRO="Amazon Linux"
                    CUDA_PAGE_VERSION="2023"
                    CUDA_PACKAGE_CODE="amzn2023"
                    CUDA_PACKAGE="rpm"
                    ;;

                *)
                    echo "[ERROR] Unsupported Amazon Linux version: $VERSION_ID"
                    exit 1
                    ;;
            esac
            ;;
            
        alpine)
            echo "[ERROR] Alpine Linux is not supported by the NVIDIA CUDA RPM/DEB repository installer."
            echo
            echo "The current installation method supports NVIDIA's RPM/DEB distributions."
            echo
            echo "For Alpine/Docker, use an NVIDIA CUDA devel container image. OR supported OS like RHEL, Rocky, Ubuntu, Debian, etc"
            echo
            exit 1
            ;;
            
        *)
            echo "[ERROR] Unsupported Linux distribution."
            echo "        ID=$ID"
            echo "        VERSION_ID=$VERSION_ID"
            exit 1
            ;;
    esac

    echo "[INFO] OS: $PRETTY_NAME"
    echo "[INFO] CUDA page distro: $CUDA_PAGE_DISTRO"
    echo "[INFO] CUDA page version: $CUDA_PAGE_VERSION"
    echo "[INFO] CUDA package code: $CUDA_PACKAGE_CODE"
    echo "[INFO] Package type: .$CUDA_PACKAGE"
}

detect_arch()
{
    TARGET_ARCH_RAW=$(uname -m)

    case "$TARGET_ARCH_RAW" in
        x86_64)
            TARGET_ARCH_RPM="x86_64"
            TARGET_ARCH_DEB="amd64"
            ;;

        aarch64)
            TARGET_ARCH_RPM="aarch64"
            TARGET_ARCH_DEB="arm64"
            ;;

        *)
            echo "[ERROR] Unsupported architecture: $TARGET_ARCH_RAW"
            exit 1
            ;;
    esac

    case "$CUDA_PACKAGE" in
        rpm)
            TARGET_ARCH="$TARGET_ARCH_RPM"
            ;;

        deb)
            TARGET_ARCH="$TARGET_ARCH_DEB"
            ;;

        *)
            echo "[ERROR] Unknown package type: $CUDA_PACKAGE"
            exit 1
            ;;
    esac
}

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

get_cuda_download_url()
{
    local html
    local all_urls
    local urls
    local url_count

    echo
    echo "[INFO] Fetching CUDA download page..."

    html=$(curl -fsSL "$CUDA_DOWNLOAD_PAGE") || {
        echo "[ERROR] Failed to download CUDA page."
        exit 1
    }

    case "$CUDA_PACKAGE" in

        rpm)

            all_urls=$(
                printf '%s' "$html" |
                grep -oE \
                'https://developer\.download\.nvidia\.com/[^"<>[:space:]]+\.rpm' |
                grep '/local_installers/' |
                sort -u
            )

            urls=$(
                printf '%s\n' "$all_urls" |
                grep "/local_installers/cuda-repo-${CUDA_PACKAGE_CODE}-" |
                grep -E "\.${TARGET_ARCH}\.rpm$" |
                sort -u
            )

            ;;

        deb)

            all_urls=$(
                printf '%s' "$html" |
                grep -oE \
                'https://developer\.download\.nvidia\.com/[^"<>[:space:]]+\.deb' |
                grep '/local_installers/' |
                sort -u
            )

            urls=$(
                printf '%s\n' "$all_urls" |
                grep "/local_installers/cuda-repo-${CUDA_PACKAGE_CODE}-" |
                grep -E "_${TARGET_ARCH}\.deb$" |
                sort -u
            )

            ;;

        *)
            echo "[ERROR] Unsupported package type: $CUDA_PACKAGE"
            exit 1
            ;;
    esac


    if [ -z "$urls" ]; then

        echo
        echo "[ERROR] Exact CUDA installer URL not found."
        echo
        echo "Requested:"
        echo "  OS           : $PRETTY_NAME"
        echo "  Package code : $CUDA_PACKAGE_CODE"
        echo "  Architecture : $TARGET_ARCH_RAW"
        echo "  Package type : $CUDA_PACKAGE"
        echo

        if [ -n "$all_urls" ]; then
            echo "[INFO] All installer URLs found on the NVIDIA page:"
            echo
            printf '%s\n' "$all_urls"
        else
            echo "[ERROR] No .$CUDA_PACKAGE installer URLs were found."
        fi

        exit 1
    fi


    url_count=$(printf '%s\n' "$urls" | wc -l)

    if [ "$url_count" -ne 1 ]; then
        echo
        echo "[ERROR] Expected exactly one matching CUDA installer."
        echo "[ERROR] Found $url_count matching URLs:"
        echo

        printf '%s\n' "$urls"

        exit 1
    fi


    CUDA_DOWNLOAD_URL="$urls"

    echo
    echo "[INFO] CUDA installer:"
    echo "$CUDA_DOWNLOAD_URL"
}

remove_previous_cuda()
{
    local packages

    echo
    echo "[INFO] Checking for previously installed CUDA packages..."

    case "$CUDA_PACKAGE" in

        deb)
            packages=$(
                dpkg-query -W -f='${binary:Package}\n' 2>/dev/null |
                grep -E '^cuda(-.*)?$|^cuda-[0-9].*|^nvidia-cuda-toolkit$' |
                sort -u || true
            )

            if [ -z "$packages" ]; then
                echo "[INFO] No previous CUDA installation found."
                return 0
            fi

            echo "[INFO] Found previous CUDA packages:"
            echo "$packages"

            apt-get purge -y $packages || {
                echo "[ERROR] Failed to remove previous CUDA packages."
                exit 1
            }

            apt-get autoremove -y
            ;;

        rpm)
            packages=$(
                rpm -qa 2>/dev/null |
                grep -E '^cuda(-.*)?-[0-9]|^cuda-[^r]|^cuda$' |
                sort -u || true
            )

            if [ -z "$packages" ]; then
                echo "[INFO] No previous CUDA installation found."
                return 0
            fi

            echo "[INFO] Found previous CUDA packages:"
            echo "$packages"

            if command -v dnf >/dev/null 2>&1; then
                dnf remove -y $packages || {
                    echo "[ERROR] Failed to remove previous CUDA packages."
                    exit 1
                }

            elif command -v yum >/dev/null 2>&1; then
                yum remove -y $packages || {
                    echo "[ERROR] Failed to remove previous CUDA packages."
                    exit 1
                }
            fi
            ;;

        *)
            echo "[ERROR] Unknown package type: $CUDA_PACKAGE"
            exit 1
            ;;
    esac

    echo "[OK] Previous CUDA packages removed."
}

remove_old_cuda_directories()
{
    echo
    echo "[INFO] Removing old CUDA directories..."

    if [ -e /usr/local/cuda ] || [ -L /usr/local/cuda ]; then
        rm -rf /usr/local/cuda
        echo "[OK] Removed /usr/local/cuda"
    fi

    find /usr/local \
        -maxdepth 1 \
        -type d \
        -name 'cuda-[0-9]*' \
        -exec rm -rf {} +

    echo "[OK] Old CUDA version directories removed."
}

install_cuda()
{
    local package_file

    package_file="/tmp/$(basename "$CUDA_DOWNLOAD_URL")"

    echo
    echo "[INFO] Downloading CUDA repository package:"
    echo "       $CUDA_DOWNLOAD_URL"

    curl -fL --progress-bar \
        -o "$package_file" \
        "$CUDA_DOWNLOAD_URL" || {
            echo "[ERROR] Failed to download CUDA repository package."
            exit 1
        }

    echo
    echo "[INFO] Installing CUDA repository package..."

    case "$CUDA_PACKAGE" in

        deb)
            dpkg -i "$package_file" || {
                echo "[ERROR] Failed to install CUDA repository package."
                exit 1
            }

            sudo cp /var/cuda-repo-${CUDA_PACKAGE_CODE}-*-local/cuda-*-keyring.gpg /usr/share/keyrings/


            apt-get update || {
                echo "[ERROR] apt-get update failed."
                exit 1
            }

            apt-get install -y cuda cuda-toolkit || {
                echo "[ERROR] CUDA Toolkit installation failed."
                exit 1
            }
            ;;

        rpm)
            if command -v dnf >/dev/null 2>&1; then
                dnf install -y "$package_file" || {
                    echo "[ERROR] Failed to install CUDA repository package."
                    exit 1
                }

                dnf install -y cuda cuda-toolkit || {
                    echo "[ERROR] CUDA Toolkit installation failed."
                    exit 1
                }

            elif command -v yum >/dev/null 2>&1; then
                yum install -y "$package_file" || {
                    echo "[ERROR] Failed to install CUDA repository package."
                    exit 1
                }

                yum install -y cuda cuda-toolkit || {
                    echo "[ERROR] CUDA Toolkit installation failed."
                    exit 1
                }

            else
                echo "[ERROR] Neither dnf nor yum is available."
                exit 1
            fi
            ;;

        *)
            echo "[ERROR] Unknown package type: $CUDA_PACKAGE"
            exit 1
            ;;
    esac

    rm -f "$package_file"

    echo
    echo "[OK] CUDA Toolkit installed."
}

configure_cuda_environment()
{
    cat > /etc/profile.d/cuda.sh <<'EOF'
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
EOF

    chmod 644 /etc/profile.d/cuda.sh

    export PATH="/usr/local/cuda/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    echo "[OK] CUDA environment configured."
}

test_cuda()
{
    if [ ! -x /usr/local/cuda/bin/nvcc ]; then
        echo "[ERROR] nvcc was not found after CUDA installation."
        exit 1
    fi

    echo
    echo "========================================"
    echo " CUDA installation completed"
    echo "========================================"
    echo
    
    nvcc --version
    echo 
    nvidia-smi

    echo
    echo
}

install_basic_tools()
{
    case "$CUDA_PACKAGE" in

        deb)
            apt-get -y install nano wget curl net-tools lsof zip unzip sudo sed || {
                echo "[ERROR] Failed to install basic tools."
                exit 1
            }
            apt-get autoremove -y
            ;;

        rpm)
            selinux_disable
            if command -v dnf >/dev/null 2>&1; then
                dnf -y install nano wget curl net-tools lsof zip unzip sudo sed || {
                    echo "[ERROR] Failed to install basic tools."
                    exit 1
                }

            elif command -v yum >/dev/null 2>&1; then
                yum -y install nano wget curl net-tools lsof zip unzip sudo sed || {
                    echo "[ERROR] Failed to install basic tools."
                    exit 1
                }
            fi
            ;;

        *)
            echo "[ERROR] Unknown package type: $CUDA_PACKAGE"
            exit 1
            ;;
    esac

    echo "[OK] Basic Tools Installed."
}

install_required_tools()
{
    case "$CUDA_PACKAGE" in

        deb)
            apt-get -y update
            apt-get -y install build-essential dkms linux-headers-$(uname -r) || {
                echo "[ERROR] Failed to install build-essential dkms linux-headers-$(uname -r) packages."
                exit 1
            }
            apt-get autoremove -y
            ;;

        rpm)
            if command -v dnf >/dev/null 2>&1; then
                dnf -y install epel-release || {
                    echo "[ERROR] Failed to install epel-release packages."
                    exit 1
                }
                dnf -y groupinstall "Development Tools" || {
                    echo "[ERROR] Failed to install Development Tools packages."
                    exit 1
                }
                dnf -y install kernel-devel-$(uname -r) kernel-headers-$(uname -r) || {
                    echo "[ERROR] Failed to install kernel-devel-$(uname -r) kernel-headers-$(uname -r) packages."
                    exit 1
                }

            elif command -v yum >/dev/null 2>&1; then
                yum -y install epel-release || {
                    echo "[ERROR] Failed to install epel-release packages."
                    exit 1
                }
                yum -y groupinstall "Development Tools" || {
                    echo "[ERROR] Failed to install Development Tools packages."
                    exit 1
                }
                yum -y install kernel-devel-$(uname -r) kernel-headers-$(uname -r) || {
                    echo "[ERROR] Failed to install kernel-devel-$(uname -r) kernel-headers-$(uname -r) packages."
                    exit 1
                }
            fi
            ;;

        *)
            echo "[ERROR] Unknown package type: $CUDA_PACKAGE"
            exit 1
            ;;
    esac

    echo "[OK] Required Tools Installed."
}


# run functions

detect_os
detect_arch

install_basic_tools

remove_previous_cuda
remove_old_cuda_directories

install_required_tools

get_cuda_download_url

install_cuda

configure_cuda_environment

test_cuda

