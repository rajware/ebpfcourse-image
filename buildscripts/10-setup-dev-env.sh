#!/bin/sh -e

echo "Installing linux docs..."
apk add mandoc man-pages

echo "Installing compilers..."
apk add llvm lldb clang

echo "Installing kernel headers and libriaries..."
apk add linux-headers \
        libbpf-dev \
        elfutils-dev \
        zstd-static \
        zlib-dev zlib-static zlib-doc

echo "Adding bpftool..."
apk add bpftool

echo "Adding iproute2..."
apk add iproute2 iproute2-doc

echo "Adding ethtool..."
apk add ethtool

echo "Installing development tools"
apk add make git geany
