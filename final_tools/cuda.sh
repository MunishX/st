#!/bin/bash

set -e

CUDA_SUB="developer"
CUDA_DOMAIN="nvidia.com"
CUDA_DIR="cuda-downloads"
CUDA_DOWNLOAD_PAGE="https://$CUDA_SUB.$CUDA_DOMAIN/$CUDA_DIR"

detect_arch()
{
    case "$(uname -m)" in
        x86_64)
            TARGET_ARCH="x86_64"
            ;;

        aarch64|arm64)
            TARGET_ARCH="sbsa"
            ;;

        *)
            echo "[ERROR] Unsupported CPU architecture: $(uname -m)"
            exit 1
            ;;
    esac

    if [[ "$TARGET_ARCH" == "sbsa" ]]; then
        if file /bin/bash | grep -q "ARM aarch64"; then
            echo "Native Arm SBSA environment detected."
        else
            echo "Cross-compiled or emulated environment detected."
            echo "Cross is currently not supported by this script.., Exiting.."
            exit 1
        fi
    fi
    echo "[INFO] Architecture: $TARGET_ARCH"
}

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

        oracle)
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

get_cuda_page_url()
{
    CUDA_PAGE_URL="${CUDA_DOWNLOAD_PAGE}?target_os=Linux&target_arch=${TARGET_ARCH}&target_distro=${CUDA_OS}&target_version=${CUDA_VERSION}&target_type=${CUDA_PACKAGE}_local"

    echo "[INFO] CUDA page:"
    echo "$CUDA_PAGE_URL"
}

get_cuda_download_url()
{
    local html
    local urls
    local url_count

    echo
    echo "[INFO] Fetching CUDA download page..."

    html=$(curl -fsSL "$CUDA_PAGE_URL") || {
        echo "[ERROR] Failed to download CUDA page."
        exit 1
    }

    urls=$(
        printf '%s' "$html" |
        grep -oE 'https://developer\.download\.nvidia\.com/[^"<>[:space:]]+\.'"$CUDA_PACKAGE" |
        grep "/local_installers/cuda-repo-${CUDA_PACKAGE_CODE}-" |
        grep -E "\.${TARGET_ARCH}\.${CUDA_PACKAGE}$" |
        sort -u
    )

    if [ -z "$urls" ]; then
        echo
        echo "[ERROR] No CUDA installer found."
        echo "        OS           : $PRETTY_NAME"
        echo "        Package code : $CUDA_PACKAGE_CODE"
        echo "        Architecture : $TARGET_ARCH"
        exit 1
    fi

    url_count=$(printf '%s\n' "$urls" | wc -l)

    if [ "$url_count" -ne 1 ]; then
        echo
        echo "[ERROR] Expected exactly one CUDA installer."
        echo "[ERROR] Found $url_count matching URLs:"
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
}


detect_arch
detect_os
get_cuda_page_url
get_cuda_download_url
remove_previous_cuda
remove_old_cuda_directories
install_cuda
configure_cuda_environment
test_cuda

echo
echo "========================================"
echo " CUDA installation completed"
echo "========================================"

nvcc --version

