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
if [ -s /.image/.SOURCE_DATE_EPOCH ]; then
	SOURCE_DATE_EPOCH="$(cat /.image/.SOURCE_DATE_EPOCH)"
	export SOURCE_DATE_EPOCH
	set -- --clamp-mtime --mtime=@"$SOURCE_DATE_EPOCH"
fi

for i in boot/vmlinuz-*; do
	i="${i#boot/vmlinuz-}"

	flavour="${i%-*}"
	flavour="${flavour#*-}"

	echo packing kernel "$i" >&2

	outdir="/.host/out/kernel-$i"
	mkdir -p -- "$outdir"

	cp ./boot/vmlinuz-"$i" -t "$outdir"
	cp ./boot/initrd-"$i".img -t "$outdir"

	ln -snf vmlinuz-"$i" "$outdir"/vmlinuz-"$flavour"
	ln -snf vmlinuz-"$i" "$outdir"/vmlinuz
	ln -snf initrd-"$i".img "$outdir"/initrd-"$flavour".img
	ln -snf initrd-"$i".img "$outdir"/initrd.img

	tar --numeric-owner "$@" \
		--xattrs \
		--use-compress-program='zstd -19 -T0 -v' \
		-cf "$outdir/$modname" lib/modules/"$i"

	print_path kernel "$outdir"/vmlinuz-"$i"
	print_path initrd "$outdir"/initrd-"$i".img
	print_path modules "$outdir/$modname"
done
