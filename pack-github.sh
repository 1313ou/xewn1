#!/bin/bash
# 1313ou@gmail.com

dbtag=$1
shift
if [ -z "${dbtag}" ]; then
	echo "$0 <dbtag>"
	exit 1
fi

VERSION="6.2.0"

# D I R S

githubdir=github
githubdir="$(readlink -m ${githubdir})"
echo "githubdir=${githubdir}"
mkdir -p ${githubdir}

sqlite_target=${githubdir}/xewn${dbtag}-sqlite.zip
mysql_target=${githubdir}/xewn${dbtag}-mysql.zip

# M A I N

cp data/xewn/${dbtag}/xewn.db.zip ${sqlite_target}
zip -r ${sqlite_target} legal/ -x '*bnc*.txt'
zip -r ${sqlite_target} doc/sqlunet

cp release/mysql-${VERSION}-${dbtag}-wn-${dbtag}.zip ${mysql_target}
zip -r ${mysql_target} legal/ -x '*bnc*.txt'
zip -r ${mysql_target} doc/

