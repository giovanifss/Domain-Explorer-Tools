#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Content Scanner
#
# Script for discover files and directories in the given domain
# 
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

OUTPUT="content.txt"                # File name for the content discovered
WORDLIST="content-wordlist.txt"     # Set the default wordlist file
URL=""                              # The target url
QUIET=false                         # Operation mode quiet
VERBOSE=false                       # Operation mode verbose
ONLYOK=false                        # Operation mode only exist

function main {
    if [ ! -e $WORDLIST ]; then                                             # Check if the wordlist exists
        error_with_message "Unable to locate the wordlist $WORDLIST"        # Abort the script execution
    fi

    echo -e "Content scanner started in $(date)\n" | tee -a $OUTPUT
    
    if ! $QUIET ; then
        echo "==> Starting brute force in $URL..."                          # Feedback for the user
    fi
    
    for attempt in $(cat $WORDLIST); do                                     # Read the wordlist and attempt every possibility
        echo -ne "--> Trying for $URL/$attempt/                              \r"
        resp=$(curl -s -o /dev/null -w "%{http_code}" $URL/$attempt/)       # Checking for file in domain

        regex=""

        if $VERBOSE; then
            regex="^[0-9]"
        else
            if $ONLYOK; then
                regex="^2"
            else
                regex="^[23]"
            fi
        fi

        if ! [[ $resp =~ $regex ]]; then                                    # If query return http code 1* or 4* or 5*
            echo -ne "--> Trying for $URL/$attempt                           \r"

            resp=$(curl -s -o /dev/null -w "%{http_code}" $URL/$attempt)    # Check for directory in domain

            if [[ $resp =~ $regex ]]; then                                  # If query return http code 1* or 4* or 5*
                echo "[+] File Found: $(echo $URL/$attempt :: $resp | tee -a $OUTPUT)" 
            fi
        else                                                                # If file exists
            echo "[+] Directory Found: $(echo $URL/$attempt/ :: $resp | tee -a $OUTPUT)"  
        fi
    done

    if ! $QUIET ; then
        echo "==> Finished brute force in $URL"
        echo ":: Results stored in $OUTPUT"                                 # Showing the location of the result
    fi

    echo -e "\nContent scanner started in $(date)" | tee -a $OUTPUT

    return 0
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

            -o|--output-file)       # Get the next arg to be the output file
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


            -q|--quiet)             # Set the program operation mode to quiet
                if $VERBOSE; then   # Program can not behave quiet and verbose at same time
                    error_with_message "Operation mode can not be quiet and verbose at the same time"
                fi
                QUIET=true;;

            -v|--verbose)           # Set the program opeartion mode to verbose 
                if $QUIET; then     # Program can not behave quiet and verbose at same time
                    error_with_message "Operation mode can not be quiet and verbose at the same time"
                fi
                VERBOSE=true;;

            -e|--exists)
                ONLYOK=true;;

            -h|--help)              # Display the help message
                display_help
                exit 0;;

            *)                      # If a different parameter was passed
                if [ ! -z "$URL" ] || [[ $1 == -* ]]; then
                    error_with_message "Unknow argument $1"
                fi

                URL=$1;;
        esac
        shift                       # Removes the element used in this iteration from parameters
    done

    if [ -z $URL ]; then
        error_with_message "The target url must be passed"
    fi

    return 0
}

function display_help {
    echo
    echo ":: Usage: domain-explorer [URL] [-w WORDLIST] [-o OUTPUT FILE] "
    echo
    echo ":: URL: The target url to gather information. MUST be a reachable domain."
    echo ":: OUTPUT: The file to store the output generated. Use '-o | --output-file'"
    echo ":: WORDLIST: The path to wordlist to use in the attack. Use '-w | --wordlist'"
    echo ":: VERBOSE|QUIET: Operation mode can be specified by '-v|--verbose' or '-q|--quiet'"
    echo ":: VERSION: To see the version and useful informations, use '-V|--version'"
    echo ":: EXIST: Return only file that exists, that means, only http status code of 200. Use '-e|--exists'"

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

#-----------------------------------------------------------------------------------------------------------------------------
# Start of the script
#   - Parse arguments
#   - Gather information from url
#-----------------------------------------------------------------------------------------------------------------------------
parse_args $@
main
