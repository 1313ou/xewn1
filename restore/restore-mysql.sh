#!/bin/bash
# bbou@ac-toulouse;fr
# 22/09/2016

# C O N S T S
dbtype=mysql
modules="wn legacy vn fn pb bnc sumo xwn glf ilfwn pm logs"

echo "Restore utility for ${dbtype}"
echo "-the ${dbtype} user needs CREATE/DELETE permission"
echo "-the -d switch will delete an existing database with this name"
read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        ;;
    *)
        exit 1
        ;;
esac

# D E L E T E (PARAM 1)
dbdelete=
if [ "$1" == "-d" ]; then
	dbdelete=true
	shift
fi

# D A T A B A S E (PARAM 2)
db=$1
if [ -z "${db}" ]; then
	read -p "Enter ${dbtype} database name: " db
	export db
fi

# F U N C T I O N S

function process()
{
	if [ ! -e "$1" ];then
		return
	fi
	echo "$2"
	mysql -u ${dbuser} ${dbpasswd} $4 $3 < $1
}

function dbexists()
{
	mysql -u ${dbuser} ${dbpasswd} -e "\q" ${db} > /dev/null 2> /dev/null
	return $? 
}

function deletedb()
{
	echo "delete ${db}"
	mysql -u ${dbuser} ${dbpasswd} -e "DROP DATABASE ${db};"
}

function createdb()
{
	echo "create ${db}"
	mysql -u ${dbuser} ${dbpasswd} -e "CREATE DATABASE ${db} DEFAULT CHARACTER SET UTF8;"
}

function getcredentials()
{
	read -p "Enter database user: " MYSQLUSER
	if [ -z "$MYSQLUSER" ]; then
		echo "Define $dbtype user"
		exit 1
	fi
	dbuser=$MYSQLUSER

	if [ -z "$MYSQLPASSWORD" ]; then
		read -s -p "Enter $MYSQLUSER's password (type '?' if you want to be asked each time): " MYSQLPASSWORD
		echo
		export MYSQLPASSWORD
	fi
	if [ ! -z "$MYSQLPASSWORD" ]; then
		if [ "$MYSQLPASSWORD" == "?" ]; then
			dbpasswd="--password"
		else
			dbpasswd="--password=$MYSQLPASSWORD"
		fi
	fi
	#echo "credentials user=${dbuser}  passwd=${MYSQLPASSWORD} switch=${dbpasswd}"
}

# M A I N

echo "restoring ${db}"

#credentials
getcredentials

#database
if [ ! -z "${dbdelete}" ]; then
	deletedb
fi
if ! dbexists; then
	createdb
fi

# module tables
for m in ${modules}; do
	sql=${dbtype}-${m}-schema.sql
	process ${sql} "schema ${m}" ${db}
done
for m in ${modules}; do
	sql=${dbtype}-${m}-data.sql
	process ${sql} "data ${m}" ${db}
done
for m in ${modules}; do
	sql=${dbtype}-${m}-unconstrain.sql
	process ${sql} "unconstrain ${m}" ${db} --force 2> /dev/null
	sql=${dbtype}-${m}-constrain.sql
	process ${sql} "constrain ${m}" ${db} --force
done
for m in ${modules}; do
	sql=${dbtype}-${m}-views.sql
	process ${sql} "views ${m}" ${db}
done
