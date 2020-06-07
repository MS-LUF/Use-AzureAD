---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Set-AzureADProxy

## SYNOPSIS
Set a web proxy to connect to Azure AD graph API

## SYNTAX

```
Set-AzureADProxy [-DirectNoProxy] [[-Proxy] <Uri>] [[-ProxyCredential] <PSCredential>]
 [-ProxyUseDefaultCredentials] [<CommonParameters>]
```

## DESCRIPTION
Set / remove a proxy to connect to your Azure AD environment using AzureADPreview module or this module.
Can handle anonymous proxy or authenticating proxy.

## EXAMPLES

### EXEMPLE 1
```
Remove Proxy
```

C:\PS\> Set-AzureADProxy -DirectNoProxy

### EXEMPLE 2
```
Set a local anonymous proxy 127.0.0.1:8888
```

C:\PS\> Set-AzureADProxy -Proxy "http://127.0.0.1:8888"

## PARAMETERS

### -DirectNoProxy
-DirectNoProxy Swith
   Remove proxy set, set to "direct" connection

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

### -Proxy
-Proxy uri
   Set the proxy settings to URI provided.
Must be provided as a valid URI like http://proxy:port

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProxyCredential
-ProxyCredential Management.Automation.PSCredential
   must be use with Proxy parameter
   Set the credential to be used with the proxy to set.
Must be provided as a valid PSCredential object (can be generated with Get-Credential)

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProxyUseDefaultCredentials
-ProxyUseDefaultCredentials Swith
must be use with Proxy parameter
Set the credential to be used with the proxy to set.
this switch will tell the system to use the current logged in credential to be authenticated with the proxy service.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TypeName : System.Net.WebProxy
## NOTES

## RELATED LINKS
