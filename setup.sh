#!/bin/bash
mkdir -p /root/auto-trace && chmod 700 /root/auto-trace > /dev/null 2>&1
sleep 1
wget -q -O /root/auto-trace/auto-trace.sh https://raw.githubusercontent.com/Aggregat-V2/auto-trace/master/auto-trace.sh
chmod 700 /root/auto-trace/auto-trace.sh  > /dev/null 2>&1
killall tcpdump > /dev/null 2>&1
crontab -r 2> /dev/null
cat <(crontab -l) <(echo "SHELL=/bin/bash") |crontab -
cat <(crontab -l) <(echo "PATH=/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/bin:/usr/bin:/usr/bin/X11") |crontab -
cat <(crontab -l) <(echo "*/10 * * * * /root/auto-trace/auto-trace.sh > /dev/null 2>&1") | crontab -
