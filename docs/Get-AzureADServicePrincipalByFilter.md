---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADServicePrincipalByFilter

## SYNOPSIS
Get Azure AD Service Principal by property and value

## SYNTAX

```
Get-AzureADServicePrincipalByFilter [-Filter] <String> [<CommonParameters>]
```

## DESCRIPTION
Get Azure AD Service Principal by property and value

## EXAMPLES

### EXEMPLE 1
```
Get Azure AD service principals with the appid fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureADServicePrincipalByFilter -Filter "appid eq 'fb01091c-a9b2-4cd2-bbc9-130dfc91452a'"

## PARAMETERS

### -Filter
-Filter string
   Odata Filter query

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
