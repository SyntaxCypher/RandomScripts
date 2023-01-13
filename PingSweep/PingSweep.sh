!/bin/bash
# DarthScripting 
# 01132023

while true; do
    # define the list of IP addresses to ping
    IP_ADDRESSES=("192.168.1.1" "192.168.1.2" "192.168.1.3")

    # iterate through the list of IP addresses
    for ip in "${IP_ADDRESSES[@]}"; do
        # ping the IP address
        ping -c 1 "$ip" > /dev/null 2>&1
        # check the exit code of the ping command
        if [ $? -eq 0 ]; then
            echo "$ip: Host is online"
        else
            echo "$ip: Host is offline"
        fi
    done

    # wait for 15 minutes
    sleep 900
done
