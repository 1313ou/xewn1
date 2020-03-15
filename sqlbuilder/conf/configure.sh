##!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
	echo "$0 <tag> <db>"
	exit 1
fi

TAG=$1
shift
DB=$1
shift

# D I R S

DIR="`dirname $(readlink -m $0)`/"
CONFDIR="${DIR}"

# C O N F I G

echo "[TAG]   ${TAG}" 1>&2
echo "[DB ]   ${DB}" 1>&2

sed "s/%database%/${DB}/g" ${CONFDIR}/%%-mysql.properties > ${CONFDIR}/mysql.properties
sed "s/%database%/${DB}/g" ${CONFDIR}/%%-sqlite.properties > ${CONFDIR}/sqlite.properties
sed "s/%dbtag%/${TAG}/g" ${CONFDIR}/%%-todo.properties > ${CONFDIR}/todo.properties
