#!/bin/bash

[ "${BASH_SOURCE[0]}" == "$0" ] || {
    >&2 echo "script must be executed, not sourced"
    return 1
}

command -v php >/dev/null || { >&2 echo "php isn't installed"; exit 1; }
command -v tmux >/dev/null || { >&2 echo "tmux isn't installed"; exit 1; }
command -v nc >/dev/null || { >&2 echo "nc isn't installed"; exit 1; }

set -o errexit

cd "$(dirname "$(readlink -f "$0")")"

2>/dev/null tmux has-session -t monlang || {
    2>/dev/null nc -z 127.0.0.1 55555 && {
        pid=$(lsof -i :55555 -t)
        >&2 echo "server is already running on pid ${pid}"
        exit 0
    }
    tmux new-session -ds monlang -e PHP_CLI_SERVER_WORKERS="${1:-2}" php -S 127.0.0.1:55555 -c php.ini
}

tmux attach-session -t monlang
