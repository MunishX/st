#!/bin/bash

detect_gcc() {
    if gcc -dumpversion; then
        echo "gcc found"
    else
        echo "gcc not found.., Install gcc 11+ to continue, Exiting.."
        exit 1
    fi

    GCC_VERSION=$(gcc -dumpversion | cut -d. -f1)

    if [ "$GCC_VERSION" -lt 11 ]; then
        echo "GCC version ($GCC_VERSION) is lower than 11. Upgrade gcc to 11+ . Exiting."
        exit 1
    else
        echo "GCC version ($GCC_VERSION) is 11 or above. continuing.."
        echo "GCC [OK]"
        echo ""
    fi
}

detect_os() {
    os_type="NULL"

    if [ -n "$(command -v yum)" ]; then
        os_type="yum"
    fi

    if [ -n "$(command -v apt-get)" ]; then
        os_type="apt"
    fi

    if [[ "$os_type" = "NULL" ]]; then
        echo "[error] Un-Supported OS found. Exiting.."
        exit 1
    else
        echo "[info] Supported OS found. OS_Type: $os_type"
    fi
}


install_required_tools(){
    if [[ "$os_type" == "yum" ]]; then
        echo "[info] Installing basic tools via yum..."
        yum -y install nano wget curl net-tools lsof zip unzip sudo sed
        return 0
    fi
    if [[ "$os_type" == "apt" ]]; then
        echo "[info] Installing basic tools via apt..."
        apt-get -y install nano wget curl net-tools lsof zip unzip sudo sed
        return 0
    fi

    echo "[error] OS type is unsupported. Exiting..."
    exit 0
}

install_cuda_drivers(){
    if [[ "$os_type" == "yum" ]]; then
        echo "[info] Installing basic tools via yum..."
        sudo dnf config-manager --add-repo 'https://nvidia.com'
        sudo dnf install cuda-drivers
        sudo dnf install cuda-toolkit

        echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
        echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
        source ~/.bashrc
        return 0
    fi
    if [[ "$os_type" == "apt" ]]; then
        echo "[info] Installing basic tools via apt..."
        apt-get -y install nano wget curl net-tools lsof zip unzip sudo sed

        echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
        echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
        source ~/.bashrc
        return 0
    fi

    echo "[error] OS type is unsupported. Exiting..."
    exit 0

}

test_cuda(){
    gcc --version
    nvcc --version
}


detect_os
detect_gcc
install_required_tools
install_cuda_drivers
test_cuda

