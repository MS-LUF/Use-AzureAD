---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADAccessToken

## SYNOPSIS
Get a valid Access Token / Refresh Token for MS Graph APIs and MS Graph APIs Beta

## SYNTAX

```
Get-AzureADAccessToken [[-adminUPN] <MailAddress>] [[-ServicePrincipalCertThumbprint] <String>]
 [[-ServicePrincipalApplicationID] <Guid>] [[-ServicePrincipalTenantDomain] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get a valid Access Token / Refresh Token for MS Graph APIs and MS Graph APIs Beta, using ADAL library, all authentication supported including MFA.
Tenant ID automatically resolved.

## EXAMPLES

### EXAMPLE 1
```
Get an access token for my admin account (my-admin@mydomain.tld)
   C:\PS> Get-AzureADAccessToken -adminUPN my-admin@mydomain.tld
```

### EXAMPLE 2
```
Get an access token for service principal with application ID 38846352-a67c-4a9a-a94c-c115be1fc52f and a certificate thumbprint of E22EE5AE84909C49D4BF66C12BF88B2D0A53CDC2
C:\PS> Get-AzureADAccessToken -ServicePrincipalCertThumbprint E22EE5AE84909C49D4BF66C12BF88B2D0A53CDC2 -ServicePrincipalApplicationID 38846352-a67c-4a9a-a94c-c115be1fc52f -ServicePrincipalTenantDomain mydomain.tld
```

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

### -ServicePrincipalCertThumbprint
-ServicePrincipalCertThumbprint string
certificate thumbprint of the certificate to load (local machine certificate only)

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

### -ServicePrincipalApplicationID
-ServicePrincipalApplicationID GUID
guid of the application using the service principal

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Collections.Hashtable+SyncHashtable
## NOTES

## RELATED LINKS
