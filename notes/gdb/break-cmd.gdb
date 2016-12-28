delete

break HttpSession.cpp:491
commands
	silent
	set scheduler-locking on
	p Packet.GetPtr()->GetIpId()
    set scheduler-locking off
	cont
end

info break

# delete
#break gettimeofday
#commands
#	bt
#	cont
#end
#info break

file /opt/cods/bin/CODS_AN_APP

set logging file /tmp/gdb.log
set logging on

break main
commands

    break CodsANStream.cpp:542
    commands
        silent
        info stack
        cont
    end


    break NetLayerBase.cpp:86
    commands
        silent
        info stack
        cont
    end


    break EthDeviceInterface.cpp:382
    commands
        silent
        info stack
        cont
    end


    break EthDeviceInterface.cpp:617
    commands
        silent
        info stack
        cont
    end

    cont
end


run


