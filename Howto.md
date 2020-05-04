![image](http://www.lucas-cueff.com/files/gallery.png)

# Use-AzureAD - How-To

## ChangeLog
### v0.5 first public release - beta version
### v0.6 last public release - beta version
- add example on Cloud provisionning schema operation (get / update)
Enjoy your AzureAD stuff with Power[Shell](Of Love)

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
Now, you can also use the same token to use MSOnline module
```
    C:\PS> Connect-MSOnlineFromAccessToken
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
### Example 6
Before playing with this use case, please take a look at the basic here : https://docs.microsoft.com/en-us/azure/active-directory/cloud-provisioning/tutorial-pilot-aadc-aadccp
I have just installed Azure AD Connect Cloud Provisionning for one of our affiliates with its own AD forest (myaffiliate.xyz). My provisionning agent is in place and I have started to sync a pilot OU for testing purpose but the default rules sync applied don't fit my need, I want to check them first then modify them.
Ok, first step, Get the current schema (including directory attributes definition, objectmappings / ruleset and so on :-) ). This schema is available for each provisionning agent installed and this schema is a copy of a default schema available for Azure AD Connect Cloud Provisionning.
So first, get the current schema for your affiliate myaffiliate.xyz
```
    C:\PS> $schema = Get-AzureADConnectCloudProvisionningServiceSyncSchema -OnPremADFQDN "myaffiliate.xyz" -Verbose
```
#### Understanding the Schema
Take a look at the PSCustomObject generated. You can find all the classic "schema" (ldap speaking), it means, all definition of attributes (name, type...). For instance, take a look of the azure AD one :
```
    C:\PS> ($schema.directories | Where-Object {$_.name -eq "Azure Active Directory"}).objects.attributes
```
Look at the properties :
```
    anchor            NoteProperty bool anchor=False
    caseExact         NoteProperty bool caseExact=False
    defaultValue      NoteProperty object defaultValue=null
    metadata          NoteProperty Object[] metadata=System.Object[]
    multivalued       NoteProperty bool multivalued=False
    mutability        NoteProperty string mutability=ReadWrite
    name              NoteProperty string name=AccountEnabled
    referencedObjects NoteProperty Object[] referencedObjects=System.Object[]
    required          NoteProperty bool required=False
```
For instance, look at the first property : anchor as boolean ==> it means you can use this property of an attribute to add a new source anchor / immutable id source for your sync :)
Now, take a look objectmappings for the user class / object, it will give us all the default sync rules for the users object (attribute and related mapping, including transformation rules as your on premise Azure AD Connect instance) :
```
    C:\PS> $schema.synchronizationRules.objectmappings | Where-Object {$_.name -like "*users*"}
```
Now, we will look closer to one of your key mapping attribute : userprincipalname :
```
    C:\PS> ($schema.synchronizationRules.objectmappings | Where-Object {$_.name -like "*users*"}).attributemappings | Where-Object {$_.targetattributename -eq "userprincipalname"}
```
```
    defaultValue            :
    exportMissingReferences : False
    flowBehavior            : FlowWhenChanged
    flowType                : Always
    matchingPriority        : 0
    targetAttributeName     : UserPrincipalName
    source                  : @{expression=IIF(IsPresent([userPrincipalName]), [userPrincipalName], IIF(IsPresent([sAMAccountName]), Join("@", [sAMAccountName], ), Error("AccountName is not present")));
                            name=IIF; type=Function; parameters=System.Object[]}
```
Look, closer at the source property... If you know the default transformation rule of Azure AD Connect, it will look familiar to you :)
Now, to conclude, zoom on the source property of this object mapping attribute :
```
    expression                                                                                                                                                     name type     parameters
    ----------                                                                                                                                                     ---- ----     ----------
    IIF(IsPresent([userPrincipalName]), [userPrincipalName], IIF(IsPresent([sAMAccountName]), Join("@", [sAMAccountName], ), Error("AccountName is not present"))) IIF  Function {@{key=one; value=}, @{key=four;...
```
You can see you can use all the functions (VBA style) already available with on premise Azure AD Connect (or the old Forefront Identity Manager...)
More information here : https://docs.microsoft.com/en-us/azure/active-directory/cloud-provisioning/reference-expressions
If you want to use a complex expression like this one, you must split your expression by function in sub object... Take a look :)
#### Updating the Schema
Well well, I think I am now ready to play with the schema and inplement several updates to take into account the specific use case of my affiliate : myaffiliate.xyz
So, here is my wishlist :
- set my cloud userprincipalname matching my on premise mail adress (hosted in mail attribute in my local AD)
- enable all my account by default because I am synchronizing a ressource forest with all my account disabled
- change my source anchor value matching my on premise attribute EmployeeID
Before starting, a "nice" warning :) **only object mapping update is supported by Micro$osft** even if you can rewrite all the schema from scratch (and it works well, I have played with it :) ) It's not supported to modify the source anchor for instance. But at the end, technically it works well :)
Note : To simplify my use case, I have decided to remove completly the objectmappings for contacts, groups, inetorgperson and keep only users (not supported by much easier to parse for checking / testing purpose). So I also had to update the schema directory to remove the reference to group/inetorperson/contact class of my attributes to have a valid schema.
##### userprincipalname use case
First thing to do : duplicate your schema object to be sure you can restore it quickly in case of emergency :)
```
    C:\PS> $newschema = $schema | select-object *
```
Now, let's go for our first update, changing the userprincipalname mapping. Basically we want to implement a basic mapping attribute to attribute without any advanced sync functions... Easy / peasy :-)
I give you the soluce :
```
    defaultValue            :
    exportMissingReferences : False
    flowBehavior            : FlowWhenChanged
    flowType                : Always
    matchingPriority        : 0
    targetAttributeName     : UserPrincipalName
    source                  : @{expression=[mail]; name=mail; type=Attribute; parameters=System.Object[]}
```
```
    C:\PS> (($newschema.synchronizationRules.objectmappings | Where-Object {$_.name -like "*users*"}).attributemappings | Where-Object {$_.targetattributename -eq "userprincipalname"}).source
```
We need to modify the source attribute of our objectmapping entry UserPrincipalName :
- expression : [mail] (string)
  - we need to use [] when we use attribute, like in Azure AD Connect on premise sync rule
- name : mail (string)
  - copy / paste from the expression without []
- type : Attribute (string)
  - here we can use several values depending on what we want to do, for instance : **Attribute** for a basic attribute to attribute mapping (our use case), or **Constant** if you want to set a value (boolean, string, integer) to an attribute or also **Function** if you want to use a sync function (Like expression in Azure AD Connect if you know how it works).
- parameters : empty array ==> @()
  - to be used with functions mainly, you must set it to an empty powershell array if you don't use it like in our use case ==> or the JSON generated won't be compliant.
**big fucking warning : everything is case sensitive, so be careful !!!!**
Now our update is done locally on our new schema $newschema, let's to the update !
```
    C:\PS> Update-AzureADConnectCloudProvisionningServiceSyncSchema -OnPremADFQDN "myaffiliate.xyz" -inputobject $newschema
```
If everything is ok, you will just receive a warning from the cmdlet because you receive an empty response from the API (normal behavior). If the schema is KO, you will receive a bad request error.
##### enable disabled account / enable signin for disabled on prem account
This trick can be useful especially when you are dealing with complex environment. For instance : building a dedicating consolidated AD Forest hosting all your objects because your AD environemnt is to complex to be synchronized "as is".
Again, you should download your current schema, copy the object and start to play with the new one ;-)
Now, let's go for the second update, changing AccountEnabled mapping. Basically we want to implement a boolean constant to "True" to enable the cloud account whatever our on prem status (in real life, my advice is to manage through a Function instead of Constant and tag your account with another attribute when you want to enable it or not).
I give you the soluce :
```
    defaultValue            :
    exportMissingReferences : False
    flowBehavior            : FlowWhenChanged
    flowType                : Always
    matchingPriority        : 0
    targetAttributeName     : AccountEnabled
    source                  : @{expression="True"; name=True; type=Constant; parameters=System.Object[]}
```
```
    C:\PS> (($newschema.synchronizationRules.objectmappings | Where-Object {$_.name -like "*users*"}).attributemappings | Where-Object {$_.targetattributename -eq "accountenabled"}).source
```
We need to modify the source attribute of our objectmapping entry AccountEnabled :
- expression : '"True"' (string)
  - we need to double quote it, so protect it with simple quote
- name : True (string)
  - copy / paste from the expression without []
- type : Constant (string)
- parameters : empty array
And, again, when ready, just do the update :)
### Example 7
I gave you two Azure AD Connect Cloud Provisionning schema sample I have made with the following update :
#### Azure_Cloud_Provisionning-Sample1
https://github.com/MS-LUF/Use-AzureAD/blob/master/sample/Azure_Cloud_Provisionning-Sample1.json
- Remove contact, group, inetorperson sync
- Update directory schema to exclude those class from the attributes
- SourceAnchor update to use EmployeeID (both directory schema and objectmapping rule)
- use mail as UserPrincipalName
#### Azure_Cloud_Provisionning-Sample2
https://github.com/MS-LUF/Use-AzureAD/blob/master/sample/Azure_Cloud_Provisionning-Sample2.json
The schema generated by the Example 6 part ;-)
- Remove contact, group, inetorperson sync
- Update directory schema to exclude those class from the attributes
- enable all account (AccountEnabled set to true)
- use mail as UserPrincipalName
### Example 8
I have lost my schema backup, everything is broken, help ! No problemo, Azure AD have a lot of templates object available and guess why, there is one available for the schema (ID : AD2AADProvisioning).
So basically, you can rebuild your default schema based on this template :)
Let's get the default schema !
```
    C:\PS> $defaultschema = Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema -OnPremADFQDN "myaffiliate.xyz"
```
```
    C:\PS> $default.schema
```
Now you can restore part of your schema with the default values available then update it again online :-)