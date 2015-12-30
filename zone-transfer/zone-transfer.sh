#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Zone Transfer
#
# Program for query DNS servers of the domain and try to get the full zone file.
# 
# This code is under the license WTFPL: 
# http://www.wtfpl.net/
#
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

# Check if the domain was given
if [ -z $1 ]; then
    echo -e "Incorret usage, should consider pass the domain:\n$0 website.com"
    # Abort the script if no URL was given
    exit 1
fi

# Output file of the program
RESULT="zone_file.txt"

echo "--> Starting zone transfer attempt in $1"

# Discovering all DNS servers of the domain
for server in $(host -t ns $1 | cut -d " " -f4 ); do
    # Get only the useful information in the zone file
    host -l $1 $server | grep -E 'has address|name server' | sed 's/\.$//' >> $RESULT # Maybe "| tee -a $RESULT" instead of ">> $RESULT" for real time feedback
    # Check if zone transfer was successful 
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "--> Successful zone transfer in server: $server\n--> Results are in $RESULT"
        # Exit program with success
        exit 0
    fi
    # If zone transfer was not successful
    echo "--> Failed zone transfer in $server"
done

# If the program still running, there are no results
echo "--> Unable to do zone transfer in $1"
