---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Add-AzureADAdministrativeUnitMemberCustom

## SYNOPSIS
Get Azure AD Service Principal by property and value

## SYNTAX

```
Add-AzureADAdministrativeUnitMemberCustom [-ObjectId] <Guid> [-RefObjectId] <Guid> [-RefObjectType] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Get Azure AD Service Principal by property and value

## EXAMPLES

### EXAMPLE 1
```
Add into an Azure AD admin unit (object id fb01091c-a9b2-4cd2-bbc9-130dfc91452a) a user (object id f8395a0b-3256-46b3-8dc8-db2e80a8ad52)
   C:\PS> Add-AzureADAdministrativeUnitMemberCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a -RefObjectId f8395a0b-3256-46b3-8dc8-db2e80a8ad52 -RefObjectType users
```

## PARAMETERS

### -ObjectId
-ObjectId guid
   GUID of the Administrative Unit

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -RefObjectId
{{ Fill RefObjectId Description }}

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefObjectType
{{ Fill RefObjectType Description }}

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
