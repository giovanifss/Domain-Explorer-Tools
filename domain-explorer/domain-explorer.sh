#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Program to locate and solve intern domains of a given website
# This was inspired by an exercise of the Professional Pentest Course applied by DESEC Information Security:
# http://www.desec.com.br/site/
# 
# This code is under the license WTFPL: 
# http://www.wtfpl.net/
#
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

# Params use:
# $1 = url
# I want to add more optional things in future, like:
# -o | --output-file : select the desired file for the output
# -q | --quiet : redirect to file and does not show in screen
# -v | --verbose: Output everything
# -u | --url : for explicit set url, will be more beautiful hahahaha
# -h | --help : Display help menu

# Output files
DOMAINS="domains.txt"
HOSTS="hosts.txt"

# Check if the url was given
if [ -z $1 ]; then
    echo -e "Incorret usage, should consider pass the url:\n$0 <your-url>"
    # Abort the script if no URL was given
    exit 1
fi

# User feedback
echo "--> Checking $1..."
# Check if the url is a valid url
# Hide the output of ping, including error messagens
ping -q -c1 $1 > /dev/null 2> /dev/null

if [ $? -ne 0 ]; then
    # Display error message
    echo -e "Unreachable url $1\nAborting..."
    # Finish the script execution
    exit 1
fi

# Starting downloading the index.html file
echo "--> Downloading index file..."
wget -q $1

# Cleaning the html file:
# - Grepping only the href= lines
# - Using / as separator for get the "links" after http://
# - Grepping only line with dot .
# - Removing the lines with <li> tags
# - Remove repeated lines
echo "--> Searching for internal domains..."
cat index.html | grep href= | cut -d "/" -f 3 | grep "\." | cut -d '"' -f 1 | grep -v "<li" | sort -u > $DOMAINS

# Finding which host have an ip addres
echo "--> Checking internal domains..."
# Iterating through all founded domains
# - Displaying in screen
# - Saving into $HOSTS file
for domain in $(cat $DOMAINS); do
    # For verbose output
    # host $domain | grep "has address" | tee -a $HOSTS
    host $domain | grep "has address" >> $HOSTS
done

echo "--> Generating output file: $HOSTS..."

# Cleaning the auxiliary files
echo "--> Removing auxiliary files..."
rm $DOMAINS index.html

echo "--> Hosts are in $HOSTS!"
