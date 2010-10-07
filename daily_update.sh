#!/bin/bash
if [ ! -d runlog ]; then
	mkdir runlog
fi
## MAKES SOEM DATES
DATE=`date +%Y-%m-%d`
FTIME=`date +%Y-%m-%d-%H.%m.%S`;
RUNLOG="$FTIME-runlog";
echo "$DATE "
# IF FILE LOG EXIST
if [ -d logs ]; then 
	LOGFILE=`ls -x1 logs/* |grep "$DATE"`;
	# IF FILE EXIST
    if [ -a $LOGILE ]; then
		# COMVERT LOG TO HTML
		lib/log-to-html.pl "$LOGFILE" >>runlog/"$RUNLOG";
    fi
fi
