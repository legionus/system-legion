include $(CURDIR)/../Makefile.common

SYSIMAGE_TAG_PREFIX = emerge
IMAGE_PACKAGES = /dev/null

all: local-prepare update-repos

local-prepare: copy-tree run-scripts

include $(HOME)/scm/sysimage/sysimage.mk

