---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Set-AzureADDynamicGroup

## SYNOPSIS
Update properties of an existing Azure AD security dynamic group

## SYNTAX

```
Set-AzureADDynamicGroup [[-inputobject] <Group>] [[-ObjectID] <Guid>] [[-NewDisplayName] <String>]
 [[-NewDescription] <String>] [[-NewMemberShipRule] <String>] [-DisableRuleProcessingState]
 [-EnableRuleProcessingState] [<CommonParameters>]
```

## DESCRIPTION
Update properties of an existing Azure AD security dynamic group, including processing state of the rule.

## EXAMPLES

### EXEMPLE 1
```
Update existing dynamic group 17a58653-3654-40bd-85ce-333ece486793 with a new description and membership rule
```

C:\PS\> Set-AzureADDynamicGroup -ObjectId 17a58653-3654-40bd-85ce-333ece486793 -NewDescription "test description" -NewMemberShipRule '(user.extensionAttribute1 -eq "test2")'

### EXEMPLE 2
```
Update existing dynamic group 17a58653-3654-40bd-85ce-333ece486793 to disable processing state of the current rule
```

C:\PS\> Set-AzureADDynamicGroup -ObjectId 17a58653-3654-40bd-85ce-333ece486793 -DisableRuleProcessingState

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

### -NewDisplayName
-NewDisplayName String
Displayname of the new group

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

### -NewDescription
-NewDescription String
Description of the new group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewMemberShipRule
-NewMembershipRule string
Membership rule (string) of the dynamic group.
More info about rule definition here : https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-dynamic-membership

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableRuleProcessingState
-DisableRuleProcessingState Switch
Disable processing state of the current rule

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

### -EnableRuleProcessingState
-EnableRuleProcessingState Switch
Enable processing state of the current rule

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
