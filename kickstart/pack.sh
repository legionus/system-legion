#!/bin/sh -eux

NAME="$(basename "$OUTNAME")"
mkdir -p "$OUTNAME"

cd /.image/"$SUBDIR"

cp ./boot/vmlinuz-* ./boot/initrd-* -t "$OUTNAME"/
cd "$OUTNAME"/

for i in vmlinuz-*; do
	i="${i#*-}"
	flavour="${i%-*}"
	flavour="${flavour#*-}"
	ln -sn vmlinuz-"$i" vmlinuz-"$flavour"
	ln -sn vmlinuz-"$i" vmlinuz
	ln -sn initrd-"$i".img initrd-"$flavour".img
	ln -sn initrd-"$i".img initrd.img
done

print_path() {
	local prefix="$1"; shift
	local path="$1"; shift
	local name="$(basename "$path")"
	local OUTSIZE="$(ls -lh "$path" | cut -f5 -d' ')"
	local checksum="$(b2sum "$path" | cut -f1 -d' ')"

	echo "** $prefix: $name [$OUTSIZE] ($checksum)" >&2
}

for f in "$OUTNAME"/vmlinuz-*; do
	[ ! -L "$f" ] || continue
	print_path kernel "$f"
done
for f in "$OUTNAME"/initrd-*; do
	[ ! -L "$f" ] || continue
	print_path initrd "$f"
done
