#!/bin/bash
if [ ! -d runlog ]; then
	mkdir runlog
fi
DATE=`date +%Y-%m-%d`
FTIME=`date +%Y-%m-%d-%H.%m.%S`;
RUNLOG="$FTIME-runlog";
echo "$DATE "
if [ -d logs ]; then 
	LOGFILE=`ls -x1 logs/* |grep "$DATE"`;
    if [ -a $LOGILE ]; then
		lib/log-to-html.pl "$LOGFILE" >>runlog/"$RUNLOG";
    fi
fi
