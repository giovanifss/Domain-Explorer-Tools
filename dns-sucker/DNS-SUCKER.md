## DNS Sucker
A bash script to automate DNS info gather  

#### Parameters:
- ```-e | --except```: Do not execute specific queries.
- ```-o | --output```: Specify the output file to program.
- ```-v | --verbose```: Set operation mode to verbose.
- ```-a | --all```: Execute all possible DNS queries, except the ones pointed in ```-e|--except```
- ```-V | --version```: Outputs relevant information about the script.

#### Usage
- Give permition for the file:  
``` chmod +x dns-sucker.sh ```

##### Usage examples:
- ```./dns-sucker.sh www.fbi.gov --output fbi-dns.txt --except MX PTR```
