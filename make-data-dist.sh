#!/bin/bash
# 1313ou@gmail.com
# dbtag

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

# P A R A M  1

DBTAG="$1"
if [ -z "${DBTAG}" ]; then
	echo "Missing tag"
	exit 1
fi
DB="xewn"
DISTTAG=${DBTAG}

# D I R S

data_dir=data
data_dir="$(readlink -m ${data_dir})"
echo ${data_dir}
mkdir -p ${data_dir}

# S Q L

echo -e "${Y}S Q L${Z}"
./make-sql.sh ${data_dir} ${DBTAG} ${DB}

# S Q L I T E

echo -e "${Y}S Q L I T E${Z}"
./make-sqlite.sh ${DBTAG}

