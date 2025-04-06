#!/bin/sh -e

cat > /etc/bhringa-release <<EOF_RELEASESTAMP
Bhringa Image Version: ${VM_VERSION}
Kernel Version  : $(uname -r)
Clang Version   : $(clang -v 2>&1 | head -n 1)
libbpf Version  : $(apk list --installed libbpf|cut -d ' ' -f 1)
bpftool Version : $(bpftool version | head -n 1 | cut -d ' ' -f 2)
iproute2 Version: $(apk list --installed iproute2|cut -d ' ' -f 1)
EOF_RELEASESTAMP