#!/bin/bash
#echo $(date +%Y%m%d_%H%M%S) >> /root/auto-trace/run.txt
########################################
# modify as needed
########################################

# minimum free space on filesystem to be left in (MB)
minfree=10000

# size of an .pcap file (MB)
dumpfilesize=50

# schwellwert is an aditional space (MB) before reaching minimum space (minfree), at when we begin deleting the oldest .pcap files
schwellwert=1000

# how many .pcap files should be deleted, when reaching "schwellwert + minfree" or "minfree"
delpcap=5

#######################################
# dont touch this
#######################################
dumphome=/root/auto-trace
dfavailable=$(df -B MB | awk '{print $4}' |sed -n 2p| /bin/sed 's/MB//g')
tcpdumppid=$(pgrep tcpdump |head -n 1)
minfree2=$(echo $(($minfree+$schwellwert)))
if [ "$dfavailable" -gt "$minfree" ]
then use=ok
else
if pidof tcpdump; then
kill $tcpdumppid ;find / -path /proc -prune -o -type f -name '*.pcap*' -print |xargs ls -t |tail -n$delcap |xargs rm -f ;exit
else
   find / -path /proc -prune -o -type f -name '*.pcap*' -print  |xargs ls -t |tail -n$delcap |xargs rm -f;exit
fi
fi
if [ $dfavailable -lt $minfree2 ]
then find $dumphome -type f -name '*.pcap*' |xargs ls -t |tail -n$delcap |xargs rm -f
else use=ok
fi
if pidof tcpdump; then
exit
else
pcaptotal=$(find / -path /proc -prune -o -type f -name '*.pcap*' -print -exec du -c -B MB {} + |grep total$ | awk '{print $1}'| /bin/sed 's/MB//g')
canuse=$(echo $(($dfavailable+$pcaptotal-$minfree2)))
filenumbers=$(($canuse/$dumpfilesize))
nohup tcpdump -i any host not localhost and port 5060 or port 5061 or portrange 10000-20000 -w "$dumphome/trace.pcap" -s0 -vv -C"$dumpfilesize"M -Zroot -W "$filenumbers" -G -C &
fi
