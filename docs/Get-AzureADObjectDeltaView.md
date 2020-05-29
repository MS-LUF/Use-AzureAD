---
external help file: Use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADObjectDeltaView

## SYNOPSIS
Get all changes from a delta view for an Azure AD object

## SYNTAX

```
Get-AzureADObjectDeltaView [-inputobject] <Object> [<CommonParameters>]
```

## DESCRIPTION
Get all changes from a delta view for an Azure AD object.
A delta view for an Azure AD object must be created first with New-AzureADObjectDeltaView. 
It can be used on several objects (groups, users, administrative units...) to retrieve change information occured between two moments (properties updated/removed/added, objects updated/removed/added).
A maximum of 30 days changes can be retrieved.

## EXAMPLES

### EXEMPLE 1
```
Get all updates from an initial delta view for manager and department properties of fb01091c-a9b2-4cd2-bbc9-130dfc91452a and 2092d280-2821-45ae-9e47-e9433a65868d users objects previously saved in $delta
```

C:\PS\> $delta = New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department") -FilterIDs @("fb01091c-a9b2-4cd2-bbc9-130dfc91452a","2092d280-2821-45ae-9e47-e9433a65868d") -Verbose
   C:\PS\> Get-AzureADDeltaFromView -inputobject $delta

## PARAMETERS

### -inputobject
-inputobject PSCustomObject
   PSCustomObject generated previously with New-AzureADObjectDeltaView cmdlet

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
