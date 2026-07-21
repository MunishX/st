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

    OS_ID="$ID"
    OS_VERSION_ID="$VERSION_ID"

    case "$ID" in

        ubuntu)
            CUDA_OS="Ubuntu"
            CUDA_VERSION="${VERSION_ID//./}"
            CUDA_PACKAGE="deb"
            ;;

        debian)
            CUDA_OS="Debian"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="deb"
            ;;

        rhel)
            CUDA_OS="RHEL"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        rocky)
            CUDA_OS="Rocky"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        almalinux)
            CUDA_OS="AlmaLinux"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        centos)
            CUDA_OS="CentOS"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        fedora)
            CUDA_OS="Fedora"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        opensuse-leap)
            CUDA_OS="OpenSUSE"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        sles)
            CUDA_OS="SLES"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        amzn)
            CUDA_OS="Amazon Linux"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        ol)
            CUDA_OS="Oracle Linux"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        kylin)
            CUDA_OS="KylinOS"
            CUDA_VERSION="10"
            CUDA_PACKAGE="rpm"
            ;;

        azurelinux)
            CUDA_OS="Azure Linux"
            CUDA_VERSION="${VERSION_ID%%.*}"
            CUDA_PACKAGE="rpm"
            ;;

        *)
            echo "[ERROR] Unsupported Linux distribution."
            echo "        ID=$ID"
            echo "        VERSION_ID=$VERSION_ID"
            exit 1
            ;;
    esac

    echo "[INFO] OS: $PRETTY_NAME"
    echo "[INFO] CUDA OS: $CUDA_OS"
    echo "[INFO] CUDA version: $CUDA_VERSION"
    echo "[INFO] Package: .$CUDA_PACKAGE"
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

    html=$(curl -fsSL "$CUDA_PAGE_URL") || {
        echo "[ERROR] Failed to download CUDA download page."
        exit 1
    }

    urls=$(
        printf '%s' "$html" |
        grep -oE 'https://developer\.download\.nvidia\.com/[^"<>[:space:]]+\.'"$CUDA_PACKAGE" |
        sort -u
    )

    if [ -z "$urls" ]; then
        echo
        echo "[ERROR] No .$CUDA_PACKAGE installer found."
        echo
        echo "Detected system:"
        echo "  OS           : $PRETTY_NAME"
        echo "  Distribution : $CUDA_OS"
        echo "  Version      : $CUDA_VERSION"
        echo "  Architecture : $TARGET_ARCH"
        echo
        echo "This OS/version/architecture combination may not be supported"
        echo "by the current CUDA download page."
        exit 1
    fi

    url_count=$(printf '%s\n' "$urls" | wc -l)

    if [ "$url_count" -ne 1 ]; then
        echo
        echo "[ERROR] Expected exactly one .$CUDA_PACKAGE installer."
        echo "[ERROR] Found $url_count links:"
        printf '%s\n' "$urls"
        exit 1
    fi

    CUDA_DOWNLOAD_URL="$urls"

    echo "[INFO] CUDA download URL:"
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

