#!/bin/bash

#generate an array of sorted file names and full paths
IFS=$'\n' Files=($(find $HOME/my/notes -type f -printf '%f\t%p\n' | sort | tr '\t' '\n'))

# for f in "${Files[@]}" ; do echo $f ; done ; exit

File=$(zenity --title 'Notes' \
                --list --hide-header --column '' --column ''    \
                --hide-column 2 --print-column 2    \
                --width=700 --height=900 \
                "${Files[@]}")

zenity --text-info --filename=$File --font=Monospace --width=700 --height=900 
