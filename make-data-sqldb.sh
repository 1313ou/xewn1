#!/bin/bash

DBTAG="$1"
if [ -z "${DBTAG}" ]; then
	echo "Missing tag"
	exit 1
fi
DB="$2"
if [ -z "${DB}" ]; then
	echo "Missing database"
	exit 1
fi
DISTTAG=${DBTAG}

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

# D I R

SQLBUILDER_DIR=sqlbuilder

# M A I N

echo -e "${Y}M Y S Q L  B U I L D${Z}"

pushd $SQLBUILDER_DIR > /dev/null

#.create database and user (use -d to delete database)
echo -e "${M}database and user${Z}"
./create-mysql.sh ${DB}

#.create
echo -e "${M}config${Z}"
conf/configure.sh ${DBTAG} ${DB}

# run
echo -e "${M}build${Z}"
./run-task-mysql.sh wn 2> >(while read line; do echo -e "${C}$line${Z}" >&2; done)
./run-task-mysql.sh bnc 2> >(while read line; do echo -e "${C}$line${Z}" >&2; done)
#./run-task-mysql.sh legacy 2> >(while read line; do echo -e "${C}$line${Z}" >&2; done)

popd > /dev/null

