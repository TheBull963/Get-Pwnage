<#
    .SYNOPSIS
        This script will get compromise information from: https://haveibeenpwned.com and https://hacked-emails.com
    
    .DESCRIPTION
        This is used to check an email address against multiple sources for previous data breaches. You can import 
        this module and call it to check accounts.

        Parameter options:
            -EmailAddress <emailaddress>
            -Source <HIBP | HE | BOTH>  
        
    
    .EXAMPLE
                PS C:\>Get-Pwnage -EmailAddress "jdoe@example.com" -Source "HIBP" -Verbose #Results from Have I Been Pwned
                PS C:\>Get-Pwnage -EmailAddress "jdoe@example.com" -Source "HE" -Verbose #Results from Hacked-Emails
                PS C:\>Get-Pwnage -EmailAddress "jdoe@example.com" -Source "HIBP"| Select Title, BreachDate
    
    .NOTES
        Written by: @TheBull963
        
#>    


function Get-Pwnage {
    [CmdletBinding()]

    param (
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,
        [ValidateNotNullOrEmpty()]
        [string]$Source
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


    If ($Source -eq 'hibp') {
        $hibp_URI = "https://haveibeenpwned.com/api/v2/breachedaccount/$EmailAddress"
        $Request = Invoke-WebRequest -Uri $hibp_URI
        $Response = ConvertFrom-Json -InputObject $Request
        Write-Verbose "[*] Getting Results from Have I Been Pwned"
        return $Response

    }
    ElseIf ($Source -eq 'he') {
        $he_URI = "https://hacked-emails.com/api?q=$EmailAddress"
        $Request = Invoke-WebRequest -Uri $he_URI
        $Response = ConvertFrom-Json -InputObject $Request
        Write-Verbose "[*] Getting Results from Hacked-Emails"
        return $Response.data
    }
    ElseIf ($Source -eq 'both'){
        $hibp_URI = "https://haveibeenpwned.com/api/v2/breachedaccount/$EmailAddress"
        $he_URI = "https://hacked-emails.com/api?q=$EmailAddress"
    

        # Get Results from Have I Been Pwned
        Write-Verbose "[*] Getting Results from Have I Been Pwned"
        $Request = Invoke-WebRequest -Uri $hibp_URI
        $Response = ConvertFrom-Json -InputObject $Request

        # Get Results from Hacked Emails
        Write-Verbose "[*] Getting Results from Hacked-Emails"
        $Request2 = Invoke-WebRequest -Uri $he_URI
        $Response2 = ConvertFrom-Json -InputObject $Request2

        $complete = $Response + $Response2.data

        return $complete
    }
    Else {
        Write-Verbose "[!] Invalid Source Chosen. Please Choose HIBP, HE, or BOTH"
    }
}

