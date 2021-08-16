---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADOnPremisesProvisionningErrors

## SYNOPSIS
Get all Azure AD Connect provisionning errors

## SYNTAX

```
Get-AzureADOnPremisesProvisionningErrors [[-filterObjectType] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get all Azure AD Connect provisionning errors for groups, users, contacts object.
Can replace old MSOnline function Get-MsolDirSyncProvisioningError

## EXAMPLES

### EXEMPLE 1
```
Get all Azure AD Connect provisionning errors for all object types
```

C:\PS\> Get-AzureADOnPremisesProvisionningErrors

### EXEMPLE 2
```
Get all Azure AD Connect provisionning errors for all contact object type
```

C:\PS\> Get-AzureADOnPremisesProvisionningErrors -filterObjectType "contacts"

## PARAMETERS

### -filterObjectType
-filterObjectType string
set an object type filter, value must be "users","groups","contacts" or "all" for all object type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: All
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
