---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Remove-AzureADDynamicGroup

## SYNOPSIS
Delete an existing Azure AD security dynamic group

## SYNTAX

```
Remove-AzureADDynamicGroup [[-inputobject] <Group>] [[-ObjectID] <Guid>] [<CommonParameters>]
```

## DESCRIPTION
Delete an existing Azure AD security dynamic group

## EXAMPLES

### EXEMPLE 1
```
Remove an existing group named Dynam_test2 (displayname)
```

C:\PS\> Get-AzureADGroup -SearchString 'Dynam_test2' | Remove-AzureADDynamicGroup

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
