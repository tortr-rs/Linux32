# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
# Linux32 profile: embedded (IoT, industrial, headless)

PROFILE_ID=embedded
PROFILE_DESC="Embedded and industrial 32-bit systems"
ARCH=i386
DEFCONFIG=i386_embedded_defconfig
FRAGMENTS="embedded"
ROOTFS_MIN_MB=64
KERNEL_CMDLINE="console=ttyS0,115200 init=/init"
QEMU_MEM=256M
QEMU_MACHINE=pc
ENABLE_MODULES=1
