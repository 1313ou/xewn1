#!/bin/bash
# 1313ou@gmail.com

dbms=sqlite

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

# P A R A M   2

name=$1
shift
if [ -z "${name}" ]; then
	echo "$0 <dbtag><name>"
	exit 1
fi

# D I R S

datadir=data/standard/${dbtag}
datadir="$(readlink -m ${datadir})"
#echo "datadir=${datadir}"

datadir2=data/sqlite/${dbtag}
datadir2="$(readlink -m ${datadir2})"
#echo "datadir2=${datadir2}"

outdir=data/sqlitedb/${dbtag}
outdir="$(readlink -m ${outdir})"
#echo "outdir=${outdir}"

dbfile=${outdir}/${name}-${dbtag}.db
echo "dbfile=${dbfile}"

# S O U R C E S

source define_domains.sh

# F U N C T I O N S

function process()
{
	if [ ! -e "$1" ];then
		echo "$1 not found"
		return
	fi
	echo "sql=$1"
	sqlfile=${datadir2}/insert-${dbtag}-$2.sql
	cat sqlite-pragmas-quick.sql sqlite-transaction-begin.sql $1 sqlite-transaction-commit.sql sqlite-pragmas-defaults.sql | sed "s/\\\'/''/g" > ${sqlfile}
	sqlite3 -init ${sqlfile} ${dbfile} .quit
	rm ${sqlfile}
}

# M A I N

# insert data
for domain in ${domains}; do
	echo -e "${M}insert data ${C}${domain}${Z}"
	sql=${datadir}/standard-${domain}-data.sql
	process ${sql} ${domain} "insert ${sql}"
done

#sources
echo -e "${M}insert sources${Z}"
sqlite3 -init sources.sql ${dbfile} .quit

# tag
echo -e "${M}insert tag${Z}"
./tag.sh ${dbfile}

echo -e "${G}sqlite db ${dbfile}${Z}"
