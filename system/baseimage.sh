#!/bin/bash -efu

set -x

export PKGDIR=/.host/cache/binpkgs
export DISTDIR=/.host/cache/distfiles
export FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox"

# https://wiki.gentoo.org/wiki/EMERGE_DEFAULT_OPTS
[ -z "${IMAGE_VAR_EMERGE_DEFAULT_OPTS-}" ] ||
	export EMERGE_DEFAULT_OPTS="$IMAGE_VAR_EMERGE_DEFAULT_OPTS"

# https://devmanual.gentoo.org/eclass-reference/linux-info.eclass/index.html
[ -z "${IMAGE_VAR_SKIP_KERNEL_CHECK-}" ] ||
	export SKIP_KERNEL_CHECK=1

emerge-webrsync

emerge --ask=n app-portage/getuto
getuto

[ ! -d "$PKGDIR" ] ||
	emaint binhost --fix

# https://wiki.gentoo.org/wiki/Binary_package_guide
emerge --ask=n --depclean

# emerge --update --newuse --deep @world
emerge --ask=n --usepkg=y --buildpkg=y --rebuilt-binaries=y --binpkg-respect-use=y --emptytree @world