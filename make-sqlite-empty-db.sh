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
	echo "$0 <dbtag><name>"
	exit 1
fi

# P A R A M   2

name=$1
shift
if [ -z "${name}" ]; then
	echo "$0 <dbtag><name>"
	exit 1
fi

# S O U R C E S

source define_domains.sh

# D I R S

datadir1=data/sqlite/${dbtag}
datadir1="$(readlink -m ${datadir1})"
#echo "datadir1=${datadir1}"

datadir2=data/standard/${dbtag}
datadir2="$(readlink -m ${datadir2})"
#echo "datadir2=${datadir2}"

datadir=data/sqlitedb/${dbtag}
mkdir -p ${datadir}
dbfile=${datadir}/${name}-${dbtag}.db
dbfile="$(readlink -m ${dbfile})"
echo "database ${dbfile}"

# F U N C T I O N S

function process()
{
	if [ ! -e "$1" ];then
		echo "$1 not found"
		return
	fi
	echo "creating empty ${dbfile} with $1"
	sqlite3 -init $1 ${dbfile} .quit
	echo "unconstraining ${dbfile} with $2"
	sqlite3 -init $2 ${dbfile} .quit
}

function dbexists()
{
	test -e ${dbfile}
	return $?
}

function deletedb()
{
	echo "delete ${dbfile}"
	rm ${dbfile} 2> /dev/null
}

function createdb()
{
	echo "create ${dbfile}"
}

# M A I N

#database
deletedb
createdb

# create schema
process ${datadir1}/sqlite-all-create.sql ${datadir1}/sqlite-all-unconstrain.sql

