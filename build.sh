#!/bin/bash

set -e
DIR=$PWD

# version
GIT_URL="https://github.com/hupster/wifi-connect/"
GIT_CHECKOUT="live_networks"

# config
ARCH="arm64"
TARGET="aarch64-unknown-linux-gnu"
CC="aarch64-linux-gnu-"

# environment
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=${CC}gcc
export CC_aarch64_unknown_linux_gnu=${CC}gcc
export CXX_aarch64_unknown_linux_gnu=${CC}g++
export PKG_CONFIG_SYSROOT_DIR=/
export PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig

# check environment
./check.sh

# install rustup if missing
if [ -z "$(which rustup)" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
fi
if [ -z "$(rustup target list |grep installed |grep $TARGET)" ]; then
    rustup target add $TARGET
    rustup toolchain install stable-$TARGET
fi

# install source if missing
if [ ! -f "${DIR}/build/Cargo.toml" ] ; then
    git clone ${GIT_URL} build
    cd ${DIR}/build
    git checkout ${GIT_CHECKOUT}
    cd ${DIR}
fi

# build
cd ${DIR}/build
cargo build --release --target=$TARGET
mkdir -p ${DIR}/bin
${CC}strip -o ${DIR}/bin/wifi-connect target/${TARGET}/release/wifi-connect
cd ${DIR}
