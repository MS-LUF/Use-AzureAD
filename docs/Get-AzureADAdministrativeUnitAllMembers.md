---
external help file: Use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADAdministrativeUnitAllMembers

## SYNOPSIS
Get all Azure AD account member of an Azure AD Administrative Unit

## SYNTAX

```
Get-AzureADAdministrativeUnitAllMembers [[-inputobject] <AdministrativeUnit>] [[-ObjectId] <Guid>]
 [<CommonParameters>]
```

## DESCRIPTION
Get all Azure AD account member of an Azure AD Administrative Unit

## EXAMPLES

### EXEMPLE 1
```
Get all Azure AD user member of the admin unit TP-AL
```

C:\PS\> Get-AzureADAdministrativeUnit -Filter "displayname eq 'TP-AL'" | Get-AzureADAdministrativeUnitAllMembers

## PARAMETERS

### -inputobject
-inputobject Microsoft.Open.AzureAD.Model.AdministrativeUnit
Microsoft.Open.AzureAD.Model.AdministrativeUnit object (for instance created by Get-AzureADAdministrativeUnit)

```yaml
Type: AdministrativeUnit
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
