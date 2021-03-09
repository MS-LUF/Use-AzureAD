---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Update-AzureADOrganizationCustom

## SYNOPSIS
update all properties of an Azure AD organization

## SYNTAX

```
Update-AzureADOrganizationCustom [[-marketingNotificationEmails] <MailAddress>]
 [[-securityComplianceNotificationMails] <MailAddress>] [[-securityComplianceNotificationPhones] <String>]
 [[-technicalNotificationMails] <MailAddress>] [[-privacyProfilemail] <MailAddress>]
 [[-privacyProfileurl] <Uri>] [<CommonParameters>]
```

## DESCRIPTION
update all properties of an Azure AD organization

## EXAMPLES

### EXEMPLE 1
```
update privacy information
```

C:\PS\> Update-AzureADOrganizationCustom -privacyProfilemail test@test.com -privacyProfileurl http://www.google.com

### EXEMPLE 2
```
update marketing mail contact for notification
```

C:\PS\> Update-AzureADOrganizationCustom -marketingNotificationEmails lcuaad.xyz@outlook.com

## PARAMETERS

### -marketingNotificationEmails
-marketingNotificationEmails mailaddress
e-mail address to be set for marketing notification

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

### -securityComplianceNotificationMails
-securityComplianceNotificationMails mailaddress
e-mail address to be set for security & compliance notification

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -securityComplianceNotificationPhones
-securityComplianceNotificationPhones string
phone number to be set for security & compliance notification

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

### -technicalNotificationMails
-technicalNotificationMails mailaddress
e-mail address to be set for technical notification

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -privacyProfilemail
-privacyProfilemail mailaddress
e-mail address to be set for privacy notification
this parameter must be used with privacyProfileurl parameter

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -privacyProfileurl
-privacyProfileurl uri
URL of the privacy information
this parameter must be used with privacyProfilemail parameter

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
