---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADAdministrativeUnitAllMembers

## SYNOPSIS
Get a valid Access Token / Refresh Token for MS Graph APIs and MS Graph APIs Beta

## SYNTAX

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Collections.Hashtable+SyncHashtable
## NOTES

## RELATED LINKS
