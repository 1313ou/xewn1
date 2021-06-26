#!/bin/bash

VERSION="6.1.0"
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
REMOTE_MYSQL_SUBDIR0=${VERSION}
REMOTE_MYSQL_SUBDIR1=${VERSION}/xewn
REMOTE_MYSQL_SUBDIR=${VERSION}/xewn/mysql

# D I R S

datadir=release
datadir="$(readlink -m ${datadir})"
#echo ${datadir}

# F I L E S

files="mysql-${VERSION}-${DBTAG}-wn-XX.zip mysql-${VERSION}-${DBTAG}-logs-XX.zip mysql-${VERSION}-${DBTAG}-bnc-01.zip"

# M A I N

echo -e "${Y}D A T A  T O  U P L O A D${Z}"

pushd ${datadir} > /dev/null
echo -e ${G}
ls -1hs ${files}
echo -e ${Z}
popd > /dev/null

echo -e "${C}$REMOTEDIR/$REMOTE_MYSQL_SUBDIR${Z}"
echo -e "${R}"
read -p "Are you sure you want to upload? " -n 1 -r
echo    # (optional) move to a new line
echo -e "${Z}"
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    exit 2
fi
echo 'Proceeding ...'

echo -e "${Y}U P L O A D${Z}"

sftp $USER@$SITE <<EOF

lcd ${datadir}
lls -l mysql*.*

-mkdir $REMOTEDIR/$REMOTE_MYSQL_SUBDIR0
-mkdir $REMOTEDIR/$REMOTE_MYSQL_SUBDIR1
-mkdir $REMOTEDIR/$REMOTE_MYSQL_SUBDIR
cd $REMOTEDIR/$REMOTE_MYSQL_SUBDIR
ls -l mysql*.*
put mysql-${VERSION}-${DBTAG}-wn-XX.zip
put mysql-${VERSION}-${DBTAG}-bnc-01.zip
put mysql-${VERSION}-${DBTAG}-logs-XX.zip
ls -l mysql*.*

quit
EOF

