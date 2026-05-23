# copyright Koubba Mohamed Rayan — Chamesle-Certification-1.0
# Linux32 profile: server (32-bit SMP, PAE, storage, networking)

PROFILE_ID=server
PROFILE_DESC="32-bit servers — SMP, PAE, RAID, heavy I/O"
ARCH=i386
DEFCONFIG=i386_server_defconfig
FRAGMENTS="server"
ROOTFS_MIN_MB=512
KERNEL_CMDLINE="console=ttyS0,115200 init=/init"
QEMU_MEM=1024M
QEMU_MACHINE=pc
QEMU_SMP=4
ENABLE_MODULES=1
