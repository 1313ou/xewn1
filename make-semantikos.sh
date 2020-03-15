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

datadir="$(readlink -m data/semantikos/${dbtag})"
mkdir -p ${datadir}
#echo "datadir=${datadir}"

src_sqlunet_db=sqlite-${dbtag}.db
semantikos_db=sqlunet-ewn.db
semantikos_sql=sqlunet-ewn${disttag}.sql
semantikos_db_zip=${semantikos_db}.zip
semantikos_sql_zip=${semantikos_sql}.zip

src=${src_datadir1}/${src_sqlunet_db}
target=${datadir}/${semantikos_db}
#echo "SRC=${src}"
#echo "TARGET=${target}"

echo -e "${Y}S E M A N T I K O S${Z}"

echo -e "${M}C O P Y   S Q L I T E   T O   S E M A N T I K O S . D B ${Z}"
echo "copy ${src} to ${target}"
if [ -e "${target}" ]; then
	chmod a+w ${target}
	rm ${target}
fi
cp ${src} ${target}
chmod a+w ${target}

echo -e "${M}S E M A N T I K O S   C L E A N U P${Z}"
echo "drop logs"
sqlite3 ${target} "DROP TABLE logs"
echo "delete sources except wn"
sqlite3 ${target} "DELETE FROM sources WHERE name <> 'WordNet' AND name <> 'English WordNet'"
echo "vacuum"
sqlite3 ${target} "VACUUM;"

echo -e "${M}S E M A N T I K O S   I N D I C E S${Z}"
echo "make indices"
sqlite3 -init ${src_datadir2}/sqlite-all-indexes.sql ${target} .quit

echo -e "${M}S E M A N T I K O S   M E T A${Z}"
./meta.sh ${target}

echo -e "${G}done: `basename ${target}` to be used as xewn db${Z}"


echo -e "${M}S E M A N T I K O S   D U M P${Z}"
echo "dump sql"
sqlite3 ${target} .dump > ${datadir}/${semantikos_sql}
echo -e "${G}done: ${semantikos_sql} to be used as semantikos sql${Z}"

echo -e "${M}S E M A N T I K O S   Z I P S${Z}"
pushd ${datadir} > /dev/null

rm -f ${semantikos_sql_zip}
cp ${src_datadir2}/sqlite-all-indexes.sql indexes.sql
zip -j ${semantikos_sql_zip} ${semantikos_sql} indexes.sql
rm indexes.sql

rm -f ${semantikos_db_zip}
zip -j ${semantikos_db_zip} ${semantikos_db} 

popd > /dev/null

echo -e "${M}S E M A N T I K O S   R E P O R T${Z}"
./report-semantikos.sh ${dbtag} ${disttag}

echo -e "${B}done: semantikos ewn${disttag}${Z}"

