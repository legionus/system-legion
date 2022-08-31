#!/bin/sh -eu

out="$OUTNAME".tar.zst

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
	export SOURCE_DATE_EPOCH="$(cat .SOURCE_DATE_EPOCH)"
	args="$args --exclude .SOURCE_DATE_EPOCH"
	args="$args --clamp-mtime --mtime=@$SOURCE_DATE_EPOCH"
fi

tar --numeric-owner --exclude 'boot/*' $args \
	--use-compress-program='zstd -19 -T0 -v' \
	-cf "$out" .

print_path() {
	local prefix="$1"; shift
	local path="$1"; shift
	local name="$(basename "$path")"
	local OUTSIZE="$(ls -lh "$path" | cut -f5 -d' ')"
	local checksum="$(b2sum "$path" | cut -f1 -d' ')"

	echo "** $prefix: $name [$OUTSIZE] ($checksum)" >&2
}

print_path image "$out"
