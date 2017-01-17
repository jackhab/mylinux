#!/bin/bash

export Session="TERMC-$RANDOM"
export McPidFile="/tmp/$Session"

cdmc() {
	cd $(readlink /proc/$(cat $McPidFile)/cwd)
}
export -f cdmc

#launch MC, get the PID of pane 0 process and save it to file
tmux 	new-session "/usr/bin/mc" \;\
		rename $Session \;\
		split-window "tmux list-panes -F '#{pane_active} #{pane_pid}' -t $Session | head -n 1 | grep -oP '(?<=\s)\d+' > $McPidFile ; bash" \;\
		bind-key -n F10 select-pane -t:.0 \\\; send-keys F10 \\\; kill-session -t $Session \;\
		bind-key -n C-Down select-pane -t:.1 \\\; send-keys cdmc Enter \;\
		bind-key -n C-Up select-pane -t:.0 \\\; send-keys C-r \;\
		set-option -g status off \;\
		set-option -g mouse on \;\
		select-pane -t:.0
		
