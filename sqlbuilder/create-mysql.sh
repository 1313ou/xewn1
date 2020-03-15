#!/bin/bash
# bbou@ac-toulouse;fr
# 22/09/2016

dbdelete=
if [ "$1" == "-d" ]; then
	dbdelete=true
	shift
fi
db=$1
dbtype=mysql
if [ -z "${db}" ]; then
	read -p "enter ${dbtype} database name: " db
	echo
	export db
fi
dbuser=sqlbuilder
dbroot=root

function process()
{
	if [ ! -e "$1" ];then
		return
	fi
	echo "$2"
	mysql -u ${dbuser} $4 $3 < $1
}

function dbexists()
{
	mysql -u ${dbuser} -e "\q" ${db} > /dev/null 2> /dev/null
	return $? 
}

function deletedb()
{
	echo "delete ${db}"
	mysql -u ${dbroot} --password=${MYSQLPASSWORD} -e "DROP DATABASE ${db};"
}

function createdb()
{
	echo "create ${db}"
	mysql -u ${dbroot} --password=${MYSQLPASSWORD} -e "CREATE DATABASE ${db} DEFAULT CHARACTER SET UTF8;"
	echo "create user ${dbuser}"
	mysql -u ${dbroot} --password=${MYSQLPASSWORD} -e "CREATE USER IF NOT EXISTS '${dbuser}'@'%';"
	mysql -u ${dbroot} --password=${MYSQLPASSWORD} -e "GRANT CREATE,CREATE VIEW,ALTER,DROP,INDEX,INSERT,UPDATE,DELETE,SELECT,LOCK TABLES ON ${db}.* TO '${dbuser}'@'%';"
}

function getpassword()
{
	read -s -p "enter ${dbroot}'s password: " MYSQLPASSWORD
	echo
	export MYSQLPASSWORD
}


#database
if [ ! -z "${dbdelete}" ]; then
	getpassword
	echo "delete and recreate ${db}"
	deletedb
	echo "deleted ${db}"
	createdb
	echo "created ${db}"
else 
	if ! dbexists; then
		getpassword
		echo "create ${db}"
		createdb
		echo "created ${db}"
	else
		echo "exists ${db}"
	fi
fi

