
#
## Created by: lucas.cueff[at]lucas-cueff.com
#
## released on 03/2021
#
# v0.5 - first public release - beta version - cmdlets to manage your Azure Active Directory Tenant (focusing on Administrative Unit features) when AzureADPreview cannot handle it correctly ;-)
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
# v0.6 - beta version - focus on Azure AD Connect Cloud Provisionning Tools
# - cmdlet to get your current schema for a specific provisionning agent / service principal
# - cmdlet to update your current schema for a specific provisionning agent / service principal
# - cmdlet to get your default schema (template) for Azure AD Connect Cloud Provisionning
# - cmdlet to get a valid token (MFA supported) for Microsoft Graph API standard / cloud endpoint and MSOnline endpoint and be able to use MSOnline cmdlets without reauthenticating
# v0.7 - beta version - update Administrative Unit features (missing features from Microsoft Cmdlets and new API features)
# - cmdlet to create an Administrative Unit with hidden members
# - cmdlet to get Administrative Units with hidden members
# - cmdlet to create delta view for users, groups, admin units objects
# - cmdlet to get all updates from a delta view for users, groups, admin units objects
# v0.8 - beta version - fix azuread proxy bug when using SSO, add cmdlets to manage Azure AD Dynamic Security Groups
# - fix Set-AzureADproxy cmdlet : not able to set correctly the parameter *ProxyUseDefaultCredentials*
# - new cmdlets to add, get, update Azure AD Dynamic Membership security groups
# - cmdlet to test Dynamic membership for users
# Note : in current release of AzureADPreview I have found a bug regarding Dynamic group (all *-AzureADMSGroup cmdlets). When you try to use them, you have a Null Reference Exception :  
# System.NullReferenceException,Microsoft.Open.MSGraphBeta.PowerShell.NewMSGroup
# v0.9 - beta version - add functions / cmdlets related to group and licensing stuff
# - cmdlet to get all Azure AD User with licensing error members of a particular group
# - cmdlet to get licensing info of a particular group
# - cmdlet to add or remove a license on an Azure AD Group
# - cmdlet to get licensing assignment type (group or user) of a particular user
# v1.0 - beta version - add service principal management for authentication and fix / improve code using DaveyRance remark : https://github.com/DaveyRance
# v1.1 - beta version - update authority URL for Service Principal to be compliant with last version of ADAL library
# v1.2 - beta version - add several functions to be able to manage OU to Admin unit sync in a service principal security context with delegated rights on API (must use MS Graph API only instead of mixing Azure AD Graph and MS Graph APIs) :
# - update Sync-ADOUtoAzureADAdministrativeUnit
# - update cmdlet Sync-ADUsertoAzureADAdministrativeUnitMember
# - update cmdlet Get-AzureADUserCustom (Get-AzureADUserallproperties)
# - add cmdlet Get-AzureADServicePrincipalCustom
# - add cmdlet Get-AzureADAdministrativeUnitCustom
# - add cmdlet Add-AzureADAdministrativeUnitMemberCustom
# - add cmdlet New-AzureADAdministrativeUnitCustom (New-AzureADAdministrativeUnitHidden)
# - add cmdlet Watch-AzureADAccessToken (be able to watch and auto renew Access Token of a service principal before expiration - useful in a script context when operation can take more than one hour)
# - update cmdlet Set-AzureADProxy (add bypassproxy on local option)
# v1.3 - beta version - add function to get administrative units of a user account and remove a user account from an administrative unit
# - Get-AzureADUserAdministrativeUnitMemberOfCustom
# - Remove-AzureADAdministrativeUnitMemberCustom
# v1.4 - beta version - add functions to get and update organization information
# - Get-AzureADOrganizationCustom
# - Update-AzureADOrganizationCustom
#
# v1.5.1 - last public release - beta version - add function to get Azure AD Connect synchronization errors through MS Graph API to replace Get-MsolDirSyncProvisioningError
# - Get-AzureADOnPremisesProvisionningErrors
#
#'(c) 2021 lucas-cueff.com - Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).'

<#
	.SYNOPSIS 
    cmdlets to use several APIs of Microsoft Graph Beta web service (mainly users,me,AdministrativeUnit)
    extend AzureADPreview capabilities in Azure AD Administrative Unit management

	.DESCRIPTION
	use-AzureAD.psm1 module provides easy to use cmdlets to manage your Azure AD tenant with a focus on Administrative Unit objects.
	
	.EXAMPLE
	C:\PS> import-module use-AzureAD.psm1
