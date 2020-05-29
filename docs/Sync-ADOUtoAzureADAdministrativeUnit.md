---
external help file: Use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Sync-ADOUtoAzureADAdministrativeUnit

## SYNOPSIS
Create new Azure AD Administrative Unit based on on premise AD Organizational Unit

## SYNTAX

```
Sync-ADOUtoAzureADAdministrativeUnit [-AllRootOU] [[-RootOUFilterName] <String>] [[-OUsDN] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Create new Azure AD Administrative Unit based on on premise AD Organizational Unit.
Can be used to synchronize all existing on prem AD root OU with new cloud Admin unit.

## EXAMPLES

### EXEMPLE 1
```
Create new cloud Azure AD administrative Unit for each on prem' OU found with a name starting with "TP-"
```

The verbose option can be used to write basic message on console (for instance when an admin unit already existing)
C:\PS\> Sync-ADOUtoAzureADAdministrativeUnit -AllRootOU -RootOUFilterName "TP-*" -Verbose

## PARAMETERS

### -AllRootOU
-AllRootOU Switch
   Synchronize all existing OU to new cloud Admin Unit (except default OU like Domain Controllers)

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

### -RootOUFilterName
-RootOUFilterName string
   must be used with AllRootOU parameter
   Set a "like" filter to synchronize only OU based on a specific pattern.
For instance "TP-*" to synchronize only OU with a name starting with TP-

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

### -OUsDN
-OUsDN string / array of string
   must not be used with AllRootOU parameter.
you must choose between these 2 parameters.
   string must be a LDAP Distinguished Name.
For instance : "OU=TP-VB,DC=domain,DC=xyz"

```yaml
Type: String[]
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

### TypeName : Microsoft.Open.AzureAD.Model.AdministrativeUnit
## NOTES

## RELATED LINKS
