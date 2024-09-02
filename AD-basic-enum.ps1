param (
    [Parameter(Position=0)]
    [string]$AdObj,  # The type of Active Directory object to search for
    
    [Parameter(Position=1)]
    [string]$Name    # Optional argument for a specific user, group, or computer name
)

# Function to display help and available search types
function Show-Help {
    Write-Host "Usage: .\enum.ps1 <ad_obj_type> [name]"
    Write-Host ""
    Write-Host "Positional Parameters:"
    Write-Host "  <ad_obj_type>    The type of Active Directory object to search for."
    Write-Host "                   Valid values:"
    Write-Host "                     users                 - Find user accounts"
    Write-Host "                     computers             - Find computer accounts"
    Write-Host "                     groups                - Find security groups"
    Write-Host "                     domaincontrollers     - Find domain controllers"
    Write-Host "                     serviceaccounts       - Find service accounts"
    Write-Host "                     trusteddomains        - Find trusted domains"
    Write-Host "                     ou                    - Find organizational units"
    Write-Host "                     printers              - Find printers"
    Write-Host "                     sites                 - Find AD sites"
    Write-Host "                     contacts              - Find contacts"
    Write-Host "                     foreignsecurity       - Find foreign security principals"
    Write-Host "                     managedserviceaccounts- Find managed service accounts"
    Write-Host "                     gpos                  - Find Group Policy Objects"
    Write-Host "                     containers            - Find containers"
    Write-Host "                     dynamicdistribution   - Find dynamic distribution groups"
    Write-Host "                     subnets               - Find AD subnets"
    Write-Host "                     sitelinks             - Find AD site links"
    Write-Host "                     hosts                 - Find host accounts"
    Write-Host ""
    Write-Host "  [name]           (Optional) The name of a specific object to search for."
    Write-Host "                   Examples:"
    Write-Host "                     .\enum.ps1 users jeff"
    Write-Host "                     .\enum.ps1 groups 'Domain Admins'"
}

# If no arguments are provided, show the help message and exit
if (-not $AdObj) {
    Show-Help
    exit
}

# Dictionary of search filters
$searchFilters = @{
    "users"                 = "samAccountType=805306368"
    "computers"             = "samAccountType=805306369"
    "groups"                = "samAccountType=268435456"
    "domaincontrollers"     = "userAccountControl:1.2.840.113556.1.4.803:=8192"
    "serviceaccounts"       = "userAccountControl:1.2.840.113556.1.4.803:=512"
    "trusteddomains"        = "objectClass=trustedDomain"
    "ou"                    = "objectCategory=organizationalUnit"
    "printers"              = "objectCategory=printQueue"
    "sites"                 = "objectClass=site"
    "contacts"              = "objectCategory=contact"
    "foreignsecurity"       = "objectCategory=foreignSecurityPrincipal"
    "managedserviceaccounts"= "objectCategory=msDS-GroupManagedServiceAccount"
    "gpos"                  = "objectCategory=groupPolicyContainer"
    "containers"            = "objectCategory=container"
    "dynamicdistribution"   = "objectCategory=group"
    "subnets"               = "objectClass=subnet"
    "sitelinks"             = "objectClass=siteLink"
    "hosts"                 = "objectCategory=computer"
}

# Convert to lowercase for case-insensitive comparison
$AdObjLower = $AdObj.ToLower()

# Validate the AD object type by checking if it exists in the dictionary
if (-not $searchFilters.ContainsKey($AdObjLower)) {
    Write-Host "Invalid search type '$AdObjLower'! Use the script without arguments to see available search types."
    exit
}

# Debug: Output the valid AdObj
Write-Host "Valid AdObj: $AdObjLower"

# Get domain information
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$PDC = $domainObj.PdcRoleOwner.Name
$DN = ([adsi]'').distinguishedName 
$LDAP = "LDAP://$PDC/$DN"

# Set up directory entry and searcher
$direntry = New-Object System.DirectoryServices.DirectoryEntry($LDAP)
$dirsearcher = New-Object System.DirectoryServices.DirectorySearcher($direntry)

# Apply the base filter
$filter = $searchFilters[$AdObjLower]

# Add specific user, group, or host filter if provided
if ($Name) {
    if ($AdObjLower -eq "users" -or $AdObjLower -eq "serviceaccounts") {
        $filter = "(&($filter)(samAccountName=$Name))"
    } elseif ($AdObjLower -eq "groups") {
        $filter = "(&($filter)(cn=$Name))"
    } elseif ($AdObjLower -eq "computers" -or $AdObjLower -eq "hosts") {
        $filter = "(&($filter)(name=$Name))"
    }
}

# Debug: Output the LDAP filter for clarity
Write-Host "LDAP Filter: $filter"

# Apply the filter to the searcher
$dirsearcher.filter = $filter

# Perform the search and display the results
$result = $dirsearcher.FindAll()

Foreach ($obj in $result) {
    Foreach ($prop in $obj.Properties) {
        $prop
    }
    Write-Host "-------------------------------"
}
