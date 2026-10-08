#!/bin/bash

current=$(basename $(readlink -f "${HOME}/.config/dotlang/lang.jsonc"))

declare -a files=($(find "${HOME}/.config/dotlang/" -type f))

for i in "${!files[@]}" 
do
    if [ $(basename "${files[$i]}") = $current ] ; then
        j=$((($i+1) % ${#files[@]} ))
        break
    fi
done

ln -snf "$(readlink -f "${files[$j]}")" "${HOME}/.config/dotlang/lang.jsonc"