# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
# Linux32 profile: ultra-weak (16–64 MB RAM, 486/Pentium class, initramfs-only)

PROFILE_ID=ultra-weak
PROFILE_DESC="Extremely weak/old hardware, minimal RAM"
ARCH=i386
DEFCONFIG=i386_ultra_weak_defconfig
FRAGMENTS="embedded tiny"
ROOTFS_MIN_MB=16
KERNEL_CMDLINE="console=ttyS0,115200 init=/init loglevel=4"
QEMU_MEM=32M
QEMU_MACHINE=pc
ENABLE_MODULES=0
