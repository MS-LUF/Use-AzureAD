#
# Manifest for Use-AzureAD module
#
# Generated by: MS-LUF
#
# Generated on : 09/2021
#

@{

# Module de script ou fichier de module binaire associe e ce manifeste
RootModule = 'use-AzureAD.psm1'

# Numero de version de ce module.
ModuleVersion = '1.7'

# editions PS prises en charge
# CompatiblePSEditions = @()

# ID utilise pour identifier de maniere unique ce module
GUID = '567c517c-f1b5-43e1-9249-d1a60bf83a41'

# Auteur de ce module
Author = 'LCU'

# Societe ou fournisseur de ce module
CompanyName = 'lucas-cueff.com'

# Declaration de copyright pour ce module
Copyright = '(c) 2021 lucas-cueff.com Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).'

# Description de la fonctionnalite fournie par ce module
Description = 'Add few cmdlets to facilitate your Azure AD management, especially with Administrative Unit, through PowerShell interface'

# Version minimale du moteur Windows PowerShell requise par ce module
PowerShellVersion = '5.1'

# Nom de l'hote Windows PowerShell requis par ce module
# PowerShellHostName = ''

# Version minimale de l'hete Windows PowerShell requise par ce module
# PowerShellHostVersion = ''

# Version minimale du Microsoft .NET Framework requise par ce module. Cette configuration requise est valide uniquement pour PowerShell Desktop Edition.
# DotNetFrameworkVersion = ''

# Version minimale de leenvironnement CLR (Common Language Runtime) requise par ce module. Cette configuration requise est valide uniquement pour PowerShell Desktop Edition.
# CLRVersion = ''

# Architecture de processeur (None, X86, Amd64) requise par ce module
# ProcessorArchitecture = ''

# Modules qui doivent etre importes dans l environnement global prealablement a l importation de ce module
# RequiredModules = @()

# Assemblys qui doivent etre charges prealablement a l importation de ce module
# RequiredAssemblies = @()

# Fichiers de script (.ps1) executes dans l environnement de l appelant prealablement a leimportation de ce module
# ScriptsToProcess = @()

# Fichiers de types (.ps1xml) a charger lors de l importation de ce module
# TypesToProcess = @()

# Fichiers de format (.ps1xml) a charger lors de l importation de ce module
# FormatsToProcess = @()

# Modules a importer en tant que modules imbriques du module specifie dans RootModule/ModuleToProcess
# NestedModules = @()

# Fonctions a exporter a partir de ce module. Pour de meilleures performances, neutilisez pas de caracteres generiques et ne supprimez pas leentree. Utilisez un tableau vide si vous neavez aucune fonction a exporter.
FunctionsToExport = 'Add-AzureADAdministrativeUnitMemberCustom','Clear-AzureADAccessToken','Connect-AzureADFromAccessToken','Connect-MSOnlineFromAccessToken','Get-AzureADAccessToken','Get-AzureADAdministrativeUnitAllMembers','Get-AzureADAdministrativeUnitCustom','Get-AzureADAdministrativeUnitHidden','Get-AzureADConnectCloudProvisionningServiceSyncDefaultSchema','Get-AzureADConnectCloudProvisionningServiceSyncSchema','Get-AzureADDynamicGroup','Get-AzureADGroupLicenseDetail','Get-AzureADGroupMembersWithLicenseErrors','Get-AzureADMyInfo','Get-AzureADObjectDeltaView','Get-AzureADServicePrincipalCustom','Get-AzureADTenantInfo','Get-AzureADUserCustom','Get-AzureADUserLicenseAssignmentStates','Invoke-APIMSGraphBeta','Invoke-APIMSGraphBetaPaging','New-AzureADAdministrativeUnitCustom','New-AzureADDynamicGroup','New-AzureADObjectDeltaView','Remove-AzureADDynamicGroup','Set-AzureADAdministrativeUnitAdminRole','Set-AzureADDynamicGroup','Set-AzureADGroupLicense','Set-AzureADProxy','Sync-ADOUtoAzureADAdministrativeUnit','Sync-ADUsertoAzureADAdministrativeUnitMember','Test-ADModule','Test-AzureADAccessTokenExpiration','Test-AzureADAccesToken','Test-AzureADUserForGroupDynamicMembership','Update-AzureADConnectCloudProvisionningServiceSyncSchema', 'Watch-AzureADAccessToken', 'Get-AzureADUserAdministrativeUnitMemberOfCustom', 'Remove-AzureADAdministrativeUnitMemberCustom', 'Get-AzureADOrganizationCustom','Update-AzureADOrganizationCustom','Get-AzureADOnPremisesProvisionningErrors','New-AzureADMSGroupCustom','Set-AzureADMSGroupCustom'

# Applets de commande a exporter a partir de ce module. Pour de meilleures performances, neutilisez pas de caracteres generiques et ne supprimez pas l entree. Utilisez un tableau vide si vous neavez aucune applet de commande e exporter.
CmdletsToExport = @()

# Variables a exporter a partir de ce module
# VariablesToExport = @()

# Alias a exporter a partir de ce module. Pour de meilleures performances, neutilisez pas de caracteres generiques et ne supprimez pas leentree. Utilisez un tableau vide si vous n avez aucun alias a exporter.
AliasesToExport = @('Get-AzureADUserAllInfo')

# Ressources DSC a exporter depuis ce module
# DscResourcesToExport = @()

# Liste de tous les modules empaquetes avec ce module
# ModuleList = @()

# Liste de tous les fichiers empaquetes avec ce module
FileList = 'use-AzureAD.psm1'

# Donnees privees a transmettre au module specifie dans RootModule/ModuleToProcess. Cela peut egalement inclure une table de hachage PSData avec des metadonnees de modules supplementaires utilisees par PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('API','AzureAD','Azure','MSGraph','GraphAPI','AdministrativeUnit')

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/MS-LUF/Use-AzureAD'

        # A URL to an icon representing this module.
        IconUri = 'http://www.lucas-cueff.com/files/gallery.png'

        # ReleaseNotes of this module
        ReleaseNotes = 'v1.7 - last public release - beta version - add functions to create / update Office 365 groups with resourceBehaviorOptions and resourceProvisioningOptions'
        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable
    
 } # End of PrivateData hashtable

# URI HelpInfo de ce module
# HelpInfoURI = ''

# Le prefixe par defaut des commandes a ete exporte a partir de ce module. Remplacez le prefixe par defaut a l aide de Import-Module -Prefix.
# DefaultCommandPrefix = ''

}