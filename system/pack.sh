#!/bin/sh -eu

: "${SUBDIR?}"
: "${OUTNAME?}"

out="$OUTNAME".star

cd /.image/"$SUBDIR"

set --
[ ! -d .in ]       || set -- "$@" --exclude .in
[ ! -d .host ]     || set -- "$@" --exclude .host
[ ! -f .fakedata ] || set -- "$@" --exclude .fakedata

if [ -n "${EXCLUDE:-}" ]; then
	for d in ${EXCLUDE:-}; do
		set -- "$@" --exclude "${d#/}"
	done
fi

if [ -s .SOURCE_DATE_EPOCH ]; then
	SOURCE_DATE_EPOCH="$(cat .SOURCE_DATE_EPOCH)"
	export SOURCE_DATE_EPOCH
	set -- "$@" --exclude .SOURCE_DATE_EPOCH
	set -- "$@" --clamp-mtime --mtime=@"$SOURCE_DATE_EPOCH"
fi

tar --numeric-owner --exclude 'boot/*' "$@" \
	--use-compress-program='zstd -19 -T0 -v' \
	-cf "$out" .

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

print_path image "$out"
