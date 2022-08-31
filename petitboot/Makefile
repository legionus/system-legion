CONFIGDIR = /usr/share/mkimage

GLOBAL_HSH_PROC = 1

include $(CONFIGDIR)/config.mk

OUTDIR=$(HOME)/out
GLOBAL_WORKROOT=$(HOME)/tmp

DATE = $(shell date +%Y%m%d)
IMAGE_NAME = petitboot-$(DATE)

MKI_HANDLER = $(CURDIR)/pack.sh
MKI_PACK_RESULTS = custom:$(IMAGE_NAME):$(MKI_HANDLER)

IMAGE_PACKAGES = \
	console-scripts \
	cryptsetup \
	kernel-image-glebfm-stable \
	kernel-modules-drm-glebfm-stable \
	linux-firmware \
	make-initrd-devmapper \
	make-initrd-petitboot \
	make-initrd-ucode \
	strace \
	#

include $(CONFIGDIR)/targets.mk

all: build-image run-image-scripts pack-image
