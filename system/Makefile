CONFIGDIR = /usr/share/mkimage

# This should happen in a separate mkimage profile.
# Needed for new make-initrd versions.
GLOBAL_HSH_PROC = 1

include $(CONFIGDIR)/config.mk

include $(CURDIR)/run-image-patches.mk

OUTDIR=$(HOME)/out
GLOBAL_WORKROOT=$(HOME)/tmp

COPY_TREE = $(CURDIR)/files

DATE = $(shell date +%Y%m%d)
IMAGE_NAME = system-$(DATE)

MKI_HANDLER = $(CURDIR)/pack.sh
EXCLUDES=!/proc
MKI_PACK_RESULTS = custom:$(IMAGE_NAME):$(MKI_HANDLER):$(EXCLUDES)

IMAGE_PACKAGES = ./packages

include $(CONFIGDIR)/targets.mk

all: build-image copy-tree run-image-patches run-image-scripts pack-image
