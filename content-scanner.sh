#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Content Scanner
#
# Script for discover files and directories in the given domain
# 
# This code is under the license WTFPL: 
# http://www.wtfpl.net/
#
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

# Check if the url was given
if [ -z $1 ]; then
    echo -e "Incorret usage, should consider pass the url:\n$0 <url> <wordlist>(optional)"
    # Abort the script if no URL was given
    exit 1
fi

# File name for the content discovered
CONTENT="domain_content.txt"

# Set the default wordlist file
WORDLIST="content.wordlist"
# Check if user pointed for another wordlist
if [ ! -z $2 ]; then
    # Set the desired list from user
    WORDLIST="$2"
fi

# Feedback for the user
echo "--> Starting brute force in $1..."

# Check if the file exists
if [ ! -e $WORDLIST ]; then
    # Abort the script execution
    echo "Unable to locate the wordlist $WORDLIST"
    exit 1
fi

# Read the wordlist and attempt every possibility
for attempt in $(cat $WORDLIST); do
    # Checking for file in domain
    resp=$(curl -s -o /dev/null -w "%{http_code}" $1/$attempt)
    # If file doesn't exist
    if [ $resp -ne '200' ]; then
        # Check for directory in domain
        resp=$(curl -s -o /dev/null -w "%{http_code}" $1/$attempt/)
        # If directory exists
        if [ $resp -eq '200' ]; then
            echo "--> Directory Found: $(echo $1/$attempt/ | tee -a $CONTENT)"  
        fi
    # If file exists
    else
        echo "--> File Found: $(echo $1/$attempt | tee -a $CONTENT)" 
    fi
done

# Feedback for the user
echo "--> Finished brute force in $1..."

# Showing the location of the result
echo "--> Results stored in $CONTENT"
