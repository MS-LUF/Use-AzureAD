---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Set-AzureADAdministrativeUnitAdminRole

## SYNOPSIS
Add / remove Azure AD administrative unit role to Azure AD user

## SYNTAX

```
Set-AzureADAdministrativeUnitAdminRole [-userUPN] <MailAddress> [-RoleAction] <String>
 -AdministrativeUnit <String> -AdministrativeRole <String> [<CommonParameters>]
```

## DESCRIPTION
Add / remove Azure AD administrative unit role to Azure AD user

## EXAMPLES

### EXEMPLE 1
```
Give the role Password Administrator for the Admin unit TP-NF to my-admin-unit@mydomain.tld
```

C:\PS\> Set-AzureADAdministrativeUnitAdminRole -userUPN my-admin-unit@mydomain.tld -RoleAction ADD -AdministrativeUnit TP-NF -AdministrativeRole 'Password Administrator' -Verbose

## PARAMETERS

### -userUPN
-userUPN System.Net.Mail.MailAddress
user principal name of the account you want to add a new role

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleAction
-RoleAction string {Add, Remove}
Specify the action to be done with the target role on the Azure AD user object : add or remove the role

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdministrativeRole
{{Fill AdministrativeRole Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdministrativeUnit
{{Fill AdministrativeUnit Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : Microsoft.Open.AzureAD.Model.ScopedRoleMembership
### Name                       MemberType Definition
### ----                       ---------- ----------
### Equals                     Method     bool Equals(System.Object obj), bool Equals(Microsoft.Open.AzureAD.Model.ScopedRoleMembership other), bool IEquatable[ScopedRoleMembership].Equals(Microsoft.Open.Azure...
### GetHashCode                Method     int GetHashCode()
### GetType                    Method     type GetType()
### ShouldSerializeId          Method     bool ShouldSerializeId()
### ToJson                     Method     string ToJson()
### ToString                   Method     string ToString()
### Validate                   Method     System.Collections.Generic.IEnumerable[System.ComponentModel.DataAnnotations.ValidationResult] Validate(System.ComponentModel.DataAnnotations.ValidationContext validat...
### AdministrativeUnitObjectId Property   string AdministrativeUnitObjectId {get;set;}
### Id                         Property   string Id {get;}
### RoleMemberInfo             Property   Microsoft.Open.AzureAD.Model.RoleMemberInfo RoleMemberInfo {get;set;}
### RoleObjectId               Property   string RoleObjectId {get;set;}
## NOTES

## RELATED LINKS
