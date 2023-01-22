#!/bin/bash

# Set directory
dir="/home/user/Downloads"

# Find files older than 30 days
find $dir -type f -mtime +30 -ls

#Uncomment the below command to search for
#filenames with spaces or special characters.
#find $dir -type f -ctime +30 -print0 | xargs -0 ls -l
