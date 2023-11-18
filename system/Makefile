VENDOR = altlinux

CURDATE = $(shell date +%Y%m%d)

CACHEDIR = $(HOME)/sysimage/cache
OUTDIR = $(HOME)/sysimage/stateless

COMPRESS = zstd -19 -T0 -v
IMAGENAME = system-$(CURDATE).star

INSTRUMENTAL_FILES = $(CURDIR)/basefiles
INSTRUMENTAL_PACKAGES = apt-https ca-certificates

IMAGE_PACKAGES = $(CURDIR)/packages
IMAGE_PREFILES = $(CURDIR)/image-predb-files

COPY_TREE = $(CURDIR)/files

INFO_DATE        = $(CURDATE)
INFO_DIST_VENDOR = ALT
INFO_DIST_REPO   = Sisyphus

INFO_USER_CREATE = legion lkp
INFO_USER_UID_legion = 1000
INFO_USER_GID_legion = 1000
INFO_USER_GROUPS_legion = users,netadmin,proc,uucp,vmusers,wheel,xgrp,fuse,input,audio,video
INFO_USER_SHELL_legion = /bin/bash
INFO_USER_HASHER_legion = true

INFO_TIME_ZONE = Europe/Prague

INFO_SYSV_ENABLE_SERVICES = \
	acpid         \
	anacron       \
	apparmor      \
	chronyd       \
	consolelocker \
	consolesaver  \
	crond         \
	fbsetfont     \
	hasher-privd  \
	keytable      \
	kheaders      \
	klogd         \
	messagebus    \
	netfs         \
	network       \
	nscd          \
	random        \
	rpcbind       \
	seatd         \
	sshd          \
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
	fusermount:fuseonly         \
	gpasswd:wheelonly           \
	groupmems:wheelonly         \
	mount:unprivileged          \
	newgidmap:wheelonly         \
	newgrp:restricted           \
	newuidmap:wheelonly         \
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

INFO_ALTERNATIVES = \
	/usr/bin/bogofilter:/usr/bin/bogofilter-sqlite        \
	/usr/bin/links:/usr/bin/elinks                        \
	/usr/bin/vim:/usr/bin/vim-enhanced                    \
	/usr/lib64/libnssckbi.so:/usr/lib64/nss/libnssckbi.so \
	$(NULL)

#INFO_SYSTEMD_ENABLE_SERVICES = \
#	chronyd consolelocker getty@tty1 getty@tty2 getty@tty3 gpm hasher-privd \
#	powertop rsyncd.socket sshd sysfs

#INFO_SYSTEMD_MASK_SERVICES = \
#	altlinux-openresolv altlinux-openresolv.path altlinux-simpleresolv \
#	altlinux-simpleresolv.path geoclue lvm2-monitor systemd-binfmt wpa_supplicant

#INFO_SYATEMD_DEFAULT_TARGET = multi-user.target

all: build-image copy-tree apply-patches run-scripts pack-image
#all: build-image apply-patches

include $(HOME)/scm/sysimage/sysimage.mk
