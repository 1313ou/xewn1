#!/bin/bash

disttag=

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

# D I R S

src_datadir1="$(readlink -m data/sqlitedb/${dbtag})"
#echo "src_datadir1=${src_datadir1}"
src_datadir2="$(readlink -m data/sqlite/${dbtag})"
#echo "src_datadir2=${src_datadir2}"

datadir="$(readlink -m data/xewn/${dbtag})"
mkdir -p ${datadir}
#echo "datadir=${datadir}"

sqlunet_db=sqlite-${dbtag}.db
xewn_db=xewn${disttag}.db
xewn_sql=xewn${disttag}.sql
xewn_db_zip=${xewn_db}.zip
xewn_sql_zip=${xewn_sql}.zip

src=${src_datadir1}/${sqlunet_db}
target=${datadir}/${xewn_db}
#echo "SRC=${src}"
#echo "TARGET=${target}"

# M A I N

echo -e "${Y}X E W N${Z}"

echo -e "${M}C O P Y   S Q L I T E   T O   X E W N . D B ${Z}"
echo "copy ${src} to ${target}"
if [ -e "${target}" ]; then
	chmod a+w ${target}
	rm ${target}
fi
cp ${src} ${target}
chmod a+w ${target}

echo -e "${M}X E W N   C L E A N U P${Z}"
echo "drop bnc"
sqlite3 ${target} "DROP TABLE bncs"
sqlite3 ${target} "DROP TABLE bncspwrs"
sqlite3 ${target} "DROP TABLE bncconvtasks"
sqlite3 ${target} "DROP TABLE bncimaginfs"
echo "delete logs except wn"
sqlite3 ${target} "DELETE FROM logs WHERE module <> 'wn'"
echo "delete sources except wn"
sqlite3 ${target} "DELETE FROM sources WHERE name <> 'WordNet' AND name <> 'English WordNet'"
echo "vacuum"
sqlite3 ${target} "VACUUM;"

echo -e "${M}X E W N   I N D I C E S${Z}"
echo "make indices"
sqlite3 -init ${src_datadir2}/sqlite-all-indexes.sql ${target} .quit

echo -e "${M}X E W N   M E T A${Z}"
./meta.sh ${target}

echo -e "${G}done: `basename ${target}` to be used as xewn db${Z}"

echo -e "${M}X E W N   D U M P${Z}"
echo "dump sql"
sqlite3 ${target} .dump > ${datadir}/${xewn_sql}
echo -e "${G}done: ${xewn_sql} to be used as xewn sql${Z}"

echo -e "${M}X E W N   Z I P${Z}"
pushd ${datadir} > /dev/null

rm -f ${xewn_sql_zip}
cp ${src_datadir2}/sqlite-all-indexes.sql indexes.sql
zip -j ${xewn_sql_zip} ${xewn_sql} indexes.sql
rm indexes.sql

rm -f ${xewn_db_zip}
zip -j ${xewn_db_zip} ${xewn_db} 

popd > /dev/null
echo -e "${G}done: ${xewn_sql_zip} to be used as xewn zipped sqls${Z}"

pushd ${datadir} > /dev/null
files="${xewn_db} ${xewn_db_zip} ${xewn_sql} ${xewn_sql_zip}"
echo -e ${G}
ls -1hs ${files}
echo -e ${Z}
popd > /dev/null

echo -e "${M}X E W N   G I T H U B   Z I P${Z}"
./pack-github.sh ${dbtag}

echo -e "${B}done: xewn${disttag}${Z}"

