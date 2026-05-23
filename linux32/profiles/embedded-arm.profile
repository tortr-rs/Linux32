# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
# Linux32 profile: ARM embedded (32-bit)

PROFILE_ID=embedded-arm
PROFILE_DESC="ARMv7 embedded (QEMU virt / tune for your SoC)"
ARCH=arm
DEFCONFIG=linux32_embedded_defconfig
FRAGMENTS="embedded"
ROOTFS_MIN_MB=64
KERNEL_CMDLINE="console=ttyAMA0 init=/init"
QEMU_MEM=256M
QEMU_MACHINE=virt
QEMU_CPU=max
ENABLE_MODULES=1