#>
Function Watch-AzureADAccessToken {
<#
	.SYNOPSIS 
	Follow an Azure Access Token requested for a service principal and auto renew it before expiration

	.DESCRIPTION
	Follow an Azure Access Token requested for a service principal and auto renew it before expiration
	
	.PARAMETER StartAutoRenewal
	-StartAutoRenewal switch
    Start autorenewal for an existing Azure AD Access Token (must be requested first with Get-AzureADAccessToken)
    limited use with service principal only for security purpose
    
    .PARAMETER StopAutoRenewal
    -StopAutoRenewal switch
    stop autorenewal for an existing Azure AD Access Token
    
	.OUTPUTS
   	none
		
	.EXAMPLE
    Start to watch Azure AD Access Token requested for Service Principal 38846352-a67c-4a9a-a94c-c115be1fc52f and auto renew it before expiration
    C:\PS> Get-AzureADAccessToken -ServicePrincipalCertThumbprint E22EE5AE84909C49D4BF66C12BF88B2D0A53CDC2 -ServicePrincipalApplicationID 38846352-a67c-4a9a-a94c-c115be1fc52f -ServicePrincipalTenantDomain mydomain.tld
    C:\PS> Watch-AzureADAccessToken -StartAutoRenewal
    
    .EXAMPLE
	Stop autorenewal of Azure AD Access Token for Service Principal 38846352-a67c-4a9a-a94c-c115be1fc52f
	C:\PS> Watch-AzureADAccessToken -StopAutoRenewal
#>
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$false)]
            [switch]$StartAutoRenewal,
        [parameter(Mandatory=$false)]
            [switch]$StopAutoRenewal
    )
    process {
        if ($StartAutoRenewal.IsPresent) {
            Test-AzureADAccessTokenExpiration | out-null
            if (!($global:AADConnectInfo.ServicePrincipalName)) {
                throw "please request an Access token with a Service Principal to use this function - exit"
            }
            if (!($global:AADConnectInfo.TokenWatch)) {
                $global:AADRunSpaceTool = [hashtable]::Synchronized(@{})
                $global:AADRunSpaceTool.add('Host',$Host)
                if ($VerbosePreference) {
                    $global:AADRunSpaceTool.add('Verbose',$true)
                }
                $global:AADConnectInfo.add('TokenWatch',$true)
                $global:AADRunspace = [runspacefactory]::CreateRunspace()
                $global:AADRunspace.Open()
                $global:AADRunspace.SessionStateProxy.SetVariable('AADConnectInfo',$AADConnectInfo)
                $global:AADRunspace.SessionStateProxy.SetVariable('AADRunSpaceTool',$AADRunSpaceTool)
                $global:AADPwsh = [powershell]::Create()
                $global:AADPwsh.Runspace = $global:AADRunspace
                $scriptblock = {
                    import-module Use-AzureAD -force
                    while ($AADConnectInfo.TokenWatch) {
                        if (Test-AzureADAccessTokenExpiration) {
                            if ($AADRunSpaceTool.verbose) {
                                $AADRunSpaceTool.host.ui.WriteVerboseLine("expired token found")
                            }
                            if ($AADConnectInfo.ServicePrincipalName) {
                                Clear-AzureADAccessToken -ServicePrincipalTenantDomain $AADConnectInfo.TenantName
                                Get-AzureADAccessToken -ServicePrincipalCertThumbprint $AADConnectInfo.ServicePrincipalCertificate -ServicePrincipalApplicationID $AADConnectInfo.ServicePrincipalName -ServicePrincipalTenantDomain $AADConnectInfo.TenantName
                                if ($AADRunSpaceTool.verbose) {
                                    $AADRunSpaceTool.host.ui.WriteVerboseLine($AADConnectInfo.AccessToken)
                                }
                            }
                        }
                        start-sleep -Seconds 300
                        if ($AADRunSpaceTool.verbose) {
                            $AADRunSpaceTool.host.ui.WriteVerboseLine("token not expired")
                        }
                    } 
                }
                $global:AADPwsh.AddScript($scriptblock) | Out-Null
                $global:AADTokenWatch = $global:AADPwsh.BeginInvoke()
            } else {
                write-warning -Message "Azure AD Access token already monitored"
            }
        }
        if ($StopAutoRenewal.IsPresent) {
            if ($global:AADTokenWatch -and $global:AADConnectInfo.TokenWatch) {
                $global:AADConnectInfo.TokenWatch = $false
                $global:AADPwsh.EndInvoke($global:AADTokenWatch)
                $global:AADRunspace.close()
                $global:AADPwsh.Dispose()
                $global:AADConnectInfo.remove('TokenWatch')
                $global:AADConnectInfo.remove('host')
                Remove-Variable -Name AADTokenWatch -Force -Scope Global
                Remove-Variable -Name AADPwsh -Force -Scope Global
                Remove-Variable -Name AADRunspace -Force -Scope Global
                Remove-Variable -Name AADRunSpaceTool -Force -Scope Global
            }
        }
    }
}
Function Get-AzureADAccessToken {
<#
	.SYNOPSIS 
	Get a valid Access Token / Refresh Token for MS Graph APIs and MS Graph APIs Beta

	.DESCRIPTION
	Get a valid Access Token / Refresh Token for MS Graph APIs and MS Graph APIs Beta, using ADAL library, all authentication supported including MFA. Tenant ID automatically resolved.
	
	.PARAMETER adminUPN
	-adminUPN System.Net.Mail.MailAddress
    UserPrincipalName of an Azure AD account with rights on Directory (for instance a user with Global Admin right)
    
    .PARAMETER ServicePrincipalCertThumbprint
    -ServicePrincipalCertThumbprint string
    certificate thumbprint of the certificate to load (local machine certificate only)
    
    .PARAMETER ServicePrincipalApplicationID
    -ServicePrincipalApplicationID GUID
    guid of the application using the service principal

    .PARAMETER ServicePrincipalTenantDomain
    -ServicePrincipalTenantDomain string
    domain name / tenant name

	.OUTPUTS
   	TypeName : System.Collections.Hashtable+SyncHashtable
		
	.EXAMPLE
	Get an access token for my admin account (my-admin@mydomain.tld)
    C:\PS> Get-AzureADAccessToken -adminUPN my-admin@mydomain.tld
    
    .EXAMPLE
	Get an access token for service principal with application ID 38846352-a67c-4a9a-a94c-c115be1fc52f and a certificate thumbprint of E22EE5AE84909C49D4BF66C12BF88B2D0A53CDC2
	C:\PS> Get-AzureADAccessToken -ServicePrincipalCertThumbprint E22EE5AE84909C49D4BF66C12BF88B2D0A53CDC2 -ServicePrincipalApplicationID 38846352-a67c-4a9a-a94c-c115be1fc52f -ServicePrincipalTenantDomain mydomain.tld
#>
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [System.Net.Mail.MailAddress]$adminUPN,
        [parameter(Mandatory=$false)]
        [ValidateScript({test-path "Cert:\LocalMachine\My\$_"})]
            [string]$ServicePrincipalCertThumbprint,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [guid]$ServicePrincipalApplicationID,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$ServicePrincipalTenantDomain
    )
    Process {
        if ($ServicePrincipalCertThumbprint -and (!($ServicePrincipalApplicationID) -or !($ServicePrincipalTenantDomain))) {
            throw "please use ServicePrincipalApplicationID with ServicePrincipalCertThumbprint and ServicePrincipalTenantDomain"
        }
        if ($ServicePrincipalApplicationID -and (!($ServicePrincipalCertThumbprint) -or !($ServicePrincipalTenantDomain))) {
            throw "please use ServicePrincipalApplicationID with ServicePrincipalCertThumbprint and ServicePrincipalTenantDomain"
        }
        $AadModule = Test-ADModule -AzureAD
        $adallib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
        [System.Reflection.Assembly]::LoadFrom($adallib) | Out-Null
        if ($adminUPN) {
            $clientId = "1b730954-1685-4b74-9bfd-dac224a7b894"
            $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
            $resourceURI = "https://graph.microsoft.com"
            $authority = "https://login.microsoftonline.com/$($adminUPN.Host)"
            try {
                $adalformslib = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"
                [System.Reflection.Assembly]::LoadFrom($adalformslib) | Out-Null
                $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
                $platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
                $userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($adminUPN.Address, "OptionalDisplayableId")
                $authResult = $authContext.AcquireTokenAsync($resourceURI, $ClientId, $redirectUri, $platformParameters, $userId)
            } catch {
                Write-Error -Message "$($_.Exception.Message)"
                throw "Not able to log you on your Azure AD Tenant using user principal name provided - exiting"
            }
            if ($authResult.result) {
                if (!($global:AADConnectInfo)) {
                    $global:AADConnectInfo = [hashtable]::Synchronized(@{})
                    $global:AADConnectInfo.add('UserName',$adminUPN)
                    $global:AADConnectInfo.add('AccessToken',$authResult.result.AccessToken)
                    $global:AADConnectInfo.add('TokenExpiresOn',$authResult.result.ExpiresOn)
                    $global:AADConnectInfo.add('ObjectID',(Get-AzureADMyInfo).id)
                    $global:AADConnectInfo.add('TenantID',(Get-AzureADTenantInfo -adminUPN $adminUPN).TenantID)
                    $global:AADConnectInfo.add('TenantName',$adminUPN.Host)
                } else {
                    $global:AADConnectInfo.UserName = $adminUPN
                    $global:AADConnectInfo.AccessToken = $authResult.result.AccessToken
                    $global:AADConnectInfo.TokenExpiresOn = $authResult.result.ExpiresOn
                    $global:AADConnectInfo.ObjectID = (Get-AzureADMyInfo).id
                    $global:AADConnectInfo.TenantID = (Get-AzureADTenantInfo -adminUPN $adminUPN).TenantID
                    $global:AADConnectInfo.TenantName = $adminUPN.Host
                    if ($global:AADConnectInfo.ServicePrincipalCertificate) {
                        $global:AADConnectInfo.remove('ServicePrincipalCertificate')
                    }
                    if ($global:AADConnectInfo.ServicePrincipalName) {
                        $global:AADConnectInfo.remove('ServicePrincipalName')
                    }
                }
            } else {
                $authResult
                throw "Authorization Access Token is null, please re-run authentication - exiting"
            }
        }
        if ($ServicePrincipalCertThumbprint -and $ServicePrincipalApplicationID -and $ServicePrincipalTenantDomain) {
            $CertStore = "Cert:\LocalMachine\My"
            $CertStorePath = Join-Path $CertStore $ServicePrincipalCertThumbprint
            $Certificate = Get-Item $CertStorePath
            if (!$Certificate) {
              throw "not able to get certificate with $ServicePrincipalCertThumbprint thumbprint in local machine cert store - exiting"
            }
            $tenantinfo = Get-AzureADTenantInfo -ServicePrincipalTenantDomain $ServicePrincipalTenantDomain
            $resourceURI = "https://graph.microsoft.com"
            $authority = "https://login.microsoftonline.com/$($tenantinfo.TenantID)"
            try {
                $ClientCert = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.ClientAssertionCertificate" -ArgumentList ($ServicePrincipalApplicationID.guid, $Certificate)
                $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
                $authResult = $authContext.AcquireTokenAsync($resourceURI, $ClientCert)
            } catch {
                Write-Error -Message "$($_.Exception.Message)"
                throw "Not able to log you on your Azure AD Tenant using Service Principal information provided - exiting"
            }
            if ($authResult.result) {
                if (!($global:AADConnectInfo)) {
                    $global:AADConnectInfo = [hashtable]::Synchronized(@{})
                    $global:AADConnectInfo.add('ServicePrincipalName',$ServicePrincipalApplicationID)
                    $global:AADConnectInfo.add('ServicePrincipalCertificate',$ServicePrincipalCertThumbprint)
                    $global:AADConnectInfo.add('AccessToken',$authResult.result.AccessToken)
                    $global:AADConnectInfo.add('TokenExpiresOn',$authResult.result.ExpiresOn)
                    $global:AADConnectInfo.add('ObjectID',(Get-AzureADServicePrincipalCustom -Filter "appid eq '$($ServicePrincipalApplicationID)'").id)
                    $global:AADConnectInfo.add('TenantID',$tenantinfo.TenantID)
                    $global:AADConnectInfo.add('TenantName',$ServicePrincipalTenantDomain)
                } else {
                    $global:AADConnectInfo.ServicePrincipalName = $ServicePrincipalApplicationID
                    $global:AADConnectInfo.ServicePrincipalCertificate = $ServicePrincipalCertThumbprint
                    $global:AADConnectInfo.AccessToken = $authResult.result.AccessToken
                    $global:AADConnectInfo.TokenExpiresOn = $authResult.result.ExpiresOn
                    $global:AADConnectInfo.ObjectID = (Get-AzureADServicePrincipalCustom -Filter "appid eq '$($ServicePrincipalApplicationID)'").id
                    $global:AADConnectInfo.TenantID = $tenantinfo.TenantID
                    $global:AADConnectInfo.TenantName = $ServicePrincipalTenantDomain
                    if ($global:AADConnectInfo.UserName) {
                        $global:AADConnectInfo.remove('UserName')
                    }
                }
            } else {
                $authResult
                throw "Authorization Access Token is null, please re-run authentication - exiting"
            }
        }
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
        Test-AzureADAccessTokenExpiration | out-null
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
    
    .PARAMETER ServicePrincipalTenantDomain
    -ServicePrincipalTenantDomain string
    Tenant domain name of your Service Principal account
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get tenant info from my useraccount (my-admin@mydomain.tld)
    C:\PS> Get-AzureADTenantInfo -adminUPN my-admin@mydomain.tld
    
    .EXAMPLE
	Get tenant info from my service principal tenant domain name (mydomain.tld)
	C:\PS> Get-AzureADTenantInfo -ServicePrincipalTenantDomain mydomain.tld
#>
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [System.Net.Mail.MailAddress]$adminUPN,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$ServicePrincipalTenantDomain
    )
    process {
        if ($adminUPN) {
            $url = "https://login.microsoftonline.com/$($adminUPN.Host)/.well-known/openid-configuration"
            write-verbose -Message "GET method to $($url)"
        }
        if ($ServicePrincipalTenantDomain) {
            $url = "https://login.microsoftonline.com/$($ServicePrincipalTenantDomain)/.well-known/openid-configuration"
            write-verbose -Message "GET method to $($url)"
        }
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
    Test-AzureADAccessTokenExpiration | out-null
    $AadModule = Test-ADModule -AzureAD
    if ($global:AADConnectInfo.AccessToken) {
        if ($global:AADConnectInfo.UserName) {
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
            connect-azuread -tenantid $global:AADConnectInfo.TenantID -AadAccessToken $authResult.result.AccessToken -MsAccessToken $global:AADConnectInfo.AccessToken -AccountId $global:AADConnectInfo.ObjectID
        }
        if ($global:AADConnectInfo.ServicePrincipalName) {
            $CertStore = "Cert:\LocalMachine\My"
            $CertStorePath = Join-Path $CertStore $global:AADConnectInfo.ServicePrincipalCertificate
            $Certificate = Get-Item $CertStorePath
            if (!$Certificate) {
                throw "not able to get certificate with $ServicePrincipalCertThumbprint thumbprint in local machine cert store - exiting"
            }
            connect-azuread -tenantid $global:AADConnectInfo.TenantID -ApplicationId $global:AADConnectInfo.ServicePrincipalName -CertificateThumbprint $global:AADConnectInfo.ServicePrincipalCertificate
        }
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
        Test-AzureADAccessTokenExpiration | out-null
        Test-ADModule -MSOnline | out-null
        $AadModule = Test-ADModule -AzureAD
        if ($global:AADConnectInfo.AccessToken) {
            if ($global:AADConnectInfo.UserName) {
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
            }
            if ($global:AADConnectInfo.ServicePrincipalName) {
                Write-Warning -message "Service Principals are not supported for passthrough token to MSOnline."
            }
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
    
    .EXAMPLE
	Set a local anonymous proxy 127.0.0.1:8888 and request local traffic to not be sent to proxy
	C:\PS> Set-AzureADProxy -Proxy "http://127.0.0.1:8888" -BypassProxyOnLocal
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
        [Switch]$ProxyUseDefaultCredentials,
      [Parameter(Mandatory=$false)]
        [switch]$BypassProxyOnLocal
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
            if ($BypassProxyOnLocal.IsPresent) {
                $proxyobj.BypassProxyOnLocal = $true
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
    
    .PARAMETER ServicePrincipalTenantDomain
    -ServicePrincipalTenantDomain string
    domain name / tenant name
		
	.OUTPUTS
    None
		
	.EXAMPLE
	clear an access token for my admin account (my-admin@mydomain.tld)
    C:\PS> Clear-AzureADAccessToken -adminUPN my-admin@mydomain.tld

    .EXAMPLE
	clear an access token for a service principal from mydomain.tld
    C:\PS> Clear-AzureADAccessToken -ServicePrincipalTenantDomain mydomain.tld
#>
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [System.Net.Mail.MailAddress]$adminUPN,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$ServicePrincipalTenantDomain
    )
    if ($adminUPN) {
        $authority = "https://login.microsoftonline.com/$($adminUPN.Host)"
    }
    if ($ServicePrincipalTenantDomain) {
        $authority = "https://login.microsoftonline.com/$($ServicePrincipalTenantDomain)"
    }
    if (!($adminUPN) -and !($ServicePrincipalTenantDomain)) {
        throw "please use ServicePrincipalTenantDomain or adminUPN parameter"
    }
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
	
	.PARAMETER AllOUs
	-AllOUs Switch
    Synchronize all existing OU to new cloud Admin Unit (except default OU like Domain Controllers)
    
    .PARAMETER OUsFilterName
	-OUsFilterName string
    must be used with AllOUs parameter
    Set a regex filter to synchronize only OU based on a specific pattern.

    .PARAMETER SearchBase
    -SearchBase string
    must be used with AllOUs parameter
    set the default search base for OU (DN format)

    .PARAMETER OUsDN
	-OUsDN string / array of string
    must not be used with AllOUs parameter. you must choose between these 2 parameters.
    string must be a LDAP Distinguished Name. For instance : "OU=TP-VB,DC=domain,DC=xyz"
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
    Create new cloud Azure AD administrative Unit for each on prem' OU found with a pattern like "AB-CD"
    The verbose option can be used to write basic message on console (for instance when an admin unit already existing)
	C:\PS> Sync-ADOUtoAzureADAdministrativeUnit -AllOUs -OUsFilterName "^([a-zA-Z]{2})(-)([a-zA-Z]{2})$" -SearchBase "DC=domain,DC=xyz" -Verbose
#>
[cmdletbinding()]
Param (
    [parameter(Mandatory=$false)]
        [switch]$AllOUs,
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
        [string]$OUsFilterName,
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
        [string[]]$OUsDN,
    [parameter(Mandatory=$false)]
        [string]$SearchBase
)
process {
    if (!($AllOUs.IsPresent) -and !($OUsDN)) {
        throw "AllOUs switch parameter or OUsDN parameter must be used - exiting"
    }
    if ($AllOUs.IsPresent -and !($SearchBase)) {
        throw "SearchBase parameter must be used with AllOUs switch - exiting"
    }
    Test-ADModule -AD | Out-Null
    Test-AzureADAccessTokenExpiration | out-null
    If ($AllOUs.IsPresent) {
        if ($OUsFilterName) {
            $OUs = Get-ADOrganizationalUnit -Filter * -SearchBase $SearchBase
            $OUs = $OUs | where-object {$_.Name -match $OUsFilterName}
        } else {
            $Ous = Get-ADOrganizationalUnit -Filter {name -ne "Domain Controllers"} -SearchBase $SearchBase
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
                    $OUs += $OU
                }
            }
        }
    }
    foreach ($OU in $OUs) {
        If (!(Get-AzureADAdministrativeUnitCustom -Filter "displayname eq '$($OU.name)'").id) {
            try {
                New-AzureADAdministrativeUnitCustom -Description "Windows Server AD OU $($OU.DistinguishedName)" -DisplayName $OU.name
            } catch {
                write-error -message $_.Exception.Message
            }
            write-verbose -message "$($OU.name) Azure Administrative Unit created"
        } else {
            write-verbose -message  "$($OU.name) Azure Administrative Unit already exists"
        }
    }
        Get-AzureADAdministrativeUnitCustom -All
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
    
    .PARAMETER AllOUs
	-AllOUs Switch
    Synchronize all existing OU to new cloud Admin Unit (except default OU like Domain Controllers)
    
    .PARAMETER OUsFilterName
	-OUsFilterName string
    must be used with AllOUs parameter
    Set a regex filter to synchronize only OU based on a specific pattern.

    .PARAMETER SearchBase
    -SearchBase string
    must be used with AllOUs parameter
    set the default search base for OU (DN format)

    .PARAMETER OUsDN
	-OUsDN string / array of string
    must not be used with AllOUs parameter. you must choose between these 2 parameters.
    string must be a LDAP Distinguished Name. For instance : "OU=TP-VB,DC=domain,DC=xyz"
		
	.OUTPUTS
   	None. verbose can be used to display message on console.
		
	.EXAMPLE
    Add Azure AD users to administrative unit based on their source Distinguished Name, do it only for users account with a DN containing a root OU name matching a pattern like "AB-CD"
    The verbose option can be used to write basic message on console (for instance when a user is already member of an admin unit)
	C:\PS> Sync-ADUsertoAzureADAdministrativeUnitMember -CloudUPNAttribute mail -AllOUs -OUsFilterName "^([a-zA-Z]{2})(-)([a-zA-Z]{2})$" -SearchBase "DC=domain,DC=xyz" -Verbose
#>
[cmdletbinding()]
Param (
    [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$CloudUPNAttribute,
    [parameter(Mandatory=$false)]
        [switch]$AllOUs,
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
        [string]$OUsFilterName,
    [parameter(Mandatory=$false)]
        [string]$SearchBase,
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
        [string[]]$OUsDN,
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
        [string]$ADUserFilter
)
process {
    if (!($AllOUs.IsPresent) -and !($OUsDN)) {
        throw "AllOUs switch parameter or OUsDN parameter must be used - exiting"
    }
    if ($AllOUs.IsPresent -and !($SearchBase)) {
        throw "SearchBase parameter must be used with AllOUs switch - exiting"
    }
    if (!($ADUserFilter)) {
        $ADUserFilter = "*"
    }
    Test-ADModule -AD | Out-Null
    Test-AzureADAccessTokenExpiration | out-null
    If ($AllOUs.IsPresent) {
        if ($OUsFilterName) {
            $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope OneLevel -SearchBase $SearchBase
            $OUs = $OUs | where-object {$_.Name -match $OUsFilterName}
        } else {
            $Ous = Get-ADOrganizationalUnit -Filter {name -ne "Domain Controllers"} -SearchBase $SearchBase
        }
    } elseif ($OUsDN) {
        $OUs = @()
        foreach ($OU in $OUsDN) {
            if ($OU -match "^(?:(?<cn>CN=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$") {
                try {
                    $OU = Get-ADOrganizationalUnit -Identity $OU
                } Catch {
                    write-error -message "OU $($OU) not found in directory"
                }
                if ($OU) {
                    write-verbose -message "OU $($OU) found in directory"
                    $OUs += $OU
                }
            }
        }
    }
    foreach ($OU in $OUs) {
        $AZADMUnit = Get-AzureADAdministrativeUnitCustom -Filter "displayname eq '$($OU.name)'"
        If ($AZADMUnit.id) {
            $AZADMUnitMember = Get-AzureADAdministrativeUnitAllMembers -objectid $AZADMUnit.ID
            $users = Get-ADUser -SearchBase $OU.DistinguishedName -SearchScope Subtree -Filter $ADUserFilter -Properties $CloudUPNAttribute
            foreach ($user in $users) {
                $azureaduser = Get-AzureADUserCustom -userUPN $user.$CloudUPNAttribute
                if ($azureaduser.error) {
                    write-verbose -message"Azure AD User $($user.$CloudUPNAttribute) not found"
                } else {
                    if ($user.($CloudUPNAttribute)) {
                        write-verbose -message "Azure AD User $($user.$CloudUPNAttribute) found"
                        if ($AZADMUnitMember) {
                            if ($AZADMUnitMember.ID -contains $azureaduser.ID) {
                                write-verbose -message "Azure AD User $($user.($CloudUPNAttribute)) already member of $($OU.name) Azure Administrative Unit"
                            } else {
                                write-verbose -message "Azure AD User $($user.($CloudUPNAttribute)) not member of $($OU.name) Azure Administrative Unit"
                                try {
                                    Add-AzureADAdministrativeUnitMemberCustom -ObjectId $AZADMUnit.ID -RefObjectId $azureaduser.ID -RefObjectType users
                                } catch {
                                    write-error -message $_.Exception.Message
                                    write-error -message "not able to add $($user.($CloudUPNAttribute)) Azure AD User in $($OU.name) Azure Administrative Unit"
                                }
                                write-verbose -message "Azure AD User $($user.($CloudUPNAttribute)) added in $($OU.name) Azure Administrative Unit"
                            }
                        } else {
                            write-verbose -message "Azure AD User $($user.($CloudUPNAttribute)) not member of $($OU.name) Azure Administrative Unit"
                            try {
                                Add-AzureADAdministrativeUnitMemberCustom -ObjectId $AZADMUnit.ID -RefObjectId $azureaduser.ID -RefObjectType users
                            } catch {
                                write-error -message $_.Exception.Message
                                write-error -message "not able to add $($user.($CloudUPNAttribute)) Azure AD User in $($OU.name) Azure Administrative Unit"
                            }
                            write-verbose -message "Azure AD User $($user.($CloudUPNAttribute)) added in $($OU.name) Azure Administrative Unit"
                        }
                    }
                }
            }
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
       Test-AzureADAccessTokenExpiration | out-null
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
Function Get-AzureADUserCustom {
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

    .PARAMETER ObjectId
	-ObjectId guid
    GUID of the Azure AD user object

    .PARAMETER Filter
	-Filter string
    Odata Filter query
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get all users properties available for the Azure AD account my-admin@mydomain.tld
    C:\PS> get-azureaduser -ObjectId "my-admin@mydomain.tld" | Get-AzureADUserCustom

    .EXAMPLE
	Get all users properties available for the Azure AD account my-admin@mydomain.tld
    C:\PS> Get-AzureADUserCustom -userUPN "my-admin@mydomain.tld"
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.User]$inputobject,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [System.Net.Mail.MailAddress]$userUPN,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$Filter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [guid]$ObjectId
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($userUPN) -and !($inputobject) -and !($all.IsPresent) -and !($ObjectId) -and ($Filter)) {
            throw "Please use userUPN or inputobject or Filter or ObjectID Parameter or All switch - exiting"
        }
        $params = @{
            API = "users"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $params.add('APIParameter',$inputobject.ObjectId)
        } elseif ($userUPN.Address) {
            $params.add('APIParameter',$userUPN.Address)
        } elseif ($ObjectId) {
            $params.add('APIParameter',$ObjectId.Guid)
        } elseif ($Filter) {
            $params.add('APIParameter',"?`$filter=$($Filter)")
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
        Test-AzureADAccessTokenExpiration | out-null
        if (!($ObjectId) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject parameter - exiting"
        }
        $params = @{
            API = "administrativeUnits"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $parameter = $inputobject.ObjectId + "/members?`$top=999"
        } elseif ($ObjectId) {
            $parameter = $ObjectId.guid + "/members?`$top=999"
        }
        $params.add('APIParameter',$parameter)
        Invoke-APIMSGraphBeta @params
    }
}
Function New-AzureADAdministrativeUnitCustom {
<#
	.SYNOPSIS 
	Create a new Azure AD Administrative Unit

	.DESCRIPTION
	Create a new Administrative Unit with hidden membership managed. if used, only members of the admin unit can see the Admin Unit members. Azure AD user account with advanced roles (Global reader, global administrator..) can still see the Admin Unit members.
	
	.PARAMETER displayName
	-displayName String
    display name of the new admin unit
    
    .PARAMETER description
	-description String
    description name of the new admin unit
    
    .PARAMETER Hidden
    -Hidden {switch}
    use the swith to set administrative unit as hidden
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Create a new Administrative Unit with hidden membership called testHidden
    C:\PS> New-AzureADAdministrativeUnitCustom -displayName "testHidden" -description "Hidden Test Admin unit" -Hidden
    
    .EXAMPLE
	Create a new Administrative Unit membership called test
	C:\PS> New-AzureADAdministrativeUnitCustom -displayName "test" -description "Test Admin unit"
#>
    [cmdletbinding()]
	Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$displayName,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$description,
        [parameter(Mandatory=$false)]
            [switch]$Hidden
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        $body = [PSCustomObject]@{
            displayName = $displayName
            description = $description
        }
        if ($Hidden.IsPresent) {
            $body | add-member -NotePropertyName visibility -NotePropertyValue "HiddenMembership"
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
        Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
            Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
        Test-AzureADAccessTokenExpiration | out-null
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
	Check if a Azure AD user is a member of an Azure AD security dynamic group

	.DESCRIPTION
    Check if a Azure AD user is a member of an Azure AD security dynamic group

    .PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object

    .PARAMETER MemberID
    -MemberID Guid
    Guid of an Azure AD user account that you want to test from a membership perspective of the group

    .PARAMETER MembershipRule
    -MembershipRule string
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
        Test-AzureADAccessTokenExpiration | out-null
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
Function Get-AzureADGroupMembersWithLicenseErrors {
<#
	.SYNOPSIS 
    Get all Azure AD User with licensing error members of a particular group
    Get all Azure AD Group containing users with licensing errors

	.DESCRIPTION
    Get all Azure AD User with licensing error members of a particular group
    Get all Azure AD Group containing users with licensing errors
	
	.PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object

    .PARAMETER All
    -All Switch
    Use this switch instead of ObjectID to retrieve All groups containing users with licensing errors
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Get licensing error info for members of Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADGroupMembersWithLicenseErrors -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

    .EXAMPLE
	Get licensing error info for members of Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureAdGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Get-AzureADGroupMembersWithLicenseErrors

    .EXAMPLE
	Get groups containing users with licensing errors
    C:\PS> Get-AzureADGroupMembersWithLicenseErrors -All
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.Group]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID,
        [parameter(Mandatory=$false)]
            [switch]$All
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($ObjectID) -and !($inputobject) -and !($all)) {
            throw "Please use ObjectID or inputobject parameters or All switch - exiting"
        }
        if ($ObjectID -and $inputobject) {
            throw "Please choose between ObjectID or inputobject parameters - exiting"
        }
        $params = @{
            API = "groups"
            Method = "GET"
        }
        if ($all) {
            $params.add('APIParameter',"?`$filter=hasMembersWithLicenseErrors+eq+true")
        } else {
            if ($inputobject.ObjectID) {
                $ExistingGroup = Get-AzureADGroup -ObjectId $inputobject.ObjectID
            } elseif ($ObjectID) {
                $ExistingGroup = Get-AzureADGroup -ObjectId $ObjectID
            }
            if ($ExistingGroup.ObjectID) {
                $params.add('APIParameter', $ExistingGroup.ObjectID + "/membersWithLicenseErrors")
            } else {
                throw "Azure AD Group not existing in directory"
            }
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADGroupLicenseDetail {
<#
	.SYNOPSIS 
    Get licensing info of a particular group

	.DESCRIPTION
    Get all licening info (skuid applied, service plans disabled) for a particular Azure AD Group
	
	.PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Get licensing info for Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADGroupLicenseDetail -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

    .EXAMPLE
	Get licensing info for Azure AD group fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureAdGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Get-AzureADGroupLicenseDetail
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.Group]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($ObjectID) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject parameters - exiting"
        }
        if ($ObjectID -and $inputobject) {
            throw "Please choose between ObjectID or inputobject parameters - exiting"
        }
        $params = @{
            API = "groups"
            Method = "GET"
        }
        if ($inputobject.ObjectID) {
            $ExistingGroup = Get-AzureADGroup -ObjectId $inputobject.ObjectID
        } elseif ($ObjectID) {
            $ExistingGroup = Get-AzureADGroup -ObjectId $ObjectID
        }
        if ($ExistingGroup.ObjectID) {
            $params.add('APIParameter', $ExistingGroup.ObjectID + "?`$select=assignedLicenses")
        } else {
            throw "Azure AD Group not existing in directory"
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function Set-AzureADGroupLicense {
<#
	.SYNOPSIS 
    Add or remove a license on an Azure AD Group

	.DESCRIPTION
    Add or remove a license (skuid applied, or service plans to be disabled) for a particular Azure AD Group
	
	.PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.Group
    Microsoft.Open.AzureAD.Model.Group generated previously with Get-AzureADGroup cmdlet

    .PARAMETER AddLicense
    -AddLicense switch
    Use the switch to add a new license to the group

    .PARAMETER RemoveLicense
    -RemoveLicense switch
    Use the switch to remove an existing license from the group

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD Group object

    .PARAMETER DisabledPlans
    -DisabledPlans Guid - array of guids
    Guid / array of guids containing the guid of the service plans to be disabled in the SKU provided. To be used only with AddLicense switch.
    You cannot remove plans disabled from the sku / group. you must remove totally the license (sku) then add it using the new disabled plans.

    .PARAMETER SkuID
    -SkuID Guid
    Guid of the SKU to be added or removed to / from the group. Mandatory parameter to be used with AddLicense and RemoveLicense switchs
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Remove SkuID license 84a661c4-e949-4bd2-a560-ed7766fcaf2b from the group 53cf95f1-49be-463e-9856-77c2b2c3e4a0
    C:\PS> Set-AzureADGroupLicense -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -RemoveLicense -SkuID 84a661c4-e949-4bd2-a560-ed7766fcaf2b -Verbose

    .EXAMPLE
	Remove SkuID license 84a661c4-e949-4bd2-a560-ed7766fcaf2b from the group 53cf95f1-49be-463e-9856-77c2b2c3e4a0
    C:\PS> Get-AzureAdGroup -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Set-AzureADGroupLicense -RemoveLicense -SkuID 84a661c4-e949-4bd2-a560-ed7766fcaf2b -Verbose

    .EXAMPLE
    Add license sku 84a661c4-e949-4bd2-a560-ed7766fcaf2b to the group 53cf95f1-49be-463e-9856-77c2b2c3e4a0 and disable service plans 113feb6c-3fe4-4440-bddc-54d774bf0318, 932ad362-64a8-4783-9106-97849a1a30b9 from this sku
    C:\PS> Set-AzureADGroupLicense -ObjectID 53cf95f1-49be-463e-9856-77c2b2c3e4a0 -AddLicense -SkuID 84a661c4-e949-4bd2-a560-ed7766fcaf2b -DisabledPlans @("113feb6c-3fe4-4440-bddc-54d774bf0318", "932ad362-64a8-4783-9106-97849a1a30b9") -verbose
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.Group]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID,
        [parameter(Mandatory=$false)]
            [switch]$AddLicense,
        [parameter(Mandatory=$false)]
            [switch]$RemoveLicense,
        [parameter(mandatory=$false)]
            [guid[]]$DisabledPlans,
        [parameter(mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [guid]$SkuID
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($ObjectID) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject parameters - exiting"
        }
        if ($RemoveLicense -and $AddLicense) {
            throw "Please choose between AddLicense and RemoveLicense - exiting"
        }
        if (!($RemoveLicense) -and !($AddLicense)) {
            throw "Please choose between AddLicense and RemoveLicense, one parameter is mandatory - exiting"
        }
        if ($ObjectID -and $inputobject) {
            throw "Please choose between ObjectID or inputobject parameters - exiting"
        }
        $params = @{
            API = "groups"
            Method = "POST"
        }
        if ($inputobject.ObjectID) {
            $ExistingGroup = Get-AzureADGroup -ObjectId $inputobject.ObjectID
        } elseif ($ObjectID) {
            $ExistingGroup = Get-AzureADGroup -ObjectId $ObjectID
        }
        if ($ExistingGroup.ObjectID) {
            $params.add('APIParameter', $ExistingGroup.ObjectID + "/assignLicense")
        } else {
            throw "Azure AD Group not existing in directory"
        }
        if ($AddLicense) {
            $tmpbody = @{
                addLicenses = @(
                    @{
                        skuId = $SkuID
                    }
                )
                removeLicenses = @()
            }
            if ($DisabledPlans) {
                $tmpbody.addLicenses[0].add('disabledPlans',@($DisabledPlans))
            }
        }
        if ($RemoveLicense) {
            $tmpbody = @{
                addLicenses = @()
                removeLicenses = @($SkuID)
            }
        }
        $params.add('APIBody', ($tmpbody | ConvertTo-Json -Depth 99))
        write-verbose -Message $params.APIBody
        $tmpobj = Invoke-APIMSGraphBeta @params
        if ($tmpobj) {
            Get-AzureADGroupLicenseDetail -ObjectID $tmpobj.id
        }
    }
}
Function Get-AzureADUserLicenseAssignmentStates {
<#
	.SYNOPSIS 
    Get licensing assignment type (group or user) of a particular user

	.DESCRIPTION
    Get licensing assignment type (group or user) of a particular user. You can check if the license is assigned directly or inherited from a group membership.
	
	.PARAMETER inputobject
	-inputobject Microsoft.Open.AzureAD.Model.User
    Microsoft.Open.AzureAD.Model.User generated previously with Get-AzureADUser cmdlet

    .PARAMETER ObjectID
    -ObjectID Guid
    Guid of an existing Azure AD User object
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Get licensing assignment info for Azure AD user fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADUserLicenseAssignmentStates -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a

    .EXAMPLE
	Get licensing assignment info for Azure AD user fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureAdUser -ObjectID fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Get-AzureADUserLicenseAssignmentStates
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.User]$inputobject,
        [parameter(Mandatory=$false)]
            [guid]$ObjectID
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($ObjectID) -and !($inputobject)) {
            throw "Please use ObjectID or inputobject parameter - exiting"
        }
        $params = @{
            API = "users"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $params.add('APIParameter',$inputobject.ObjectId + "?`$select=licenseAssignmentStates")
        } elseif ($ObjectID) {
            $params.add('APIParameter',$ObjectID.guid + "?`$select=licenseAssignmentStates")
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADServicePrincipalCustom {
<#
	.SYNOPSIS 
    Get Azure AD Service Principal by property and value

	.DESCRIPTION
    Get Azure AD Service Principal by property and value
	
	.PARAMETER Filter
	-Filter string
    Odata Filter query

    .PARAMETER ObjectId
	-ObjectId guid
    GUID of the Service Principal
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Get Azure AD service principal with the appid fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADServicePrincipalCustom -Filter "appid eq 'fb01091c-a9b2-4cd2-bbc9-130dfc91452a'"

    .EXAMPLE
	Get Azure AD service principal with the object id fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADServicePrincipalCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a

#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$Filter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [guid]$ObjectId
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($Filter) -and !($ObjectId)) {
            throw "Please use Filter or ObjectId parameter - exiting"
        }
        $params = @{
            API = "serviceprincipals"
            Method = "GET"
        }
        if ($ObjectId) {
        $params.add('APIParameter',$ObjectId.Guid)
        }
        if ($Filter) {
        $params.add('APIParameter',"?`$filter=$($Filter)")
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADAdministrativeUnitCustom {
<#
	.SYNOPSIS 
    Get Azure AD Administrative Unit properties by properties value or ID

	.DESCRIPTION
    Get Azure AD Administrative Unit properties by properties value or ID
	
	.PARAMETER Filter
	-Filter string
    Odata Filter query

    .PARAMETER ObjectId
	-ObjectId guid
    GUID of the Administrative Unit
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Get Azure AD Administrative Unit with the displayname 'myadmin'
    C:\PS> Get-AzureADAdministrativeUnitCustom -Filter "displayname eq 'myadmin'"

    .EXAMPLE
	Get Azure AD Administrative Unit with the object id fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADAdministrativeUnitCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a

    .EXAMPLE
	Get all Azure AD Administrative Units 
    C:\PS> Get-AzureADAdministrativeUnitCustom -All

#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$Filter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [guid]$ObjectId,
        [parameter(Mandatory=$false)]
            [switch]$All
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($Filter) -and !($ObjectId) -and !($All)) {
            throw "Please use Filter or ObjectId parameter or All switch - exiting"
        }
        $params = @{
            API = "administrativeUnits"
            Method = "GET"
        }
        if ($ObjectId) {
            $params.add('APIParameter',$ObjectId.Guid)
        }
        if ($Filter) {
            $params.add('APIParameter',"?`$filter=$($Filter)")
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function Add-AzureADAdministrativeUnitMemberCustom {
<#
	.SYNOPSIS 
    Get Azure AD Service Principal by property and value

	.DESCRIPTION
    Get Azure AD Service Principal by property and value
	
	.PARAMETER Filter
	-Filter string
    Odata Filter query

    .PARAMETER ObjectId
	-ObjectId guid
    GUID of the Administrative Unit
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Add into an Azure AD admin unit (object id fb01091c-a9b2-4cd2-bbc9-130dfc91452a) a user (object id f8395a0b-3256-46b3-8dc8-db2e80a8ad52)
    C:\PS> Add-AzureADAdministrativeUnitMemberCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a -RefObjectId f8395a0b-3256-46b3-8dc8-db2e80a8ad52 -RefObjectType users
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
            [Guid]$ObjectId,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [guid]$RefObjectId,
        [parameter(Mandatory=$true)]
        [validateSet("users","groups")]
            [string]$RefObjectType
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        $body = [PSCustomObject]@{
            "@odata.id" = "https://graph.microsoft.com/beta/$($RefObjectType)/$($RefObjectId.Guid)"
        }
        $params = @{
            API = "administrativeUnits"
            Method = "POST"
            APIBody = (ConvertTo-Json -InputObject $body -Depth 100)
            APIParameter = "$($ObjectId.Guid)/members/`$ref"
        }
        write-verbose -Message "JSON Body : $(ConvertTo-Json -InputObject $body -Depth 100)"
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADUserAdministrativeUnitMemberOfCustom {
<#
	.SYNOPSIS 
    Get an Administrative Units of an Azure AD User account

	.DESCRIPTION
    Get an Administrative Units of an Azure AD User account
	
    .PARAMETER ObjectId
	-ObjectId guid
    GUID of the user account

    .PARAMETER inputobject
    -inputobject Microsoft.Open.AzureAD.Model.User
     Microsoft.Open.AzureAD.Model.User object (for instance generated by Get-AzureADUser)
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	List Administrative Units of the Azure AD user account fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADUserAdministrativeUnitMemberOfCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a

    .EXAMPLE
	List Administrative Units of the Azure AD user account my-admin@mydomain.tld
    C:\PS> get-azureaduser -ObjectId "my-admin@mydomain.tld" | Get-AzureADUserAdministrativeUnitMemberOfCustom
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.User]$inputobject,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [Guid]$ObjectId
    )
    process {
        if (!($inputobject) -and !($ObjectId)) {
            throw "Please inputobject or ObjectID Parameter - exiting"
        }
        Test-AzureADAccessTokenExpiration | out-null
        $params = @{
            API = "users"
            Method = "GET"
        }
        if ($inputobject.ObjectId) {
            $params.add('APIParameter',"$($inputobject.ObjectId)/memberOf/`$/Microsoft.Graph.AdministrativeUnit")
        } elseif ($ObjectId) {
            $params.add('APIParameter',"$($ObjectId.Guid)/memberOf/`$/Microsoft.Graph.AdministrativeUnit")
        } 
        Invoke-APIMSGraphBeta @params
    }
}
Function Remove-AzureADAdministrativeUnitMemberCustom {
<#
	.SYNOPSIS 
    Remove a member of an Administrative Units

	.DESCRIPTION
    Remove a member of an Administrative Units
	
    .PARAMETER ObjectId
	-ObjectId guid
    GUID of the Administrative Unit

    .PARAMETER inputobject
    -inputobject Microsoft.Open.AzureAD.Model.AdministrativeUnit
     Microsoft.Open.AzureAD.Model.AdministrativeUnit object (for instance generated by Get-AzureADAdministrativeUnit)

    .PARAMETER RefObjectId
	-ObjectId RefObjectId
    GUID of the Administrative Unit member
    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	Remove Azure AD User account 50b147d8-411f-4359-a09a-e31a0d791900 from Administrative Unit fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Remove-AzureADAdministrativeUnitMemberCustom -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a -RefObjectId 50b147d8-411f-4359-a09a-e31a0d791900

    .EXAMPLE
	Remove Azure AD User account 50b147d8-411f-4359-a09a-e31a0d791900 from Administrative Unit fb01091c-a9b2-4cd2-bbc9-130dfc91452a
    C:\PS> Get-AzureADAdministrativeUnit -ObjectId fb01091c-a9b2-4cd2-bbc9-130dfc91452a | Remove-AzureADAdministrativeUnitMemberCustom -RefObjectId 50b147d8-411f-4359-a09a-e31a0d791900
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
            [Microsoft.Open.AzureAD.Model.AdministrativeUnit]$inputobject,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [Guid]$ObjectId,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [Guid]$RefObjectId	
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if (!($inputobject) -and !($ObjectId)) {
            throw "Please inputobject or ObjectID Parameter - exiting"
        }
        $params = @{
            API = "administrativeUnits"
            Method = "DELETE"
        }
        if ($inputobject.ObjectId) {
            $params.add('APIParameter',"$($inputobject.ObjectId)/members/$($RefObjectId.Guid)/`$ref")
        } elseif ($ObjectId) {
            $params.add('APIParameter',"$($ObjectId.Guid)/members/$($RefObjectId.Guid)/`$ref")
        } 
        Invoke-APIMSGraphBeta @params
    }
}
Function Get-AzureADOrganizationCustom {
<#
	.SYNOPSIS 
    get all properties of an Azure AD organization

	.DESCRIPTION
    get all properties of an Azure AD organization
	    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	get all properties of your current organization
    C:\PS> Get-AzureADOrganizationCustom
#>
    [cmdletbinding()]
    Param ()
    process {
        Test-AzureADAccessTokenExpiration | out-null
        $params = @{
            API = "organization"
            Method = "GET"
        }
        Invoke-APIMSGraphBeta @params
    }
}
Function Update-AzureADOrganizationCustom {
<#
	.SYNOPSIS 
    update all properties of an Azure AD organization

	.DESCRIPTION
    update all properties of an Azure AD organization

    .PARAMETER marketingNotificationEmails
    -marketingNotificationEmails mailaddress
    e-mail address to be set for marketing notification

    .PARAMETER securityComplianceNotificationMails
    -securityComplianceNotificationMails mailaddress
    e-mail address to be set for security & compliance notification

    .PARAMETER technicalNotificationMails
    -technicalNotificationMails mailaddress
    e-mail address to be set for technical notification

    .PARAMETER privacyProfilemail
    -privacyProfilemail mailaddress
    e-mail address to be set for privacy notification
    this parameter must be used with privacyProfileurl parameter

    .PARAMETER privacyProfileurl
    -privacyProfileurl uri
    URL of the privacy information
    this parameter must be used with privacyProfilemail parameter

    .PARAMETER securityComplianceNotificationPhones
    -securityComplianceNotificationPhones string
    phone number to be set for security & compliance notification
	    		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		    
    .EXAMPLE
	update privacy information
    C:\PS> Update-AzureADOrganizationCustom -privacyProfilemail test@test.com -privacyProfileurl http://www.google.com

    .EXAMPLE
    update marketing mail contact for notification
    C:\PS> Update-AzureADOrganizationCustom -marketingNotificationEmails lcuaad.xyz@outlook.com
#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [mailaddress]$marketingNotificationEmails,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [mailaddress]$securityComplianceNotificationMails,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$securityComplianceNotificationPhones,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [mailaddress]$technicalNotificationMails,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [mailaddress]$privacyProfilemail,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [uri]$privacyProfileurl
    )
    process {
        if (($privacyProfileurl -and !($privacyProfilemail)) -or (!($privacyProfileurl) -and $privacyProfilemail)) {
            throw "please use privacyProfilemail and privacyProfilemail together"
        }
        Test-AzureADAccessTokenExpiration | out-null
        $params = @{
            API = "organization"
            Method = "PATCH"
            APIParameter = "$($AADConnectInfo.TenantID)/"
        }
        $body = @{}
        if ($marketingNotificationEmails) {
            $body.add("marketingNotificationEmails",@($marketingNotificationEmails.Address))
        }
        if ($securityComplianceNotificationMails) {
            $body.add("securityComplianceNotificationMails",@($securityComplianceNotificationMails.Address))
        }
        if ($securityComplianceNotificationPhones) {
            $body.add("securityComplianceNotificationPhones",@($securityComplianceNotificationPhones))
        }
        if ($technicalNotificationMails) {
            $body.add("technicalNotificationMails",@($technicalNotificationMails.Address))
        }
        if ($privacyProfilemail -and $privacyProfileurl) {
            $body.add("privacyProfile",@{"contactEmail" = $privacyProfilemail.Address;"statementUrl" = $privacyProfileurl.AbsoluteUri})
        }
        if ($body) {
            $params.add("APIBody",(ConvertTo-Json -InputObject $body -Depth 100))
            write-verbose -Message "JSON Body : $(ConvertTo-Json -InputObject $body -Depth 100)"
            Invoke-APIMSGraphBeta @params
        }
    }
}
Function Get-AzureADOnPremisesProvisionningErrors {
<#
	.SYNOPSIS 
	Get all Azure AD Connect provisionning errors

	.DESCRIPTION
	Get all Azure AD Connect provisionning errors for groups, users, contacts object. Can replace old MSOnline function Get-MsolDirSyncProvisioningError

    .PARAMETER filterObjectType
    -filterObjectType string
    set an object type filter, value must be "users","groups","contacts" or "all" for all object type.
		
	.OUTPUTS
   	TypeName : System.Management.Automation.PSCustomObject
		
	.EXAMPLE
	Get all Azure AD Connect provisionning errors for all object types
	C:\PS> Get-AzureADOnPremisesProvisionningErrors

    .EXAMPLE
	Get all Azure AD Connect provisionning errors for all contact object type
	C:\PS> Get-AzureADOnPremisesProvisionningErrors -filterObjectType "contacts"
#>
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$false)]
        [validateSet("users","groups","contacts","all")]
            [string]$filterObjectType = "all"
    )
    process {
        Test-AzureADAccessTokenExpiration | out-null
        if ($filterObjectType -ne "all") {
                $params = @{
                    API = $filterObjectType
                    Method = "GET"
                    APIParameter = "?`$filter=onPremisesProvisioningErrors/any(i:i/category eq 'PropertyConflict')&select=onPremisesProvisioningErrors,id,displayname,mail"
                }
                $result = Invoke-APIMSGraphBeta @params
                if ($result.value) {
                    $result
                }
        } else {
            $filtersObjecttype = @("users","groups","contacts")
            foreach ($filtertype in $filtersObjecttype) {
                $params = @{
                    API = $filtertype
                    Method = "GET"
                    APIParameter = "?`$filter=onPremisesProvisioningErrors/any(i:i/category eq 'PropertyConflict')&select=onPremisesProvisioningErrors,id,displayname,mail"
                }
                $result = Invoke-APIMSGraphBeta @params
                if ($result.value) {
                    $result
                }
            }
        }
    }
}
Function Invoke-APIMSGraphBeta {
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$false)]
        [validateSet("users","me","administrativeUnits","serviceprincipals","groups","organization","contacts")]
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
            $responseerror = ConvertFrom-Json $responseBody
            write-error -message "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
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
        } elseif ($responseerror ) {
            $responseerror
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
    [cmdletbinding()]
    Param ()
    Process {
        if(!($global:AADConnectInfo.AccessToken)) {
            throw "Not able to find a valid Azure AD Access Token in cache, please use Get-AzureADAccessToken first - exiting"
        }
    }
}
Function Test-AzureADAccessTokenExpiration {
    [cmdletbinding()]
    Param ()
    process {
        Test-AzureADAccesToken
        if ((get-date).ToUniversalTime() -gt $AADConnectInfo.TokenExpiresOn.DateTime.AddMinutes(-15)) {
            $remainingtime = $AADConnectInfo.TokenExpiresOn.DateTime.AddMinutes(-15) - (get-date).ToUniversalTime()
            write-warning -Message "your token is about to expire in $($remainingtime.Minutes.tostring()) minutes."
            return $true
        } else {
            return $false
        }
    }
}

