---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADUserLicenseAssignmentStates

## SYNOPSIS
Get licensing assignment type (group or user) of a particular user

## SYNTAX

```
Get-AzureADUserLicenseAssignmentStates [[-inputobject] <User>] [[-ObjectID] <Guid>] [<CommonParameters>]
```

## DESCRIPTION
Get licensing assignment type (group or user) of a particular user.
You can check if the license is assigned directly or inherited from a group membership.

## EXAMPLES

### EXEMPLE 1
```
Get licensing assignment info for Azure AD user fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureADUserLicenseAssignmentStates -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

### EXEMPLE 2
```
Get licensing assignment info for Azure AD user fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureAdUser -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Get-AzureADUserLicenseAssignmentStates

## PARAMETERS

### -inputobject
-inputobject Microsoft.Open.AzureAD.Model.User
   Microsoft.Open.AzureAD.Model.User generated previously with Get-AzureADUser cmdlet

```yaml
Type: User
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ObjectID
-ObjectID Guid
Guid of an existing Azure AD User object

```yaml
Type: Guid
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
