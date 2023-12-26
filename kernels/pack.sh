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

cd /.image

set --
if [ -s ./.SOURCE_DATE_EPOCH ]; then
	SOURCE_DATE_EPOCH="$(cat ./.SOURCE_DATE_EPOCH)"
	export SOURCE_DATE_EPOCH
	set -- --clamp-mtime --mtime=@"$SOURCE_DATE_EPOCH"
fi

for i in boot/vmlinuz-*; do
	if [ ! -e "$i" ]; then
		echo >&2 "ERROR: unable to find /boot/vmlinuz-<KVER>"
		exit 1
	fi

	[ ! -L "$i" ] ||
		continue

	i="${i#boot/vmlinuz-}"
	flavour=""

	if [ -z "${i##*-*}" ]; then
		flavour="${i%-*}"
		flavour="${flavour#*-}"
	fi

	echo packing kernel "$i" >&2

	outdir="/.host/out/kernel-$i"
	mkdir -p -- "$outdir"

	cp -t "$outdir" boot/vmlinuz-"$i"
	cp -t "$outdir" boot/initrd-"$i".img

	if [ -n "$flavour" ]; then
		ln -snf vmlinuz-"$i"    "$outdir"/vmlinuz-"$flavour"
		ln -snf initrd-"$i".img "$outdir"/initrd-"$flavour".img
	fi
	ln -snf vmlinuz-"$i"    "$outdir"/vmlinuz
	ln -snf initrd-"$i".img "$outdir"/initrd.img

	tar --numeric-owner "$@" \
		--xattrs \
		-cf - lib/modules/"$i" |
		sqfstar -b 1M -comp xz "$outdir/$modname"

	print_path kernel "$outdir"/vmlinuz-"$i"
	print_path initrd "$outdir"/initrd-"$i".img
	print_path modules "$outdir/$modname"
done
