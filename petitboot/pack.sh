#!/bin/sh -eu

NAME="$(basename "$OUTNAME")"
mkdir -p "$OUTNAME"

cd /.image/"$SUBDIR"

cp ./boot/vmlinuz-* ./boot/initrd-* -t "$OUTNAME"/
cd "$OUTNAME"/
ln -sn vmlinuz-* vmlinuz
ln -sn initrd-* initrd.img

print_path() {
	local prefix="$1"; shift
	local path="$1"; shift
	local name="$(basename "$path")"
	local OUTSIZE="$(ls -lh "$path" | cut -f5 -d' ')"

	echo "** $prefix: $name [$OUTSIZE]" >&2
}

print_path kernel "$OUTNAME"/vmlinuz-*
print_path initrd "$OUTNAME"/initrd-*
