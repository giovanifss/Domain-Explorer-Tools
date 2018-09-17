#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Network Block Scan
#
# Program to scan a especified ip range block in a giver network. Searching for alive hosts in this range.
# 
# This code is under the GPLv3 license. See LICENSE for more informations.
#
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

NETWORK=                                    # Network to perform the scan
OUTPUT="/dev/null"                          # File to write the output
VERBOSE=false                               # Operation mode verbose
EXCEPT=()                                   # Hosts to ignore
FIRST=1                                     # First valid host of the network
START=0                                     # The host to start the scan
LAST=0                                      # Last host of the network to scan
MASK=                                       # Network mask

trap "echo; exit" INT                       # Set trap to exit script when receiving a sigint

function main {
    hosts=$(((2 ** (32 - $MASK)) - 2))      # Calculates valid IP adresses in the network
    
    if [ $(($FIRST + ($hosts - 1))) -lt $LAST ]; then
        error_with_message "Invalid last option. Out of bounds in the network. Range: $NETWORK.$FIRST to $NETWORK.$(($FIRST + ($hosts - 1)))"
    fi

    if [ $LAST -eq 0 ]; then                # If last argument was not given
        LAST=$(($FIRST + ($hosts - 1)))
    fi

    if [ $START -eq 0 ]; then               # If start argument was not given
        START=$FIRST
    fi

    if [ $START -gt $LAST ]; then
        error_with_message "Invalid range - Initial value is greater than last"
    fi

    echo -e "Network scan started in $(date)\n" | tee -a $OUTPUT

    if $VERBOSE; then
        echo "==> Starting scan in $NETWORK.$(($FIRST - 1))/$MASK"
    fi

    echo "==> Scanning from $NETWORK.$START to $NETWORK.$LAST"

    for octet in $(seq $START $LAST); do    # Iterates through all valid adresses in the network until the last desired
        echo -ne "----> Trying for $NETWORK.$octet...                 \r"

        ping -q -W 4 -c 1 $NETWORK.$octet &> /dev/null
        
        pcode=$?

        if [ $pcode -eq 0 ]; then
            echo "[+] Host $NETWORK.$octet is up! (Answering ping)" | tee -a $OUTPUT
        fi

        host=$(host $NETWORK.$octet) 

        hcode=$?

        if [ $hcode -eq 0 ]; then
            echo "[+] Host $NETWORK.$octet DNS lookup: $(echo $host | cut -d ' ' -f 5 | grep -v $NETWORK | sed 's/\.$//')" | tee -a $OUTPUT
        fi

        if [ $pcode -eq 0 ] || [ $hcode -eq 0 ]; then
            echo
        fi
    done

    if [ ! $OUTPUT == "/dev/null" ]; then
        echo ":: Results are stored in $OUTPUT"
    fi

    echo -e "\nNetwork scan finished in $(date)" | tee -a $OUTPUT

    return 0
}

function parse_args {
    if [ $# -eq 0 ]; then                   # Check if at least one arg was passed
        display_help
        exit 1
    fi

    while (( "$#" )); do                    # Stays in the loop as long as the number of parameters is greater than 0
        case $1 in                          # Switch through cases to see what arg was passed
            -V|--version) 
                echo ":: Author: Giovani Ferreira"
                echo ":: Source: https://github.com/giovanifss/Domain-Explorer-Tools"
                echo ":: License: GPLv3"
                echo ":: Version: 0.2"
                exit 0;;

            -o|--output)                    # Get the next arg to be the output file
                if [ -z $2 ] || [[ $2 == -* ]]; then
                    error_with_message "Expected argument after output file option"
                fi
                OUTPUT=$2
                shift;;                     # To ensure that the next parameter will not be evaluated again

            -f|--first)                     # Set the first host in the network to scan
                if [ -z $2 ] || [[ $2 == -* ]]; then
                    error_with_message "Expected argument after first host option"
                fi

                if [[ ! $2 =~ ^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-4])$ ]] || [ $2 -eq 0 ]; then
                    error_with_message "Invalid argument for first option"
                fi

                START=$2
                shift;;

            -l|--last)                      # Set the first host in the network to scan
                if [ -z $2 ] || [[ $2 == -* ]]; then
                    error_with_message "Expected argument after first host option"
                fi

                if [[ ! $2 =~ ^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-4])$ ]] || [ $2 -eq 0 ]; then
                    error_with_message "Invalid argument for last option"
                fi

                LAST=$2
                shift;;

            -v|--verbose)                   # Set the program operation mode to verbose 
                VERBOSE=true;;

            -e|--except)                    # Hosts to ignore
                while [[ $2 =~ ^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$ ]]; do
                    EXCEPT+=($2)  
                    shift
                done

                if [ ${#EXCEPT[@]} -eq 0 ]; then
                    error_with_message "Expected argument after except option"
                fi;;

            -h|--help)                      # Display the help message
                display_help
                exit 0;;

            *)                              # If a different parameter was passed
                if [ ! -z "$NETWORK" ] || [[ $1 == -* ]]; then
                    error_with_message "Unknow argument $1"
                fi

                regex="\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/[0-9][0-9]\b"

                if [[ ! $1 =~ $regex ]];then
                    error_with_message "Invalid network $1. Format ex: 192.168.1.0/24"
                fi

                NETWORK=$1
        esac
        shift                               # Removes the element used in this iteration from parameters
    done

    if [ -z $NETWORK ]; then
        error_with_message "The target network must be passed"
    fi

    MASK=$(echo $NETWORK | grep -oP "\d{1,3}$")

    if [ $MASK -lt 24 ]; then
        error_with_message "This script only supports networks with mask greater or equal to 24"
    fi

    lastoctet=$(echo $NETWORK | sed 's/\/.*$//' | grep -oP "\d{1,3}$")
    if [ $lastoctet -gt $FIRST ]; then
        FIRST=$(($FIRST + $lastoctet))
    fi

    NETWORK=$(echo $NETWORK | grep -oP "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" | grep -oP "\b(\d{1,3}\.){2}\d{1,3}\b")

    return 0
}

function display_help {
    echo
    echo ":: Usage: network-block-scan [NETWORK] [-o OUTPUT FILE]"
    echo
    echo ":: NETWORK: The target network to scan. Must have the mask, for example: 192.168.1.1/24" 
    echo ":: OUTPUT: The file to store the output generated. Use '-o | --output'"
    echo ":: EXCEPT: Specify addresses to ignore. Ex: -e 244 243 (only last octet)"
    echo ":: FIRST: Set the first in address to be scanned. Ex: --first 10 (only last octet)"
    echo ":: LAST: Set the last address to be scanned. Ex: -l 254 (only last octet)"
    echo ":: VERBOSE: Operation mode can be specified by '-v|--verbose'"
    echo ":: VERSION: To see the version and useful informations, use '-V|--version'"

    return 0
}

function error_with_message {
    echoerr "[-] Error: $1"
    echoerr ":: Use -h for help"
    exit 1
}

function echoerr {
    cat <<< "$@" 1>&2
}

# Start of script
parse_args $@
main
