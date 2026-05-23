#!/bin/sh
# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
#
# Build kernel (if needed) and boot in QEMU i386.
# Usage: ./scripts/mkboot-qemu.sh [i386_embedded_defconfig]

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ARCH=i386
export ARCH
DEFCONFIG="${1:-i386_embedded_defconfig}"
BZIMAGE="arch/x86/boot/bzImage"
JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"

if [ ! -f .config ]; then
 echo "==> $DEFCONFIG"
 make ARCH="$ARCH" "$DEFCONFIG"
fi

if [ ! -f "$BZIMAGE" ]; then
 echo "==> building kernel (-j$JOBS)"
 make ARCH="$ARCH" -j"$JOBS"
fi

if ! command -v qemu-system-i386 >/dev/null 2>&1; then
 echo "install qemu: sudo apt install qemu-system-x86" >&2
 exit 1
fi

echo "==> qemu-system-i386 (Ctrl+A X to quit)"
exec qemu-system-i386 \
 -m 256M \
 -kernel "$BZIMAGE" \
 -append "console=ttyS0 loglevel=7" \
 -nographic \
 -no-reboot
