AUTODETECT =
MOUNTPOINTS = /

MODULES_ADD += fs-ext4 fs-squashfs

# nvme root device
MODULES_ADD += pci:v000015B7d00005009sv000015B7sd00005009bc01sc08i02

COMPRESS = zstd

UKI = 1
UKI_FEATURES = \
	add-modules add-udev-rules cleanup compress rdshell rootfs system-glibc \
	modules-blockdev \
	modules-filesystem \
	pipeline

UKI_CMDLINE = \
	ro panic=30 rdlog=console \
	root=pipeline \
	pipeline=waitdev,mountfs,mountfs,mountfs,mountfs,overlayfs,rootfs \
	waitdev=LABEL=ROOT \
	mountfs=dev \
	mountfs=pipe1/sysimage/stateless/local-latest.star \
	mountfs=pipe1/sysimage/stateless/kernel-$(KERNEL)/kmodules.star \
	mountfs=pipe1/sysimage/stateless/system-stable.star \
	overlayfs=pipe2,pipe3,pipe4
