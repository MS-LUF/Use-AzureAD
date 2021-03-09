---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADGroupMembersWithLicenseErrors

## SYNOPSIS
Get all Azure AD User with licensing error members of a particular group
Get all Azure AD Group containing users with licensing errors

## SYNTAX

```
Get-AzureADGroupMembersWithLicenseErrors [[-inputobject] <Group>] [[-ObjectID] <Guid>] [-All]
 [<CommonParameters>]
```

## DESCRIPTION
Get all Azure AD User with licensing error members of a particular group
Get all Azure AD Group containing users with licensing errors

## EXAMPLES

### EXEMPLE 1
```
Get licensing error info for members of Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureADGroupMembersWithLicenseErrors -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

### EXEMPLE 2
```
Get licensing error info for members of Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureAdGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Get-AzureADGroupMembersWithLicenseErrors

### EXEMPLE 3
```
Get groups containing users with licensing errors
```

C:\PS\> Get-AzureADGroupMembersWithLicenseErrors -All

## PARAMETERS

### -inputobject
-inputobject Microsoft.Open.AzureAD.Model.Group
   Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

```yaml
Type: Group
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
Guid of an existing Azure AD Group object

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

### -All
-All Switch
Use this switch instead of ObjectID to retrieve All groups containing users with licensing errors

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
