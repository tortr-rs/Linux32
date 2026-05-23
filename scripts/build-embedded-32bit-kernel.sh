#!/bin/sh
# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
#
# Build an embedded-tuned 32-bit kernel from this fork.
# Usage:
#   ./scripts/build-embedded-32bit-kernel.sh              # x86 i386 embedded
#   ./scripts/build-embedded-32bit-kernel.sh arm         # ARM embedded
#   ./scripts/build-embedded-32bit-kernel.sh i386 menuconfig

set -eu

TARGET="${1:-i386}"
if [ "$TARGET" = "menuconfig" ] || [ "$TARGET" = "olddefconfig" ]; then
	MAKE_ARGS="$TARGET"
	TARGET="i386"
else
	shift || true
	MAKE_ARGS="${*:-}"
fi

JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
MAKE="${MAKE:-make}"

if [ ! -f Makefile ]; then
	echo "Run this script from the kernel source root." >&2
	exit 1
fi

case "$TARGET" in
i386|x86)
	ARCH=i386
	DEFCONFIG=i386_embedded_defconfig
	;;
arm)
	ARCH=arm
	DEFCONFIG=linux32_embedded_defconfig
	;;
mips)
	ARCH=mips
	DEFCONFIG=linux32_embedded_defconfig
	;;
*)
	echo "Unknown target: $TARGET (use i386, arm, or mips)" >&2
	exit 1
	;;
esac

export ARCH

if [ ! -f .config ]; then
	echo "==> Generating $DEFCONFIG (ARCH=$ARCH)"
	$MAKE ARCH="$ARCH" "$DEFCONFIG"
fi

echo "==> Building embedded 32-bit kernel (ARCH=$ARCH, -j$JOBS)"
if [ -n "$MAKE_ARGS" ]; then
	exec $MAKE ARCH="$ARCH" -j"$JOBS" $MAKE_ARGS
else
	exec $MAKE ARCH="$ARCH" -j"$JOBS"
fi
