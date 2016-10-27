#!/bin/bash -x
IMPORT_PATH="$1"
[ "${IMPORT_PATH#/}" == "$IMPORT_PATH" ] && IMPORT_PATH="/home/sketchup/filestoconvert/$IMPORT_PATH"
IMPORT_DIR="$IMPORT_PATH"
[ -f "$IMPORT_PATH" ] && IMPORT_DIR="$(dirname "$IMPORT_PATH")"
find "$IMPORT_PATH" -iname "*.skp" | while read IMPORT_FILE; do
	echo "[$(date -Iseconds)] Converting $IMPORT_FILE..."
	EXPORT_FILE="${IMPORT_FILE%.[Ss][Kk][Pp]}.dae"
	EXPORT_DIR="$(dirname "$EXPORT_FILE")"
	SCRIPT="$EXPORT_FILE.rb"
	if [ -w "$EXPORT_DIR" ]; then
		sed /home/sketchup/ImportExportQuit.rb.tmpl \
				-e 's,^\(\$IMPORT_FILE = \).*,\1"Z:'"$IMPORT_FILE"'",' \
				-e 's,^\(\$EXPORT_FILE = \).*,\1"Z:'"$EXPORT_FILE"'",' \
				> "$SCRIPT"
		if [ -e "$EXPORT_FILE" ]; then
			echo "[$(date -Iseconds)] $EXPORT_FILE exists, skipping it." >&2
		else
#			timeout -k 300s 120s \
#					xvfb-run -a -s "-screen 0 1280x800x24 -ac +extension GLX +render -noreset -notcp" \
			timelimit -p -T300 -t120 \
					xvfb-run -a -s "-screen 0 1280x800x24" \
					wine 'C:\Program Files\Google\Google SketchUp 8\SketchUp.exe' \
					-RubyStartup "Z:\\${SCRIPT//\//\\}"
					
			STATUS="$?"
			if [ "$STATUS" -eq $((128+9)) ] || [ "$STATUS" -eq $((128+15)) ]; then
				echo "[$(date -Iseconds)] SketchUp timed out for $IMPORT_FILE."
				ps aux | grep wine
			else
				echo "[$(date -Iseconds)] SketchUp run finished for $IMPORT_FILE."
				waitfor sketchup wineserver
			fi
		fi
	else
		echo "[$(date -Iseconds)] Cannot write to $EXPORT_DIR, skipping $IMPORT_FILE." >&2
	fi
done 2>&1 \
	| sed -e '/^fixme:nls:CompareStringEx semi-stub behavor for flag(s) 0x10000000$/d' \
	| tee "$IMPORT_DIR/$(basename "$0").log"

