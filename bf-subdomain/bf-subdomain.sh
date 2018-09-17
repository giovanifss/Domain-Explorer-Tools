#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Brute Force subdomain
#
# Brute force program to locate intern domains of a given website
# 
# This code is under the license GPLv3. See more informations in LICENSE. 
#
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

DOMAIN=                                         # Target domain to brute force
OUTPUT=                                         # To write output to disk
WORDLIST="common-wordlist.txt"                  # Default wordlist
VERBOSE=false                                   # Operation mode verbose

trap "echo; exit 1" INT                         # Trap for abort scritp with sigint

function main {
    echo -e "Bruteforce subdomain started in $(date)\n"

    if [ ! -z $OUTPUT ]; then
        echo -e "Bruteforce subdomain started in $(date)\n" >> $OUTPUT
    fi

    echo "==> Starting bruteforce in $DOMAIN..."

    for subdomain in $(cat $WORDLIST); do
        echo -ne "----> Trying $subdomain.$DOMAIN...                           \r"

        ip=$(host $subdomain.$DOMAIN | grep 'has address' | cut -d ' ' -f 4)
        if [ ! -z "$ip" ]; then
            message="[+] Found subdomain: $(echo $subdomain.$DOMAIN :: $ip)"

            ping -q -W 2 -c1 $subdomain.$DOMAIN &> /dev/null
            if [ $? -eq 0 ]; then                   # Check if host answered ping
                message="$message | State: [UP]"
            else
                message="$message | State: [FILTERED|DOWN]"
            fi

            if [ ! -z $OUTPUT ]; then
                echo "$message" >> $OUTPUT
            fi

            echo "$message"
        fi
    done

    echo -e "==> Finished bruteforce."

    if [ ! -z $OUTPUT ]; then
        echo ":: Results stored in $OUTPUT"
        echo -e "\nBruteforce subdomain finished in $(date)" >> $OUTPUT
    fi

    echo -e "\nBruteforce subdomain finished in $(date)"
}

function parse_args {
    if [ $# -eq 0 ]; then           # Check if at least one arg was passed
        display_help
        exit 1
    fi

    while (( "$#" )); do            # Stays in the loop as long as the number of parameters is greater than 0
        case $1 in                  # Switch through cases to see what arg was passed
            -V|--version) 
                echo ":: Author: Giovani Ferreira"
                echo ":: Source: https://github.com/giovanifss/Domain-Explorer-Tools"
                echo ":: License: GPLv3"
                echo ":: Version: 0.2"
                exit 0;;

            -o|--output)            # Get the next arg to be the output file
                if [ -z $2 ] || [[ $2 == -* ]]; then
                    error_with_message "Expected argument after output file option"
                fi
                OUTPUT=$2
                shift;;             # To ensure that the next parameter will not be evaluated again

            -w|--wordlist)          # Get the next arg to be the output file
                if [ -z $2 ] || [[ $2 == -* ]]; then
                    error_with_message "Expected argument after wordlist option"
                fi
                WORDLIST=$2
                shift;;             # To ensure that the next parameter will not be evaluated again

            -v|--verbose)           # Set the program opeartion mode to verbose 
                if $QUIET; then     # Program can not behave quiet and verbose at same time
                    error_with_message "Operation mode can not be quiet and verbose at the same time"
                fi
                VERBOSE=true;;

            -h|--help)              # Display the help message
                display_help
                exit 0;;

            *)                      # If a different parameter was passed
                if [ ! -z "$DOMAIN" ] || [[ $1 == -* ]]; then
                    error_with_message "Unknow argument $1"
                fi

                DOMAIN=$1;;
        esac
        shift                       # Removes the element used in this iteration from parameters
    done

    if [ -z $DOMAIN ]; then
        error_with_message "The target domain must be passed"
    fi

    if [ ! -e $WORDLIST ]; then                 # Check if wordlist exists
        error_with_message "Unable to locate the wordlist $WORDLIST"
    fi

    return 0
}

function display_help {
    echo
    echo ":: Usage: bf-subdomain [DOMAIN] [-w WORDLIST] [-o OUTPUT FILE] "
    echo
    echo ":: DOMAIN: The target domain lo brute force." 
    echo ":: OUTPUT: The file to store the output generated. Use '-o | --output-file'"
    echo ":: WORDLIST: The path to wordlist to use in the attack. Use '-w | --wordlist'"
    echo ":: VERBOSE: Verbose operation mode can be specified by '-v|--verbose'"
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
