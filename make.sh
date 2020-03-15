#!/bin/bash

DBTAG=XX
DB=xewn
VERSION=6.0.0

SQLBUILDERHOME=/opt/devel/sqlbuilder/sqlbuilder/
ln -sf $SQLBUILDERHOME/core/sqlbuilder-wn-6.0.0.jar												sqlbuilder/sqlbuilder-wn.jar
ln -sf $SQLBUILDERHOME/core/sqlbuilder-wn-legacy-vn-pb-fn-bnc-sumo-xwn-glf-ilfwn-pm-6.0.0.jar 	sqlbuilder/wn-legacy-vn-pb-fn-bnc-sumo-xwn-glf-ilfwn-pm.jar
ln -sf $SQLBUILDERHOME/core/sqlbuilder-wn-legacy-vn-pb-fn-bnc-sumo-xwn-glf-ilfwn-pm-6.0.0.jar 	sqlbuilder/sqlbuilder.jar

#./make-data-wndb.sh ${DBTAG}
#TODO copy to wndb dict

#./make-data-sqldb.sh ${DBTAG} ${DB}
#TODO sql statements

./make-data-dist.sh ${DBTAG}
./make-semantikos.sh ${DBTAG}
./make-xewn.sh ${DBTAG}

#./upload.sh ${DBTAG}
#TODO upload

