#!/bin/bash

VERSION="6.0.0"
DBTAG="$1"
if [ -z "${DBTAG}" ]; then
	echo "Missing tag"
	exit 1
fi

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

# D I R S

datadir="/opt/data/nlp/wordnet/WordNet-XX/xewn"
datadir="$(readlink -m ${datadir})"
echo ${datadir}

datadir_wndb=${datadir}/wndb
datadir_sqlite=${datadir}/sqlite
datadir_mysql=${datadir}/mysql

# F I L E S
declare -A files


# M A I N

files=([wndb]="xewn.dict.tar.gz xewn.zip" [sqlite]="xewnXX-sqlite.zip" [mysql]="xewnXX-mysql.zip")

echo -e "${Y}D A T A  T O  C O P Y   T O   G I T H U B${Z}"
for k in ${!files[@]}; do 
	d="${datadir}/${k}"
	for f in ${files[$k]}; do
		echo -e "${B}${files[$k]}${Z} as ${G}${k}${Z} to ${C}${d}${Z}"
	done
done

read -p "Are you sure you want to upload? " -n 1 -r
echo    # (optional) move to a new line
echo -e "${Z}"
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    exit 2
fi
echo 'Proceeding ...'

for k in ${!files[@]}; do 
	d="${datadir}/${k}"
	echo -e "${M}${k}${Z} to ${C}${d}${Z}"
	for f in ${files[$k]}; do
		echo -e "${G}${f}${Z}"
	done
done

