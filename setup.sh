#!/bin/bash
mkdir -p /root/auto-trace && chmod 700 /root/auto-trace
sleep 2
wget -O /root/auto-trace/auto-trace.sh https://raw.githubusercontent.com/Aggregat-V2/auto-trace/master/auto-trace.sh && chmod 700 /root/auto-trace/auto-trace.sh

crontab -r
cat <(crontab -l) <(echo "SHELL=/bin/bash") |crontab -
cat <(crontab -l) <(echo "PATH=/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/bin:/usr/bin:/usr/bin/X11") |crontab -
cat <(crontab -l) <(echo "*/10 * * * * /root/auto-trace/auto-trace.sh > /dev/null 2>&1") | crontab -
