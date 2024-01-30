#!/bin/bash

set -e
DIR=$PWD
PACKAGES=$(<packages)
ARCH="arm64"

check_host () {
    if [ ! -f /etc/debian_version ]; then
        echo "This script must be executed on a Debian based system."
        exit 1
    fi
}
check_arch () {
    if [ -z "$(dpkg --print-foreign-architectures |grep $ARCH)" ]; then
        echo "Missing architecture, please run:"
        echo "-----------------------------"
        echo "sudo dpkg --add-architecture $ARCH"
        echo "sudo apt update"
        echo "-----------------------------"
        exit 2
    fi
}
check_dpkg () {
    dpkg -s ${pkg} >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
}
check_packages () {
    unset deb_pkgs
    for pkg in ${PACKAGES[@]}
    do
        check_dpkg
    done
    if [ "${deb_pkgs}" ] ; then
        echo "Missing dependencies, please run:"
        echo "-----------------------------"
        echo "sudo apt update"
        echo "sudo apt install ${deb_pkgs}"
        echo "-----------------------------"
        exit 3
    fi
}

check_host
check_arch
check_packages
