## Network Block Scan
A bash script for scan a especified ip range in a network, searching for alive hosts.

#### Parameters:
- ```-f | --first```: Set the first in address to be scanned. Ex: --first 10 (only last octet).
- ```-l | --last```: Set the last address to be scanned. Ex: -l 254 (only last octet).
- ```-e | --except```: Specify addresses to ignore. Ex: -e 244 243 (only last octet).
- ```-o | --output```: Specify the output file to program.
- ```-v | --verbose```: Set operation mode to verbose, note that this can not be used together with ```--quiet```.
- ```-V | --version```: Outputs relevant information about the script.

#### Usage
- Give permition for the file:  
``` chmod +x network-block-scan.sh ```

- Example:  
- ``` ./network-block-scan.sh 192.168.1.16/29```
- ``` ./network-block-scan.sh 192.168.1.1/24 --first 30 -e 35 36 37 38 -l 200 -o "/tmp/output_file.txt"```  
