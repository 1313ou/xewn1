#!/bin/bash

DBTAG=XX
DB=xewn
VERSION=6.1.0-SNAPSHOT

./make-semantikos.sh ${DBTAG}
./make-xewn.sh ${DBTAG}

