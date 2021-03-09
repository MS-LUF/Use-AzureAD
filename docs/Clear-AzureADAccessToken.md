---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Clear-AzureADAccessToken

## SYNOPSIS
Clear an existing MS Graph APIs and MS Graph APIs Beta Access Token

## SYNTAX

```
Clear-AzureADAccessToken [[-adminUPN] <MailAddress>] [[-ServicePrincipalTenantDomain] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Clear an existing MS Graph APIs and MS Graph APIs Beta Access Token.
Required to be already authenticated.

## EXAMPLES

### EXEMPLE 1
```
clear an access token for my admin account (my-admin@mydomain.tld)
```

C:\PS\> Clear-AzureADAccessToken -adminUPN my-admin@mydomain.tld

### EXEMPLE 2
```
clear an access token for a service principal from mydomain.tld
```

C:\PS\> Clear-AzureADAccessToken -ServicePrincipalTenantDomain mydomain.tld

## PARAMETERS

### -adminUPN
-adminUPN System.Net.Mail.MailAddress
   UserPrincipalName of the Azure AD account currently logged in that you want the access token to be removed

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipalTenantDomain
-ServicePrincipalTenantDomain string
domain name / tenant name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None
## NOTES

## RELATED LINKS
