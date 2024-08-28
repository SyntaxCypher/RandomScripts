#Created by: Seth Bates
#NOV192022
#Recommended Max Threshold 80%-95% (I Perfer 80%)
#Add script to CronTab (I perfer it to run every hour)

#Comment out this Section if you would like to use Alerting for two disks. If not Leave two disk commented out.
#1 Disk alert below

MAX=80
EMAIL=user@userdomain.com #Insert Your Email Here
DRIVE=sda# #sda1, sda2. Check your installation for labeling 

USE=$(df -h | grep $DRIVE | awk '{ print $20 }' | cut -d'%' -f1)
if [ $USE -gt $MAX ]; then
	echo "Percent used on $DRIVE: $USE" | mail -s "Running out of disk space" $EMAIL
fi

#2 disk alert below

#MAX=80
#EMAIL=user@userdomain.com #Insert Your Email Here
#DRIVE1=sda# #sda1, sda2. Check your installation for labeling 
#DRIVE2=sda# 

#USE=$(df -h | grep $DRIVE1 | awk '{ print $20 }' | cut -d'%' -f1)
#if [ $USE -gt $MAX ]; then
#	echo "Percent used on $DRIVE1: $USE" | mail -s "Running out of disk space" $EMAIL
#fi

#USE=$(df -h | grep $DRIVE2 | awk '{ print $20 }' | cut -d'%' -f1)
#if [ $USE -gt $MAX ]; then
#	echo "Percent used on $DRIVE2: $USE" | mail -s "Running out of disk space" $EMAIL
#fi
