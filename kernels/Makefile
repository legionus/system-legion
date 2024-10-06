include $(CURDIR)/../Makefile.common

SYSIMAGE_TAG_PREFIX = kernels

INSTRUMENTAL_FILES = $(CURDIR)/instrumental-files
INSTRUMENTAL_PACKAGES2 = sys-fs/squashfs-tools

IMAGE_PACKAGES = $(CURDIR)/packages

INFO_MODALIAS = \
	pci:v000015B7d00005009sv000015B7sd00005009bc01sc08i02 \
	pci:v000010DEd00001E89sv00003842sd00002068bc03sc00i00

PACK_IMAGE = $(CURDIR)/pack.sh

all: copy-tree build-image run-scripts pack-image

include $(HOME)/scm/sysimage/sysimage.mk
