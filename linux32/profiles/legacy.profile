# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
# Linux32 profile: legacy (1990s–2000s PCs, PATA, classic NICs)

PROFILE_ID=legacy
PROFILE_DESC="Old desktops and laptops (PIII, early Pentium 4, VIA)"
ARCH=i386
DEFCONFIG=i386_legacy_defconfig
FRAGMENTS="embedded"
ROOTFS_MIN_MB=128
KERNEL_CMDLINE="console=ttyS0,115200 init=/init"
QEMU_MEM=256M
QEMU_MACHINE=pc
ENABLE_MODULES=1
