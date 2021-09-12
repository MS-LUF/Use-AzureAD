---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADTenantInfo

## SYNOPSIS
Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta

## SYNTAX

```
Get-AzureADTenantInfo [[-adminUPN] <MailAddress>] [[-ServicePrincipalTenantDomain] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta, using ADAL library, all authentication supported including MFA.
Tenant ID automatically resolved.

## EXAMPLES

### EXEMPLE 1
```
Get tenant info from my useraccount (my-admin@mydomain.tld)
```

C:\PS\> Get-AzureADTenantInfo -adminUPN my-admin@mydomain.tld

### EXEMPLE 2
```
Get tenant info from my service principal tenant domain name (mydomain.tld)
```

C:\PS\> Get-AzureADTenantInfo -ServicePrincipalTenantDomain mydomain.tld

## PARAMETERS

### -adminUPN
-adminUPN System.Net.Mail.MailAddress
UserPrincipalName of an Azure AD account with rights on Directory (for instance a user with Global Admin right)

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
Tenant domain name of your Service Principal account

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

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
