#!/bin/zsh
# Server monitoring: checks to see if site is up.

#Config
siteurl="http://example.com"
sitename="site_name"
email="example@me.com"

wget --delete-after $siteurl 
wstatus=$?
ping -c 1 $siteurl
pingstatus=$?
if [[ $wstatus != 0 && $pingstatus != 0 ]] ;
	then
		echo "$sitename is not responding to ping nor serving HTTP files " | mail -s "$sitename Uptime Error" $email
fi
if [[ $wstatus != 0 && $pingstatus = 0 ]] ;
	then
		echo "$sitename is not serving http files but is responding to ping " | mail -s "$sitename Apache2 Error" $email 
	fi

