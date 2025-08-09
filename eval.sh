#!/bin/bash

# compared to coreutils timeout utility..
# .., will not print anything when child process..
# ..segfaults or crash
function timeout (
    set -o nounset
    local seconds=$1
    local cmd="${@:2}"

    $cmd & cmd_pid=$!
    { sleep $seconds && kill -15 $cmd_pid; } 2>/dev/null & timeout=$!
    set +o errexit
    2>/dev/null wait -n $cmd_pid; exit_code=$?
    2>/dev/null kill -0 $timeout && {
        kill -9 $timeout
        return $exit_code
    }
    wait -n $timeout
    [ $? -ne 0 ] && {
        return $exit_code
    }
    return 124
)

set -o errexit
set -o nounset

# set -o xtrace #debug

trap 'echo "script,$?"' ERR

tmppath="$1"
srcpath="$2"
request_id="${3:-0}"

srcdir="."; [[ "$srcpath" = */* ]] && srcdir="${srcpath%/*}"

[[ "$request_id" =~ [0-9]+ ]] && {
    rm -rf "home/${request_id}"; mkdir -p $_ # extra check for security
}
home_dir="$(realpath "$_")"

mkdir -p "$home_dir"/{out,"$srcdir"}
cat /dev/null > "${home_dir}/out/console.txt"
cp "$tmppath" "${home_dir}/$srcpath"
cd "$home_dir"
ulimit -Sv 512000 # restrict virtual memory to 500MB
&>/dev/null ../../monlang-parser/bin/main.elf "$srcpath" & parser_pid=$!
# we need to use stdbuf otherwise we won't get output in case the program segfaults or gets timed out..
&>out/console.txt timeout 5 stdbuf -oL ../../monlang-interpreter/bin/main.elf "$srcpath" & interpreter_pid=$!
set +o errexit; trap - ERR
wait -n $parser_pid; parser_exit_code=$?
wait -n $interpreter_pid; interpreter_exit_code=$?

if [ $parser_exit_code -ne 0 ]; then
    echo "parser,$parser_exit_code"
else
    echo "interpreter,$interpreter_exit_code"
fi
