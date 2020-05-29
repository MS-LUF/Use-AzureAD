
#
## Created by: lucas.cueff[at]lucas-cueff.com
#
## released on 04/2020
#
# v0.5 : first public release - beta version - cmdlets to manage your Azure Active Directory Tenant (focusing on Administrative Unit features) when AzureADPreview cannot handle it correctly ;-)
# Note : currently Powershell Core and AzureADPreview are not working well together (logon / token request issue) : https://github.com/PowerShell/PowerShell/issues/10473 ==> this module will work only with Windows Powershell 5.1
# - cmdlet to get a valid access token (MFA supported) for Microsoft Graph Beta APIs
# - cmdlet to get a valid token for Microsoft Graph API standard / cloud endpoint (ressource graph.windows.net) and be able to use AzureADPreview cmdlets without reauthenticating
# - cmdlet to get all properties available (ex : extensionattribute) for an AAD user account
# - cmdlet to set a web proxy to be used with Use-AzureAD and AzureADPreview cmdlets
# - cmdlet to get all info for current logged in (@ Azure AD Tenant and Graph APIs) AAD user account
# - cmdlet to create / synchronize your on premise Active Directory OUs with Azure AD Administrive Units (not managed currently through Azure AD Connect or other Microsoft cmdlets / modules)
# - cmdlet to add / synchronize your on premise Active Directory users DN with Azure AD Administrative Unit membership (not managed currently through Azure AD Connect or other Microsoft cmdlets / modules)
# - cmdlet to add / remove Azure AD user account in Administrative Unit Role (everything managed in an easy and smooth way including, enabling the AAD role if missing and so on)
# - cmdlet to list all members of an Azure AD Administrative Unit (limited @ first 100 objets with default MS cmdlet... #WTF)
# v0.6 : beta version - focus on Azure AD Connect Cloud Provisionning Tools
# - cmdlet to get your current schema for a specific provisionning agent / service principal
# - cmdlet to update your current schema for a specific provisionning agent / service principal
# - cmdlet to get your default schema (template) for Azure AD Connect Cloud Provisionning
# - cmdlet to get a valid token (MFA supported) for Microsoft Graph API standard / cloud endpoint and MSOnline endpoint and be able to use MSOnline cmdlets without reauthenticating
# v0.7 : beta version - update Administrative Unit features (missing features from Microsoft Cmdlets and new API features)
# - cmdlet to create an Administrative Unit with hidden members
# - cmdlet to get Administrative Units with hidden members
# - cmdlet to create delta view for users, groups, admin units objects
# - cmdlet to get all updates from a delta view for users, groups, admin units objects
#
# v0.8 : last public release - beta version - fix azuread proxy bug when using SSO, add cmdlets to manage Azure AD Dynamic Security Groups
# - fix Set-AzureADproxy cmdlet : not able to set correctly the parameter *ProxyUseDefaultCredentials*
# - new cmdlets to add, get, update Azure AD Dynamic Membership security groups
# - cmdlet to test Dynamic membership for users
# Note : in current release of AzureADPreview I have found a bug regarding Dynamic group (all *-AzureADMSGroup cmdlets). When you try to use them, you have a Null Reference Exception :  
# System.NullReferenceException,Microsoft.Open.MSGraphBeta.PowerShell.NewMSGroup
#
#'(c) 2020 lucas-cueff.com - Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).'

<#
	.SYNOPSIS 
    cmdlets to use several APIs of Microsoft Graph Beta web service (mainly users,me,AdministrativeUnit)
    extend AzureADPreview capabilities in Azure AD Administrative Unit management

	.DESCRIPTION
	use-AzureAD.psm1 module provides easy to use cmdlets to manage your Azure AD tenant with a focus on Administrative Unit objects.
	
	.EXAMPLE
	C:\PS> import-module use-AzureAD.psm1
