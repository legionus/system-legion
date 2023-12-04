include $(CURDIR)/../Makefile.common

IMAGE_PACKAGES = $(CURDIR)/packages

INFO_MODALIAS = \
	pci:v000015B7d00005009sv000015B7sd00005009bc01sc08i02

PACK_IMAGE = $(CURDIR)/pack.sh

all: copy-tree build-image run-scripts pack-image

include $(HOME)/scm/sysimage/sysimage.mk
