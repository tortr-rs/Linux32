#!/bin/sh
# Linux32 shared library — profile loader, paths
# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0

LINUX32_ROOT="$(cd "$(dirname "$0")/../linux32" && pwd)"
LINUX32_PROFILES="$LINUX32_ROOT/profiles"
LINUX32_ROOTFS_SKEL="$LINUX32_ROOT/rootfs/skeleton"
LINUX32_OUT="${LINUX32_OUT:-output/linux32}"

linux32_load_profile() {
	profile="$1"
	file="$LINUX32_PROFILES/${profile}.profile"
	if [ ! -f "$file" ]; then
		echo "unknown profile: $profile" >&2
		echo "available:" >&2
		linux32_list_profiles >&2
		return 1
	fi
	# shellcheck source=/dev/null
	. "$file"
	export LINUX32_PROFILE="$profile"
}

linux32_list_profiles() {
	for f in "$LINUX32_PROFILES"/*.profile; do
		[ -f "$f" ] || continue
		id=$(basename "$f" .profile)
		desc=$(grep '^PROFILE_DESC=' "$f" | cut -d= -f2- | tr -d '"')
		printf "  %-16s %s\n" "$id" "$desc"
	done
}

linux32_kernel_image() {
	case "${ARCH:-i386}" in
	i386|x86) echo "arch/x86/boot/bzImage" ;;
	arm)      echo "arch/arm/boot/zImage" ;;
	mips)     echo "arch/mips/boot/vmlinux.bin" ;;
	*)        echo "arch/$ARCH/boot/Image" ;;
	esac
}
