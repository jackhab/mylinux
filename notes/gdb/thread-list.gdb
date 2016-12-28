define thlist
	printf "Listing threads from %d to %d\n", $arg0, $arg1

	set $thread = $arg0
	while ($thread <= $arg1)
		printf "\n\n-------------THREAD: %d\n", $thread
		thread $thread
		info stack
		set $thread++
	end
end

info thread

printf "\n\nUsage thlist FROM-NUM TO-NUM\n"
