# Domain Explorer Tools
A collection of some useful bash scripts for information gathering and domain exploration.  

## Domain Explorer
A bash script to solve intern domains of a given url:  
- Ping host from url  
- Download index page  
- Filter index page to get subdomains  
- Solve subdomains through host command  
- Output host's ips  

#### Usage
- Give permition for the file:  
``` chmod +x domain-explorer.sh ```

- Execute passing the desired url to find hosts:  
``` ./domain-explorer.sh <your desired url> ```

- The hosts and address will be in hosts.txt file  

## Brute Force Subdomain
A bash script to find subdomains of a given url, using brute force approach:  
- Read possible subdomains from wordlist  
- Try every possibility  
- Output found subdomains  

#### Usage
- Give permition for the file:  
``` chmod +x bf-subdomain.sh ```

- Execute passing the desired url to find hosts (without the 'www'):  
``` ./bf-subdomain.sh <your desired url> ```

- Passing wordlist:  
You can pass your own wordlist for brute force:  
``` ./bf-subdomain.sh <your desired url> <path-to-your-wordlist>```

- Example:  
``` ./bf-subdomain.sh facebook.com```  
``` ./bf-subdomain.sh facebook.com mywordlist.txt```

## Content Scanner
A bash script to find files and directories in a given domain, using burte force approach:  
- Read possible files or directories from wordlist  
- Try every possibility
- Output found files or directories

#### Usage
- Give permition for the file:  
``` chmod +x content-scanner.sh ```

- Execute passing the desired url to find hosts (without the 'www'):  
``` ./content-scanner.sh <your desired url> ```

- Passing wordlist:  
You can pass your own wordlist for brute force:  
``` ./content-scanner.sh <your desired url> <path-to-your-wordlist>```

## Network Block Scan
A bash script for scan a especified ip range in a network, searching for alive hosts.

#### Usage
- Give permition for the file:  
``` chmod +x network-block-scan.sh ```

- Execute passing the first 3 octets of the network's ip, the first host to be scanned and the last host to be scanned:  
``` ./network-block-scan.sh <first-3-octets-network-ip> <first-host-to-scan> <last-host-to-scan>```

- Example:  
``` ./network-block-scan.sh 216.58.202 100 150```  
This will search all alive hosts in 216.58.202.100 ~ 216.58.202.150  

## Zone Transfer
A bash script for try a zone transfer in a given domain  

#### Usage
- Give permition for the file:  
``` chmod +x zone-transfer.sh ```

- Execute passing the target for a zone transfer:  
``` ./zone-transfer.sh <domain for attempt>```

## License
This collection of scripts is under the GPLv3 license  
See LICENSE for more details  
