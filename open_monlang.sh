#!/bin/bash

[ "${BASH_SOURCE[0]}" == "$0" ] || {
    >&2 echo "script must be executed, not sourced"
    return 1
}

set -o errexit

[ "$1" != "" ] && {
    FILENAME="$(basename "$1")"
    FILEPATH="$(realpath "$1")"
}

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

2>/dev/null tmux has-session -t monlang || {
    tmux new-session -ds monlang php -S 127.0.0.1:55555
    {
        until nc -z 127.0.0.1 55555; do
            sleep 0.1
        done
    } &
}

[ "$FILENAME" != "" ] && {
    srcname="$(php -r 'echo urlencode($argv[1]);' "$FILENAME")"

    [ -f "$FILEPATH" ] && {
        src="$(php -r 'echo urlencode(file_get_contents($argv[1]));' "$FILEPATH")"
    }
}

wait
xdg-open "http://127.0.0.1:55555${srcname+?srcname=}${srcname}${src+&src=}${src}"
