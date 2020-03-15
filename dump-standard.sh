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

# P A R A M   2

dbtag=$1
shift
if [ -z "${dbtag}" ]; then
	echo "$0 <dbtag>"
	exit 1
fi

# D A T A B A S E

dbms=standard
indbms=mysql

# D I R S

indir=${whereto}/${indbms}/${dbtag}
indir="$(readlink -m ${indir})"
#echo "indir=${indir}"

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
	echo -e "* dumping ${C}data${Z} of		${mytables} from ${C}`basename $(dirname ${indir})`${Z}/"
	./filter-normalize.sh < ${indir}/${indbms}-${mydomain}-data.sql > ${outdir}/standard-${mydomain}-data.sql
}

# M A I N

rm -fR ${outdir}
mkdir -p ${outdir}

for domain in ${domains}; do
	eval tables=\$${domain}
	data "${tables}" "${domain}"
done
