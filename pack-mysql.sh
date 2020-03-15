#!/bin/bash
# 1313ou@gmail.com

dbtag=$1
shift
if [ -z "${dbtag}" ]; then
	echo "$0 <dbtag>"
	exit 1
fi

# M A I N

ant -Ddbtag=${dbtag} -f make-dist-database.xml dist-mysql 

