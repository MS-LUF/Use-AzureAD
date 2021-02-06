---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADUserAdministrativeUnitMemberOfCustom

## SYNOPSIS
Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta

## SYNTAX

## DESCRIPTION
Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta, using ADAL library, all authentication supported including MFA.
Tenant ID automatically resolved.

## EXAMPLES

### EXAMPLE 1
```
Get tenant info from my useraccount (my-admin@mydomain.tld)
   C:\PS> Get-AzureADTenantInfo -adminUPN my-admin@mydomain.tld
```

### EXAMPLE 2
```
Get tenant info from my service principal tenant domain name (mydomain.tld)
C:\PS> Get-AzureADTenantInfo -ServicePrincipalTenantDomain mydomain.tld
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
