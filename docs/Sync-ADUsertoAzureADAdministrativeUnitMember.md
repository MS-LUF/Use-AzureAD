---
external help file: Use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Sync-ADUsertoAzureADAdministrativeUnitMember

## SYNOPSIS
Add Azure AD user account into Azure AD Administrative Unit based on their on premise LDAP Distinguished Name

## SYNTAX

```
Sync-ADUsertoAzureADAdministrativeUnitMember [-CloudUPNAttribute] <String> [-AllRootOU]
 [[-RootOUFilterName] <String>] [[-OUsDN] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Add Azure AD user account into Azure AD Administrative Unit based on their on premise LDAP Distinguished Name.

## EXAMPLES

### EXEMPLE 1
```
Add Azure AD users to administrative unit based on their source Distinguished Name, do it only for users account with a DN containing a root OU name starting with "TP-"
```

The verbose option can be used to write basic message on console (for instance when a user is already member of an admin unit)
C:\PS\> Sync-ADUsertoAzureADAdministrativeUnitMember -CloudUPNAttribute mail -AllRootOU -RootOUFilterName "TP-*" -Verbose

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
Position: 2
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
Position: 3
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
