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

IMAGE_PACKAGES = \
	console-scripts \
	kernel-image-centos \
	kernel-modules-alsa-centos \
	kernel-modules-drm-centos \
	kernel-modules-media-centos \
	kernel-modules-nvidia-open-centos \
	\
	make-initrd \
	make-initrd-pipeline-stateless \
	make-initrd-ucode \
	strace \
	#

include $(CONFIGDIR)/targets.mk

all: build-image run-image-scripts pack-image
