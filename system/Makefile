VENDOR = gentoo

CURDATE = $(shell date +%Y%m%d)

#CACHEDIR = $(HOME)/sysimage/cache

CACHEDIR = /sysimage/cache
OUTDIR = $(HOME)/sysimage/stateless

COMPRESS = zstd -19 -T0 -v
IMAGENAME = system-gentoo-$(CURDATE).star

IMAGE_VAR_ARCH    = amd64
IMAGE_VAR_VARIANT = systemd-mergedusr

IMAGE_VAR_OVERLAYS = \
	local:git:https://github.com/legionus/local-overlay

IMAGE_VAR_EMERGE_JOBS = 3

IMAGE_PREFILES = $(CURDIR)/files
COPY_TREE = $(CURDIR)/files
BASEIMAGE_SCRIPT = $(CURDIR)/baseimage.sh
IMAGE_PACKAGES = $(CURDIR)/packages

INFO_USER_CREATE = legion
INFO_USER_UID_legion = 1000
INFO_USER_GID_legion = 1000
INFO_USER_GROUPS_legion = users,uucp,wheel,input,audio,video,kvm,pipewire
INFO_USER_SHELL_legion = /bin/bash

INFO_TIME_ZONE = Europe/Prague

INFO_SYSTEMD_ENABLE_SERVICES = \
	getty@tty1 getty@tty2 getty@tty3 sshd upower \
	systemd-networkd systemd-resolved systemd-timesyncd

#INFO_SYSTEMD_MASK_SERVICES = \
#	altlinux-openresolv altlinux-openresolv.path altlinux-simpleresolv \
#	altlinux-simpleresolv.path geoclue lvm2-monitor systemd-binfmt wpa_supplicant

INFO_SYATEMD_DEFAULT_TARGET = multi-user.target

all: copy-tree build-image apply-patches run-scripts pack-image
#all: build-image apply-patches

include $(HOME)/scm/sysimage/sysimage.mk
