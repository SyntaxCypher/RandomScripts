#!/bin/bash
#DarthScripting
#01162023

echo "Enter the IP address you want to scan: "
read ip

echo "Enter the timeout in seconds: "
read timeout

common_ports="22 23 25 53 80 443"

for port in $common_ports; do
  if nc -zw $timeout "$ip" $port; then
    echo "Port $port is open"
  else
    echo "Port $port is closed or timeout reached"
  fi
done
