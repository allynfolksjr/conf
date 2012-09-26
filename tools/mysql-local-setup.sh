#!/bin/bash

MD=0		# new, but prexisting data instance
OMS=0		# old local instance/version
BASE=`/usr/bin/readlink /usr/local/mysql`
MYSQLVER=$BASE

if [ -d ~/mysql.pre ]; then
    echo -e "\n\tYou have apparently already upgraded once."
    echo -e "\tTo continue, please manually remove ~/mysql.pre and rerun"
    echo -e "\tthis script.\n"
    exit
fi 

echo ""
echo -e "\tThis script will set up a MySQL instance using the "
echo -e "\tC&C-installed code base and a local data set."
echo ""

cd ~ 
PWD=`/bin/pwd`
echo -e "\tNew instance will be installed to $PWD\n" 
if [ -d ~/mysql-data ]; then
    MD=1 
    echo -e "\tYou have a pre-existing mysql-data directory; the new instance"
    echo -e "\twill use that as the data source."
fi

if [ -d ~/mysql ]; then
    OMS=1;
    echo -e "\tYou have an old mysql instance; it will be moved to mysql.pre"
    echo -e "\tPrivilege tables will probably need to be updated; please"
    echo -e "\tsee the documentation at:" 
    echo -e "\thttp://www.washington.edu/computing/web/publishing/mysql.html"
fi

echo -ne "\n\tProceed? (yes/n) [n]:  "

read ANS

if [ "$ANS" = "yes" ]; then
    echo -e "\tProceeding with MySQL upgrade to C&C-installed binaries"

    if [ "$OMS" = "1" ]; then
   	echo -e "\n\tMoving old ./mysql to ./mysql.pre"
	mv ~/mysql ~/mysql.pre
    fi

    if [ "$MD" = "1" ]; then
	echo -e "\n\tUsing $PWD/mysql-data"
    else
	echo -e "\tCreating data directory ~/mysql-data"
	mkdir ~/mysql-data
    fi

    echo -e "\tLinking to /usr/local/mysql"

    mkdir ~/mysql
    cd ~/mysql
    ln -sf $MYSQLVER mysqlver
    ln -sf mysqlver/bin ./bin
    ln -sf mysqlver/docs ./docs
    ln -sf mysqlver/include ./include
    ln -sf mysqlver/lib ./lib
    ln -sf mysqlver/man ./man
    ln -sf mysqlver/scripts ./scripts
    ln -sf mysqlver/share ./share
    ln -sf mysqlver/sql-bench ./sql-bench
    ln -sf mysqlver/support-files ./support-files
    ln -sf mysqlver/tests ./tests
    ln -sf mysqlver/usr   ./usr

    ln -sf ~/mysql-data ./data
   
else
   echo "Abandoning MySQL upgrade"
   exit
fi 

