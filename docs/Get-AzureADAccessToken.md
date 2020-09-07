---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADAccessToken

## SYNOPSIS
cmdlets to use several APIs of Microsoft Graph Beta web service (mainly users,me,AdministrativeUnit)
extend AzureADPreview capabilities in Azure AD Administrative Unit management

## SYNTAX

```
Get-AzureADAccessToken [[-adminUPN] <MailAddress>] [[-ServicePrincipalCertThumbprint] <String>]
 [[-ServicePrincipalApplicationID] <Guid>] [[-ServicePrincipalTenantDomain] <String>] [<CommonParameters>]
```

## DESCRIPTION
use-AzureAD.psm1 module provides easy to use cmdlets to manage your Azure AD tenant with a focus on Administrative Unit objects.

## EXAMPLES

### EXEMPLE 1
```
import-module use-AzureAD.psm1
```

## PARAMETERS

### -adminUPN
{{Fill adminUPN Description}}

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipalCertThumbprint
{{Fill ServicePrincipalCertThumbprint Description}}

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

### -ServicePrincipalApplicationID
{{Fill ServicePrincipalApplicationID Description}}

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicePrincipalTenantDomain
{{Fill ServicePrincipalTenantDomain Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
