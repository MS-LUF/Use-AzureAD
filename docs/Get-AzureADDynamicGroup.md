---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADDynamicGroup

## SYNOPSIS
Retrieve information about an Azure AD security dynamic group

## SYNTAX

```
Get-AzureADDynamicGroup [[-inputobject] <Group>] [[-ObjectID] <Guid>] [[-DisplayName] <String>] [-All]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieve all available properties about an existing security group with dynamic membership

## EXAMPLES

### EXEMPLE 1
```
Get dynamic group with ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureADDynamicGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

### EXEMPLE 2
```
Get all security group with dynamic membership
```

C:\PS\> Get-AzureADDynamicGroup -all

### EXEMPLE 3
```
Get dynamic group with Dynam_test display name
```

C:\PS\> Get-AzureADDynamicGroup -DisplayName "Dynam_test"

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

### -DisplayName
-DisplayName String
Displayname of an existing Azure AD Group object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
-All switch
swith parameter that can be used to retrieve all existing Azure AD security group with dynamic membership rule

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
