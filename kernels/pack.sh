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

	moddir=lib/modules
	[ ! -L lib ] || moddir="$(readlink lib)/modules"

	tar --numeric-owner "$@" \
		--xattrs \
		-cf - "$moddir/$i" |
		sqfstar -b 1M -comp xz "$outdir/$modname"

	print_path kernel "$outdir"/vmlinuz-"$i"
	print_path initrd "$outdir"/initrd-"$i".img
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

for cfg in boot/loader/entries/*.conf; do
	[ -f "$cfg" ] || continue

	version="$(sed -rn -e 's/^version[[:space:]]+//p' "$cfg")"
	vmlinuz="$(sed -rn -e 's/^linux[[:space:]]+//p' "$cfg")"

	pack_kernel "$version" "./$vmlinuz" boot/initrd-"$version".img "$@"
	found=1
done

for i in boot/kernel-*; do
	[ -e "$i" ] || continue

	[ ! -L "$i" ] ||
		continue

	i="${i#boot/kernel-}"

	pack_kernel "$i" boot/kernel-"$i" boot/initrd-"$i".img "$@"
	found=1
done

for i in boot/vmlinuz-*; do
	[ -e "$i" ] || continue

	[ ! -L "$i" ] ||
		continue

	i="${i#boot/vmlinuz-}"

	pack_kernel "$i" boot/vmlinuz-"$i" boot/initrd-"$i".img "$@"
	found=1
done

if [ -z "$found" ]; then
	echo >&2 "ERROR: unable to find kernel and initramfs"
	exit 1
fi
