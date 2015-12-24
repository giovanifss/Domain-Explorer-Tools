#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Network Block Scan
#
# Program to scan a especified ip range block in a giver network. Searching for alive hosts in this range.
# 
# This code is under the license WTFPL: 
# http://www.wtfpl.net/
#
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

# Check if the url was given
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
    echo -e "Incorret usage, use the correct arguments:\n$0 <first-3-octets-of-the-network-ip> <initial-value-of-the-last-octet> <final-value-of-the-last-octet>\nExample: $0 172.168.22 105 200"
    # Abort the script if parameters are incorrect
    exit 1
fi

# Feedback for user
echo "--> Starting scan in $1.xxx"

RESULT="alive_hosts.txt"

# Checking the hosts in the ip range
for octet in $(seq $2 $3); do
    # Getting only the hosts that exist in the ip range
    host=$(host $1.$octet | cut -d ' ' -f5 | grep -v $1 | sed 's/\.$//') 

    # Checking if the current host exist
    # If it doesn't exist, the var host will be null
    if [ ! -z $host ]; then
        echo "Host found: $(echo "$host - $1.$octet" | tee -a $RESULT)"
    fi
done

# Telling user where to find the alive hosts
echo -e "--> Scan finished\n--> Results are in $RESULT"
