##!/bin/bash

DATA=$1
shift
JDBC=$1
shift
TODO=$1
shift

if [ -z "${DATA}" -o -z "${JDBC}" -o -z "${TODO}" ]; then
	echo "$0: <data> <jdbc> <todo>" 
	exit 1
fi

# D I R S

DIR="`dirname $(readlink -m $0)`"
CONFDIR="${DIR}/conf"
REPO=lib

# C O N F I G

#echo "[DATA]   ${CONFDIR}/${DATA}" 1>&2
#echo "[JDBC]   ${CONFDIR}/${JDBC}" 1>&2
#echo "[TODO]   ${CONFDIR}/${TODO}" 1>&2

# S O U R C E

eval `grep dbms  ${CONFDIR}/${JDBC}`
#echo "[DBMS]   ${dbms}" 1>&2

# C L A S S P A T H

RUNJAR="sqlbuilder.jar"
#echo "[CP]     $CP" 1>&2

# R U N

#echo "[JAVA]   $JAVA_HOME" 1>&2
#echo "[ARGS]   $@" 1>&2
$JAVA_HOME/jre/bin/java -Xms512M -Xmx1024M -jar ${RUNJAR} -jdbc:${CONFDIR}/${JDBC} -data:${CONFDIR}/${DATA} -todo:${CONFDIR}/${TODO} $@
