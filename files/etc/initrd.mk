AUTODETECT =
MOUNTPOINTS = /

MODULES_ADD += fs-ext4 fs-squashfs \
	pci:v000015B7d00005009sv000015B7sd00005009bc01sc08i02 \
	pci:v000010DEd00001E89sv00003842sd00002068bc03sc00i00

FEATURES += add-modules add-udev-rules cleanup compress rdshell rootfs \
	    system-glibc pipeline

COMPRESS = zstd
