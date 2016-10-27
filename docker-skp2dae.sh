#!/bin/bash
VOL="$1"
[ -z "$VOL" ] && VOL="$PWD/filestoconvert"
[ "${VOL#/}" == "$VOL" ] && VOL="$PWD/$VOL"
shift
#docker build -t skp-converter .
for FILE in "$@"; do
	timelimit -p -T500 -t240 docker run --rm --volume "$VOL":/home/sketchup/filestoconvert --user sketchup skp-converter "$FILE"
done