New-Alias -Name Get-AzureADUserAllInfo -Value Get-AzureADUserCustom

Export-ModuleMember -Function Get-AzureADTenantInfo, Get-AzureADMyInfo, Get-AzureADAccessToken, Connect-AzureADFromAccessToken, Clear-AzureADAccessToken, 
                                Set-AzureADProxy, Test-ADModule, Sync-ADOUtoAzureADAdministrativeUnit, Invoke-APIMSGraphBeta, Get-AzureADUserCustom, Test-AzureADAccesToken,
                                Sync-ADUsertoAzureADAdministrativeUnitMember,Set-AzureADAdministrativeUnitAdminRole, Get-AzureADAdministrativeUnitAllMembers, Connect-MSOnlineFromAccessToken,
                                Get-AzureADConnectCloudProvisionningServiceSyncSchema, Update-AzureADConnectCloudProvisionningServiceSyncSchema,
                                Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema, New-AzureADAdministrativeUnitCustom, Get-AzureADAdministrativeUnitHidden,
                                New-AzureADObjectDeltaView, Get-AzureADObjectDeltaView, 
                                Get-AzureADGroupMembersWithLicenseErrors, Get-AzureADGroupLicenseDetail, Set-AzureADGroupLicense, Get-AzureADUserLicenseAssignmentStates, 
                                Get-AzureADDynamicGroup, New-AzureADDynamicGroup, Remove-AzureADDynamicGroup, Set-AzureADDynamicGroup, Test-AzureADUserForGroupDynamicMembership,
                                Get-AzureADServicePrincipalCustom, Get-AzureADAdministrativeUnitCustom, Add-AzureADAdministrativeUnitMemberCustom, Test-AzureADAccessTokenExpiration,
                                Watch-AzureADAccessToken, Get-AzureADUserAdministrativeUnitMemberOfCustom, Remove-AzureADAdministrativeUnitMemberCustom,
                                Get-AzureADOrganizationCustom, Update-AzureADOrganizationCustom, Get-AzureADOnPremisesProvisionningErrors
Export-ModuleMember -Alias Get-AzureADUserAllInfo