CONFIGDIR = /usr/share/mkimage

include $(CONFIGDIR)/config.mk

NULL :=

INFO_USER_CREATE = legion lkp
INFO_USER_UID_legion = 500
INFO_USER_GID_legion = 500
INFO_USER_GROUPS_legion = users,netadmin,proc,uucp,vmusers,wheel,xgrp
INFO_USER_SHELL_legion = /bin/bash
INFO_USER_HASHER_legion = true

INFO_TIME_ZONE = Europe/Prague

INFO_SYSV_ENABLE_SERVICES = \
	acpid         \
	anacron       \
	chronyd       \
	consolelocker \
	consolesaver  \
	crond         \
	fbsetfont     \
	hasher-privd  \
	keytable      \
	kheaders      \
	klogd         \
	netfs         \
	network       \
	random        \
	rpcbind       \
	seatd         \
	sshd          \
	sysfs         \
	syslogd       \
	udevd         \
	udevd-final   \
	$(NULL)

INFO_CONTROL_STATES = \
	at:restricted               \
	chrony:client               \
	consolehelper:public        \
	crontab:public              \
	cups:server                 \
	fusermount:restricted       \
	gpasswd:restricted          \
	groupmems:restricted        \
	mount:unprivileged          \
	newgidmap:restricted        \
	newgrp:restricted           \
	newuidmap:restricted        \
	pam_access:disabled         \
	pam_mktemp:enabled          \
	passwd:tcb                  \
	passwdqc-enforce:everyone   \
	ping:netadmin               \
	rpcbind:local               \
	sftp:disabled               \
	sshd-allow-groups:enabled   \
	sshd-password-auth:disabled \
	su:restricted               \
	system-auth:local           \
	system-policy:local         \
	tcb_chkpwd:tcb              \
	write:restricted            \
	xdg-user-dirs:enabled       \
	$(NULL)

#INFO_SYSTEMD_ENABLE_SERVICES = \
#	chronyd consolelocker getty@tty1 getty@tty2 getty@tty3 gpm hasher-privd \
#	powertop rsyncd.socket sshd sysfs

#INFO_SYSTEMD_MASK_SERVICES = \
#	altlinux-openresolv altlinux-openresolv.path altlinux-simpleresolv \
#	altlinux-simpleresolv.path geoclue lvm2-monitor systemd-binfmt wpa_supplicant

#INFO_SYATEMD_DEFAULT_TARGET = multi-user.target

include $(CURDIR)/run-image-patches.mk

OUTDIR=$(HOME)/sysimage/stateless
GLOBAL_WORKROOT=$(HOME)/tmp

COPY_TREE = $(CURDIR)/files

DATE = $(shell date +%Y%m%d)
IMAGE_NAME = system-$(DATE)

MKI_HANDLER = $(CURDIR)/pack.sh
EXCLUDES=!/proc/*
MKI_PACK_RESULTS = custom:$(IMAGE_NAME):$(MKI_HANDLER):$(EXCLUDES)

IMAGE_PACKAGES = $(CURDIR)/packages

include $(CONFIGDIR)/targets.mk

all: build-image copy-tree run-image-patches run-image-scripts pack-image
