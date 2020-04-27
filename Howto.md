![image](http://www.lucas-cueff.com/files/gallery.png)

# Use-AzureAD - How-To

## ChangeLog
**first public release - beta version**. Enjoy your AzureAD stuff with Power[Shell](Of Love)

(c) 2020 lucas-cueff.com Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).

## Prerequisites
### Set your internet proxy if you need
This is an optionnal step. If you are using a proxy infrastructure to access Azure AD portal and APIs, you must use the following cmdlet to set it.
Note : you can also use this cmdlet to do local Man In The Middle scenario to debug and learn about MS Graph APIs... I did it on all AzureAD cmdlets to learn about OData implementation by the Azure team...
For instance, if you have fiddler installed on your PC :
```
    C:\PS> Set-AzureADProxy -Proxy "http://127.0.0.1:8888"
```
### Get an access token for MS Graph Beta API
First thing to do is to request your Access Token, so the other cmdlet will be able to built the bearer token header to deal with MS API authorization :
```
    C:\PS> Get-AzureADAccessToken -adminUPN my-admin@mydomain.tld
```
The token is hosted in a global variable (a custom PS Object) that is shared by all other cmdlets : 
```
    C:\PS> $global:AADConnectInfo
```
This token will give you access to all APIs of MS Graph Beta.
MFA is supported of course for this authentication, you can renew your token using the same cmdlet every two hours without having the need to be re-authenticated.
### Use your access token to get an access for classic MS Graph API used by Azure AD MS modules
When you will have your Access Token, we can use it to request another access to MS Graph API v1.0 (graph.windows.net) used by AzureAD and AzureADPreview modules
```
    C:\PS> Connect-AzureADFromAccessToken
```

## Output of Use-AzureAD functions / cmdlets
Depending on cmdlet, output could be a PSCustomObject (TypeName: System.Management.Automation.PSCustomObject) or a Microsoft.Open.AzureAD.Model (TypeName : Microsoft.Open.AzureAD.Model.xxxx)
When I am dealing directly with APIs you will find PSCustomObject, when I am wrapping AzureAD cmdlet you will find Microsoft.Open.AzureAD.Model

## Input of Use-AzureAD functions / cmdlets
You can pipe object to several functions :-)
For instance Get-AzureADUserAllInfo function will accept an object from get-azureaduser
```
    C:\PS> C:\PS> get-azureaduser -ObjectId "my-admin@mydomain.tld" | Get-AzureADUserAllInfo
```

## Help on cmdlets / functions
Get-help is available on all functions, for instance, if you want to consult the help section of Get-AzureADUserAllInfo (input, output, description and examples are available)
```
    C:\PS>Get-Help Get-AzureADUserAllInfo -full
```
## Practice example
Hereunder find a couple of "real" use case playing with the functions provided in my module.
### Example 1
I have set a couple of user tag in my on premise AD using ExtensionAttribute1 to ExtensionAttribute9. Those attributes are synchronized in the cloud using Azure AD Connect and I would like to get these values for a user account in order to troubleshoot a current issue.
My account is user1
Well, quite simple :)
```
    C:\PS> get-azureaduser -ObjectId "user1@mydomain.tld" | Get-AzureADUserAllInfo
```
or 
```
    C:\PS> Get-AzureADUserAllInfo -userUPN "user1@mydomain.tld"
```
### Example 2
In my on prem' AD I have organized my object in root Organizational Unit and I want to create one Azure AD Administrative Unit for each of them.
```
    C:\PS> Sync-ADOUtoAzureADAdministrativeUnit -AllRootOU
```
### Example 3
Nice, now my Administrative Units are set in the cloud based on my on prem' OU logical organization. Now, I want to add users in each of my on prem' OU in the target Administrative Unit. Is this possible ?
Of course :), one question, @ the cloud, you are using your on prem UPN or mail to be logged in ?
mail
ok, let's do it.
```
    C:\PS> Sync-ADUsertoAzureADAdministrativeUnitMember -CloudUPNAttribute mail -AllRootOU -Verbose
```
A warning guys, because there is no batch mode available for now and also because nothing is supported by MS, I have to do it, entry by entry so it could take several times depending on the amount of users.
For instance, I have made some bench for an AD containing 11 000 users accounts :
```
    C:\PS> Measure-command {Sync-ADUsertoAzureADAdministrativeUnitMember -CloudUPNAttribute mail -AllRootOU -Verbose}

    Days              : 0
    Hours             : 0
    Minutes           : 43
    Seconds           : 43
    Milliseconds      : 160
    Ticks             : 26231607340
    TotalDays         : 0.0303606566435185
    TotalHours        : 0.728655759444444
    TotalMinutes      : 43.7193455666667
    TotalSeconds      : 2623.160734
    TotalMilliseconds : 2623160.734
```
It means it takes ~45 minutes to add 10 000 users in an cloud Admin Unit. Advice, use the parameter verbose so you can follow in live the action and see what is going on.
### Example 4
One of my colleague added a couple of more users manually in one of our cloud Admin Unit containing 10 000 users. I want to list all members of one of my admin unit to see who is in or not. The admin unit is TP-AL
Easy peasy :)
```
    C:\PS> Get-AzureADAdministrativeUnit -Filter "displayname eq 'TP-AL'" | Get-AzureADAdministrativeUnitAllMembers
```
A warning guys, It could take several times to parse all objects in one Admin unit especially if you have thousand and thousand of objects to list.
For instance, I have made some bench with and admin unit containing 10 000 users :
```
    C:\PS> Measure-command {Get-AzureADAdministrativeUnit -Filter "displayname eq 'TP-AL'" | Get-AzureADAdministrativeUnitAllMembers}
    Days              : 0
    Hours             : 0
    Minutes           : 3
    Seconds           : 0
    Milliseconds      : 234
    Ticks             : 1802343408
    TotalDays         : 0,00208604561111111
    TotalHours        : 0,0500650946666667
    TotalMinutes      : 3,00390568
    TotalSeconds      : 180,2343408
    TotalMilliseconds : 180234,3408
```
It means it takes 3 minutes to parse / list the 10 000 users objects of this admin unit. Unfortunately MS did not implement all paging features of the ODATA 3.0 core protocol, it means we have to list everything to be able to count for instance... A shame is'n it ?
### Example 5
I have my admin unit created, my users added, but now I need to delegate rights on this admin unit to a user. For instance, I want to delegate the right to manage users account of my admin unit TP-AL to a user account called user1
Ok, let's go !
```
    C:\PS> Set-AzureADAdministrativeUnitAdminRole -userUPN user1@mydomain.tld -RoleAction ADD -AdministrativeUnit TP-AL -AdministrativeRole 'User Account Administrator' -Verbose
```