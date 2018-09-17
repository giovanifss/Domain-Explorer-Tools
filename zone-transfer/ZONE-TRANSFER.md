## Zone Transfer
A bash script for zone transfer in a given domain  

#### Parameters:
- ```-s | --separator```: The separator to be used in output. The output is ```<domain> <separator> <ip>```.
- ```-o | --output-file```: Specify the output file to program.
- ```-v | --verbose```: Set operation mode to verbose, note that this can not be used together with ```--quiet```.
- ```-q | --quiet```: Set operation mode to quiet, note that this can not be used together with ```--verbose```.
- ```-V | --version```: Outputs relevant information about the script.

#### Usage
- Give permition for the file:  
``` chmod +x zone-transfer.sh ```

- Execute passing the target for a zone transfer:  
``` ./zone-transfer.sh <target domain>```
