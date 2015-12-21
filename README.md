# Domain Explorer Tools
A collection of some useful bash scripts for domain exploration  

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
- Output founded subdomains  

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

## License
This collection of scripts is under the WTFPL license, you can read more about this in:  
http://www.wtfpl.net/about/
