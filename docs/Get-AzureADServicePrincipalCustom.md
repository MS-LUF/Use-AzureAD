---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADServicePrincipalCustom

## SYNOPSIS
Get Azure AD Service Principal by property and value

## SYNTAX

```
Get-AzureADServicePrincipalCustom [[-Filter] <String>] [[-ObjectId] <Guid>] [<CommonParameters>]
```

## DESCRIPTION
Get Azure AD Service Principal by property and value

## EXAMPLES

### EXEMPLE 1
```
Get Azure AD service principal with the appid fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureADServicePrincipalCustom -Filter "appid eq 'fb01091c-a9b2-4cd2-bbc9-130dfc91452a'"

### EXEMPLE 2
```
Get Azure AD service principal with the object id fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureADServicePrincipalCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a

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
GUID of the Service Principal

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
