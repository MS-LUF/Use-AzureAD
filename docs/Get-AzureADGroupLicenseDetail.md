---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADGroupLicenseDetail

## SYNOPSIS
Get licensing info of a particular group

## SYNTAX

```
Get-AzureADGroupLicenseDetail [[-inputobject] <Group>] [[-ObjectID] <Guid>] [<CommonParameters>]
```

## DESCRIPTION
Get all licening info (skuid applied, service plans disabled) for a particular Azure AD Group

## EXAMPLES

### EXEMPLE 1
```
Get licensing info for Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureADGroupLicenseDetail -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

### EXEMPLE 2
```
Get licensing info for Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
```

C:\PS\> Get-AzureAdGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Get-AzureADGroupLicenseDetail

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
