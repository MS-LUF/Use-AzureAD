---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADAdministrativeUnitHidden

## SYNOPSIS
Get Administrative Units with hidden membership

## SYNTAX

```
Get-AzureADAdministrativeUnitHidden [[-inputobject] <AdministrativeUnit>] [[-public] <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION
Get Administratives Unit with hidden membership.
Only members of the admin unit can see the Admin Unit members.
Azure AD user account with advanced roles (Global reader, global administrator..) can still see the Admin Unit members.

## EXAMPLES

### EXEMPLE 1
```
Get Administrative Units with hidden membership
```

C:\PS\> Get-AzureADAdministrativeUnitHidden

### EXEMPLE 2
```
Get Administrative Units with public membership
```

C:\PS\> Get-AzureADAdministrativeUnitHidden -public $true

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

### -public
-public boolean
   choose if you want to display Administrative Unit with hidden membership or public membership

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
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
