#!/bin/bash
# 1313ou@gmail.com
# 27/11/2013 

thisdir=`dirname $(readlink -m $0)`

pushd ${thisdir} > /dev/null
#./filter-inserts-only.sh | ./filter-no-backquote.sh | ./filter-mysql2sqlite.sh
./filter-inserts-only.sh | ./filter-mysql2sqlite.sh
popd > /dev/null

