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

### EXAMPLE 1
```
Get all user account properties of my current account (my-admin@mydomain.tld)
C:\PS> Get-AzureADMyInfo
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
