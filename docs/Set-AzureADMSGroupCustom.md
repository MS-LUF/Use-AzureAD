---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Set-AzureADMSGroupCustom

## SYNOPSIS
Update an existing Azure AD Office 365 dynamic or static group

## SYNTAX

```
Set-AzureADMSGroupCustom [[-inputobject] <Group>] [[-ObjectID] <Guid>] [[-NewDisplayName] <String>]
 [[-NewDescription] <String>] [[-NewMailNickname] <String>] [[-Newvisibility] <String>]
 [[-ResourceExchangeOptions] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Update an existing Azure AD Office 365 dynamic or static group with resourceExchangeOptions support : https://docs.microsoft.com/en-us/graph/api/group-update?view=graph-rest-beta&tabs=http

## EXAMPLES

### EXEMPLE 1
```
Update a group to set several Exchange options
```

C:\PS\> Get-AzureADGroup -ObjectId fd04a7ae-65e2-44ba-a940-b75efbd95d7e | set-AzureADMSGroupCustom -ResourceExchangeOptions @{"hideFromAddressLists"=$true;"allowExternalSenders"=$false;"autoSubscribeNewMembers"=$false;"hideFromOutlookClients"=$true;"isSubscribedByMail"=$false;"unseenCount"=10}

### EXEMPLE 2
```
Update a group to set a new description
```

C:\PS\> Get-AzureADGroup -ObjectId fd04a7ae-65e2-44ba-a940-b75efbd95d7e | set-AzureADMSGroupCustom -NewDescription "testapigroup55 test"

## PARAMETERS

### -inputobject
{{Fill inputobject Description}}

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
{{Fill ObjectID Description}}

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
-NewDisplayname String
Updated displayname of the new group

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
Updated description of the group

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

### -NewMailNickname
NewMailNickname string
updated mail nickname to be used for the group.
if not defined, the new displayname value is used.

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

### -Newvisibility
-Newvisibility string ("private","public","Hiddenmembership")
use "private" to update to a private group, "public" for a public group or "Hiddenmembership" for private group with hidden membership

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

### -ResourceExchangeOptions
-ResourceExchangeOptions hastable 
available key name : allowExternalSenders, autoSubscribeNewMembers, hideFromAddressLists, hideFromOutlookClients, isSubscribedByMail, unseenCount
available value : boolean for all key except unseenCount int32

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
