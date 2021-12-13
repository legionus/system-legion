#!/bin/sh -eu

NAME="$(basename "$OUTNAME")"
mkdir -p "$OUTNAME"

cd /.image/"$SUBDIR"

args=
[ ! -d .in ]       || args="$args --exclude .in"
[ ! -d .host ]     || args="$args --exclude .host"
[ ! -f .fakedata ] || args="$args --exclude .fakedata"

if [ -n "${EXCLUDE:-}" ]; then
        for d in ${EXCLUDE:-}; do
                args="$args --exclude ${d#/}"
        done
fi

if [ -s .SOURCE_DATE_EPOCH ]; then
	SOURCE_DATE_EPOCH="$(cat .SOURCE_DATE_EPOCH)"
	args="$args --exclude .SOURCE_DATE_EPOCH"
	args="$args --clamp-mtime --mtime=@$SOURCE_DATE_EPOCH"
fi

tar --numeric-owner --exclude 'boot/*' $args \
	--zstd -cf "$OUTNAME"/rootfs.tar.zst .
cp ./boot/vmlinuz-* ./boot/initrd-* -t "$OUTNAME"/
cd "$OUTNAME"/

for i in vmlinuz-*; do
	i="${i#*-}"
	flavour="${i%-*}"
	flavour="${flavour#*-}"
	ln -sn vmlinuz-"$i" vmlinuz-"$flavour"
	ln -sn initrd-"$i".img initrd-"$flavour".img
done

print_path() {
	local prefix="$1"; shift
	local path="$1"; shift
	local name="$(basename "$path")"
	local OUTSIZE="$(ls -lh "$path" | cut -f5 -d' ')"
	local checksum="$(b2sum "$path" | cut -f1 -d' ')"

	echo "** $prefix: $name [$OUTSIZE] ($checksum)" >&2
}

print_path image "$OUTNAME"/rootfs.tar.zst
for f in "$OUTNAME"/vmlinuz-*; do
	[ ! -L "$f" ] || continue
	print_path kernel "$f"
done
for f in "$OUTNAME"/initrd-*; do
	[ ! -L "$f" ] || continue
	print_path initrd "$f"
done
