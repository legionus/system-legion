include $(CURDIR)/../Makefile.common

SYSIMAGE_TAG_PREFIX = system

IMAGENAME = system-gentoo-$(CURDATE).star

INSTRUMENTAL_FILES = $(CURDIR)/instrumental-files
INSTRUMENTAL_PACKAGES2 = sys-fs/squashfs-tools

IMAGE_PACKAGES = $(CURDIR)/packages

INFO_USER_CREATE = legion
INFO_USER_UID_legion = 1000
INFO_USER_GID_legion = 1000
INFO_USER_GROUPS_legion = users,wheel,input,audio,video,kvm,pipewire
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
