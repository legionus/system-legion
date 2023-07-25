CONFIGDIR = /usr/share/mkimage

GLOBAL_HSH_PROC = 1

include $(CONFIGDIR)/config.mk

OUTDIR=$(HOME)/sysimage/stateless
GLOBAL_WORKROOT=$(HOME)/tmp

# It's actually up to pack method whether to use the name or not,
# so we can use it as a prefix.
IMAGE_NAME = kernel-

MKI_HANDLER = $(CURDIR)/pack.sh
MKI_PACK_RESULTS = custom:$(IMAGE_NAME):$(MKI_HANDLER)

MAKE_INITRD_PACKAGES = \
	make-initrd \
	make-initrd-pipeline-stateless \
	make-initrd-ucode \
	#

KERNEL_PACKAGES_SET_1 = \
	kernel-image-centos \
	kernel-modules-alsa-centos \
	kernel-modules-drm-centos \
	kernel-modules-media-centos \
	kernel-modules-nvidia-open-centos \
	#

KERNEL_PACKAGES_SET_2 = \
	kernel-image-un-def \
	#

IMAGE_PACKAGES = \
	console-scripts strace \
	$(KERNEL_PACKAGES_SET_1) \
	$(MAKE_INITRD_PACKAGES)

INFO_MODALIAS = \
        pci:v000015B7d00005009sv000015B7sd00005009bc01sc08i02

include $(CONFIGDIR)/targets.mk

all: build-image run-image-scripts pack-image
