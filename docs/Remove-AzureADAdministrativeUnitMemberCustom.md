---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Remove-AzureADAdministrativeUnitMemberCustom

## SYNOPSIS
Create a new delta view for an Azure AD object

## SYNTAX

## DESCRIPTION
Create a new delta view for an Azure AD object.
It can be used on several objects (groups, users, administrative units...) to retrieve change information occured between two moments (properties updated/removed/added, objects updated/removed/added).
This cmdlet create the initial view (available at server side for 30 days maximum) and the cmdlet Get-AzureADObjectDeltaView will retrieve the changes occured between the first view creation.

## EXAMPLES

### EXAMPLE 1
```
Create an initial delta view for manager and department properties of all users objects
   C:\PS> New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department")
```

### EXAMPLE 2
```
Create an initial delta view for manager and department properties of fb01091c-a9b2-4cd2-bbc9-130dfc91452a and 2092d280-2821-45ae-9e47-e9433a65868d users objects
C:\PS> New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department") -FilterIDs @("fb01091c-a9b2-4cd2-bbc9-130dfc91452a","2092d280-2821-45ae-9e47-e9433a65868d") -Verbose
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
