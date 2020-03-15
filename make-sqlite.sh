#!/bin/bash
# 1313ou@gmail.com

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

# P A R A M   1

dbtag=$1
shift
if [ -z "${dbtag}" ]; then
	echo "$0 <dbtag>"
	exit 1
fi

echo -e "${M}S Q L I T E   E M P T Y   D A T A B A S E${Z}"
./make-sqlite-empty-db.sh ${dbtag} sqlite

echo -e "${M}S Q L I T E   I N S E R T${Z}"
./make-sqlite-insert.sh ${dbtag} sqlite

echo -e "${M}S Q L I T E   P A C K${Z}"
./pack-sqlite.sh ${dbtag} sqlite

