![image](http://www.lucas-cueff.com/files/gallery.png)

# Use-AzureAD
Simple PowerShell module to manage your Azure Active Directory Tenant (focusing on Administrative Unit features) when AzureADPreview cannot handle it correctly ;-)

(c) 2021 lucas-cueff.com Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).

## Notes
currently Powershell Core and AzureADPreview are not working well together (logon / token request issue)
The issue is opened here : https://github.com/PowerShell/PowerShell/issues/10473  
Waiting for the fix, this module will **work only with Windows Powershell 5.1**

## Notes version :
### 0.5 - first public release - beta version
 - cmdlet to get a valid access token (MFA supported) for Microsoft Graph Beta APIs
 - cmdlet to get a valid token for Microsoft Graph API standard / cloud endpoint (ressource graph.windows.net) and be able to use AzureADPreview cmdlets without reauthenticating
 - cmdlet to get all properties available (ex : extensionattribute) for an AAD user account
 - cmdlet to set a web proxy to be used with Use-AzureAD and AzureADPreview cmdlets
 - cmdlet to get all info for current logged in (@ Azure AD Tenant and Graph APIs) AAD user account
 - cmdlet to create / synchronize your on premise Active Directory OUs with Azure AD Administrive Units (not managed currently through Azure AD Connect or other Microsoft cmdlets / modules)
 - cmdlet to add / synchronize your on premise Active Directory users DN with Azure AD Administrative Unit membership (not managed currently through Azure AD Connect or other Microsoft cmdlets / modules)
 - cmdlet to add / remove Azure AD user account in Administrative Unit Role (everything managed in an easy and smooth way including, enabling the AAD role if missing and so on)
 - cmdlet to list all members of an Azure AD Administrative Unit (limited @ first 100 objets with default MS cmdlet... #WTF)
### 0.6 - beta version
 - cmdlet to get your current schema for a specific provisionning agent / service principal
 - cmdlet to update your current schema for a specific provisionning agent / service principal
 - cmdlet to get your default schema (template) for Azure AD Connect Cloud Provisionning
 - cmdlet to get a valid token (MFA supported) for Microsoft Graph API standard / cloud endpoint and MSOnline endpoint and be able to use MSOnline cmdlets without reauthenticating
### 0.7 - beta version
 - cmdlet to create an Administrative Unit with hidden members
 - cmdlet to get Administrative Units with hidden members
 - cmdlet to create delta view for users, groups, admin units objects
 - cmdlet to get all updates from a delta view for users, groups, admin units objects
### 0.8 - beta version
 - fix Set-AzureADproxy cmdlet : not able to set correctly the parameter *ProxyUseDefaultCredentials*
 - new cmdlets to add, get, update Azure AD Dynamic Membership security groupstest dynamic membership
  * Note : in current release of AzureADPreview I have found a bug regarding Dynamic group (on all *-AzureADMSGroup cmdlets). When you try to use them, you have a Null Reference Exception :  
`System.NullReferenceException,Microsoft.Open.MSGraphBeta.PowerShell.NewMSGroup`
 - new cmdlet to test user membership of dynamic group membership
### 0.9 - beta version
add functions / cmdlets related to group and licensing stuff missing from azureadpreview current module
 - cmdlet to get all Azure AD User with licensing error members of a particular group
 - cmdlet to get licensing info of a particular group
 - cmdlet to add or remove a license on an Azure AD Group
 - cmdlet to get licensing assignment type (group or user) of a particular user
### 1.0 - beta version
- add service principal management for authentication and fix / improve code using DaveyRance remark : https://github.com/DaveyRance
### 1.1 - beta version
- update authority URL for Service Principal to be compliant with last version of ADAL library
### 1.2 - beta version
 - update Sync-ADOUtoAzureADAdministrativeUnit (update OU filter name to use regex instead)
 - update cmdlet Sync-ADUsertoAzureADAdministrativeUnitMember (update OU filter name to use regex instead)
 - update cmdlet Get-AzureADUserCustom (Get-AzureADUserallproperties)
 - add cmdlet Get-AzureADServicePrincipalCustom
 - add cmdlet Get-AzureADAdministrativeUnitCustom
 - add cmdlet Add-AzureADAdministrativeUnitMemberCustom
 - add cmdlet New-AzureADAdministrativeUnitCustom (New-AzureADAdministrativeUnitHidden)
 - add cmdlet Watch-AzureADAccessToken (be able to watch and auto renew Access Token of a service principal before expiration - useful in a script context when operation can take more than one hour)
 - update cmdlet Set-AzureADProxy (add bypassproxy on local option)
### 1.3 - beta version
- add function to get administrative units of a user account and remove a user account from an administrative unit (thanks to Achraf Amor)
  - Get-AzureADUserAdministrativeUnitMemberOfCustom
  - Remove-AzureADAdministrativeUnitMemberCustom
### 1.4 - beta version
- add functions to get and update Azure AD organization information
  - Get-AzureADOrganizationCustom
  - Update-AzureADOrganizationCustom
### 1.5 - last release - beta version
- add function to get Azure AD Connect synchronization errors through MS Graph API to replace Get-MsolDirSyncProvisioningError
  - Get-AzureADOnPremisesProvisionningErrors

## Why another Azure AD module ?
I am a new player on all Azure AD stuff. Currently, I am interesting in all directory stuff, including synchronization for my new job. When I was trying to understand how this **** works, I understand quickly that the current tools available from MS are buggy and / or not managing everything...
I have opened several request for change on Azure feedback website and also I have voted for several ones...
Here are my current issues, I have tried to resolve them with this PowerShell Module :
 - the BETA API of MS Graph are more powerfull than the v1.0 used by the PowerShell modules AzureAD or AzureADPreview
   - for instance, Get-AzureADUser cannot give you the value of the extensionattributexx !!!
   - You can create dynamic group based on the value hosted in those attributes but you cannot get the value of them for a user account... a shame...
 - There is no easy way to be authenticated at the same time on MS Graph API v1.0 and the Beta ones because Microsoft used a different endpoint in the Powershell modules AzureAD and AzureADPreview :
   - graph.windows.net is used by default in the MS modules, the Beta Graph is available with grap.microsoft.com/beta/
   - ==> the ressources URI are different so you must request tokens 2 times !!!
 - there is no tool available to synchronize on premise AD Organizational Unit and Azure AD Administrative unit
   - you must do it manually !
 - there is no tool available to add an Azure AD User account automatically to an Administrative Unit based on criteria
   - again you must do it manually !
 - there is no tool avaialable for massive provisionning in administrative unit
   - except bulk import with CSV from the portal but... wait we are in 2020 not in the 1990 !
 - the way Microsoft is managing the Administrative Unit role membership is a nightmare
   - for adding someone :
     - you need to be sure the role is enable from the directory template role,
     - then resolve your self all required GUIDs,
     - create some object to build the request,
     - then submit the request...
     - ==> wait, in on prem AD we are talking about a one liner stuff with easy name to remember !
 - several cmdlet are buggy and not implement paging feature
   - for instance you are limited to the first 100 objects only when you want to get all members of an admin unit... (Get-AzureADAdministrativeUnitMember)
   - the API administrativeUnits is able to handle it but they just forgot to implement it in the PowerShell module...
 - missing Graph APIs implementations
   - licensing stuff limited to user object / ressources and not able to investigate licensing issue correctly except by using the deprecated module MSOnline

### Azure requests for changes opened
https://feedback.azure.com/forums/169401-azure-active-directory/suggestions/40276534-azureadpreview  
https://feedback.azure.com/forums/169401-azure-active-directory/suggestions/40276597-azureadpreview-get-azureadadministrativeunitmem  
https://feedback.azure.com/forums/169401-azure-active-directory/suggestions/40276621-azureadpreview-odata-advanced-paging  
https://feedback.azure.com/forums/169401-azure-active-directory/suggestions/39167986-sync-onprem-ad-ous-to-aad-administrative-units  
https://feedback.azure.com/forums/34192--general-feedback/suggestions/40542640-ms-graph-api-evaluatedynamicmembershipresult-on-gr

## How-to
a how-to is available here : https://github.com/MS-LUF/Use-AzureAD/blob/master/Howto.md

## install Use-AzureAD from PowerShell Gallery repository
You can easily install it from powershell gallery repository  
https://www.powershellgallery.com/packages/Use-AzureAD/  
using a simple powershell command and an internet access :-) 
```
	Install-Module -Name Use-AzureAD
```

