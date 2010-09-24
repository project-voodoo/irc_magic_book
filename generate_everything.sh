#!/bin/bash
if [ ! -d runlog ]; then
	mkdir runlog
fi
if [ -d output ]; then
    MKD=1; 
else  
	mkdir output;
    MKD=1; 
fi
FTIME=`date +%Y-%m-%d-%H.%m.%S`;
RUNLOG="$FTIME-runlog";
if [ -d logs ]; then 
    
	for x in logs/*; do
		if [ -f runlog/"$RUNLOG" ]; then 
			lib/log-to-html.pl "$x" >>runlog/"$RUNLOG";
		else 
			lib/log-to-html.pl "$x" >runlog/"$RUNLOG";
		fi
		mv -v $x.html output/;
	done;
   CONVERT=1;
fi
if [ $MKD -eq 1 -a $CONVERT -eq 1 ]; then
	lib/index.pl >>runlog/"$RUNLOG"
	cp ressources/* output
fi
