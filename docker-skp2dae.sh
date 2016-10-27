#!/bin/bash
VOL="$1"
[ -z "$VOL" ] && VOL="$PWD/filestoconvert"
[ "${VOL#/}" == "$VOL" ] && VOL="$PWD/$VOL"
if [ $# -gt 1 ]; then
	shift
elif [ $# -eq 1 ]; then
	[ -f "$VOL" ] && VOL="$(dirname "$VOL")"
else
	echo "Usage:" >&2
	echo "	$0   FILE-AS-SEEN-FROM-HOST" >&2
	echo "	$0   DIRECTORY-TO-SHARE-WITH-THE-CONTAINER   FILES-AS-SEEN-FROM-CONTAINER..." >&2
	echo "Inside the container, the shared directory is /home/sketchup/filestoconvert" >&2
	exit 1
fi
#docker build -t skp-converter .
for FILE in "$@"; do
	timelimit -p -T500 -t240 docker run --rm --volume "$VOL":/home/sketchup/filestoconvert --user sketchup skp-converter "$FILE"
done

