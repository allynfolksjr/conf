#!/bin/zsh
# VARIABLES!!!!!!!
ssh depts01 "grep '$1' /logs/access_log" >> swapfile 
ssh depts02 "grep '$1' /logs/access_log" >> swapfile
ssh depts03 "grep '$1' /logs/access_log" >> swapfile
ssh courses01 "grep '$1' /logs/access_log" >> swapfile
ssh courses02 "grep '$1' /logs/access_log" >> swapfile
perl ./splitter.pl drupallog
echo "`exec date +%s` `exec date --iso-8601` `exec wc -l sortedresults.txt`" >> $2
rm swapfile
rm sortedresults.txt
