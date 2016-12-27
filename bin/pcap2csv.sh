#!/bin/bash

[[ -z "$1" ]] && { echo -e "Convert pcap to CSV\nUsage: `basename $0` PCAP_FILE" ; exit 1 ; }


List=$(cat << EOF
frame.number
ip.id
frame.time_relative
ip.src
ip.dst
tcp.srcport
tcp.dstport
tcp.seq
tcp.nxtseq
tcp.ack
tcp.len
tcp.options.timestamp.tsval
tcp.options.timestamp.tsecr
tcp.window_size
tcp.options.sack_le
tcp.options.sack_re
tcp.flags.ack
tcp.flags.syn
tcp.flags.fin
tcp.flags.reset
tcp.analysis
EOF
)

#add '-e' before each field
for f in $List ; do Fields="${Fields} -e $f" ; done


echo "tshark -r  -T fields  -E header=y -E separator=, $Fields  > ${1}.csv"