#!/bin/bash
VOL="$1"
[ -z "$VOL" ] && VOL="$PWD/filestoconvert"
[ "${VOL#/}" == "$VOL" ] && VOL="$PWD/$VOL"
if [ $# -gt 1 ]; then
	shift
else
	[ -f "$VOL" ] && VOL="$(dirname "$VOL")"
fi
#docker build -t skp-converter .
for FILE in "$@"; do
	timelimit -p -T500 -t240 docker run --rm --volume "$VOL":/home/sketchup/filestoconvert --user sketchup skp-converter "$FILE"
done

