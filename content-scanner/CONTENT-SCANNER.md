## Content Scanner
A bash script to find files and directories in a given domain, using burte force approach:  
- Read possible files or directories from wordlist  
- Try every possibility
- Output found files or directories

#### Parameters:
- ```-w | --wordlist```: The wordlist to be used by script.
- ```-e | --exists```: Only output found file and directories. That means, only output http status code 200.
- ```-o | --output-file```: Specify the output file to program.
- ```-v | --verbose```: Set operation mode to verbose, note that this can not be used together with ```--quiet```.
- ```-q | --quiet```: Set operation mode to quiet, note that this can not be used together with ```--verbose```.
- ```-V | --version```: Outputs relevant information about the script.

#### Usage
- Give permition for the file:  
``` chmod +x content-scanner.sh ```

##### Usage examples:
- ``` ./content-scanner.sh www.fbi.gov ```: Use the default wordlist and output status code 20* and 3**.
- ``` ./content-scanner.sh www.github.com -e -w /usr/share/wordlists/blabla.txt```: Specify the wordlist located in ```/usr/share/wordlist/``` to be used instead of the default one and output only directories and files with http status code 200 in the request.
