#!/bin/sh
# Build a minimal root filesystem — no Buildroot/Yocto required
# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
#
# Uses busybox from PATH, or downloads a static binary once.
# Output: output/linux32/<profile>/rootfs/ and rootfs.cpio.gz

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
. "$ROOT/scripts/linux32-lib.sh"

PROFILE="${1:-embedded}"
linux32_load_profile "$PROFILE"

DESTDIR="$LINUX32_OUT/$PROFILE/rootfs"
CPIO="$LINUX32_OUT/$PROFILE/rootfs.cpio.gz"
BUSYBOX_CACHE="$LINUX32_OUT/.cache/busybox"
JOBS="${JOBS:-$(nproc 2>/dev/null || echo 2)}"

mkdir -p "$DESTDIR" "$LINUX32_OUT/.cache"

echo "==> Linux32 rootfs: profile=$PROFILE -> $DESTDIR"

# Skeleton
cp -a "$LINUX32_ROOTFS_SKEL"/* "$DESTDIR/"
echo "$PROFILE" > "$DESTDIR/etc/linux32-profile"
echo "export LINUX32_PROFILE=$PROFILE" > "$DESTDIR/etc/profile.local"

# Busybox
busybox_bin=""
if command -v busybox >/dev/null 2>&1; then
	busybox_bin=$(command -v busybox)
elif [ -x "$BUSYBOX_CACHE" ]; then
	busybox_bin="$BUSYBOX_CACHE"
else
	echo "==> downloading static busybox (one-time)..."
	mkdir -p "$(dirname "$BUSYBOX_CACHE")"
	# Static musl build commonly used for initramfs
	url="https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox"
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL -o "$BUSYBOX_CACHE" "$url" || true
	elif command -v wget >/dev/null 2>&1; then
		wget -q -O "$BUSYBOX_CACHE" "$url" || true
	fi
	chmod +x "$BUSYBOX_CACHE" 2>/dev/null || true
	[ -x "$BUSYBOX_CACHE" ] && busybox_bin="$BUSYBOX_CACHE"
fi

if [ -z "$busybox_bin" ]; then
	echo "Install busybox: sudo apt install busybox-static" >&2
	exit 1
fi

cp "$busybox_bin" "$DESTDIR/bin/busybox"
chmod +x "$DESTDIR/bin/busybox"
"$DESTDIR/bin/busybox" --install -s "$DESTDIR/bin"
ln -sf busybox "$DESTDIR/sbin/init"
ln -sf ../bin/busybox "$DESTDIR/sbin/mdev"
chmod +x "$DESTDIR/init"

# Pack initramfs
mkdir -p "$(dirname "$CPIO")"
( cd "$DESTDIR" && find . | cpio -o -H newc 2>/dev/null | gzip -9 ) > "$CPIO"
echo "==> wrote $CPIO ($(du -h "$CPIO" | awk '{print $1}'))"
