export GLOBAL_VERBOSE=1
export CLEANUP_OUTDIR=1

OUTDIR=$(CURDIR)/out
CONFIGDIR = /usr/share/mkimage

GLOBAL_HSH_PROC = 1

include $(CONFIGDIR)/config.mk

GLOBAL_WORKROOT=$(HOME)/tmp

IMAGE_NAME = kickstart

IMAGE_PACKAGES = ./packages

COPY_TREE = $(CURDIR)/files

PACKAGES_REQUIRED_PACK_CUSTOM = e2fsprogs
MKI_HANDLER = $(CURDIR)/pack.sh
EXCLUDES=!/proc
MKI_PACK_RESULTS = custom:$(IMAGE_NAME):$(MKI_HANDLER):$(EXCLUDES)

include $(CONFIGDIR)/targets.mk

all: build-image copy-tree run-image-scripts pack-image
