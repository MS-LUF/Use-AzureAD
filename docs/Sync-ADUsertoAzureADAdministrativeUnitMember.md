---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Sync-ADUsertoAzureADAdministrativeUnitMember

## SYNOPSIS
Add Azure AD user account into Azure AD Administrative Unit based on their on premise LDAP Distinguished Name

## SYNTAX

```
Sync-ADUsertoAzureADAdministrativeUnitMember [-CloudUPNAttribute] <String> [-AllOUs]
 [[-OUsFilterName] <String>] [[-SearchBase] <String>] [[-OUsDN] <String[]>] [[-ADUserFilter] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Add Azure AD user account into Azure AD Administrative Unit based on their on premise LDAP Distinguished Name.

## EXAMPLES

### EXEMPLE 1
```
Add Azure AD users to administrative unit based on their source Distinguished Name, do it only for users account with a DN containing a root OU name matching a pattern like "AB-CD"
```

The verbose option can be used to write basic message on console (for instance when a user is already member of an admin unit)
C:\PS\> Sync-ADUsertoAzureADAdministrativeUnitMember -CloudUPNAttribute mail -AllOUs -OUsFilterName "^(\[a-zA-Z\]{2})(-)(\[a-zA-Z\]{2})$" -SearchBase "DC=domain,DC=xyz" -Verbose

## PARAMETERS

### -CloudUPNAttribute
-CloudUPNAttribute string
On premise AD user account attribute hosting the cloud Azure AD User userprincipal name.
For instance, it could be also the userPrincipalName attribute or mail attribute.

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

### -AllOUs
-AllOUs Switch
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

### -OUsFilterName
-OUsFilterName string
must be used with AllOUs parameter
Set a regex filter to synchronize only OU based on a specific pattern.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchBase
-SearchBase string
must be used with AllOUs parameter
set the default search base for OU (DN format)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OUsDN
-OUsDN string / array of string
must not be used with AllOUs parameter.
you must choose between these 2 parameters.
string must be a LDAP Distinguished Name.
For instance : "OU=TP-VB,DC=domain,DC=xyz"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ADUserFilter
{{Fill ADUserFilter Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None. verbose can be used to display message on console.
## NOTES

## RELATED LINKS
