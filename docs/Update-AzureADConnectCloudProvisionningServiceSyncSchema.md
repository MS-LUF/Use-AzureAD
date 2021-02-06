---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Update-AzureADConnectCloudProvisionningServiceSyncSchema

## SYNOPSIS
Update your Azure AD Connect Cloud Sync schema for a provisionning agent

## SYNTAX

```
Update-AzureADConnectCloudProvisionningServiceSyncSchema [[-OnPremADFQDN] <String>] [[-ObjectID] <Guid>]
 [-inputobject] <PSObject> [<CommonParameters>]
```

## DESCRIPTION
Update your  Azure AD Connect Cloud Sync schema for a provisionning agent (synchronizationRules, schema, objectMappings rules...)

## EXAMPLES

### EXAMPLE 1
```
Update your Azure AD Connect Cloud Sync schema for provisionning agent of domain mydomain.tld, new schema available in $schema object
C:\PS> Update-AzureADConnectCloudProvisionningServiceSyncSchema -OnPremADFQDN mydomain.tld -inputobject $schema
```

## PARAMETERS

### -OnPremADFQDN
-OnPremADFQDN string
FQDN of your on premise AD Domain managed through Azure AD Connect Cloud Provisionning (provisionning agent must already be declared)

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

### -ObjectID
-ObjectId guid
   GUID of the SPN used by your provisionning agent

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -inputobject
-inputobject PSCustomObject
a PSCustom Object containing your new schema to upload

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None (except warning)
## NOTES

## RELATED LINKS
