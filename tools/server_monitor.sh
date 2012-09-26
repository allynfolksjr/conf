#!/bin/zsh
# Server monitoring program prints out vmstat results from specified systems.
# By default, ovid is the most monitored, with occasional checks to depts0?
# Prints results to file.

# Program useful for beginning of quarter monitoring and other high traffic loads.

## Config ##

#Primary Server config (ovid)


#Number of times to repeat
repeat=30
#Seconds to wait between querying
int=5

#Secondary server config (depts01, depts02, depts03)


#Number of times to repeat
secrepeat=4
#Seconds to wait between querying
secint=5


# End Config #

# Loop forever. #

while [ 1 ]
  
do
  {
filename=~/server_logs/`hostname --short`.log.`date +%F`

echo -e "\n" >> $filename
hostname >> $filename
date >> $filename
uptime >> $filename
echo -e "\n" >> $filename
vmstat -m $int $repeat | { while read LINE ; do echo `date +%H:%M:%S` "$LINE" ; done ; } >> $filename

echo -e "\ndepts01" >> $filename
date >> $filename
echo -e "\n" >> $filename
ssh depts01 uptime >> $filename; vmstat -m $secint $secrepeat | { while read LINE ; do echo `date +%H:%M:%S` "$LINE" ; done ; } >> $filename

echo -e "\ndepts02" >> $filename
date >> $filename
echo -e "\n" >> $filename
ssh depts02 uptime >> $filename;  vmstat -m $secint $secrepeat | { while read LINE ; do echo `date +%H:%M:%S` "$LINE" ; done ; } >> $filename

echo -e "\ndepts03" >> $filename
date >> $filename
echo -e "\n" >> $filename
ssh depts03 uptime >> $filename; vmstat -m $secint $secrepeat | { while read LINE ; do echo `date +%H:%M:%S` "$LINE" ; done ; } >> $filename
 }
 done