#>
Function Get-AzureADAccessToken {
<#
	.SYNOPSIS 
	Get a valid Access Token / Refresh Token for MS Graph APIs and MS Graph APIs Beta

	.DESCRIPTION
	Get a valid Access Token / Refresh Token for MS Graph APIs and MS Graph APIs Beta, using ADAL library, all authentication supported including MFA. Tenant ID automatically resolved.
	
	.PARAMETER adminUPN
	-adminUPN System.Net.Mail.MailAddress
	UserPrincipalName of an Azure AD account with rights on Directory (for instance a user with Global Admin right)
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get an access token for my admin account (my-admin@mydomain.tld)
	C:\PS> Get-AzureADAccessToken -adminUPN my-admin@mydomain.tld
#>
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$true)]
            [System.Net.Mail.MailAddress]$adminUPN
    )
    Process {
    $clientId = "1b730954-1685-4b74-9bfd-dac224a7b894"
    #$clientId = "1950a258-227b-4e31-a9cf-717495945fc2"
    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    $resourceURI = "https://graph.microsoft.com"
    $authority = "https://login.microsoftonline.com/$($adminUPN.Host)"
    $AadModule = Test-ADModule -AzureAD
    try {
        $adallib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        $adalformslib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"
        [System.Reflection.Assembly]::LoadFrom($adallib) | Out-Null
        [System.Reflection.Assembly]::LoadFrom($adalformslib) | Out-Null
        $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
        $platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
        $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($adminUPN.Address, "OptionalDisplayableId")
        $authResult = $authContext.AcquireTokenAsync($resourceURI, $ClientId, $redirectUri, $platformParameters, $userId)
    } catch {
        Write-Error -Message "$($_.Exception.Message)"
        throw "Not Able to log you on your Azure AD Tenant - exiting"
    }
    if ($authResult.result) {
        $tmpobj = [PSCustomObject]@{
            UserName = $adminUPN
            AccessToken = $authResult.result.AccessToken
            TokenExpiresOn = $authResult.result.ExpiresOn
        }
        $global:AADConnectInfo = $tmpobj.psobject.Copy()
        $tmpobj | add-member -MemberType NoteProperty -Name 'ObjectID' -Value (Get-AzureADMyInfo).id
        $tmpobj | add-member -MemberType NoteProperty -Name 'TenantID' -Value (Get-AzureADTenantInfo -adminUPN $adminUPN).TenantID
    } else {
        throw "Authorization Access Token is null, please re-run authentication - exiting"
    }
    $global:AADConnectInfo = $tmpobj.psobject.Copy()
    $global:AADConnectInfo
    }
}
Function Get-AzureADMyInfo {
<#
	.SYNOPSIS 
	Get all Azure AD account properties of current logged in user

	.DESCRIPTION
	Get all Azure AD account properties of current logged in user. Note : including hidden properties like extensionattribute.
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get all user account properties of my current account (my-admin@mydomain.tld)
	C:\PS> Get-AzureADMyInfo
#>
    [cmdletbinding()]
	Param ()
    process {
        Test-AzureADAccesToken
        Invoke-APIMSGraphBeta -API "me" -Method "GET"
    }
}
Function Get-AzureADTenantInfo {
<#
	.SYNOPSIS 
	Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta

	.DESCRIPTION
	Get a valid Access Tokem / Refresh Token for MS Graph APIs and MS Graph APIs Beta, using ADAL library, all authentication supported including MFA. Tenant ID automatically resolved.
	
	.PARAMETER adminUPN
	-adminUPN System.Net.Mail.MailAddress
	UserPrincipalName of an Azure AD account with rights on Directory (for instance a user with Global Admin right)
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get an access token for my admin account (my-admin@mydomain.tld)
	C:\PS> Get-AzureADTenantInfo -adminUPN my-admin@mydomain.tld
#>
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$true)]
            [System.Net.Mail.MailAddress]$adminUPN
    )
    process {
        $url = "https://login.microsoftonline.com/$($adminUPN.Host)/.well-known/openid-configuration"
        write-verbose -Message "GET method to $($url)"
        Try {
            $tmpobj = (Invoke-WebRequest $url).content | ConvertFrom-Json
        } catch {
            $tmpobj = $_ | ConvertFrom-Json
        }
        if ($tmpobj.issuer) {
            $tmpobj | Add-Member -MemberType NoteProperty -Name 'TenantID' -Value ([uri]$tmpobj.issuer).AbsolutePath.Replace("/","")
        }
        $tmpobj
    }
}
Function Connect-AzureADFromAccessToken {
<#
	.SYNOPSIS 
	Connect to your Azure AD Tenant / classic MS Graph endpoint used by AzureADPreview module using an existing Access token requested with Get-AzureADAccessToken

	.DESCRIPTION
	Connect to your Azure AD Tenant / classic MS Graph endpoint used by AzureADPreview module using an existing Access token requested with Get-AzureADAccessToken
			
	.OUTPUTS
   	TypeName : Microsoft.Open.Azure.AD.CommonLibrary.PSAzureContext
		
	.EXAMPLE
	Connect to your Azure AD Tenant / classic MS Graph endpoint used by AzureADPreview module using an existing Access token requested with Get-AzureADAccessToken
	C:\PS> Connect-AzureADFromAccessToken
#>
    [cmdletbinding()]
    Param ()
    Test-AzureADAccesToken
    $AadModule = Test-ADModule -AzureAD
    if ($global:AADConnectInfo.AccessToken) {
        $resourceURI = "https://graph.windows.net"
        $clientId = "1b730954-1685-4b74-9bfd-dac224a7b894"
        $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
        $authority = "https://login.microsoftonline.com/$(($global:AADConnectInfo.UserName).host)"
        try {
            $adallib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
            $adalformslib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"
            [System.Reflection.Assembly]::LoadFrom($adallib) | Out-Null
            [System.Reflection.Assembly]::LoadFrom($adalformslib) | Out-Null
            $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
            $platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
            $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($global:AADConnectInfo.UserName, "OptionalDisplayableId")
            $authResult = $authContext.AcquireTokenAsync($resourceURI, $ClientId, $redirectUri, $platformParameters, $userId)
        } catch {
            Write-Error -Message "$($_.Exception.Message)"
            throw "Not Able to log you on your Azure AD Tenant - exiting"
        }        
        connect-azuread -tenantid $global:AADConnectInfo.TenantID -AadAccessToken $authResult.result.AccessToken -AccountId $global:AADConnectInfo.ObjectID
    } else {
        throw "No valid Access Token found - exiting"
    }
}
Function Connect-MSOnlineFromAccessToken {
    <#
        .SYNOPSIS 
        Connect to your Azure AD Tenant / classic MS Graph endpoint used by MSOnline module using an existing Access token requested with Get-AzureADAccessToken
    
        .DESCRIPTION
        Connect to your Azure AD Tenant / classic MS Graph endpoint used by MSOnline module using an existing Access token requested with Get-AzureADAccessToken
                
        .OUTPUTS
        None
                
        .EXAMPLE
        Connect to your Azure AD Tenant / classic MS Graph endpoint used by MSOnline module using an existing Access token requested with Get-AzureADAccessToken
        C:\PS> Connect-MSOnlineFromAccessToken
    #>
        [cmdletbinding()]
        Param ()
        Test-AzureADAccesToken
        Test-ADModule -MSOnline | out-null
        $AadModule = Test-ADModule -AzureAD
        if ($global:AADConnectInfo.AccessToken) {
            $resourceURI = "https://graph.windows.net"
            $clientId = "1b730954-1685-4b74-9bfd-dac224a7b894"
            $redirectUri = new-object System.Uri("http://localhost/")
            $authority = "https://login.microsoftonline.com/$(($global:AADConnectInfo.UserName).host)"
            try {
                $adallib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
                $adalformslib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"
                [System.Reflection.Assembly]::LoadFrom($adallib) | Out-Null
                [System.Reflection.Assembly]::LoadFrom($adalformslib) | Out-Null
                $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
                $platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
                $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($global:AADConnectInfo.UserName, "OptionalDisplayableId")
                $authResult = $authContext.AcquireTokenAsync($resourceURI, $ClientId, $redirectUri, $platformParameters, $userId)
            } catch {
                Write-Error -Message "$($_.Exception.Message)"
                throw "Not Able to log you on your Azure AD Tenant - exiting"
            }
            Connect-MsolService -AccessToken $authResult.result.AccessToken
        } else {
            throw "No valid Access Token found - exiting"
        }
}
Function Set-AzureADProxy {
<#
	.SYNOPSIS 
	Set a web proxy to connect to Azure AD graph API

	.DESCRIPTION
	Set / remove a proxy to connect to your Azure AD environment using AzureADPreview module or this module. Can handle anonymous proxy or authenticating proxy.
	
	.PARAMETER DirectNoProxy
	-DirectNoProxy Swith
    Remove proxy set, set to "direct" connection
    
    .PARAMETER Proxy
	-Proxy uri
    Set the proxy settings to URI provided. Must be provided as a valid URI like http://proxy:port
    
    .PARAMETER ProxyCredential
	-ProxyCredential Management.Automation.PSCredential
    must be use with Proxy parameter
    Set the credential to be used with the proxy to set. Must be provided as a valid PSCredential object (can be generated with Get-Credential)

    .PARAMETER ProxyUseDefaultCredentials
    -ProxyUseDefaultCredentials Swith
    must be use with Proxy parameter
    Set the credential to be used with the proxy to set. this switch will tell the system to use the current logged in credential to be authenticated with the proxy service.
		
	.OUTPUTS
   	TypeName : System.Net.WebProxy
		
	.EXAMPLE
	Remove Proxy
    C:\PS> Set-AzureADProxy -DirectNoProxy
    
    .EXAMPLE
	Set a local anonymous proxy 127.0.0.1:8888
	C:\PS> Set-AzureADProxy -Proxy "http://127.0.0.1:8888"
#>
    [cmdletbinding()]
	Param (
	  [Parameter(Mandatory=$false)]
	    [switch]$DirectNoProxy,
	  [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
	    [uri]$Proxy,
	  [Parameter(Mandatory=$false)]
	    [Management.Automation.PSCredential]$ProxyCredential,
	  [Parameter(Mandatory=$false)]
	    [Switch]$ProxyUseDefaultCredentials
    )
    process {
        if ($DirectNoProxy.IsPresent){
            [System.Net.WebRequest]::DefaultWebProxy = $null
        } ElseIf ($Proxy) {
            $proxyobj = New-Object System.Net.WebProxy $proxy.AbsoluteUri            
            if ($ProxyCredential){
                $proxyobj.Credentials = $ProxyCredential
            } Elseif ($ProxyUseDefaultCredentials.IsPresent){
                $proxyobj.UseDefaultCredentials = $true
            } 
            [System.Net.WebRequest]::DefaultWebProxy = $proxyobj
            $proxyobj
        }
    }
}
Function Clear-AzureADAccessToken {
<#
	.SYNOPSIS 
	Clear an existing MS Graph APIs and MS Graph APIs Beta Access Token

	.DESCRIPTION
	Clear an existing MS Graph APIs and MS Graph APIs Beta Access Token. Required to be already authenticated.
	
	.PARAMETER adminUPN
	-adminUPN System.Net.Mail.MailAddress
	UserPrincipalName of the Azure AD account currently logged in that you want the access token to be removed
		
	.OUTPUTS
    None
		
	.EXAMPLE
	Get an access token for my admin account (my-admin@mydomain.tld)
	C:\PS> Clear-AzureADAccessToken -adminUPN my-admin@mydomain.tld
#>
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$true)]
            [System.Net.Mail.MailAddress]$adminUPN
    )
    $authority = "https://login.microsoftonline.com/$($adminUPN.Host)"
    Test-ADModule -AzureAD | Out-Null
    try {
        $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
        $authContext.TokenCache.Clear()
    } catch {
        throw "Not Able to clear your current tokens and disconnect your session - exiting"
    }
}
Function Sync-ADOUtoAzureADAdministrativeUnit {
<#
	.SYNOPSIS 
	Create new Azure AD Administrative Unit based on on premise AD Organizational Unit

	.DESCRIPTION
	Create new Azure AD Administrative Unit based on on premise AD Organizational Unit. Can be used to synchronize all existing on prem AD root OU with new cloud Admin unit.
	
	.PARAMETER AllRootOU
	-AllRootOU Switch
    Synchronize all existing OU to new cloud Admin Unit (except default OU like Domain Controllers)
    
    .PARAMETER RootOUFilterName
	-RootOUFilterName string
    must be used with AllRootOU parameter
    Set a "like" filter to synchronize only OU based on a specific pattern. For instance "TP-*" to synchronize only OU with a name starting with TP-

    .PARAMETER OUsDN
	-OUsDN string / array of string
    must not be used with AllRootOU parameter. you must choose between these 2 parameters.
    string must be a LDAP Distinguished Name. For instance : "OU=TP-VB,DC=domain,DC=xyz"
		
	.OUTPUTS
   	TypeName : Microsoft.Open.AzureAD.Model.AdministrativeUnit
		
	.EXAMPLE
    Create new cloud Azure AD administrative Unit for each on prem' OU found with a name starting with "TP-"
    The verbose option can be used to write basic message on console (for instance when an admin unit already existing)
	C:\PS> Sync-ADOUtoAzureADAdministrativeUnit -AllRootOU -RootOUFilterName "TP-*" -Verbose
#>
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$false)]
            [switch]$AllRootOU,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$RootOUFilterName,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string[]]$OUsDN
    )
    process {
        if (!($AllRootOU.IsPresent) -and !($OUsDN)) {
            throw "AllRootOU switch parameter or OUsDN parameter must be used - exiting"
        }
        Test-ADModule -AzureAD -AD | Out-Null
        If ($AllRootOU.IsPresent) {
            if ($RootOUFilterName) {
                $OUs = Get-ADOrganizationalUnit -Filter {name -like $RootOUFilterName}
            } else {
                $Ous = Get-ADOrganizationalUnit -Filter {name -ne "Domain Controllers"}
            }
        } elseif ($OUsDN) {
            $OUs = @()
            foreach ($OU in $OUsDN) {
                if ($OU -match "^(?:(?<cn>CN=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$") {
                    try {
                        $OU = Get-ADOrganizationalUnit -Identity $OU
                    } Catch {
                        write-verbose "OU $($OU) not found in directory"
                    }
                    if ($OU) {
                        $OUs += $OU
                    }
                }
            }
        }
        foreach ($OU in $OUs) {
            If (!(Get-AzureADAdministrativeUnit -Filter "displayname eq '$($OU.name)'")) {
                try {
                    New-AzureADAdministrativeUnit -Description "Windows Server AD OU $($OU.DistinguishedName)" -DisplayName $OU.name
                } catch {
                    Write-Error -Message "$($_.Exception.Message)"
                }
                write-verbose "$($OU.name) Azure Administrative Unit created"
            } else {
                write-verbose "$($OU.name) Azure Administrative Unit already exists"
            }
        }
        Get-AzureADAdministrativeUnit
    }
}
Function Sync-ADUsertoAzureADAdministrativeUnitMember {
<#
	.SYNOPSIS 
	Add Azure AD user account into Azure AD Administrative Unit based on their on premise LDAP Distinguished Name

	.DESCRIPTION
	Add Azure AD user account into Azure AD Administrative Unit based on their on premise LDAP Distinguished Name.
	
	.PARAMETER CloudUPNAttribute
	-CloudUPNAttribute string
    On premise AD user account attribute hosting the cloud Azure AD User userprincipal name. For instance, it could be also the userPrincipalName attribute or mail attribute.
    
    .PARAMETER AllRootOU
	-AllRootOU Switch
    Synchronize all existing OU to new cloud Admin Unit (except default OU like Domain Controllers)
    
    .PARAMETER RootOUFilterName
	-RootOUFilterName string
    must be used with AllRootOU parameter
    Set a "like" filter to synchronize only OU based on a specific pattern. For instance "TP-*" to synchronize only OU with a name starting with TP-

    .PARAMETER OUsDN
	-OUsDN string / array of string
    must not be used with AllRootOU parameter. you must choose between these 2 parameters.
    string must be a LDAP Distinguished Name. For instance : "OU=TP-VB,DC=domain,DC=xyz"
		
	.OUTPUTS
   	None. verbose can be used to display message on console.
		
	.EXAMPLE
    Add Azure AD users to administrative unit based on their source Distinguished Name, do it only for users account with a DN containing a root OU name starting with "TP-"
    The verbose option can be used to write basic message on console (for instance when a user is already member of an admin unit)
	C:\PS> Sync-ADUsertoAzureADAdministrativeUnitMember -CloudUPNAttribute mail -AllRootOU -RootOUFilterName "TP-*" -Verbose
#>
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$CloudUPNAttribute,
        [parameter(Mandatory=$false)]
            [switch]$AllRootOU,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$RootOUFilterName,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string[]]$OUsDN
    )
    process {
        if (!($AllRootOU.IsPresent) -and !($OUsDN)) {
            throw "AllRootOU switch parameter or OUsDN parameter must be used - exiting"
        }
        Test-ADModule -AzureAD -AD | Out-Null
        If ($AllRootOU.IsPresent) {
            if ($RootOUFilterName) {
                $OUs = Get-ADOrganizationalUnit -Filter {name -like $RootOUFilterName}
            } else {
                $Ous = Get-ADOrganizationalUnit -Filter {name -ne "Domain Controllers"}
            }
        } elseif ($OUsDN) {
            $OUs = @()
            foreach ($OU in $OUsDN) {
                if ($OU -match "^(?:(?<cn>CN=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$") {
                    try {
                        $OU = Get-ADOrganizationalUnit -Identity $OU
                    } Catch {
                        write-verbose -message "OU $($OU) not found in directory"
                    }
                    if ($OU) {
                        write-verbose -message "OU $($OU) found in directory"
                        $OUs += $OU
                    }
                }
            }
        }
        foreach ($OU in $OUs) {
            $AZADMUnit = Get-AzureADAdministrativeUnit -Filter "displayname eq '$($OU.name)'"
            If ($AZADMUnit) {
                write-verbose -Message "Azure AD Administrative Unit $($OU.name) found"
                $AZADMUnitMember = $AZADMUnit | Get-AzureADAdministrativeUnitMember
                $users = Get-ADUser -SearchBase $OU.DistinguishedName -SearchScope Subtree -Filter * -Properties $CloudUPNAttribute
                foreach ($user in $users) {
                    try {
                        $azureaduser = get-azureaduser -objectid $user.($CloudUPNAttribute)
                    } catch {
                        write-verbose -message "Azure AD User $($user.$CloudUPNAttribute) not found"
                    }
                    if ($user.($CloudUPNAttribute)) {
                        write-verbose -message "Azure AD User $($user.$CloudUPNAttribute) found"
                        if ($AZADMUnitMember) {
                            if ($AZADMUnitMember.ObjectID -contains $azureaduser.ObjectID) {
                                Write-Verbose -message "Azure AD User $($user.($CloudUPNAttribute)) already member of $($OU.name) Azure Administrative Unit"
                            } else {
                                Write-Verbose -message "Azure AD User $($user.($CloudUPNAttribute)) not member of $($OU.name) Azure Administrative Unit"
                                try {
                                    Add-AzureADAdministrativeUnitMember -ObjectId $AZADMUnit.ObjectID -RefObjectId $azureaduser.ObjectID
                                } catch {
                                    Write-Error -Message "$($_.Exception.Message)"
                                    Write-Error -Message "not able to add $($user.($CloudUPNAttribute)) Azure AD User in $($OU.name) Azure Administrative Unit"
                                }
                                Write-Verbose -message "Azure AD User $($user.($CloudUPNAttribute)) added in $($OU.name) Azure Administrative Unit" 
                            }
                        } else {
                            Write-Verbose -message "Azure AD User $($user.($CloudUPNAttribute)) not member of $($OU.name) Azure Administrative Unit"
                            try {
                                Add-AzureADAdministrativeUnitMember -ObjectId $AZADMUnit.ObjectID -RefObjectId $azureaduser.ObjectID
                            } catch {
                                Write-Error -Message "$($_.Exception.Message)"
                                Write-Error -Message "not able to add $($user.($CloudUPNAttribute)) Azure AD User in $($OU.name) Azure Administrative Unit"
                            }
                            Write-Verbose -message "Azure AD User $($user.($CloudUPNAttribute)) added in $($OU.name) Azure Administrative Unit" 
                        }
                    }
                }
            } else {
                write-verbose -message "Azure AD Administrative Unit $($OU.name) not exist"
            }
        }
    }
}
Function Set-AzureADAdministrativeUnitAdminRole {
<#
	.SYNOPSIS 
	Add / remove Azure AD administrative unit role to Azure AD user

	.DESCRIPTION
	Add / remove Azure AD administrative unit role to Azure AD user
	
	.PARAMETER AdministrativeUnit
    -AdministrativeUnit string
    Dynamic parameter built using the list of Administrative Unit created in your Tenant.
    
    .PARAMETER AdministrativeRole
    -AdministrativeRole string
    Dynamic parameter built using the list of Role template available in your Tenant.
    Note : warning, currently all roles are not compliant with Administrative Unit object.

    .PARAMETER userUPN
    -userUPN System.Net.Mail.MailAddress
    user principal name of the account you want to add a new role

    .PARAMETER RoleAction
    -RoleAction string {Add, Remove}
    Specify the action to be done with the target role on the Azure AD user object : add or remove the role
		
	.OUTPUTS
   	TypeName : Microsoft.Open.AzureAD.Model.ScopedRoleMembership
		
	.EXAMPLE
	Give the role Password Administrator for the Admin unit TP-NF to my-admin-unit@mydomain.tld
	C:\PS> Set-AzureADAdministrativeUnitAdminRole -userUPN my-admin-unit@mydomain.tld -RoleAction ADD -AdministrativeUnit TP-NF -AdministrativeRole 'Password Administrator' -Verbose
#>
    [cmdletbinding()]
    param (
        [parameter(Mandatory=$true,Position=2)]
        [ValidateNotNullOrEmpty()]
            [System.Net.Mail.MailAddress]$userUPN,
        [parameter(Mandatory=$true,position=4)]
        [validateSet("Add","Remove")]
            [string]$RoleAction
    )
    DynamicParam
    {
        $ParameterNameAdmUnit = 'AdministrativeUnit'
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.ValueFromPipeline = $false
        $ParameterAttribute.ValueFromPipelineByPropertyName = $false
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.Position = 1
        $AttributeCollection.Add($ParameterAttribute)
        $arrSet = (Get-AzureADAdministrativeUnit).displayname
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameAdmUnit, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterNameAdmUnit, $RuntimeParameter)
        
        $ParameterNameAdmRole = 'AdministrativeRole'
        $AttributeCollection2 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute2 = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute2.ValueFromPipeline = $false
        $ParameterAttribute2.ValueFromPipelineByPropertyName = $false
        $ParameterAttribute2.Mandatory = $true
        $ParameterAttribute2.Position = 3
        $AttributeCollection2.Add($ParameterAttribute2)
        $arrSet =  (Get-AzureADDirectoryRoleTemplate).displayname
        $ValidateSetAttribute2 = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
        $AttributeCollection2.Add($ValidateSetAttribute2)
        $RuntimeParameter2 = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterNameAdmRole, [string], $AttributeCollection2)
        $RuntimeParameterDictionary.Add($ParameterNameAdmRole, $RuntimeParameter2)
        
        return $RuntimeParameterDictionary
   }
    Process {
       $AdminUnit = $PsBoundParameters[$ParameterNameAdmUnit]
       $AdminRole = $PsBoundParameters[$ParameterNameAdmRole]
       Test-ADModule -AzureAD | out-null
       try {
           $UserObj = Get-AzureADUser -ObjectId $userUPN.Address
       } catch {
            Write-Error -Message "$($_.Exception.Message)"
            throw "Not able to find user $($userUPN.Address) - exiting"  
       }
       $AdminUnitObj = Get-AzureADAdministrativeUnit -filter "DisplayName eq '$($AdminUnit)'"
       if (!($AdminUnitObj)) {
           throw "Not able to find $($AdminUnit) Azure AD Administrative Unit - exiting"
       }
       $AdminroleObj = Get-AzureADDirectoryRole -Filter "DisplayName eq '$($AdminRole)'"
       if (!($AdminroleObj)) {
           write-verbose -message "$($AdminRole) role currently disabled, needed to enable it before adding member"
            try {
                $AdminroleObj = Enable-AzureADDirectoryRole -RoleTemplateId (Get-AzureADDirectoryRoleTemplate | Where-Object {$_.Displayname -eq $AdminRole}).ObjectId
            } catch {
                Write-Error -Message "$($_.Exception.Message)"
                throw "Not able to enable requested role $($AdminRole) - exiting"
            }
       }
       try { 
           $AdminRoleMember = (Get-AzureADScopedRoleMembership -ObjectId $AdminUnitObj.ObjectID | Where-Object {$_.RoleObjectID -eq $AdminroleObj.ObjectID}).RoleMemberInfo
       } catch {
            Write-Error -Message "$($_.Exception.Message)"
       }
       If (($AdminRoleMember.ObjectId -contains $UserObj.ObjectId) -and ($RoleAction -eq "ADD")) {
           write-verbose "User $($userUPN.Address) already member of $($AdminRole) role"
       } elseif (($AdminRoleMember.ObjectId -notcontains $UserObj.ObjectId) -and ($RoleAction -eq "ADD")) {
           try {
                $AdmRoleMemberInfo = New-Object -TypeName Microsoft.Open.AzureAD.Model.RoleMemberInfo -Property @{ ObjectId =  $UserObj.ObjectId }
                Add-AzureADScopedRoleMembership -RoleObjectId $AdminroleObj.ObjectID -ObjectId $AdminUnitObj.ObjectID -RoleMemberInfo $AdmRoleMemberInfo
           } catch {
                Write-Error -Message "$($_.Exception.Message)"
                throw "Not able to add $($userUPN.Address) user in $($AdminRole) role for $($AdminUnit) Azure administrative unit - exiting"
           }
       }
       If (($AdminRoleMember.ObjectId -notcontains $UserObj.ObjectId) -and ($RoleAction -eq "Remove")) {
        write-verbose "User $($userUPN.Address) already removed from $($AdminRole) role"
        } elseif (($AdminRoleMember.ObjectId -contains $UserObj.ObjectId) -and ($RoleAction -eq "Remove")) {
            try {
                $AdmRoleMembershipID = (Get-AzureADScopedRoleMembership -ObjectId $AdminUnitObj.ObjectID | Where-Object {($_.RoleObjectID -eq $AdminroleObj.ObjectID) -and ($_.RoleMemberInfo.ObjectId -eq $UserObj.ObjectID)}).ID
                Remove-AzureADScopedRoleMembership -ObjectId $AdminUnitObj.ObjectID -ScopedRoleMembershipId $AdmRoleMembershipID
            } catch {
                Write-Error -Message "$($_.Exception.Message)"
                throw "Not able to remove $($userUPN.Address) user from $($AdminRole) role for $($AdminUnit) Azure administrative unit - exiting"
            }
        }
        Get-AzureADScopedRoleMembership -ObjectId $AdminUnitObj.ObjectID
   }
}
Function Get-AzureADUserAllInfo {
<#
	.SYNOPSIS 
	Get all info available for an existing Azure AD account

	.DESCRIPTION
	Get all info available for an existing Azure AD account (all user properties available including all the hidden one not managed by Get-AzureADUsers)
	
	.PARAMETER userUPN
	-userUPN System.Net.Mail.MailAddress
    UserPrincipalName of an Azure AD account
    
    .PARAMETER inputobject
    -inputobject Microsoft.Open.AzureAD.Model.User
     Microsoft.Open.AzureAD.Model.User object (for instance generated by Get-AzureADUser)
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get all users properties available for the Azure AD account my-admin@mydomain.tld
    C:\PS> get-azureaduser -ObjectId "my-admin@mydomain.tld" | Get-AzureADUserAllInfo

    .EXAMPLE
	Get all users properties available for the Azure AD account my-admin@mydomain.tld
    C:\PS> Get-AzureADUserAllInfo -userUPN "my-admin@mydomain.tld"
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.User]$inputobject,
        [parameter(Mandatory=$false)]
            [System.Net.Mail.MailAddress]$userUPN,
        [parameter(Mandatory=$false)]
            [switch]$All
    )
    process {
        Test-AzureADAccesToken
        if (!($userUPN) -and !($inputobject) -and !($all.IsPresent)) {
            throw "Please use userUPN or inputobject parameter or All switch - exiting"
        }
        $params = @{
            API = "users"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $params.add('APIParameter',$inputobject.ObjectId)
        } elseif ($userUPN.Address) {
            $params.add('APIParameter',$userUPN.Address)
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADAdministrativeUnitAllMembers {
<#
	.SYNOPSIS 
	Get all Azure AD account member of an Azure AD Administrative Unit

	.DESCRIPTION
	Get all Azure AD account member of an Azure AD Administrative Unit
	
	.PARAMETER ObjectId
	-ObjectId guid
    GUID of the Administrative Unit
    
    .PARAMETER inputobject
    -inputobject Microsoft.Open.AzureAD.Model.AdministrativeUnit
    Microsoft.Open.AzureAD.Model.AdministrativeUnit object (for instance created by Get-AzureADAdministrativeUnit)
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get all Azure AD user member of the admin unit TP-AL
	C:\PS> Get-AzureADAdministrativeUnit -Filter "displayname eq 'TP-AL'" | Get-AzureADAdministrativeUnitAllMembers
#>
    [cmdletbinding()]
	Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.AdministrativeUnit]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectId
    )
    process {
        Test-AzureADAccesToken
        if (!($ObjectId) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject parameter - exiting"
        }
        $params = @{
            API = "administrativeUnits"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $parameter = $inputobject.ObjectId + "/" + "members?"   
        } elseif ($ObjectId) {
            $parameter = $ObjectId + "/" + "members?$top=999"
        }
        $params.add('APIParameter',$parameter)
        Invoke-APIMSGraphBeta @params
    }
}
Function New-AzureADAdministrativeUnitHidden {
<#
	.SYNOPSIS 
	Create a new Administrative Unit with hidden membership

	.DESCRIPTION
	Create a new Administrative Unit with hidden membership. Only members of the admin unit can see the Admin Unit members. Azure AD user account with advanced roles (Global reader, global administrator..) can still see the Admin Unit members.
	
	.PARAMETER displayName
	-displayName String
    display name of the new admin unit
    
    .PARAMETER description
	-description String
	description name of the new admin unit
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Create a new Administrative Unit with hidden membership called testHidden
	C:\PS> New-AzureADAdministrativeUnitHidden -displayName "testHidden" -description "Hidden Test Admin unit"
#>
    [cmdletbinding()]
	Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$displayName,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$description
    )
    process {
        Test-AzureADAccesToken
        $body = [PSCustomObject]@{
            displayName = $displayName
            description = $description
            visibility = "HiddenMembership"
        }
        $params = @{
            API = "administrativeUnits"
            Method = "POST"
            APIBody = (ConvertTo-Json -InputObject $body -Depth 100)
        }
        write-verbose -Message "JSON Body : $(ConvertTo-Json -InputObject $body -Depth 100)"
        Invoke-APIMSGraphBeta @params
    } 
}
Function Get-AzureADAdministrativeUnitHidden {
<#
	.SYNOPSIS 
	Get Administrative Units with hidden membership

	.DESCRIPTION
	Get Administratives Unit with hidden membership. Only members of the admin unit can see the Admin Unit members. Azure AD user account with advanced roles (Global reader, global administrator..) can still see the Admin Unit members.
	
	.PARAMETER public
	-public boolean
    choose if you want to display Administrative Unit with hidden membership or public membership

    .PARAMETER inputobject
    -inputobject Microsoft.Open.AzureAD.Model.AdministrativeUnit
    Microsoft.Open.AzureAD.Model.AdministrativeUnit object (for instance created by Get-AzureADAdministrativeUnit)
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get Administrative Units with hidden membership
    C:\PS> Get-AzureADAdministrativeUnitHidden
    
    .EXAMPLE
	Get Administrative Units with public membership
	C:\PS> Get-AzureADAdministrativeUnitHidden -public $true
#>
    [cmdletbinding()]
	Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.AdministrativeUnit]$inputobject,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [bool]$public
    )
    process {
        Test-AzureADAccesToken
        $params = @{
            API = "administrativeUnits"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $params.Add('APIParameter',$inputobject.ObjectId)  
        }
        $adminunitobj = Invoke-APIMSGraphBeta @params
        if (($public -eq $false) -and !($inputobject)) {
            $adminunitobj | Where-Object { $_.visibility -eq "HiddenMembership"}
        } elseif (($public -eq $true) -and !($inputobject)) {
            $adminunitobj | Where-Object { $_.visibility -ne "HiddenMembership"}
        } else {
            $adminunitobj
        }
    }
}
Function Get-AzureADConnectCloudProvisionningServiceSyncSchema {
<#
	.SYNOPSIS 
	Get Azure AD Connect Cloud Sync schema for a provisionning agent

	.DESCRIPTION
	Get all properties of an Azure AD Connect Cloud Sync schema for a provisionning agent (synchronizationRules, schema, objectMappings rules...)
	
	.PARAMETER ObjectId
	-ObjectId guid
    GUID of the SPN used by your provisionning agent
    
    .PARAMETER OnPremADFQDN
    -OnPremADFQDN string
    FQDN of your on premise AD Domain managed through Azure AD Connect Cloud Provisionning (provisionning agent must already be declared)
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
            
	.EXAMPLE
	Get Azure AD Connect Cloud Sync schema for a provisionning agent of domain mydomain.tld
	C:\PS> Get-AzureADConnectCloudProvisionningServiceSyncSchema -OnPremADFQDN mydomain.tld
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$OnPremADFQDN,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [GUID]$ObjectID
    )
    process {
        if (!($OnPremADFQDN) -and !($ObjectID)) {
            throw "Use OnPremADFQDN or ObjectID parameter - exiting"
        }
        $params = @{
            API = "serviceprincipals"
            Method = "GET"
        }
        if ($OnPremADFQDN) {
            $params.add('APIParameter',"?`$filter=startswith(Displayname,'$($OnPremADFQDN)')")
        } elseif ($ObjectID) {
            $params.add('APIParameter',$ObjectID)
        }
        $spnobj = Invoke-APIMSGraphBeta @params
        write-verbose -message "SPN ID : $($spnobj.id)"
        $params['APIParameter'] = "$($spnobj.id)/synchronization/jobs/?`$filter=templateId eq 'AD2AADProvisioning'"
        $syncjobsobj = Invoke-APIMSGraphBeta @params
        write-verbose -message "AD2AADProvisioning ID : $syncjobsobj.id"
        if ($syncjobsobj.id -notlike "AD2AADProvisioning.*") {
            throw "Azure AD Service Principal does not seem to be an AD2AAD provisionning object - exiting"
        }
        $params['APIParameter'] = "$($spnobj.id)/synchronization/jobs/$($syncjobsobj.id)/schema"
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema {
    <#
        .SYNOPSIS 
        Get Azure AD Connect Cloud Sync default schema (Azure AD Connect Cloud Sync template)
    
        .DESCRIPTION
        Get all properties of the Azure AD Connect Cloud Sync default schema - Azure AD Connect Cloud Sync template (synchronizationRules, schema, objectMappings rules...)
        
        .PARAMETER ObjectId
        -ObjectId guid
        GUID of the SPN used by your provisionning agent
        
        .PARAMETER OnPremADFQDN
        -OnPremADFQDN string
        FQDN of your on premise AD Domain managed through Azure AD Connect Cloud Provisionning (provisionning agent must already be declared)
            
        .OUTPUTS
        TypeName : System.Management.Automation.PSCustomObject
                    
        .EXAMPLE
        Get Azure AD Connect Cloud Sync default schema of domain mydomain.tld
        C:\PS> Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema -OnPremADFQDN mydomain.tld
    #>
        [cmdletbinding()]
        Param (
            [Parameter(Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
                [string]$OnPremADFQDN,
            [parameter(Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
                [GUID]$ObjectID
        )
        process {
            if (!($OnPremADFQDN) -and !($ObjectID)) {
                throw "Use OnPremADFQDN or ObjectID parameter - exiting"
            }
            $params = @{
                API = "serviceprincipals"
                Method = "GET"
            }
            if ($OnPremADFQDN) {
                $params.add('APIParameter',"?`$filter=startswith(Displayname,'$($OnPremADFQDN)')")
            } elseif ($ObjectID) {
                $params.add('APIParameter',$ObjectID)
            }
            $spnobj = Invoke-APIMSGraphBeta @params
            write-verbose -message "SPN ID : $($spnobj.id)"
            $params['APIParameter'] = "$($spnobj.id)/synchronization/templates/AD2AADProvisioning/"
            Invoke-APIMSGraphBeta @params
        }
}
Function Update-AzureADConnectCloudProvisionningServiceSyncSchema {
<#
	.SYNOPSIS 
	Update your Azure AD Connect Cloud Sync schema for a provisionning agent

	.DESCRIPTION
	Update your  Azure AD Connect Cloud Sync schema for a provisionning agent (synchronizationRules, schema, objectMappings rules...)
	
	.PARAMETER ObjectId
	-ObjectId guid
    GUID of the SPN used by your provisionning agent
    
    .PARAMETER OnPremADFQDN
    -OnPremADFQDN string
    FQDN of your on premise AD Domain managed through Azure AD Connect Cloud Provisionning (provisionning agent must already be declared)
    
    .PARAMETER inputobject
    -inputobject PSCustomObject
    a PSCustom Object containing your new schema to upload
	.OUTPUTS 
   	None (except warning)
            
	.EXAMPLE
	Update your Azure AD Connect Cloud Sync schema for provisionning agent of domain mydomain.tld, new schema available in $schema object
	C:\PS> Update-AzureADConnectCloudProvisionningServiceSyncSchema -OnPremADFQDN mydomain.tld -inputobject $schema
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$OnPremADFQDN,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [GUID]$ObjectID,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
            [pscustomobject]$inputobject
    )
    process {
        if (!($OnPremADFQDN) -and !($ObjectID)) {
            throw "Use OnPremADFQDN or ObjectID parameter - exiting"
        }
        if ($inputobject.'@odata.context' -notlike "*AD2AADProvisioning*") {
            throw "PSCustomObject inputobject seems to be invalid (not containing an Azure AD Cloud Provisionning Schema) - exiting"
        }
        $params = @{
            API = "serviceprincipals"
            Method = "GET"
        }
        if ($OnPremADFQDN) {
            $params.add('APIParameter',"?`$filter=startswith(Displayname,'$($OnPremADFQDN)')")
        } elseif ($ObjectID) {
            $params.add('APIParameter',$ObjectID)
        }
        $spnobj = Invoke-APIMSGraphBeta @params
        write-verbose -message "SPN ID : $($spnobj.id)"
        $params['APIParameter'] = "$($spnobj.id)/synchronization/jobs/?`$filter=templateId eq 'AD2AADProvisioning'"
        $syncjobsobj = Invoke-APIMSGraphBeta @params
        write-verbose -message "AD2AADProvisioning ID : $syncjobsobj.id"
        if ($syncjobsobj.id -notlike "AD2AADProvisioning.*") {
            throw "Azure AD Service Principal does not seem to be an AD2AAD provisionning object - exiting"
        }
        $params['method'] = "PUT"
        $params['APIParameter'] = "$($spnobj.id)/synchronization/jobs/$($syncjobsobj.id)/schema"
        $params.add('APIBody',(ConvertTo-Json -InputObject $inputobject -Depth 100))
        Invoke-APIMSGraphBeta @params
    }
}
Function New-AzureADObjectDeltaView {
<#
	.SYNOPSIS 
	Create a new delta view for an Azure AD object

	.DESCRIPTION
    Create a new delta view for an Azure AD object. It can be used on several objects (groups, users, administrative units...) to retrieve change information occured between two moments (properties updated/removed/added, objects updated/removed/added).
    This cmdlet create the initial view (available at server side for 30 days maximum) and the cmdlet Get-AzureADObjectDeltaView will retrieve the changes occured between the first view creation.
	
	.PARAMETER ObjectType
	-ObjectType String {"Users","Groups","AdministrativeUnits"}
    target object type you want to use for the delta view
    
    .PARAMETER SelectProperties
    -SelectProperties String - array of strings
    object properties you want to watch, by default all properties will be followed

    .PARAMETER FilterIDs
    -FilterIDs String - array of strings
    object GUID you want to watch, by default all object from the object type selected will be followed
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Create an initial delta view for manager and department properties of all users objects
    C:\PS> New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department")
    
    .EXAMPLE
	Create an initial delta view for manager and department properties of fb01091c-a9b2-4cd2-bbc9-130dfc91452a and 2092d280-2821-45ae-9e47-e9433a65868d users objects
	C:\PS> New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department") -FilterIDs @("fb01091c-a9b2-4cd2-bbc9-130dfc91452a","2092d280-2821-45ae-9e47-e9433a65868d") -Verbose
#>
    [cmdletbinding()]
    param (
        [parameter(Mandatory=$true)]
        [validateSet("Users","Groups","AdministrativeUnits")]
            [string]$ObjectType,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string[]]$SelectProperties,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string[]]$FilterIDs
    )
    process {
        Test-AzureADAccesToken
        $params = @{
            API = $ObjectType
            Method = "GET"
        }
        if ($SelectProperties) {
            if ($SelectProperties.Count -gt 1) {
                $properties = $SelectProperties -join ","
            } else {
                $properties = $SelectProperties
            }
            Write-verbose -Message "Select properties : $($properties)"
            $parameterproperties = "`$select=" + $properties
        }
        if ($FilterIDs) {
            if ($FilterIDs.count -gt 1) {
                    $UpdFilterIDs = @()
                foreach ($FilterID in $FilterIDs) {
                    $UpdFilterIDs += "id eq '{0}'" -f $FilterID
                }
                $properties = $UpdFilterIDs -join " or "
            } else {
                $properties = "id eq '$($FilterIDs)'"
            }
            Write-verbose -Message "Select filter : $($properties)"
            $parameterfilters = "`$filter=" + $properties
        }
        if ($parameterproperties -and $parameterfilters) {
            $parameters = "delta?" + $parameterproperties + "&" + $parameterfilters
        } elseif ($parameterproperties -or $parameterfilters) {
            $parameters = "delta?" + $parameterproperties + $parameterfilters
        } else {
            $parameters = "delta"
        }
        Write-verbose -Message "parameters : $($parameters)"
        $params.Add('APIParameter',$parameters) 
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADObjectDeltaView {
<#
	.SYNOPSIS 
	Get all changes from a delta view for an Azure AD object

	.DESCRIPTION
    Get all changes from a delta view for an Azure AD object. A delta view for an Azure AD object must be created first with New-AzureADObjectDeltaView. 
    It can be used on several objects (groups, users, administrative units...) to retrieve change information occured between two moments (properties updated/removed/added, objects updated/removed/added).
    A maximum of 30 days changes can be retrieved.
	
	.PARAMETER inputobject
	-inputobject PSCustomObject
    PSCustomObject generated previously with New-AzureADObjectDeltaView cmdlet
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Get all updates from an initial delta view for manager and department properties of fb01091c-a9b2-4cd2-bbc9-130dfc91452a and 2092d280-2821-45ae-9e47-e9433a65868d users objects previously saved in $delta
    C:\PS> $delta = New-AzureADObjectDeltaView -ObjectType Users -SelectProperties @("manager","department") -FilterIDs @("fb01091c-a9b2-4cd2-bbc9-130dfc91452a","2092d280-2821-45ae-9e47-e9433a65868d") -Verbose
    C:\PS> Get-AzureADDeltaFromView -inputobject $delta
#>
    [cmdletbinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            $inputobject
    )
    process {
        Test-AzureADAccesToken
        if (!($inputobject[-1].deltaLink)) {
            throw "Not able to find deltalink property of the object - please use New-AzureADObjectDeltaView cmdlet to generate a view first - exiting"
        } else {
            write-verbose -Message "Delta link : $($inputobject[-1].deltaLink)"
            Invoke-APIMSGraphBeta -Method GET -Paging $inputobject[-1].deltaLink
        }
    }
}
Function Get-AzureADDynamicGroup {
<#
	.SYNOPSIS 
	Retrieve information about an Azure AD security dynamic group

	.DESCRIPTION
    Retrieve all available properties about an existing security group with dynamic membership
	
	.PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object

    .PARAMETER Displayname
    -DisplayName String
    Displayname of an existing Azure AD Group object

    .PARAMETER All
    -All switch
    swith parameter that can be used to retrieve all existing Azure AD security group with dynamic membership rule
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Get dynamic group with ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADDynamicGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

    .EXAMPLE
	Get all security group with dynamic membership
    C:\PS> Get-AzureADDynamicGroup -all

    .EXAMPLE
    Get dynamic group with Dynam_test display name
    C:\PS> Get-AzureADDynamicGroup -DisplayName "Dynam_test"
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.Group]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$DisplayName,
        [parameter(Mandatory=$false)]
            [switch]$All
    )
    process {
        Test-AzureADAccesToken
        if (!($ObjectID) -and !($inputobject) -and !($all.IsPresent) -and !($DisplayName)) {
            throw "Please use ObjectID or inputobject or DisplayName parameter or All switch - exiting"
        }
        $GroupFilter = "?`$filter=groupTypes/any(c:c+eq+'DynamicMembership')"
        $params = @{
            API = "groups"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $params.add('APIParameter',$inputobject.ObjectId)
        } elseif ($ObjectID) {
            $params.add('APIParameter',$ObjectID)
        } elseif ($DisplayName) {
            $params.add('APIParameter',$GroupFilter + "and displayName eq '$($DisplayName)'")
        } else {
            $params.add('APIParameter',$GroupFilter)
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function New-AzureADDynamicGroup {
<#
	.SYNOPSIS 
	Create a new Azure AD security dynamic group

	.DESCRIPTION
    Create a new Azure AD security dynamic group and set its membership rule
	
    .PARAMETER Description
    -Description String
    Description of the new group

    .PARAMETER Displayname
    -DisplayName String
    Displayname of the new group

    .PARAMETER MembershipRule
    -MembershipRule string
    Membership rule (string) of the new dynamic group. More info about rule definition here : https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-dynamic-membership
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Create a new dynamic group Dynam_test5 with a membership rule based on user extensionAttribute9 value "test"
    C:\PS> New-AzureADDynamicGroup -DisplayName "Dynam_test5" -Description "Dynam_test5" -MemberShipRule '(user.extensionAttribute9 -eq "test")'
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$DisplayName,
        [parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$Description,
        [parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$MemberShipRule
    )
    process {
        Test-AzureADAccesToken
        $ExistingGroup = Get-AzureADDynamicGroup -DisplayName $DisplayName
        If ($ExistingGroup.id) {
            throw "$($DisplayName) group is already existing with ID $($ExistingGroup.id)"
        } Else {
            $tmpbody = @{
                description = $Description
                displayName = $DisplayName
                groupTypes = @("DynamicMembership")
                mailEnabled = $false
                mailNickname = ($DisplayName -replace '[^a-zA-Z0-9]', '')
                membershipRule = $MemberShipRule
                membershipruleProcessingState = "On"
                SecurityEnabled = $true
            }
            $params = @{
                API = "groups"
                Method = "POST"
                APIBody = $tmpbody | ConvertTo-Json -Depth 99
            }
            write-verbose -Message $params.APIBody
            Invoke-APIMSGraphBeta @params
        }
    }
}
Function Remove-AzureADDynamicGroup {
<#
	.SYNOPSIS 
	Delete an existing Azure AD security dynamic group

	.DESCRIPTION
    Delete an existing Azure AD security dynamic group

    .PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object
	
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Remove an existing group named Dynam_test2 (displayname)
    C:\PS> Get-AzureADGroup -SearchString 'Dynam_test2' | Remove-AzureADDynamicGroup
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.Group]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID
    )
    process {
        Test-AzureADAccesToken
        if (!($ObjectID) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject - exiting"
        }
        if ($inputobject.ObjectID) {
            $ExistingGroup = Get-AzureADDynamicGroup -ObjectId $inputobject.ObjectID
        } elseif ($ObjectID) {
            $ExistingGroup = Get-AzureADDynamicGroup -ObjectId $ObjectID
        }
        if ($ExistingGroup.id) {
            $params = @{
                API = "groups"
                Method = "DELETE"
                APIParameter = $ExistingGroup.id
            }
            Invoke-APIMSGraphBeta @params
        } else {
            throw "Azure AD Group not existing in directory"
        }
    }
}
Function Set-AzureADDynamicGroup {
<#
	.SYNOPSIS 
	Update properties of an existing Azure AD security dynamic group

	.DESCRIPTION
    Update properties of an existing Azure AD security dynamic group, including processing state of the rule.

    .PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object
	
    .PARAMETER NewDescription
    -NewDescription String
    Description of the new group

    .PARAMETER NewDisplayname
    -NewDisplayName String
    Displayname of the new group

    .PARAMETER NewMembershipRule
    -NewMembershipRule string
    Membership rule (string) of the dynamic group. More info about rule definition here : https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-dynamic-membership
    
    .PARAMETER DisableRuleProcessingState
    -DisableRuleProcessingState Switch
    Disable processing state of the current rule

    .PARAMETER EnableRuleProcessingState
    -EnableRuleProcessingState Switch
    Enable processing state of the current rule

	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Update existing dynamic group 17a58653-3654-40bd-85ce-333ece486793 with a new description and membership rule
    C:\PS> Set-AzureADDynamicGroup -ObjectId 17a58653-3654-40bd-85ce-333ece486793 -NewDescription "test description" -NewMemberShipRule '(user.extensionAttribute1 -eq "test2")'

    .EXAMPLE
	Update existing dynamic group 17a58653-3654-40bd-85ce-333ece486793 to disable processing state of the current rule
    C:\PS> Set-AzureADDynamicGroup -ObjectId 17a58653-3654-40bd-85ce-333ece486793 -DisableRuleProcessingState
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.Group]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID,
        [Parameter(Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$NewDisplayName,
        [parameter(Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$NewDescription,
        [parameter(Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$NewMemberShipRule,
        [parameter(Mandatory=$false)]
            [switch]$DisableRuleProcessingState,
        [parameter(Mandatory=$false)]
            [switch]$EnableRuleProcessingState
    )
    process {
        Test-AzureADAccesToken
        if (!($ObjectID) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject - exiting"
        }
        if (!($NewDisplayName) -and !($NewDescription) -and !($NewMemberShipRule) -and !($DisableRuleProcessingState) -and !($EnableRuleProcessingState)) {
            throw "Please select at least one parameter to update : NewDisplayName, NewDescription, NewMemberShipRule, DisableRuleProcessingState, EnableRuleProcessingState - exiting"
        }
        if ($DisableRuleProcessingState -and $EnableRuleProcessingState) {
            throw "Please select between DisableRuleProcessingState and EnableRuleProcessingState parameters - exiting"
        }
        if ($inputobject.ObjectID) {
            $ExistingGroup = Get-AzureADDynamicGroup -ObjectId $inputobject.ObjectID
        } elseif ($ObjectID) {
            $ExistingGroup = Get-AzureADDynamicGroup -ObjectId $ObjectID
        }
        if ($ExistingGroup.id) {
            $tmpbody = @{}
            if ($NewDisplayName) {
                $tmpbody.add('displayName',$NewDisplayName)
                $tmpbody.add('mailNickname',($NewDisplayName -replace '[^a-zA-Z0-9]', ''))
            }
            if ($NewDescription) {
                $tmpbody.add('description',$NewDescription)
            }
            if ($NewMemberShipRule) {
                $tmpbody.add('membershipRule',$NewMemberShipRule)
            }
            if ($DisableRuleProcessingState) {
                $tmpbody.add('membershipruleProcessingState',"Paused")
            }
            if ($EnableRuleProcessingState) {
                $tmpbody.add('membershipruleProcessingState',"On")
            }
            $params = @{
                API = "groups"
                Method = "PATCH"
                APIParameter = $ExistingGroup.id
                APIBody = $tmpbody | ConvertTo-Json -Depth 99
            }
            write-verbose -Message $params.APIBody
            Invoke-APIMSGraphBeta @params
        } else {
            throw "Azure AD Group not existing in directory"
        }
    }
}
Function Test-AzureADUserForGroupDynamicMembership {
<#
	.SYNOPSIS 
	Delete an existing Azure AD security dynamic group

	.DESCRIPTION
    Delete an existing Azure AD security dynamic group

    .PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object

    .PARAMETER MemberID
    -MemberID Guid
    Guid of an Azure AD user account that you want to test from a membership perspective of the group

    .PARAMETER NewMembershipRule
    -NewMembershipRule string
    Membership rule (string) of dynamic group you want to test. More info about rule definition here : https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-dynamic-membership
	
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Test if ca57f8b0-0c86-4677-8167-7d37534bd3bc object user account is member of 53cf95f1-49be-463e-9856-77c2b2c3e4a0 dynamic group using a specific rule
    C:\PS> Test-AzureADUserForGroupDynamicMembership -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -MemberID ca57f8b0-0c86-4677-8167-7d37534bd3bc -MemberShipRule 'user.extensionAttribute9 -eq "test2"'

    .EXAMPLE
	Test if ca57f8b0-0c86-4677-8167-7d37534bd3bc object user account is member of 53cf95f1-49be-463e-9856-77c2b2c3e4a0 dynamic group
    C:\PS> Test-AzureADUserForGroupDynamicMembership -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -MemberID ca57f8b0-0c86-4677-8167-7d37534bd3bc
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.Group]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID,
        [parameter(Mandatory=$true)]
            [guid]$MemberID,
        [parameter(Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$MemberShipRule
    )
    process {
        Test-AzureADAccesToken
        if (!($ObjectID) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject - exiting"
        }
        if ($inputobject.ObjectID) {
            $ExistingGroup = Get-AzureADDynamicGroup -ObjectId $inputobject.ObjectID
        } elseif ($ObjectID) {
            $ExistingGroup = Get-AzureADDynamicGroup -ObjectId $ObjectID
        }
        if ($ExistingGroup.id) {
            try {
                $existinguser = get-azureaduser -objectid $MemberID
            } catch {
                throw "Azure AD User not exising in directory"
            }
            $tmpbody = @{
                memberId = $existinguser.objectid
            }
            $params = @{
                API = "groups"
                Method = "POST"
            }
            if ($MemberShipRule) {
                $tmpbody.add('membershipRule',$MemberShipRule)
                $params.add('APIParameter',"evaluateDynamicMembership")
            } else {
                $params.add('APIParameter',($ExistingGroup.id + "/evaluateDynamicMembership"))
            }
            $params.add('APIBody', ($tmpbody | ConvertTo-Json -Depth 99))
            write-verbose -Message $params.APIBody
            Invoke-APIMSGraphBeta @params
        } else {
            throw "Azure AD Group not existing in directory"
        }
    }
}
Function Invoke-APIMSGraphBeta {
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$false)]
        [validateSet("users","me","administrativeUnits","serviceprincipals","groups")]
            [string]$API,
        [parameter(Mandatory=$true)]
        [validateSet("GET","POST","PUT","PATCH","DELETE")]
            [string]$Method,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$APIParameter,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$APIBody,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [uri]$Paging
    )
    process {
        $authHeader = @{
            'Content-Type' = "application/json"
            'Authorization' = "Bearer $($global:AADConnectInfo.AccessToken)"
            'ExpiresOn' = $global:AADConnectInfo.TokenExpiresOn
            'x-ms-client-request-id' = [guid]::NewGuid()
            'x-ms-correlation-id'    = [guid]::NewGuid()
        }
        if (($paging.AbsoluteUri -like "*skiptoken=*") -or ($paging.AbsoluteUri -like "*deltatoken=*")) {
            $uri = $paging.AbsoluteUri
            write-verbose -Message $uri
        } else {
            $uri = "https://graph.microsoft.com/beta/$($API)"
            if ($APIParameter) {
                $uri = $uri + "/" + $APIParameter
            }
        }
        write-verbose -message "$($Method) to $($uri)"
        $params = @{ UseBasicParsing = $true;
            headers = $authHeader;
            Uri = $uri;
            Method = $Method
        }
        if ($Method -ne "GET") {
            $params.add("Body",$APIBody)
        }
        try {
            $response = Invoke-WebRequest @params
        } catch {
            $ex = $_.Exception
            $errorResponse = $ex.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorResponse)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd();
            write-verbose -message "Response content:`n$responseBody"
            throw "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription) - exiting"
        }
        if ($response.Content) {
            $result = ConvertFrom-Json $response.Content
            write-verbose -Message $response.Content
            if ($result.value) {
                $result.value
            } else {
                $result
            }
            if ($result.'@odata.nextLink') {
                write-verbose -Message "Paging : $($result.'@odata.nextLink')"
                Invoke-APIMSGraphBeta -Method GET -Paging $result.'@odata.nextLink'
            }
            if ($result.'@odata.deltaLink') {
                [PSCustomObject]@{
                    deltaLink = $result.'@odata.deltaLink'
                }
            }
        } else {
            Write-Warning "response is null - exiting"
        }
    }
}
Function Test-ADModule {
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$false)]
        [switch]$AzureAD,
        [parameter(Mandatory=$false)]
        [switch]$AD,
        [parameter(Mandatory=$false)]
        [switch]$MSOnline
    )
    Process {
        if ($AzureAD.IsPresent) {
            try {
                $AadModule = get-module -Name AzureADPreview
                if (!($AadModule)) {
                    import-module -name AzureADPreview
                    $AadModule = get-module -Name AzureADPreview
                }
            } catch {
                throw "AzureADPreview module is missing, please install this module using 'install-module AzureADPreview' - exiting"
            }
            $AadModule
        }
        if ($AD.IsPresent) {
            try {
                $AdModule = get-module -Name ActiveDirectory
                if (!($AdModule)) {
                    import-module -name ActiveDirectory
                    $AdModule = get-module -Name ActiveDirectory
                }
            } catch {
                throw "ActiveDirectory module is missing, please install this module using 'Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online' or 'Add-WindowsFeature -Name RSAT-AD-Tools' - exiting"
            }
            $AdModule
        }
        if ($MSOnline.IsPresent) {
            try {
                $AdModule = get-module -Name MSOnline
                if (!($AdModule)) {
                    import-module -name MSOnline
                    $MSOnlineModule = get-module -Name MSOnline
                }
            } catch {
                throw "MSOnline module is missing, please install this module using 'install-module MSOnline' - exiting"
            }
            $MSOnlineModule
        }
    }
}
Function Test-AzureADAccesToken {
    Process {
        if(!($global:AADConnectInfo.AccessToken)) {
            throw "Not able to find a valid Azure AD Access Token in cache, please use Get-AzureADAccessToken first - exiting"
        }
    }
}

Export-ModuleMember -Function Get-AzureADTenantInfo, Get-AzureADMyInfo, Get-AzureADAccessToken, Connect-AzureADFromAccessToken, Clear-AzureADAccessToken, 
                                Set-AzureADProxy, Test-ADModule, Sync-ADOUtoAzureADAdministrativeUnit, Invoke-APIMSGraphBeta, Get-AzureADUserAllInfo, Test-AzureADAccesToken,
                                Sync-ADUsertoAzureADAdministrativeUnitMember,Set-AzureADAdministrativeUnitAdminRole, Get-AzureADAdministrativeUnitAllMembers, Connect-MSOnlineFromAccessToken,
                                Get-AzureADConnectCloudProvisionningServiceSyncSchema, Update-AzureADConnectCloudProvisionningServiceSyncSchema,
                                Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema, New-AzureADAdministrativeUnitHidden, Get-AzureADAdministrativeUnitHidden,
                                New-AzureADObjectDeltaView, Get-AzureADObjectDeltaView, 
                                Get-AzureADDynamicGroup, New-AzureADDynamicGroup, Remove-AzureADDynamicGroup, Set-AzureADDynamicGroup, Test-AzureADUserForGroupDynamicMembership