---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# New-AzureADMSGroupCustom

## SYNOPSIS
Create a new Azure AD Office 365 dynamic or static group

## SYNTAX

```
New-AzureADMSGroupCustom [-DisplayName] <String> [-Description] <String> [[-MailNickname] <String>]
 [[-groupType] <String>] [[-visibility] <String>] [[-MemberShipRule] <String>]
 [[-resourceBehaviorOptions] <String[]>] [[-resourceProvisioningOptions] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Create a new Azure AD Office 365 dynamic or static group with resourceBehaviorOptions and resourceProvisioningOptions support : https://docs.microsoft.com/en-us/graph/group-set-options

## EXAMPLES

### EXEMPLE 1
```
Create a new static group testapigroup4 with resourceBehaviorOptions set
```

C:\PS\> New-AzureADMSGroupCustom -DisplayName "testapigroup4" -Description "testapigroup4" -resourceBehaviorOptions @("AllowOnlyMembersToPost","HideGroupInOutlook","WelcomeEmailDisabled")

### EXEMPLE 2
```
Create a new dynamic group testapigroup5 with resourceBehaviorOptions and resourceProvisioningOptions set
```

C:\PS\> New-AzureADMSGroupCustom -DisplayName "testapigroup5" -Description "testapigroup5" -resourceBehaviorOptions @("AllowOnlyMembersToPost","HideGroupInOutlook","WelcomeEmailDisabled") -MailNickname "testapigroup55" -groupType DynamicMembership -visibility public -MemberShipRule "(user.userType -eq \`"Guest\`")" -resourceProvisioningOptions Teams -Verbose

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

### -MailNickname
-MailNickname string
mail nickname to be used for the group.
if not defined, the displayname value is used.

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

### -groupType
-groupType string ("StaticMembership","DynamicMembership")
use "StaticMembership" value to create a standard group with classic members, use "DynamicMembership" value to create a dynamic group with members managed by rules.
when using "DynamicMembership", the parameter "MembershipRule" must be use also to define the rule

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: StaticMembership
Accept pipeline input: False
Accept wildcard characters: False
```

### -visibility
-visibility string ("private","public","Hiddenmembership")
use "private" to create a private group, "public" for a public group or "Hiddenmembership" for private group with hidden membership

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Private
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

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceBehaviorOptions
-resourceBehaviorOptions array of string ("AllowOnlyMembersToPost","HideGroupInOutlook","WelcomeEmailDisabled","SubscribeNewGroupMembers")
more information here : https://docs.microsoft.com/en-us/graph/group-set-options

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceProvisioningOptions
-resourceProvisioningOptions array of string ("Teams")
more information here : https://docs.microsoft.com/en-us/graph/group-set-options

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
