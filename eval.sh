#!/bin/bash
set -o errexit
set -o nounset

# set -o xtrace #debug

tmppath="$1"
srcpath="$2"

srcdir="."; [[ "$srcpath" = */* ]] && srcdir="${srcpath%/*}"

mkdir -p home/{out,"$srcdir"}
touch home/out/console.txt
cp "$tmppath" "home/$srcpath"
cd home
>/dev/null 2>&1 ../monlang-parser/bin/main.elf "$srcpath" &
>out/console.txt 2>&1 ../monlang-interpreter/bin/main.elf "$srcpath" &

exit_code=0
for job in $(jobs -p); do
    wait -n $job; job_exit_code=$?
    exit_code=$((exit_code || job_exit_code))
done

exit $exit_code
