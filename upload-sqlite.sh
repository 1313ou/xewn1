#!/bin/bash

VERSION="6.2.0"
DBTAG="$1"
if [ -z "${DBTAG}" ]; then
	echo "Missing tag"
	exit 1
fi

# C O L O R S

R='\u001b[31m'
G='\u001b[32m'
B='\u001b[34m'
Y='\u001b[33m'
M='\u001b[35m'
C='\u001b[36m'
Z='\u001b[0m'

# S I T E

SITE=frs.sourceforge.net
USER=bbou,sqlunet
REMOTEDIR=/home/frs/project/s/sq/sqlunet
REMOTE_SQLITE_SUBDIR0=${VERSION}
REMOTE_SQLITE_SUBDIR1=${VERSION}/xewn
REMOTE_SQLITE_SUBDIR=${VERSION}/xewn/sqlite

# D I R S

datadir=data/sqlitedb/${DBTAG}
datadir="$(readlink -m ${datadir})"
#echo ${datadir}

# F I L E S

files="sqlite-${DBTAG}.db"

# M A I N

echo -e "${Y}S Q L I T E   T O  U P L O A D   T O   S O U R C E F O R G E${Z}"

pushd ${datadir} > /dev/null
echo -e ${G}
ls -1hs ${files}
echo -e ${Z}
popd > /dev/null

echo -e "${C}$REMOTEDIR/$REMOTE_SQLITE_SUBDIR${Z}"
echo -e "${R}"
read -p "Are you sure you want to upload? " -n 1 -r
echo    # (optional) move to a new line
echo -e "${Z}"
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    exit 2
fi
echo 'Proceeding ...'

echo -e "${Y}upload${Z}"

sftp $USER@$SITE <<EOF

lcd ${datadir}
lls -l

-mkdir $REMOTEDIR/$REMOTE_SQLITE_SUBDIR0
-mkdir $REMOTEDIR/$REMOTE_SQLITE_SUBDIR1
-mkdir $REMOTEDIR/$REMOTE_SQLITE_SUBDIR
cd $REMOTEDIR/$REMOTE_SQLITE_SUBDIR
ls -l *
put sqlite-${DBTAG}.db

quit
EOF

