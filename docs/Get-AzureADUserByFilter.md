---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADUserByFilter

## SYNOPSIS
Get Azure AD user by property and value

## SYNTAX

```
Get-AzureADUserByFilter [-Filter] <String> [<CommonParameters>]
```

## DESCRIPTION
Get Azure AD user by property and value

## EXAMPLES

### EXEMPLE 1
```
Get Azure AD user with the immutableid test
```

C:\PS\> Get-AzureADUserByFilter -Filter "immutableid eq 'test'"

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
