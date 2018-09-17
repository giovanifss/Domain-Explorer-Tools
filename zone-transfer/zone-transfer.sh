#!/bin/bash

#------------------------------------------------------------------------------------------------------------
# Zone Transfer
#
# Program for query DNS servers of the domain and try to get the full zone file.
# 
# Developer - Giovani Ferreira
#------------------------------------------------------------------------------------------------------------

OUTPUT="zone_file.txt"                  # Output file of the program
URL=""                                  # Target url for the attack
QUIET=false                             # Operation mode quiet
VERBOSE=false                           # Operation mode verbose
SEPARATOR="::"                          # The separator in output

function main {
    echo -e "Zone transfer started in $(date)\n" | tee -a $OUTPUT

    if ! $QUIET; then
        echo "==> Starting zone transfer attempt in $URL"
    fi

    for server in $(host -t ns $URL | cut -d " " -f 4); do              # Discover all Name Servers of the domain
        if $VERBOSE; then
            echo "---> Trying zone transfer in $server"
        fi

        if $VERBOSE; then
            host -l $URL $server | grep -E 'has address|name server' | sed 's/\.$//' | awk -F ' ' '{print $1"%%"$4}' | sed -e "s/\%\%/$SEPARATOR/g" | tee -a $OUTPUT;
        else
            host -l $URL $server | grep -E 'has address|name server' | sed 's/\.$//' | awk -F ' ' '{print $1"%%"$4}' | sed -e "s/\%\%/$SEPARATOR/g" >> $OUTPUT;
        fi

        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo -e "[+] Successful zone transfer in server: $server\n:: Results are in $OUTPUT"
            echo -e "\nZone transfer finished in $(date)" | tee -a $OUTPUT
            exit 0
        fi

        echoerr "[-] Failed zone transfer in $server"                   # If zone transfer was not successful
    done

    echoerr "[-] Unable to do zone transfer in $URL"                    # If the program still running, there are no results
    echo -e "\nZone transfer finished in $(date)" | tee -a $OUTPUT

    exit 1
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

            -s|--separator)         # Get the separator to display the output
                if [ -z $2 ] || [[ $2 == -* ]]; then
                    error_with_message "Expected argument after separator option"
                fi
                SEPARATOR=$2
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
    echo ":: Usage: zone-trasfer [URL] [-o OUTPUT FILE] [ -s --SEPARATOR ]"
    echo
    echo ":: URL: The target url to gather information. MUST be a reachable domain."
    echo ":: OUTPUT: The file to store the output generated. Use '-o | --output-file'"
    echo ":: SEPARATOR: The separator of the domain found and the IP in output. Ex: hide.google.com::200.175.224.99 Separator='::'"
    echo ":: VERBOSE|QUIET: Operation mode can be specified by '-v|--verbose' or '-q|--quiet'"
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

parse_args $@
main
