#!/bin/sh
# CC0
# original script by Jan Suchotzki <jan@suchotzki.de>
# from https://github.com/suchja/wix-toolset/blob/master/waitonprocess.sh
# inspired by http://stackoverflow.com/a/10407912

[ $# -lt 2 ] && echo "Usage: $0 USER PROCESS-NAMES..." >&2 && exit 1
USER="$1"
shift
echo "Started waiting for $@"
while pgrep -u "$USER" "$@" > /dev/null; do 
		echo "waiting ..."
		sleep 1; 
done
echo "$@ completed"

