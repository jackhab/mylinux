#!/bin/bash

Source=$1
File=showcalls.gdb

echo delete > $File
grep -P "CHttpSession::.*\(.*\)" $Source -n | \
    tr ':' '\t' | \
    cut -f 1 | \
    xargs -I@ echo "b ${Source}:@
commands
silent
bt
printf "--------------\n"
cont
end

" >> $File
