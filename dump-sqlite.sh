#!/bin/bash
# 1313ou@gmail.com
# whereto [--schema] dbtag

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

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
	echo "$0 <dbtag>"
	exit 1
fi

# D A T A B A S E

dbms=sqlite

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

function schema()
{
	mytables=$1
	mydomain=$2
	echo -e "* dumping ${C}schema${Z} of		${mytables}"
	pushd ${builderdir} > /dev/null
	./run-task-sqlite.sh -mute -silent dump table creates ${mydomain} > ${outdir}/${dbms}-${mydomain}-schema.sql
	popd > /dev/null
}

function constraints()
{
	mydomain=$1
	myswitch=${mydomain}
	echo -e "* dumping ${C}views${Z}			${mydomain}"
	pushd ${builderdir} > /dev/null
	./run-task-sqlite.sh -mute -silent dump ${mydomain} constraint creates > ${outdir}/${dbms}-${mydomain}-constrain.sql 2> /dev/null
	./run-task-sqlite.sh -mute -silent dump ${mydomain} constraint drops > ${outdir}/${dbms}-${mydomain}-unconstrain.sql 2> /dev/null
	popd > /dev/null
}

function views()
{
	mydomain=$1
	myswitch=${mydomain}
	echo -e "* dumping ${C}constr${Z}		${mydomain}"
	pushd ${builderdir} > /dev/null
	./run-task-sqlite.sh -mute -silent dump ${mydomain} view creates > ${outdir}/${dbms}-${mydomain}-views.sql 2> /dev/null
	popd > /dev/null
}

# M A I N

rm -fR ${outdir}
mkdir -p ${outdir}

# domain data
for domain in ${domains}; do
	eval tables=\$${domain}
	if [ ! -z "$schema" ]; then
		schema "${tables}" "${domain}"
		constraints "${domain}"
		views "${domain}"
	fi
done

# schema sql
cat ${outdir}/sqlite-*-schema.sql > ${outdir}/sqlite-all-create.sql

#unconstrain sql
cat ${outdir}/sqlite-*-unconstrain.sql > ${outdir}/sqlite-all-unconstrain.sql

# indices
cp indexes.sql ${outdir}/sqlite-all-indexes.sql

