## Domain Explorer
A bash script to solve intern domains of a given url:  
- Ping host from url  
- Download index page  
- Filter index page to get subdomains  
- Solve subdomains through host command  
- Output host's ips  

#### Parameters:
- ```-s | --separator```: The separator to be used in output. The output is ```<domain> <separator> <ip>```.
- ```-c | --contains```: The program will output only the domains that contains the specified string.
- ```-o | --output-file```: Specify the output file to program.
- ```-v | --verbose```: Set operation mode to verbose, note that this can not be used together with ```--quiet```.
- ```-q | --quiet```: Set operation mode to quiet, note that this can not be used together with ```--verbose```.
- ```-V | --version```: Outputs relevant information about the script.

#### Usage
- Give permition for the file:  
``` chmod +x domain-explorer.sh ```

##### Usage examples:
- ```./domain-explorer.sh www.fbi.gov --output-file fbi-domains.txt```: This will parse the information and store in ```fbi-domains.txt```.
- ```./domain-explorer.sh www.github.com -s '::::'```: This will parse the information and use ```::::``` as a separator for domain and ip.
- ```./domain-explorer.sh thehackernews.com --contains 'history'```: This will parse the information but only output domains that contains ```history``` in the url.
