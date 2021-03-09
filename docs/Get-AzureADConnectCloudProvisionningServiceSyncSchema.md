---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Get-AzureADConnectCloudProvisionningServiceSyncSchema

## SYNOPSIS
Get Azure AD Connect Cloud Sync schema for a provisionning agent

## SYNTAX

```
Get-AzureADConnectCloudProvisionningServiceSyncSchema [[-OnPremADFQDN] <String>] [[-ObjectID] <Guid>]
 [<CommonParameters>]
```

## DESCRIPTION
Get all properties of an Azure AD Connect Cloud Sync schema for a provisionning agent (synchronizationRules, schema, objectMappings rules...)

## EXAMPLES

### EXEMPLE 1
```
Get Azure AD Connect Cloud Sync schema for a provisionning agent of domain mydomain.tld
```

C:\PS\> Get-AzureADConnectCloudProvisionningServiceSyncSchema -OnPremADFQDN mydomain.tld

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
