#!/bin/bash

DBTAG=XX
DB=xewn
VERSION=6.0.1-SNAPSHOT

SQLBUILDERHOME=/opt/devel/sqlbuilder/sqlbuilder/
ln -sf $SQLBUILDERHOME/core/sqlbuilder-wn-${VERSION}.jar											sqlbuilder/sqlbuilder-wn.jar
ln -sf $SQLBUILDERHOME/core/sqlbuilder-wn-legacy-vn-pb-fn-bnc-sumo-xwn-glf-ilfwn-pm-${VERSION}.jar 	sqlbuilder/wn-legacy-vn-pb-fn-bnc-sumo-xwn-glf-ilfwn-pm.jar
ln -sf $SQLBUILDERHOME/core/sqlbuilder-wn-legacy-vn-pb-fn-bnc-sumo-xwn-glf-ilfwn-pm-${VERSION}.jar 	sqlbuilder/sqlbuilder.jar

if [ "$1" == "-r" ]; then
	echo "Update to wndb dict by copying data"
	./make-data-wndb.sh ${DBTAG}
fi

./make-data-sqldb.sh ${DBTAG} ${DB}
./make-data-dist.sh ${DBTAG}
./make-semantikos.sh ${DBTAG}
./make-xewn.sh ${DBTAG}

./upload-mysql.sh ${DBTAG}
./upload-sqlite.sh ${DBTAG}
./upload-semantikos.sh ${DBTAG}
./upload-github.sh ${DBTAG}

