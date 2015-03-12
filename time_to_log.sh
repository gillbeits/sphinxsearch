#!/bin/bash
while read line; do
	echo "`date +'%Y-%m-%d %T'` | $line"
done