## import module from PowerShell 
```
	C:\PS> import-module Use-AzureAD.psm1
```

## module content
documentation in markdown available here : https://github.com/MS-LUF/Use-AzureAD/tree/master/docs  
### function
 - Clear-AzureADAccessToken
 - Connect-AzureADFromAccessToken
 - Connect-MSOnlineFromAccessToken
 - Get-AzureADAccessToken
 - Get-AzureADAdministrativeUnitAllMembers
 - Get-AzureADAdministrativeUnitCustom
 - Get-AzureADAdministrativeUnitHidden
 - Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema
 - Get-AzureADConnectCloudProvisionningServiceSyncSchema
 - Get-AzureADDynamicGroup
 - Get-AzureADGroupLicenseDetail
 - Get-AzureADGroupMembersWithLicenseErrors
 - Get-AzureADMyInfo
 - Get-AzureADObjectDeltaView
 - Get-AzureADServicePrincipalCustom
 - Get-AzureADTenantInfo
 - Get-AzureADUserCustom
 - Get-AzureADUserLicenseAssignmentStates
 - Invoke-APIMSGraphBeta
 - New-AzureADAdministrativeUnitCustom
 - New-AzureADDynamicGroup
 - New-AzureADObjectDeltaView
 - Remove-AzureADDynamicGroup
 - Set-AzureADAdministrativeUnitAdminRole
 - Set-AzureADDynamicGroup
 - Set-AzureADGroupLicense
 - Set-AzureADProxy
 - Sync-ADOUtoAzureADAdministrativeUnit
 - Sync-ADUsertoAzureADAdministrativeUnitMember
 - Test-ADModule
 - Test-AzureADAccessTokenExpiration
 - Test-AzureADAccesToken
 - Test-AzureADUserForGroupDynamicMembership
 - Update-AzureADConnectCloudProvisionningServiceSyncSchema
 - Watch-AzureADAccessToken
 - Get-AzureADUserAdministrativeUnitMemberOfCustom
 - Remove-AzureADAdministrativeUnitMemberCustom
 - Get-AzureADOrganizationCustom
 - Update-AzureADOrganizationCustom
 - Get-AzureADOnPremisesProvisionningErrors
### alias
- Get-AzureADUserAllInfo