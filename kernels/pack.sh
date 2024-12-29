#!/bin/sh -eu

modname=kmodules.star

print_path() {
	local prefix="$1"; shift
	local path="$1"; shift
	local name
	local size
	local checksum
	name="$(basename "$path")"
	size="$(stat -c %s "$path")"
	size="$(numfmt --to=iec-i --suffix=B "$size")"
	checksum="$(b2sum "$path" | cut -f1 -d' ')"

	echo "** $prefix: $name [$size] ($checksum)" >&2
}

pack_modules() {
	local outdir i moddir

	i="$1"; shift

	outdir="/.host/out/kernel-$i"
	mkdir -p -- "$outdir"

	moddir=lib/modules
	[ ! -L lib ] || moddir="$(readlink lib)/modules"

	tar --numeric-owner "$@" \
		--xattrs \
		-cf - "$moddir/$i" |
		sqfstar -b 1M -comp xz "$outdir/$modname"
}

pack_kernel() {
	local outdir i vmlinuz initrd flavour moddir

	i="$1"; shift
	vmlinuz="$1"; shift
	initrd="$1"; shift

	flavour=""

	if [ -z "${i##*-*}" ]; then
		flavour="${i%-*}"
		flavour="${flavour#*-}"
	fi

	echo packing kernel "$i" >&2

	outdir="/.host/out/kernel-$i"
	mkdir -p -- "$outdir"

	cp -f -- "$vmlinuz" "$outdir/vmlinuz-$i"
	cp -f -- "$initrd"  "$outdir/initrd-$i.img"

	if [ -n "$flavour" ]; then
		ln -snf vmlinuz-"$i"    "$outdir"/vmlinuz-"$flavour"
		ln -snf initrd-"$i".img "$outdir"/initrd-"$flavour".img
	fi
	ln -snf vmlinuz-"$i"    "$outdir"/vmlinuz
	ln -snf initrd-"$i".img "$outdir"/initrd.img

	pack_modules "$i" "$@"

	print_path kernel  "$outdir"/vmlinuz-"$i"
	print_path initrd  "$outdir"/initrd-"$i".img
	print_path modules "$outdir/$modname"
}

cd /.image

set --
if [ -s ./.SOURCE_DATE_EPOCH ]; then
	SOURCE_DATE_EPOCH="$(cat ./.SOURCE_DATE_EPOCH)"
	export SOURCE_DATE_EPOCH
	set -- --clamp-mtime --mtime=@"$SOURCE_DATE_EPOCH"
fi

found=

for i in boot/EFI/Linux/*.efi; do
	[ -e "$i" ] || continue

	n="${i##*/}"

	version="${n#*-}"
	version="${version%.efi}"

	outdir="/.host/out/kernel-$version"
	mkdir -p -- "$outdir"

	cp -f -- "$i" "$outdir/linux-$version.efi"
	pack_modules "$version" "$@"

	print_path "uefi stub" "$outdir/linux-$version.efi"
	print_path modules     "$outdir/$modname"

	found=1
done

[ -z "$found" ] ||
	exit 0

for i in /lib/modules/*; do
	[ -e "$i" ] || continue

	[ -e "$i/vmlinuz" ] ||
		continue

	version="${i##*/}"
	vmlinuz="$i/vmlinuz"

	pack_kernel "$version" "$vmlinuz" boot/initramfs-"$version".img "$@"
	found=1
done

[ -z "$found" ] ||
	exit 0

for cfg in boot/loader/entries/*.conf; do
	[ -f "$cfg" ] || continue

	version="$(sed -rn -e 's/^version[[:space:]]+//p' "$cfg")"
	vmlinuz="$(sed -rn -e 's/^linux[[:space:]]+//p' "$cfg")"

	pack_kernel "$version" "./$vmlinuz" boot/initramfs-"$version".img "$@"
	found=1
done

[ -z "$found" ] ||
	exit 0

for n in kernel vmlinuz; do
	for i in "boot/$n"-*; do
		[ -e "$i" ] || continue

		[ ! -L "$i" ] ||
		continue

		i="${i#boot/$n-}"

		pack_kernel "$i" boot/"$n-$i" boot/initramfs-"$i".img "$@"
		found=1
	done

	[ -z "$found" ] ||
		exit 0
done

if [ -z "$found" ]; then
	echo >&2 "ERROR: unable to find kernel and initramfs"
	exit 1
fi
