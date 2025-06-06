#!/bin/bash
set -o errexit
set -o nounset

# set -o xtrace #debug

trap 'echo "script,$?"' ERR

tmppath="$1"
srcpath="$2"

srcdir="."; [[ "$srcpath" = */* ]] && srcdir="${srcpath%/*}"

mkdir -p home/{out,"$srcdir"}
touch home/out/console.txt
cp "$tmppath" "home/$srcpath"
cd home
>/dev/null 2>&1 ../monlang-parser/bin/main.elf "$srcpath" & parser_pid=$!
>out/console.txt 2>&1 ../monlang-interpreter/bin/main.elf "$srcpath" & interpreter_pid=$!

set +o errexit; trap - ERR
wait -n $parser_pid; parser_exit_code=$?
wait -n $interpreter_pid; interpreter_exit_code=$?

if [ $parser_exit_code -ne 0 ]; then
    echo "parser,$parser_exit_code"
else
    echo "interpreter,$interpreter_exit_code"
fi
