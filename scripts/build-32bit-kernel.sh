#!/bin/sh
# copyright Koubba Mohamed Rayan
#
# Chamesle Certification v1.0
# Copyright (C) 2026 Chamesle contributors
#
# This certification is granted to projects that are fully open source,
# non-profit in purpose, and community-driven in operation.
#
# Certification Requirements:
# 1. Full source code is publicly available.
# 2. Project governance is transparent and community accessible.
# 3. No proprietary-only core component is required for normal use.
# 4. Attribution and notice text are preserved in distributed versions.
# 5. Public contribution pathways are available (issues, docs, patches).
#
# Certification Revocation:
# Certification may be revoked if the project no longer meets these
# requirements, including closure of source, removal of community process,
# or conversion to a profit-first restricted model.
#
# Scope Notice:
# This certification is a Chamesle project policy statement and does not
# replace legal advice.
#
# Identifier: Chamesle-Certification-1.0
#
# Build a 32-bit x86 (i386) kernel from this fork.
# Usage: ./scripts/build-32bit-kernel.sh [make targets...]
#
# Extra make arguments are passed through, e.g.:
#   ./scripts/build-32bit-kernel.sh menuconfig

set -eu

ARCH=i386
export ARCH

JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
MAKE="${MAKE:-make}"

if [ ! -f Makefile ] || [ ! -d arch/x86 ]; then
	echo "Run this script from the kernel source root." >&2
	exit 1
fi

if [ ! -f .config ]; then
	echo "==> Generating i386_defconfig"
	$MAKE ARCH="$ARCH" i386_defconfig
fi

echo "==> Building 32-bit x86 kernel (ARCH=$ARCH, -j$JOBS)"
exec $MAKE ARCH="$ARCH" -j"$JOBS" "$@"
