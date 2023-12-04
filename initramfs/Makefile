VENDOR = gentoo

CURDATE = $(shell date +%Y%m%d)

CACHEDIR = /sysimage/cache
OUTDIR = $(HOME)/sysimage/stateless

COMPRESS = zstd -19 -T0 -v
IMAGENAME = system-gentoo-$(CURDATE).star

IMAGE_VAR_ARCH    = amd64
IMAGE_VAR_VARIANT = systemd-mergedusr

IMAGE_VAR_OVERLAYS = \
	local:git:https://github.com/legionus/local-overlay

IMAGE_VAR_EMERGE_QUIET = true
IMAGE_VAR_EMERGE_JOBS = 3

IMAGE_PREFILES = $(CURDIR)/files
COPY_TREE = $(CURDIR)/files
BASEIMAGE_SCRIPT = $(CURDIR)/baseimage.sh
IMAGE_PACKAGES = $(CURDIR)/packages

INFO_MODALIAS = \
	pci:v000015B7d00005009sv000015B7sd00005009bc01sc08i02

PACK_IMAGE = $(CURDIR)/pack.sh

all: copy-tree build-image run-scripts pack-image

include $(HOME)/scm/sysimage/sysimage.mk
