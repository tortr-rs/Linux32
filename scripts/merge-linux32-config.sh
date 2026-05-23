#!/bin/sh
# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
#
# Merge Linux32 embedded config fragments into the current .config
# Usage:
#   make ARCH=i386 i386_defconfig
#   ./scripts/merge-linux32-config.sh embedded [tiny|flash|rt]
#
# Examples:
#   ./scripts/merge-linux32-config.sh embedded
#   ./scripts/merge-linux32-config.sh embedded flash tiny

set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MERGE="$ROOT/scripts/kconfig/merge_config.sh"
FRAGDIR="$ROOT/kernel/configs"

if [ ! -x "$MERGE" ]; then
	echo "missing $MERGE" >&2
	exit 1
fi

if [ ! -f "$ROOT/.config" ]; then
	echo "no .config — run a defconfig first" >&2
	exit 1
fi

apply() {
 frag="$FRAGDIR/linux32-$1.config"
 if [ ! -f "$frag" ]; then
  echo "unknown fragment: $1 ($frag)" >&2
  exit 1
 fi
 echo "==> merge linux32-$1.config"
 "$MERGE" -m "$ROOT/.config" "$frag"
}

case "${1:-embedded}" in
embedded) apply embedded ;;
tiny)     apply tiny ;;
flash)    apply flash-root ;;
rt)       apply preempt-rt ;;
server)   apply server ;;
legacy)   apply legacy ;;
ultra-weak) apply ultra-weak ;;
*)
 echo "usage: $0 [embedded|tiny|flash|rt|server|legacy|ultra-weak] [more...]" >&2
 exit 1
 ;;
esac
shift || true

for extra in "$@"; do
 apply "$extra"
done

echo "==> olddefconfig"
make ARCH="${ARCH:-i386}" olddefconfig
