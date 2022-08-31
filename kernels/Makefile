CONFIGDIR = /usr/share/mkimage

GLOBAL_HSH_PROC = 1

include $(CONFIGDIR)/config.mk

OUTDIR=$(HOME)/out
GLOBAL_WORKROOT=$(HOME)/tmp

# It's actually up to pack method whether to use the name or not,
# so we can use it as a prefix.
IMAGE_NAME = kernel-

MKI_HANDLER = $(CURDIR)/pack.sh
MKI_PACK_RESULTS = custom:$(IMAGE_NAME):$(MKI_HANDLER)

IMAGE_PACKAGES = \
	console-scripts \
	kernel-image-glebfm-stable \
	kernel-image-un-def \
	kernel-modules-drm-glebfm-stable \
	kernel-modules-drm-un-def \
	make-initrd-luks \
	make-initrd-pipeline-stateless \
	make-initrd-ucode \
	strace \
	#

include $(CONFIGDIR)/targets.mk

all: build-image run-image-scripts pack-image
