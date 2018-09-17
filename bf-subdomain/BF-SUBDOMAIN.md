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
