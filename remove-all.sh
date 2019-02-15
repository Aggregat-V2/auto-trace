#!/bin/bash
crontab -r > /dev/null 2>&1
sleep 1
killall tcpdump > /dev/null 2>&1
sleep 3
rm -rf /root/auto-trace > /dev/null 2>&1

