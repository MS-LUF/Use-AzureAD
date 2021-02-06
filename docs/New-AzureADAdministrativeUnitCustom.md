---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# New-AzureADAdministrativeUnitCustom

## SYNOPSIS
Create a new Azure AD Administrative Unit

## SYNTAX

```
New-AzureADAdministrativeUnitCustom [-displayName] <String> [-description] <String> [-Hidden]
 [<CommonParameters>]
```

## DESCRIPTION
Create a new Administrative Unit with hidden membership managed.
if used, only members of the admin unit can see the Admin Unit members.
Azure AD user account with advanced roles (Global reader, global administrator..) can still see the Admin Unit members.

## EXAMPLES

### EXAMPLE 1
```
Create a new Administrative Unit with hidden membership called testHidden
   C:\PS> New-AzureADAdministrativeUnitCustom -displayName "testHidden" -description "Hidden Test Admin unit" -Hidden
```

### EXAMPLE 2
```
Create a new Administrative Unit membership called test
C:\PS> New-AzureADAdministrativeUnitCustom -displayName "test" -description "Test Admin unit"
```

## PARAMETERS

### -displayName
-displayName String
   display name of the new admin unit

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -description
-description String
   description name of the new admin unit

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

### -Hidden
-Hidden {switch}
use the swith to set administrative unit as hidden

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
