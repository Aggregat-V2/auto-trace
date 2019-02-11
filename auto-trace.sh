#!/bin/bash
#echo $(date +%Y%m%d_%H%M%S) >> /root/auto-trace/run.txt
########################################
# modify as needed
########################################
# minimum free space on filesystem to be left in MB
minfree=4000
# size of an .pcap file
dumpfilesize=20
# aditional space before before reaching minimum space, at when we start deleting the oldest .pcap
schwellwert=1000
# how much .pcaps should be deletet when reaching "schwellwert"
delpcap=15

#######################################
# dont touch this
#######################################
dumphome=/root/auto-trace
pcaptotal=$(find / -type f -name '*.pcap*' -exec du -c -B MB {} + |grep total$ | awk '{print $1}'| /bin/sed 's/MB//g')
dfavailable=$(df -B MB | awk '{print $4}' |sed -n 2p| /bin/sed 's/MB//g')
canuse=$(echo $(($dfavailable+$pcaptotal-$minfree)))
tcpdumppid=$(pgrep tcpdump |head -n 1)
minfree2=$(echo $(($minfree+$schwellwert)))
filenumbers=$(($canuse/$dumpfilesize))
mkdir -p $dumphome
chmod 700 $dumphome
if [ "$dfavailable" -gt "$minfree" ]
then use=ok
else
if pidof tcpdump; then
kill $tcpdumppid ;find $dumphome -type f -name '*.pcap*' |xargs ls -t |tail -n1 |xargs rm -f ;exit
else
   find $dumphome -type f -name '*.pcap*' |xargs ls -t |tail -n1 |xargs rm -f
fi
fi
if [ $dfavailable -lt $minfree2 ]
then find $dumphome -type f -name '*.pcap*' |xargs ls -t |tail -n1 |xargs rm -f
else use=ok
fi
if pidof tcpdump; then
exit
else
nohup tcpdump -i any host not localhost and port 5060 or port 5061 or portrange 10000-20000 -w "$dumphome/trace.pcap" -s0 -vv -C"$dumpfilesize"M -Zroot -W "$filenumbers" -G -C &
fi
