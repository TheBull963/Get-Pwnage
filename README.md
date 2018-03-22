# Get-Pwnage
PowerShell script to check HaveIBeenPwned and Hacked-Emails for a breach.

This PowerShell script is used to check an email address against multiple sources for previous data breaches. 

     Parameter options:
         -EmailAddress <emailaddress>
         -Source <HIBP | HE | BOTH>  
        
Example Usage:

     PS C:\>Get-Pwnage -EmailAddress "jdoe@example.com" -Source "HIBP" -Verbose #Results from Have I Been Pwned
     PS C:\>Get-Pwnage -EmailAddress "jdoe@example.com" -Source "HE" -Verbose #Results from Hacked-Emails
     PS C:\>Get-Pwnage -EmailAddress "jdoe@example.com" -Source "HIBP"| Select Title, BreachDate
