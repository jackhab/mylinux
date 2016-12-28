define peth
	if $argc == 0
		help peth
	end
	
	printf "Sequence: %x\n", $$arg0.mObject->_P_TcpHeader->seq

document peth
	Prints EEthPacket information.
	Syntax: peth EthPacketVariable
end 
