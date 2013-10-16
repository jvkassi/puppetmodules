#!/bin/bash
# HEADER: This file is maintained with Puppet.
# HEADER: Do not edit it directly.

FTP_PASSWDFILE=/etc/proftpd/ftpd.passwd
FTP_HOMEDIR=/var/www
USR_NAME=proftpd
USR_ID=`id -u $USR_NAME`
GRP_NAME=nobody
GRP_ID=`id -g $GRP_NAME`

RES_COL="60"
RES_COL_INFO="30"
MOVE_TO_COL="\\033[${RES_COL}G"
MOVE_TO_COL_INFO="\\033[${RES_COL_INFO}G"
SETCOLOR_INFO="\\033[1;38m"
SETCOLOR_SUCCESS="\\033[1;32m"
SETCOLOR_FAILURE="\\033[1;31m"
SETCOLOR_NORMAL="\\033[0;39m"

if [ ! -e /usr/sbin/ftpasswd ]; then
        wget http://www.castaglia.org/proftpd/contrib/ftpasswd -O /usr/sbin/ftpasswd
        chmod 755 /usr/sbin/ftpasswd
fi

if [ $# -ne 1 ]; then
        echo "Usage:  ${0##*/} <site_name>"
        exit 1
fi


user_name=$1
passwd=`/usr/bin/pwgen -cn -N 1`
USER_FTP_HOMEDIR=$FTP_HOMEDIR/$user_name

echo -n "Creating SFTP defaut configuration: "
if [ ! -d $FTP_HOMEDIR/$user_name ]; then
    mkdir $USER_FTP_HOMEDIR;
fi 
# root directory chown $USR_ID:$GRP_ID $USER_FTP_HOMEDIR chmod 550 $USER_FTP_HOMEDIR

    # create dir
    mkdir -p $USER_FTP_HOMEDIR/{conf,logs,bin,htdocs}
	chmod -R 550 $USER_FTP_HOMEDIR/conf
	chown -R $USR_ID:$GRP_ID $USER_FTP_HOMEDIR

	echo -e "${MOVE_TO_COL}${SETCOLOR_SUCCESS}OK${SETCOLOR_NORMAL}"

# FTP user creation
echo -n "Creating SFTP account: "
ftpasswd --passwd --file=$FTP_PASSWDFILE --home=$USER_FTP_HOMEDIR --name=$user_name --uid=$USR_ID --gid=$GRP_ID --shell=/bin/bash --stdin <<< "$passwd" > /dev/null
[ $? -eq 0 ] && echo -e "${MOVE_TO_COL}${SETCOLOR_SUCCESS}OK${SETCOLOR_NORMAL}" || echo -e "${MOVE_TO_COL}${SETCOLOR_FAILURE}KO${SETCOLOR_NORMAL}"

echo -e "Credential : ${MOVE_TO_COL_INFO}${SETCOLOR_INFO}$user_name/$passwd${SETCOLOR_NORMAL}"
