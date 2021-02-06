---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# New-AzureADDynamicGroup

## SYNOPSIS
Create a new Azure AD security dynamic group

## SYNTAX

```
New-AzureADDynamicGroup [-DisplayName] <String> [-Description] <String> [-MemberShipRule] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Create a new Azure AD security dynamic group and set its membership rule

## EXAMPLES

### EXAMPLE 1
```
Create a new dynamic group Dynam_test5 with a membership rule based on user extensionAttribute9 value "test"
   C:\PS> New-AzureADDynamicGroup -DisplayName "Dynam_test5" -Description "Dynam_test5" -MemberShipRule '(user.extensionAttribute9 -eq "test")'
```

## PARAMETERS

### -DisplayName
-DisplayName String
Displayname of the new group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Description
-Description String
Description of the new group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberShipRule
-MembershipRule string
Membership rule (string) of the new dynamic group.
More info about rule definition here : https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-dynamic-membership

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
