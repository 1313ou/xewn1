#!/bin/bash
# 1313ou@gmail.com
# whereto dbtag db

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

# P A R A M   1

whereto=$1
shift
if [ -z "${whereto}" ]; then
	echo "$0 <dbtag> <db> <whereto>"
	exit 1
fi

# P A R A M   2

dbtag=$1
shift
if [ -z "${dbtag}" ]; then
	echo "$0 <dbtag> <db> <whereto>"
	exit 1
fi

# P A R A M   3

db=$1
shift
if [ -z "${db}" ]; then
	echo "$0 <dbtag> <db> <whereto>"
	exit 1
fi

echo -e "${M}D U M P   F R O M   M Y S Q L${Z}"
./dump-mysql.sh ${whereto} --schema ${dbtag} ${db}

echo -e "${M}P A C K   M Y S Q L${Z}"
./pack-mysql.sh ${dbtag}

echo -e "${M}C O N V E R T   D A T A   T O   S T A N D A R D   S Q L${Z}"
./dump-standard.sh ${whereto} ${dbtag} 

echo -e "${M}D U M P   S Q L I T E   D A T A B A S E   M A N A G E M E N T  S Q L${Z}"
./dump-sqlite.sh ${whereto} --schema ${dbtag} 

