---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADMyInfo

## SYNOPSIS
Get all Azure AD account properties of current logged in user

## SYNTAX

```
Get-AzureADMyInfo [<CommonParameters>]
```

## DESCRIPTION
Get all Azure AD account properties of current logged in user.
Note : including hidden properties like extensionattribute.

## EXAMPLES

### EXEMPLE 1
```
Get all user account properties of my current account (my-admin@mydomain.tld)
```

C:\PS\> Get-AzureADMyInfo

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
### Name                            MemberType   Definition
### ----                            ----------   ----------
### Equals                          Method       bool Equals(System.Object obj)
### GetHashCode                     Method       int GetHashCode()
### GetType                         Method       type GetType()
### ToString                        Method       string ToString()
### @odata.context                  NoteProperty string @odata.context=https://graph.microsoft.com/beta/$metadata#users/$entity
### accountEnabled                  NoteProperty bool accountEnabled=True
### ageGroup                        NoteProperty object ageGroup=null
### assignedLicenses                NoteProperty Object[] assignedLicenses=System.Object[]
### assignedPlans                   NoteProperty Object[] assignedPlans=System.Object[]
### businessPhones                  NoteProperty Object[] businessPhones=System.Object[]
### city                            NoteProperty object city=null
### companyName                     NoteProperty object companyName=null
### consentProvidedForMinor         NoteProperty object consentProvidedForMinor=null
### country                         NoteProperty object country=null
### createdDateTime                 NoteProperty string createdDateTime=2020-04-21T15:17:08Z
### creationType                    NoteProperty object creationType=null
### deletedDateTime                 NoteProperty object deletedDateTime=null
### department                      NoteProperty object department=null
### deviceKeys                      NoteProperty Object[] deviceKeys=System.Object[]
### displayName                     NoteProperty string displayName=admin
### employeeId                      NoteProperty object employeeId=null
### externalUserState               NoteProperty object externalUserState=null
### externalUserStateChangeDateTime NoteProperty object externalUserStateChangeDateTime=null
### faxNumber                       NoteProperty object faxNumber=null
### givenName                       NoteProperty string givenName=firsname
### id                              NoteProperty string id=72a50bb8-20cf-494c-969d-fbcd2324b822
### identities                      NoteProperty Object[] identities=System.Object[]
### imAddresses                     NoteProperty Object[] imAddresses=System.Object[]
### infoCatalogs                    NoteProperty Object[] infoCatalogs=System.Object[]
### isResourceAccount               NoteProperty object isResourceAccount=null
### jobTitle                        NoteProperty object jobTitle=null
### legalAgeGroupClassification     NoteProperty object legalAgeGroupClassification=null
### mail                            NoteProperty object mail=null
### mailNickname                    NoteProperty string mailNickname=my-admin
### mobilePhone                     NoteProperty string mobilePhone=
### officeLocation                  NoteProperty object officeLocation=null
### onPremisesDistinguishedName     NoteProperty object onPremisesDistinguishedName=null
### onPremisesDomainName            NoteProperty object onPremisesDomainName=null
### onPremisesExtensionAttributes   NoteProperty System.Management.Automation.PSCustomObject onPremisesExtensionAttributes=@{extensionAttribute1=; extensionAttribute2=; extensionAttribute3=; extensionAttribute...
### onPremisesImmutableId           NoteProperty object onPremisesImmutableId=null
### onPremisesLastSyncDateTime      NoteProperty object onPremisesLastSyncDateTime=null
### onPremisesProvisioningErrors    NoteProperty Object[] onPremisesProvisioningErrors=System.Object[]
### onPremisesSamAccountName        NoteProperty object onPremisesSamAccountName=null
### onPremisesSecurityIdentifier    NoteProperty object onPremisesSecurityIdentifier=null
### onPremisesSyncEnabled           NoteProperty object onPremisesSyncEnabled=null
### onPremisesUserPrincipalName     NoteProperty object onPremisesUserPrincipalName=null
### otherMails                      NoteProperty Object[] otherMails=System.Object[]
### passwordPolicies                NoteProperty object passwordPolicies=null
### passwordProfile                 NoteProperty object passwordProfile=null
### postalCode                      NoteProperty object postalCode=null
### preferredDataLocation           NoteProperty object preferredDataLocation=null
### preferredLanguage               NoteProperty object preferredLanguage=null
### provisionedPlans                NoteProperty Object[] provisionedPlans=System.Object[]
### proxyAddresses                  NoteProperty Object[] proxyAddresses=System.Object[]
### refreshTokensValidFromDateTime  NoteProperty string refreshTokensValidFromDateTime=2020-04-21T15:24:29Z
### showInAddressList               NoteProperty object showInAddressList=null
### signInSessionsValidFromDateTime NoteProperty string signInSessionsValidFromDateTime=2020-04-21T15:24:29Z
### state                           NoteProperty object state=null
### streetAddress                   NoteProperty object streetAddress=null
### surname                         NoteProperty string surname=name
### usageLocation                   NoteProperty string usageLocation=US
### userPrincipalName               NoteProperty string userPrincipalName=my-admin@mydomain.tld
### userType                        NoteProperty string userType=Member
## NOTES

## RELATED LINKS
