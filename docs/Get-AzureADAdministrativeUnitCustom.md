---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADAdministrativeUnitCustom

## SYNOPSIS
Get Azure AD Administrative Unit properties by properties value or ID

## SYNTAX

```
Get-AzureADAdministrativeUnitCustom [[-Filter] <String>] [[-ObjectId] <Guid>] [-All] [<CommonParameters>]
```

## DESCRIPTION
Get Azure AD Administrative Unit properties by properties value or ID

## EXAMPLES

### EXAMPLE 1
```
Get Azure AD Administrative Unit with the displayname 'myadmin'
   C:\PS> Get-AzureADAdministrativeUnitCustom -Filter "displayname eq 'myadmin'"
```

### EXAMPLE 2
```
Get Azure AD Administrative Unit with the object id fb01091c-a9b2-4cd2-bbc9-130dfc91452a
   C:\PS> Get-AzureADAdministrativeUnitCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

### EXAMPLE 3
```
Get all Azure AD Administrative Units 
   C:\PS> Get-AzureADAdministrativeUnitCustom -All
```

## PARAMETERS

### -Filter
-Filter string
   Odata Filter query

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectId
-ObjectId guid
   GUID of the Administrative Unit

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
{{ Fill All Description }}

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
