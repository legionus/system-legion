VENDOR = altlinux

CACHEDIR = $(HOME)/sysimage/cache
OUTDIR = $(HOME)/sysimage/stateless

BASEIMAGE_FILES = $(CURDIR)/basefiles
BASEIMAGE_PACKAGES = apt-https ca-certificates

IMAGE_PACKAGES = $(CURDIR)/packages

PACK_IMAGE = $(CURDIR)/pack.sh

all: build-image run-scripts pack-image

include $(HOME)/scm/sysimage/sysimage.mk
