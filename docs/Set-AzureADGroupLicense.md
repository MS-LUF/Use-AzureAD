---
external help file: use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# Set-AzureADGroupLicense

## SYNOPSIS
Add or remove a license on an Azure AD Group

## SYNTAX

```
Set-AzureADGroupLicense [[-inputobject] <Group>] [[-ObjectID] <Guid>] [-AddLicense] [-RemoveLicense]
 [[-DisabledPlans] <Guid[]>] [-SkuID] <Guid> [<CommonParameters>]
```

## DESCRIPTION
Add or remove a license (skuid applied, or service plans to be disabled) for a particular Azure AD Group

## EXAMPLES

### EXEMPLE 1
```
Remove SkuID license 84a661c4-e949-4bd2-a560-ed7766fcaf2b from the group 53cf95f1-49be-463e-9856-77c2b2c3e4a0
```

C:\PS\> Set-AzureADGroupLicense -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -RemoveLicense -SkuID 84a661c4-e949-4bd2-a560-ed7766fcaf2b -Verbose

### EXEMPLE 2
```
Remove SkuID license 84a661c4-e949-4bd2-a560-ed7766fcaf2b from the group 53cf95f1-49be-463e-9856-77c2b2c3e4a0
```

C:\PS\> Get-AzureAdGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Set-AzureADGroupLicense -RemoveLicense -SkuID 84a661c4-e949-4bd2-a560-ed7766fcaf2b -Verbose

### EXEMPLE 3
```
Add license sku 84a661c4-e949-4bd2-a560-ed7766fcaf2b to the group 53cf95f1-49be-463e-9856-77c2b2c3e4a0 and disable service plans 113feb6c-3fe4-4440-bddc-54d774bf0318, 932ad362-64a8-4783-9106-97849a1a30b9 from this sku
```

C:\PS\> Set-AzureADGroupLicense -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -AddLicense -SkuID 84a661c4-e949-4bd2-a560-ed7766fcaf2b -DisabledPlans @("113feb6c-3fe4-4440-bddc-54d774bf0318", "932ad362-64a8-4783-9106-97849a1a30b9") -verbose

## PARAMETERS

### -inputobject
-inputobject Microsoft.Open.AzureAD.Model.Group
Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

```yaml
Type: Group
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ObjectID
-ObjectID Guid
Guid of an existing Azure AD Group object

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

### -AddLicense
-AddLicense switch
Use the switch to add a new license to the group

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

### -RemoveLicense
-RemoveLicense switch
Use the switch to remove an existing license from the group

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

### -DisabledPlans
-DisabledPlans Guid - array of guids
Guid / array of guids containing the guid of the service plans to be disabled in the SKU provided.
To be used only with AddLicense switch.
You cannot remove plans disabled from the sku / group.
you must remove totally the license (sku) then add it using the new disabled plans.

```yaml
Type: Guid[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkuID
-SkuID Guid
Guid of the SKU to be added or removed to / from the group.
Mandatory parameter to be used with AddLicense and RemoveLicense switchs

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: True
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

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
