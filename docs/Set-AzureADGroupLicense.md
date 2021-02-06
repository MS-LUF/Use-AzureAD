---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Set-AzureADGroupLicense

## SYNOPSIS
Add / remove Azure AD administrative unit role to Azure AD user

## SYNTAX

## DESCRIPTION
Add / remove Azure AD administrative unit role to Azure AD user

## EXAMPLES

### EXAMPLE 1
```
Give the role Password Administrator for the Admin unit TP-NF to my-admin-unit@mydomain.tld
C:\PS> Set-AzureADAdministrativeUnitAdminRole -userUPN my-admin-unit@mydomain.tld -RoleAction ADD -AdministrativeUnit TP-NF -AdministrativeRole 'Password Administrator' -Verbose
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : Microsoft.Open.AzureAD.Model.ScopedRoleMembership
## NOTES

## RELATED LINKS
