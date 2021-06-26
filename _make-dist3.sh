#!/bin/bash

DBTAG=XX
DB=xewn
VERSION=6.1.0-SNAPSHOT

./upload-mysql.sh ${DBTAG}
./upload-sqlite.sh ${DBTAG}
./upload-semantikos.sh ${DBTAG}
./upload-github.sh ${DBTAG}

