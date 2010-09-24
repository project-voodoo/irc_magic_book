#!/bin/sh

mkdir output 2>/dev/null

for x in logs/*; do
	lib/log-to-html.pl "$x"
	mv -v $x.html output/
done

lib/index.pl

cp ressources/* output

