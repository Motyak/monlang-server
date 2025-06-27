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

2>/dev/null tmux has-session -t monlang || 2>/dev/null nc -z 127.0.0.1 55555 || {
    tmux new-session -ds monlang -e PHP_CLI_SERVER_WORKERS=2 php -S 127.0.0.1:55555
    {
        until 2>/dev/null nc -z 127.0.0.1 55555; do
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
url="http://127.0.0.1:55555${srcname+?srcname=}${srcname}${src+&src=}${src}"
2>/dev/null xdg-open "$url" || {
    [ "$WSL_DISTRO_NAME" != "" ] && export BROWSER="$(type -P explorer.exe)"
    sensible-browser "$url" || true
}
