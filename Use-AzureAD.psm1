
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
#
# v0.6 : last public release - beta version - focus on Azure AD Connect Cloud Provisionning Tools
# - cmdlet to get your current schema for a specific provisionning agent / service principal
# - cmdlet to update your current schema for a specific provisionning agent / service principal
# - cmdlet to get your default schema (template) for Azure AD Connect Cloud Provisionning
# - cmdlet to get a valid token (MFA supported) for Microsoft Graph API standard / cloud endpoint and MSOnline endpoint and be able to use MSOnline cmdlets without reauthenticating
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

    Name           MemberType   Definition
    ----           ----------   ----------
    Equals         Method       bool Equals(System.Object obj)
    GetHashCode    Method       int GetHashCode()
    GetType        Method       type GetType()
    ToString       Method       string ToString()
    AccessToken    NoteProperty string AccessToken=xxxxx...
    ObjectID       NoteProperty string ObjectID=e3ab4983-22c4-417b-b18d-0271f81a9cde
    TenantID       NoteProperty string TenantID=fbf266be-12e8-48a4-bd5f-c513713bd96d
    TokenExpiresOn NoteProperty DateTimeOffset TokenExpiresOn=26/04/2020 16:20:40 +00:00
    UserName       NoteProperty mailaddress UserName=my-admin@mydomain.tld
		
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

    Name                            MemberType   Definition
    ----                            ----------   ----------
    Equals                          Method       bool Equals(System.Object obj)
    GetHashCode                     Method       int GetHashCode()
    GetType                         Method       type GetType()
    ToString                        Method       string ToString()
    @odata.context                  NoteProperty string @odata.context=https://graph.microsoft.com/beta/$metadata#users/$entity
    accountEnabled                  NoteProperty bool accountEnabled=True
    ageGroup                        NoteProperty object ageGroup=null
    assignedLicenses                NoteProperty Object[] assignedLicenses=System.Object[]
    assignedPlans                   NoteProperty Object[] assignedPlans=System.Object[]
    businessPhones                  NoteProperty Object[] businessPhones=System.Object[]
    city                            NoteProperty object city=null
    companyName                     NoteProperty object companyName=null
    consentProvidedForMinor         NoteProperty object consentProvidedForMinor=null
    country                         NoteProperty object country=null
    createdDateTime                 NoteProperty string createdDateTime=2020-04-21T15:17:08Z
    creationType                    NoteProperty object creationType=null
    deletedDateTime                 NoteProperty object deletedDateTime=null
    department                      NoteProperty object department=null
    deviceKeys                      NoteProperty Object[] deviceKeys=System.Object[]
    displayName                     NoteProperty string displayName=admin
    employeeId                      NoteProperty object employeeId=null
    externalUserState               NoteProperty object externalUserState=null
    externalUserStateChangeDateTime NoteProperty object externalUserStateChangeDateTime=null
    faxNumber                       NoteProperty object faxNumber=null
    givenName                       NoteProperty string givenName=firsname
    id                              NoteProperty string id=72a50bb8-20cf-494c-969d-fbcd2324b822
    identities                      NoteProperty Object[] identities=System.Object[]
    imAddresses                     NoteProperty Object[] imAddresses=System.Object[]
    infoCatalogs                    NoteProperty Object[] infoCatalogs=System.Object[]
    isResourceAccount               NoteProperty object isResourceAccount=null
    jobTitle                        NoteProperty object jobTitle=null
    legalAgeGroupClassification     NoteProperty object legalAgeGroupClassification=null
    mail                            NoteProperty object mail=null
    mailNickname                    NoteProperty string mailNickname=my-admin
    mobilePhone                     NoteProperty string mobilePhone=
    officeLocation                  NoteProperty object officeLocation=null
    onPremisesDistinguishedName     NoteProperty object onPremisesDistinguishedName=null
    onPremisesDomainName            NoteProperty object onPremisesDomainName=null
    onPremisesExtensionAttributes   NoteProperty System.Management.Automation.PSCustomObject onPremisesExtensionAttributes=@{extensionAttribute1=; extensionAttribute2=; extensionAttribute3=; extensionAttribute...
    onPremisesImmutableId           NoteProperty object onPremisesImmutableId=null
    onPremisesLastSyncDateTime      NoteProperty object onPremisesLastSyncDateTime=null
    onPremisesProvisioningErrors    NoteProperty Object[] onPremisesProvisioningErrors=System.Object[]
    onPremisesSamAccountName        NoteProperty object onPremisesSamAccountName=null
    onPremisesSecurityIdentifier    NoteProperty object onPremisesSecurityIdentifier=null
    onPremisesSyncEnabled           NoteProperty object onPremisesSyncEnabled=null
    onPremisesUserPrincipalName     NoteProperty object onPremisesUserPrincipalName=null
    otherMails                      NoteProperty Object[] otherMails=System.Object[]
    passwordPolicies                NoteProperty object passwordPolicies=null
    passwordProfile                 NoteProperty object passwordProfile=null
    postalCode                      NoteProperty object postalCode=null
    preferredDataLocation           NoteProperty object preferredDataLocation=null
    preferredLanguage               NoteProperty object preferredLanguage=null
    provisionedPlans                NoteProperty Object[] provisionedPlans=System.Object[]
    proxyAddresses                  NoteProperty Object[] proxyAddresses=System.Object[]
    refreshTokensValidFromDateTime  NoteProperty string refreshTokensValidFromDateTime=2020-04-21T15:24:29Z
    showInAddressList               NoteProperty object showInAddressList=null
    signInSessionsValidFromDateTime NoteProperty string signInSessionsValidFromDateTime=2020-04-21T15:24:29Z
    state                           NoteProperty object state=null
    streetAddress                   NoteProperty object streetAddress=null
    surname                         NoteProperty string surname=name
    usageLocation                   NoteProperty string usageLocation=US
    userPrincipalName               NoteProperty string userPrincipalName=my-admin@mydomain.tld
    userType                        NoteProperty string userType=Member
		
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

    Name           MemberType   Definition
    ----           ----------   ----------
    Equals         Method       bool Equals(System.Object obj)
    GetHashCode    Method       int GetHashCode()
    GetType        Method       type GetType()
    ToString       Method       string ToString()
    AccessToken    NoteProperty string AccessToken=xxxxx...
    ObjectID       NoteProperty string ObjectID=e3ab4983-22c4-417b-b18d-0271f81a9cde
    TenantID       NoteProperty string TenantID=fbf266be-12e8-48a4-bd5f-c513713bd96d
    TokenExpiresOn NoteProperty DateTimeOffset TokenExpiresOn=26/04/2020 16:20:40 +00:00
    UserName       NoteProperty mailaddress UserName=my-admin@mydomain.tld
		
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

    Name         MemberType Definition
    ----         ---------- ----------
    Equals       Method     bool Equals(System.Object obj)
    GetHashCode  Method     int GetHashCode()
    GetType      Method     type GetType()
    ToString     Method     string ToString()
    Account      Property   Microsoft.Open.Azure.AD.CommonLibrary.AzureAccount Account {get;}
    Environment  Property   Microsoft.Open.Azure.AD.CommonLibrary.AzureEnvironment Environment {get;}
    Tenant       Property   Microsoft.Open.Azure.AD.CommonLibrary.AzureTenant Tenant {get;}
    TenantDomain Property   string TenantDomain {get;}
    TenantId     Property   guid TenantId {get;}
		
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

    Name                  MemberType Definition
    ----                  ---------- ----------
    Equals                Method     bool Equals(System.Object obj)
    GetHashCode           Method     int GetHashCode()
    GetObjectData         Method     void ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
    GetProxy              Method     uri GetProxy(uri destination), uri IWebProxy.GetProxy(uri destination)
    GetType               Method     type GetType()
    IsBypassed            Method     bool IsBypassed(uri host), bool IWebProxy.IsBypassed(uri host)
    ToString              Method     string ToString()
    Address               Property   uri Address {get;set;}
    BypassArrayList       Property   System.Collections.ArrayList BypassArrayList {get;}
    BypassList            Property   string[] BypassList {get;set;}
    BypassProxyOnLocal    Property   bool BypassProxyOnLocal {get;set;}
    Credentials           Property   System.Net.ICredentials Credentials {get;set;}
    UseDefaultCredentials Property   bool UseDefaultCredentials {get;set;}
		
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
                $proxy.Credentials = $ProxyCredential
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

    Name                             MemberType Definition
    ----                             ---------- ----------
    Equals                           Method     bool Equals(System.Object obj), bool Equals(Microsoft.Open.AzureAD.Model.AdministrativeUnit other), bool Equals(Microsoft.Open.AzureAD.Model.DirectoryObject, Mic...
    GetHashCode                      Method     int GetHashCode()
    GetType                          Method     type GetType()
    ShouldSerializeDeletionTimeStamp Method     bool ShouldSerializeDeletionTimeStamp()
    ShouldSerializeObjectId          Method     bool ShouldSerializeObjectId()
    ShouldSerializeObjectType        Method     bool ShouldSerializeObjectType()
    ToJson                           Method     string ToJson()
    ToString                         Method     string ToString()
    Validate                         Method     System.Collections.Generic.IEnumerable[System.ComponentModel.DataAnnotations.ValidationResult] Validate(System.ComponentModel.DataAnnotations.ValidationContext v...
    DeletionTimeStamp                Property   System.Nullable[datetime] DeletionTimeStamp {get;}
    Description                      Property   string Description {get;set;}
    DisplayName                      Property   string DisplayName {get;set;}
    ObjectId                         Property   string ObjectId {get;}
    ObjectType                       Property   string ObjectType {get;}
		
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

    Name                       MemberType Definition
    ----                       ---------- ----------
    Equals                     Method     bool Equals(System.Object obj), bool Equals(Microsoft.Open.AzureAD.Model.ScopedRoleMembership other), bool IEquatable[ScopedRoleMembership].Equals(Microsoft.Open.Azure...
    GetHashCode                Method     int GetHashCode()
    GetType                    Method     type GetType()
    ShouldSerializeId          Method     bool ShouldSerializeId()
    ToJson                     Method     string ToJson()
    ToString                   Method     string ToString()
    Validate                   Method     System.Collections.Generic.IEnumerable[System.ComponentModel.DataAnnotations.ValidationResult] Validate(System.ComponentModel.DataAnnotations.ValidationContext validat...
    AdministrativeUnitObjectId Property   string AdministrativeUnitObjectId {get;set;}
    Id                         Property   string Id {get;}
    RoleMemberInfo             Property   Microsoft.Open.AzureAD.Model.RoleMemberInfo RoleMemberInfo {get;set;}
    RoleObjectId               Property   string RoleObjectId {get;set;}
		
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

    Name                            MemberType   Definition
    ----                            ----------   ----------
    Equals                          Method       bool Equals(System.Object obj)
    GetHashCode                     Method       int GetHashCode()
    GetType                         Method       type GetType()
    ToString                        Method       string ToString()
    @odata.context                  NoteProperty string @odata.context=https://graph.microsoft.com/beta/$metadata#users/$entity
    accountEnabled                  NoteProperty bool accountEnabled=True
    ageGroup                        NoteProperty object ageGroup=null
    assignedLicenses                NoteProperty Object[] assignedLicenses=System.Object[]
    assignedPlans                   NoteProperty Object[] assignedPlans=System.Object[]
    businessPhones                  NoteProperty Object[] businessPhones=System.Object[]
    city                            NoteProperty object city=null
    companyName                     NoteProperty object companyName=null
    consentProvidedForMinor         NoteProperty object consentProvidedForMinor=null
    country                         NoteProperty object country=null
    createdDateTime                 NoteProperty string createdDateTime=2020-04-21T15:17:08Z
    creationType                    NoteProperty object creationType=null
    deletedDateTime                 NoteProperty object deletedDateTime=null
    department                      NoteProperty object department=null
    deviceKeys                      NoteProperty Object[] deviceKeys=System.Object[]
    displayName                     NoteProperty string displayName=admin
    employeeId                      NoteProperty object employeeId=null
    externalUserState               NoteProperty object externalUserState=null
    externalUserStateChangeDateTime NoteProperty object externalUserStateChangeDateTime=null
    faxNumber                       NoteProperty object faxNumber=null
    givenName                       NoteProperty string givenName=firsname
    id                              NoteProperty string id=72a50bb8-20cf-494c-969d-fbcd2324b822
    identities                      NoteProperty Object[] identities=System.Object[]
    imAddresses                     NoteProperty Object[] imAddresses=System.Object[]
    infoCatalogs                    NoteProperty Object[] infoCatalogs=System.Object[]
    isResourceAccount               NoteProperty object isResourceAccount=null
    jobTitle                        NoteProperty object jobTitle=null
    legalAgeGroupClassification     NoteProperty object legalAgeGroupClassification=null
    mail                            NoteProperty object mail=null
    mailNickname                    NoteProperty string mailNickname=my-admin
    mobilePhone                     NoteProperty string mobilePhone=
    officeLocation                  NoteProperty object officeLocation=null
    onPremisesDistinguishedName     NoteProperty object onPremisesDistinguishedName=null
    onPremisesDomainName            NoteProperty object onPremisesDomainName=null
    onPremisesExtensionAttributes   NoteProperty System.Management.Automation.PSCustomObject onPremisesExtensionAttributes=@{extensionAttribute1=; extensionAttribute2=; extensionAttribute3=; extensionAttribute...
    onPremisesImmutableId           NoteProperty object onPremisesImmutableId=null
    onPremisesLastSyncDateTime      NoteProperty object onPremisesLastSyncDateTime=null
    onPremisesProvisioningErrors    NoteProperty Object[] onPremisesProvisioningErrors=System.Object[]
    onPremisesSamAccountName        NoteProperty object onPremisesSamAccountName=null
    onPremisesSecurityIdentifier    NoteProperty object onPremisesSecurityIdentifier=null
    onPremisesSyncEnabled           NoteProperty object onPremisesSyncEnabled=null
    onPremisesUserPrincipalName     NoteProperty object onPremisesUserPrincipalName=null
    otherMails                      NoteProperty Object[] otherMails=System.Object[]
    passwordPolicies                NoteProperty object passwordPolicies=null
    passwordProfile                 NoteProperty object passwordProfile=null
    postalCode                      NoteProperty object postalCode=null
    preferredDataLocation           NoteProperty object preferredDataLocation=null
    preferredLanguage               NoteProperty object preferredLanguage=null
    provisionedPlans                NoteProperty Object[] provisionedPlans=System.Object[]
    proxyAddresses                  NoteProperty Object[] proxyAddresses=System.Object[]
    refreshTokensValidFromDateTime  NoteProperty string refreshTokensValidFromDateTime=2020-04-21T15:24:29Z
    showInAddressList               NoteProperty object showInAddressList=null
    signInSessionsValidFromDateTime NoteProperty string signInSessionsValidFromDateTime=2020-04-21T15:24:29Z
    state                           NoteProperty object state=null
    streetAddress                   NoteProperty object streetAddress=null
    surname                         NoteProperty string surname=name
    usageLocation                   NoteProperty string usageLocation=US
    userPrincipalName               NoteProperty string userPrincipalName=my-admin@mydomain.tld
    userType                        NoteProperty string userType=Member
		
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

    Name                            MemberType   Definition
    ----                            ----------   ----------
    Equals                          Method       bool Equals(System.Object obj)
    GetHashCode                     Method       int GetHashCode()
    GetType                         Method       type GetType()
    ToString                        Method       string ToString()
    @odata.context                  NoteProperty string @odata.context=https://graph.microsoft.com/beta/$metadata#users/$entity
    accountEnabled                  NoteProperty bool accountEnabled=True
    ageGroup                        NoteProperty object ageGroup=null
    assignedLicenses                NoteProperty Object[] assignedLicenses=System.Object[]
    assignedPlans                   NoteProperty Object[] assignedPlans=System.Object[]
    businessPhones                  NoteProperty Object[] businessPhones=System.Object[]
    city                            NoteProperty object city=null
    companyName                     NoteProperty object companyName=null
    consentProvidedForMinor         NoteProperty object consentProvidedForMinor=null
    country                         NoteProperty object country=null
    createdDateTime                 NoteProperty string createdDateTime=2020-04-21T15:17:08Z
    creationType                    NoteProperty object creationType=null
    deletedDateTime                 NoteProperty object deletedDateTime=null
    department                      NoteProperty object department=null
    deviceKeys                      NoteProperty Object[] deviceKeys=System.Object[]
    displayName                     NoteProperty string displayName=admin
    employeeId                      NoteProperty object employeeId=null
    externalUserState               NoteProperty object externalUserState=null
    externalUserStateChangeDateTime NoteProperty object externalUserStateChangeDateTime=null
    faxNumber                       NoteProperty object faxNumber=null
    givenName                       NoteProperty string givenName=firsname
    id                              NoteProperty string id=72a50bb8-20cf-494c-969d-fbcd2324b822
    identities                      NoteProperty Object[] identities=System.Object[]
    imAddresses                     NoteProperty Object[] imAddresses=System.Object[]
    infoCatalogs                    NoteProperty Object[] infoCatalogs=System.Object[]
    isResourceAccount               NoteProperty object isResourceAccount=null
    jobTitle                        NoteProperty object jobTitle=null
    legalAgeGroupClassification     NoteProperty object legalAgeGroupClassification=null
    mail                            NoteProperty object mail=null
    mailNickname                    NoteProperty string mailNickname=my-admin
    mobilePhone                     NoteProperty string mobilePhone=
    officeLocation                  NoteProperty object officeLocation=null
    onPremisesDistinguishedName     NoteProperty object onPremisesDistinguishedName=null
    onPremisesDomainName            NoteProperty object onPremisesDomainName=null
    onPremisesExtensionAttributes   NoteProperty System.Management.Automation.PSCustomObject onPremisesExtensionAttributes=@{extensionAttribute1=; extensionAttribute2=; extensionAttribute3=; extensionAttribute...
    onPremisesImmutableId           NoteProperty object onPremisesImmutableId=null
    onPremisesLastSyncDateTime      NoteProperty object onPremisesLastSyncDateTime=null
    onPremisesProvisioningErrors    NoteProperty Object[] onPremisesProvisioningErrors=System.Object[]
    onPremisesSamAccountName        NoteProperty object onPremisesSamAccountName=null
    onPremisesSecurityIdentifier    NoteProperty object onPremisesSecurityIdentifier=null
    onPremisesSyncEnabled           NoteProperty object onPremisesSyncEnabled=null
    onPremisesUserPrincipalName     NoteProperty object onPremisesUserPrincipalName=null
    otherMails                      NoteProperty Object[] otherMails=System.Object[]
    passwordPolicies                NoteProperty object passwordPolicies=null
    passwordProfile                 NoteProperty object passwordProfile=null
    postalCode                      NoteProperty object postalCode=null
    preferredDataLocation           NoteProperty object preferredDataLocation=null
    preferredLanguage               NoteProperty object preferredLanguage=null
    provisionedPlans                NoteProperty Object[] provisionedPlans=System.Object[]
    proxyAddresses                  NoteProperty Object[] proxyAddresses=System.Object[]
    refreshTokensValidFromDateTime  NoteProperty string refreshTokensValidFromDateTime=2020-04-21T15:24:29Z
    showInAddressList               NoteProperty object showInAddressList=null
    signInSessionsValidFromDateTime NoteProperty string signInSessionsValidFromDateTime=2020-04-21T15:24:29Z
    state                           NoteProperty object state=null
    streetAddress                   NoteProperty object streetAddress=null
    surname                         NoteProperty string surname=name
    usageLocation                   NoteProperty string usageLocation=US
    userPrincipalName               NoteProperty string userPrincipalName=my-admin@mydomain.tld
    userType                        NoteProperty string userType=Member
		
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

    Name                       MemberType   Definition
    ----                       ----------   ----------
    Equals                     Method       bool Equals(System.Object obj)
    GetHashCode                Method       int GetHashCode()
    GetType                    Method       type GetType()
    ToString                   Method       string ToString()
    @odata.context             NoteProperty string @odata.context=https://graph.microsoft.com/beta/$metadata#servicePrincipals..
    directories                NoteProperty Object[] directories=System.Object[]
    directories@odata.context  NoteProperty string directories@odata.context=https://graph.microsoft.com/beta/$metadata#servicePrincipals...
    id                         NoteProperty string id=AD2AADProvisioning...
    provisioningTaskIdentifier NoteProperty string provisioningTaskIdentifier=AD2AADProvisioning...
    synchronizationRules       NoteProperty Object[] synchronizationRules=System.Object[]
    version                    NoteProperty string version=Date:2020-05-03T16:45:55.0837002Z...
            
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
    
        Name                       MemberType   Definition
        ----                       ----------   ----------
        Equals                     Method       bool Equals(System.Object obj)
        GetHashCode                Method       int GetHashCode()
        GetType                    Method       type GetType()
        ToString                   Method       string ToString()
        @odata.context             NoteProperty string @odata.context=https://graph.microsoft.com/beta/$metadata#servicePrincipals..
        directories                NoteProperty Object[] directories=System.Object[]
        directories@odata.context  NoteProperty string directories@odata.context=https://graph.microsoft.com/beta/$metadata#servicePrincipals...
        id                         NoteProperty string id=AD2AADProvisioning...
        provisioningTaskIdentifier NoteProperty string provisioningTaskIdentifier=AD2AADProvisioning...
        synchronizationRules       NoteProperty Object[] synchronizationRules=System.Object[]
        version                    NoteProperty string version=Date:2020-05-03T16:45:55.0837002Z...
                
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
Function Invoke-APIMSGraphBeta {
    [cmdletbinding()]
	Param (
        [parameter(Mandatory=$false)]
        [validateSet("users","me","administrativeUnits","serviceprincipals")]
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
        if ($paging.AbsoluteUri -like "*skiptoken=*") {
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
            if ($result.value) {
                $result.value
            } else {
                $result
            }
            if ($result.'@odata.nextLink') {
                write-verbose -Message "Paging : $($result.'@odata.nextLink')"
                Invoke-APIMSGraphBeta -Method GET -Paging $result.'@odata.nextLink'
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
                                Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema