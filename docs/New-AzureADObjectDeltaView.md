---
external help file: Use-AzureAD-help.xml
Module Name: Use-AzureAD
online version:
schema: 2.0.0
---

# New-AzureADObjectDeltaView

## SYNOPSIS
Create a new delta view for an Azure AD object

## SYNTAX

```
New-AzureADObjectDeltaView [-ObjectType] <String> [[-SelectProperties] <String[]>] [[-FilterIDs] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Create a new delta view for an Azure AD object.
It can be used on several objects (groups, users, administrative units...) to retrieve change information occured between two moments (properties updated/removed/added, objects updated/removed/added).
This cmdlet create the initial view (available at server side for 30 days maximum) and the cmdlet Get-AzureADObjectDeltaView will retrieve the changes occured between the first view creation.

## EXAMPLES

### EXEMPLE 1
```
Create an initial delta view for manager and department properties of all users objects
```

C:\PS\> New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department")

### EXEMPLE 2
```
Create an initial delta view for manager and department properties of fb01091c-a9b2-4cd2-bbc9-130dfc91452a and 2092d280-2821-45ae-9e47-e9433a65868d users objects
```

C:\PS\> New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department") -FilterIDs @("fb01091c-a9b2-4cd2-bbc9-130dfc91452a","2092d280-2821-45ae-9e47-e9433a65868d") -Verbose

## PARAMETERS

### -ObjectType
-ObjectType String {"Users","Groups","AdministrativeUnits"}
   target object type you want to use for the delta view

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

### -SelectProperties
-SelectProperties String - array of strings
object properties you want to watch, by default all properties will be followed

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterIDs
-FilterIDs String - array of strings
object GUID you want to watch, by default all object from the object type selected will be followed

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

### TypeName : System.Management.Automation.PSCustomObject
## NOTES

## RELATED LINKS
