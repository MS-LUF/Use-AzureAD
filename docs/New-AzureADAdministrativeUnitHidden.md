---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# New-AzureADAdministrativeUnitHidden

## SYNOPSIS
Create a new Administrative Unit with hidden membership

## SYNTAX

```
New-AzureADAdministrativeUnitHidden [-displayName] <String> [-description] <String> [<CommonParameters>]
```

## DESCRIPTION
Create a new Administrative Unit with hidden membership.
Only members of the admin unit can see the Admin Unit members.
Azure AD user account with advanced roles (Global reader, global administrator..) can still see the Admin Unit members.

## EXAMPLES

### EXEMPLE 1
```
Create a new Administrative Unit with hidden membership called testHidden
```

C:\PS\> New-AzureADAdministrativeUnitHidden -displayName "testHidden" -description "Hidden Test Admin unit"

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
### Name            MemberType   Definition
### ----            ----------   ----------
### Equals          Method       bool Equals(System.Object obj)
### GetHashCode     Method       int GetHashCode()
### GetType         Method       type GetType()
### ToString        Method       string ToString()
### deletedDateTime NoteProperty object deletedDateTime=null
### description     NoteProperty string description=Hidden Test Admin unit
### displayName     NoteProperty string displayName=testHidden
### id              NoteProperty string id=...
### visibility      NoteProperty string visibility=HiddenMembership
## NOTES

## RELATED LINKS
