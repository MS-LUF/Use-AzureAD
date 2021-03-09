---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Test-AzureADUserForGroupDynamicMembership

## SYNOPSIS
Check if a Azure AD user is a member of an Azure AD security dynamic group

## SYNTAX

```
Test-AzureADUserForGroupDynamicMembership [[-inputobject] <Group>] [[-ObjectID] <Guid>] [-MemberID] <Guid>
 [[-MemberShipRule] <String>] [<CommonParameters>]
```

## DESCRIPTION
Check if a Azure AD user is a member of an Azure AD security dynamic group

## EXAMPLES

### EXEMPLE 1
```
Test if ca57f8b0-0c86-4677-8167-7d37534bd3bc object user account is member of 53cf95f1-49be-463e-9856-77c2b2c3e4a0 dynamic group using a specific rule
```

C:\PS\> Test-AzureADUserForGroupDynamicMembership -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -MemberID ca57f8b0-0c86-4677-8167-7d37534bd3bc -MemberShipRule 'user.extensionAttribute9 -eq "test2"'

### EXEMPLE 2
```
Test if ca57f8b0-0c86-4677-8167-7d37534bd3bc object user account is member of 53cf95f1-49be-463e-9856-77c2b2c3e4a0 dynamic group
```

C:\PS\> Test-AzureADUserForGroupDynamicMembership -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -MemberID ca57f8b0-0c86-4677-8167-7d37534bd3bc

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

### -MemberID
-MemberID Guid
Guid of an Azure AD user account that you want to test from a membership perspective of the group

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberShipRule
-MembershipRule string
Membership rule (string) of dynamic group you want to test.
More info about rule definition here : https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-dynamic-membership

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
