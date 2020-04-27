---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADTenantInfo

## SYNOPSIS
Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta

## SYNTAX

```
Get-AzureADTenantInfo [-adminUPN] <MailAddress> [<CommonParameters>]
```

## DESCRIPTION
Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta, using ADAL library, all authentication supported including MFA.
Tenant ID automatically resolved.

## EXAMPLES

### EXEMPLE 1
```
Get an access token for my admin account (my-admin@mydomain.tld)
```

C:\PS\> Get-AzureADTenantInfo -adminUPN my-admin@mydomain.tld

## PARAMETERS

### -adminUPN
-adminUPN System.Net.Mail.MailAddress
UserPrincipalName of an Azure AD account with rights on Directory (for instance a user with Global Admin right)

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
### Name           MemberType   Definition
### ----           ----------   ----------
### Equals         Method       bool Equals(System.Object obj)
### GetHashCode    Method       int GetHashCode()
### GetType        Method       type GetType()
### ToString       Method       string ToString()
### AccessToken    NoteProperty string AccessToken=xxxxx...
### ObjectID       NoteProperty string ObjectID=e3ab4983-22c4-417b-b18d-0271f81a9cde
### TenantID       NoteProperty string TenantID=fbf266be-12e8-48a4-bd5f-c513713bd96d
### TokenExpiresOn NoteProperty DateTimeOffset TokenExpiresOn=26/04/2020 16:20:40 +00:00
### UserName       NoteProperty mailaddress UserName=my-admin@mydomain.tld
## NOTES

## RELATED LINKS
