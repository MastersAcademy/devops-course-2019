#!/bin/bash
processId=`ps -lfC nginx | grep "master" | awk '{print $4}'`;
processCount=`ps -lfC nginx | grep -c "^[0-9]"`;

if [[ $processCount -ne 0 ]]
then
	echo "Nginx main process have a PID: $processId";
	echo -e "Nginx worker process: \033[31;5m$processCount\033[0m";
else
	echo "Nginx is not running..";
fi
exit 0;
