#!/bin/bash

export Session="TERMC-$RANDOM"
export DirFile="/tmp/$Session"
export PrevDirFile="/tmp/$Session-prev"
cdmc() {
	cd $(readlink /proc/$(cat $DirFile)/cwd)
}
export -f cdmc

#kill previous sessions to prevent runnning too many clients by accident
tmux kill-session -t $Session 2>&1 > /dev/null

#setting PROMPT_COMMAND via proxy variable simplifies expansion and escaping
#PC='cd $(readlink /proc/$(cat $DirFile)/cwd)' ; [[ "$(cat $PrevDir)" != "$PWD" ]] && ll --color=always | sed 1d'
#		send-keys -t:.1 PROMPT_COMMAND=\'"$PC"\' Enter clear Enter \;\


#launch MC, get the PID of pane 0 process and save it to file
tmux 	new-session "/usr/bin/mc" \;\
		rename $Session \;\
		split-window "tmux list-panes -F '#{pane_active} #{pane_pid}' -t $Session | head -n 1 | grep -oP '(?<=\s)\d+' > $DirFile ; bash" \;\
		bind-key -n F10 kill-session -t $Session \;\
		bind-key -n C-Down select-pane -t:.1 \\\; send-keys cdmc Enter \;\
		bind-key -n C-Up select-pane -t:.0 \;\
		set-option -g status off \;\
		set-option -g mouse on \;\
		select-pane -t:.0
		
