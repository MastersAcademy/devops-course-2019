#!/bin/bash
master=`ps -lfC nginx | grep "master" | awk '{print $4}'`;
process=`ps -lfC nginx | grep -c "^[0-9]"`;

echo "Nginx main process have a PID: $master"
echo "nginx worker process $process"
