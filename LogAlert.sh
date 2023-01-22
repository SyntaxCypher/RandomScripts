#!/bin/bash

# Set the log file to monitor
LOG_FILE="/var/log/syslog"

# Set the email address to send alerts to
EMAIL_ADDRESS="admin@example.com"

# Check if the log file exists
if [ ! -f $LOG_FILE ]; then
  echo "Error: Log file $LOG_FILE does not exist."
  exit 1
fi

# Check for error messages in the log file
ERROR_COUNT=$(grep -c "ERROR" $LOG_FILE)

# If there are error messages, send an email alert
if [ $ERROR_COUNT -gt 0 ]; then
  echo "There are $ERROR_COUNT error messages in the log file. Sending alert email to $EMAIL_ADDRESS."
  echo "Please check the log file for details." | mail -s "Error Alert: $ERROR_COUNT errors in $LOG_FILE" $EMAIL_ADDRESS
fi
