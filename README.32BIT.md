copyright Koubba Mohamed Rayan

Chamesle Certification v1.0
Copyright (C) 2026 Chamesle contributors

This certification is granted to projects that are fully open source,
non-profit in purpose, and community-driven in operation.

Certification Requirements:
1. Full source code is publicly available.
2. Project governance is transparent and community accessible.
3. No proprietary-only core component is required for normal use.
4. Attribution and notice text are preserved in distributed versions.
5. Public contribution pathways are available (issues, docs, patches).

Certification Revocation:
Certification may be revoked if the project no longer meets these
requirements, including closure of source, removal of community process,
or conversion to a profit-first restricted model.

Scope Notice:
This certification is a Chamesle project policy statement and does not
replace legal advice.

Identifier: Chamesle-Certification-1.0

# Linux Kernel — 32-bit Fork

This tree is a **32-bit-only** fork of the Linux kernel, maintained for systems
that still need 32-bit kernel support as upstream Linux phases it out.

## Supported architectures

| Architecture | Build command | Notes |
|---|---|---|
| **x86 (i386)** | `make ARCH=i386 defconfig && make ARCH=i386 -j$(nproc)` | Primary target; use `i386_defconfig` |
| **x86 embedded** | `make ARCH=i386 i386_embedded_defconfig && make ARCH=i386 -j$(nproc)` | Low-RAM industrial/IoT x86 |
| **x86 ultra-weak** | `i386_ultra_weak_defconfig` | 16–64 MB RAM, 486+ class |
| **x86 legacy** | `i386_legacy_defconfig` | Old PCs (PATA, NE2000, VESA fb) |
| **x86 server** | `i386_server_defconfig` | 32-bit SMP + PAE, RAID, bonding |
| **ARM embedded** | `make ARCH=arm linux32_embedded_defconfig && make ARCH=arm -j$(nproc)` | ARMv7 starting point (QEMU virt) |
| **ARM** | `make ARCH=arm <board>_defconfig && make ARCH=arm -j$(nproc)` | 32-bit ARM only (`arch/arm/`) |
| **MIPS** | `make ARCH=mips <board>_defconfig && make ARCH=mips -j$(nproc)` | 64-bit MIPS builds disabled |
| **PowerPC** | `make ARCH=powerpc <board>_defconfig && make ARCH=powerpc -j$(nproc)` | PPC32 only |
| **SPARC** | `make ARCH=sparc32 defconfig && make ARCH=sparc32 -j$(nproc)` | SPARC32 only |
| **RISC-V** | `make ARCH=riscv defconfig && make ARCH=riscv -j$(nproc)` | RV32I only (enable `NONPORTABLE` in menuconfig) |
| m68k, sh, microblaze, nios2, csky, arc, hexagon, openrisc, xtensa, parisc, um | Standard upstream build flow | Already 32-bit native |

## Removed architectures (64-bit only)

These upstream architecture trees are **not present** in this fork:

- `arm64` (AArch64)
- `alpha`
- `loongarch`
- `s390`

Attempting `make ARCH=arm64` (or the other removed arches) will fail with an
explicit error.

## Quick start — x86 32-bit

```bash
# From the kernel source root
make ARCH=i386 i386_defconfig
make ARCH=i386 -j$(nproc)

# Or use the helper script (Linux/WSL)
./scripts/build-32bit-kernel.sh
```

## Embedded / IoT builds

This fork adds configs tuned for **low RAM**, **flash storage**, and **headless** 32-bit
targets (serial console, MTD/SPI NOR, SquashFS/JFFS2/UBIFS, smaller log buffer,
100 Hz tick, CMA for DMA).

**x86 embedded (Geode, Vortex86, industrial PC):**

```bash
make ARCH=i386 i386_embedded_defconfig
make ARCH=i386 -j$(nproc)
# or
./scripts/build-embedded-32bit-kernel.sh
```

**ARM 32-bit embedded (starting point — pick your SoC in menuconfig):**

```bash
make ARCH=arm linux32_embedded_defconfig
make ARCH=arm -j$(nproc)
# or
./scripts/build-embedded-32bit-kernel.sh arm
```

**Merge embedded options into an existing board config:**

```bash
make ARCH=arm your_board_defconfig
./scripts/kconfig/merge_config.sh -m .config kernel/configs/linux32-embedded.config
make ARCH=arm olddefconfig
make ARCH=arm -j$(nproc)
```

Enable `CONFIG_LINUX32_EMBEDDED` in menuconfig (*General setup*) to mark an embedded profile.

## Linux32 tool — embedded without Buildroot/Yocto

One script builds **kernel + busybox rootfs + QEMU boot**:

```bash
./scripts/linux32 profiles          # list: ultra-weak, legacy, embedded, server, embedded-arm
./scripts/linux32 run embedded        # full pipeline: config, build, rootfs, qemu
./scripts/linux32 image server        # kernel + initramfs in output/linux32/server/
./scripts/linux32 rootfs ultra-weak   # only the minimal rootfs cpio
```

Requires WSL/Linux: `build-essential`, `gcc-multilib`, `busybox-static` (or auto-download).

On a 64-bit host you need a cross-compiler or multilib toolchain:

```bash
# Debian/Ubuntu
sudo apt-get install gcc-multilib libc6-dev-i386

# Build with explicit 32-bit flags
make ARCH=i386 CROSS_COMPILE=i686-linux-gnu- i386_defconfig
make ARCH=i386 CROSS_COMPILE=i686-linux-gnu- -j$(nproc)
```

## What changed from upstream

1. **Removed** `arch/arm64`, `arch/alpha`, `arch/loongarch`, `arch/s390`
2. **Forced 32-bit** in dual-mode architectures: x86, MIPS, PowerPC, SPARC, RISC-V
3. **Removed** `x86_64_defconfig` and `sparc64_defconfig`
4. **Version suffix** set to `-32bit` in the top-level Makefile (`EXTRAVERSION`)
5. **Build guards** reject `ARCH=x86_64`, `ARCH=sparc64`, and removed architectures
6. **Embedded profile** — `i386_embedded_defconfig`, `linux32_embedded_defconfig` (ARM),
   and `kernel/configs/linux32-embedded.config` merge fragment

## Fork maintenance notes

- Upstream driver/Kconfig code may still contain `depends on ARM64` or similar
  symbols; these options are simply unavailable without the arm64 architecture.
- Merging from upstream: expect conflicts in `arch/x86/Kconfig`, `arch/mips/Kconfig`,
  and files under removed `arch/` trees. Re-apply the 32-bit-only Kconfig changes
  after each merge.
- CI should build at least `ARCH=i386` and one embedded target (e.g. `ARCH=arm`).

## Kernel version string

Built kernels report a version like `7.1.0-32bit` instead of the upstream
`-rc` suffix.
