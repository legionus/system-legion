#!/bin/sh -eu

: "${SUBDIR?}"
: "${OUTNAME?}"

modname=kmodules.star

cd /.image/"$SUBDIR"

set --
if [ -s .SOURCE_DATE_EPOCH ]; then
	SOURCE_DATE_EPOCH="$(cat .SOURCE_DATE_EPOCH)"
	export SOURCE_DATE_EPOCH
	set -- --clamp-mtime --mtime=@"$SOURCE_DATE_EPOCH"
fi

for i in boot/vmlinuz-*; do
	i="${i#boot/vmlinuz-}"
	flavour="${i%-*}"
	flavour="${flavour#*-}"
	echo packing kernel "$i" >&2
	outdir="$OUTNAME$i"
	mkdir -p "$outdir"

	cp ./boot/vmlinuz-"$i" -t "$outdir"
	cp ./boot/initrd-"$i".img -t "$outdir"
	ln -sn vmlinuz-"$i" "$outdir"/vmlinuz-"$flavour"
	ln -sn vmlinuz-"$i" "$outdir"/vmlinuz
	ln -sn initrd-"$i".img "$outdir"/initrd-"$flavour".img
	ln -sn initrd-"$i".img "$outdir"/initrd.img

	tar --numeric-owner "$@" \
		--xattrs \
		--use-compress-program='zstd -19 -T0 -v' \
		-cf "$outdir/$modname" lib/modules/"$i"
done

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

for i in boot/vmlinuz-*; do
	i="${i#boot/vmlinuz-}"
	outdir="$OUTNAME$i"
	print_path kernel "$outdir"/vmlinuz-"$i"
	print_path initrd "$outdir"/initrd-"$i".img
	print_path modules "$outdir/$modname"
done
