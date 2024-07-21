#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"
extension="${file##*.}"

if [ "$extension" == "dts" ]; then
    # Convert DTS to DTB
    dtc -I dts -O dtb -o "${file%.dts}.dtb" "$file"
    echo "Converted $file to ${file%.dts}.dtb"
elif [ "$extension" == "dtb" ]; then
    # Convert DTB to DTS
    dtc -I dtb -O dts -o "${file%.dtb}.dts" "$file"
    echo "Converted $file to ${file%.dtb}.dts"
else
    echo "Unsupported file extension: $extension"
    exit 1
fi
