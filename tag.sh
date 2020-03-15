#!/bin/bash

dbfile=$1
echo "dbfile=${dbfile}"
if [ ! -e "${dbfile}" ]; then
	echo "dbfile=${dbfile} does not exit"
	exit 1
fi

# tag
tagdir=/opt/data/nlp/wordnet/WordNet-XX
tag=`sed -n '4p' ${tagdir}/dict/build`
echo "tag=${tag}"

# write tag
chmod +w ${dbfile}
sqlite3 ${dbfile} "UPDATE sources SET version = '${tag}' WHERE name = 'English WordNet'"
#chmod -w ${dbfile}
sqlite3 ${dbfile} "SELECT version FROM sources WHERE name = 'English WordNet'"

