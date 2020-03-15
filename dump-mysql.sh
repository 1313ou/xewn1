#!/bin/bash
# 1313ou@gmail.com
# whereto [--schema] dbtag db

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

dbuser=sqlbuilder

# P A R A M   1

whereto="$1"
shift
if [ -z "${whereto}" ]; then
	echo "$0 <whereto> <dbtag> <db>"
	exit 1
fi

# P A R A M   2 (optional)

schema=
if [ "$1" == "--schema" ]; then
	schema=true
	shift
fi

# P A R A M   2

dbtag=$1
shift
if [ -z "${dbtag}" ]; then
	echo "$0 <whereto> <dbtag> <db>"
	exit 1
fi

# P A R A M   3

db=$1
shift
if [ -z "${db}" ]; then
	echo "$0 <whereto> <dbtag> <db>"
	exit 1
fi

# P A R A M   4

#if [ -z "$MYSQLPASSWORD" ]; then
#	MYSQLPASSWORD=$1
#	shift
#	if [ -z "$MYSQLPASSWORD" ]; then
#		read -s -p "enter ${dbuser}'s password: " MYSQLPASSWORD
#		echo
#		export MYSQLPASSWORD
#	fi
#fi

# D A T A B A S E

echo -e "${B}from database${db}${Z}"
dbms=mysql
#dbcompatible='--compatible=mysql323'
dboptions='--extended-insert=FALSE'

# D I R S

outdir=${whereto}/${dbms}/${dbtag}
outdir="$(readlink -m ${outdir})"
mkdir -p "${outdir}"
#echo "outdir=${outdir}"

builderdir=sqlbuilder
builderdir="$(readlink -m ${builderdir})"
#echo "builderdir=${builderdir}"

# S O U R C E S

source define_domains.sh
source define_tables.sh ${dbtag}

# F U N C T I O N S

function data()
{
	mytables=$1
	mydomain=$2
	echo -e "* dumping ${C}data${Z} of		${M}${mytables}${Z}"
	#mysqldump -u ${dbuser} --password=$MYSQLPASSWORD ${dbcompatible} ${dboptions} --no-create-db --no-create-info --add-drop-table --quote-names --databases ${db} --tables ${mytables} > ${outdir}/${dbms}-${mydomain}-data.sql
	mysqldump -u ${dbuser} ${dbcompatible} ${dboptions} --no-create-db --no-create-info --add-drop-table --quote-names --databases ${db} --tables ${mytables} > ${outdir}/${dbms}-${mydomain}-data.sql
}

function schema()
{
	mytables=$1
	mydomain=$2
	echo -e "* dumping ${C}schema${Z} of		${M}${mytables}${Z}"
	#mysqldump -u ${dbuser} --password=$MYSQLPASSWORD --no-data ${dbcompatible} --add-drop-table --databases ${db} --tables ${mytables} --no-create-db | ../filter-schema-${dbms}.py > ${outdir}/${dbms}-${mydomain}-schema.sql
	mysqldump -u ${dbuser} --no-data ${dbcompatible} --add-drop-table --databases ${db} --tables ${mytables} --no-create-db | ./filter-schema-${dbms}.py > ${outdir}/${dbms}-${mydomain}-schema.sql
}

function constraints()
{
	mydomain=$1
	myswitch=${mydomain}
	echo -e "* dumping ${C}constr${Z}		${mydomain}"
	pushd ${builderdir} > /dev/null
	./run-task-mysql.sh -mute -silent dump ${mydomain} constraint drops > ${outdir}/${dbms}-${mydomain}-unconstrain.sql
	./run-task-mysql.sh -mute -silent dump ${mydomain} constraint creates > ${outdir}/${dbms}-${mydomain}-constrain.sql
	popd  > /dev/null
}

function views()
{
	mydomain=$1
	myswitch=${mydomain}
	echo -e "* dumping ${C}views${Z}			${mydomain}"
	pushd ${builderdir} > /dev/null
	./run-task-mysql.sh -mute -silent dump ${mydomain} view creates > ${outdir}/${dbms}-${mydomain}-views.sql
	popd  > /dev/null
}

# M A I N

rm -fR ${outdir}
mkdir -p ${outdir}

for domain in ${domains}; do
	eval tables=\$${domain}
	#echo "${domain} -> ${tables}"
	data "${tables}" "${domain}"
	if [ ! -z "$schema" ]; then
		schema "${tables}" "${domain}"
		constraints "${domain}"
		views "${domain}"
	fi
done

