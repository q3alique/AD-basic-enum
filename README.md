# AD-basic-enum.ps1

## Description

`AD-basic-enum.ps1` is a PowerShell script designed for basic enumeration of Active Directory objects. The script allows you to search for various AD object types such as users, computers, groups, and more. It is especially useful for quickly retrieving information about specific objects within an Active Directory environment.

## Installation

1. Download the `AD-basic-enum.ps1` script to your local machine.
2. Place the script in a directory of your choice.

## Usage

### Running the Script

The script can be executed by providing the type of Active Directory object you want to search for, along with an optional name for more specific searches.

### Command-Line Examples

```powershell
# Find all users
.\AD-basic-enum.ps1 users

# Find a specific user
.\AD-basic-enum.ps1 users jeff

# Find all groups
.\AD-basic-enum.ps1 groups

# Find a specific group
.\AD-basic-enum.ps1 groups "Domain Admins"
```

### Running Without Arguments

If you run the script without any arguments, it will display the help information:

```powershell
.\AD-basic-enum.ps1
```

### Supported AD Object Types

- `users` - Find user accounts
- `computers` - Find computer accounts
- `groups` - Find security groups
- `domaincontrollers` - Find domain controllers
- `serviceaccounts` - Find service accounts
- `trusteddomains` - Find trusted domains
- `ou` - Find organizational units
- `printers` - Find printers
- `sites` - Find AD sites
- `contacts` - Find contacts
- `foreignsecurity` - Find foreign security principals
- `managedserviceaccounts` - Find managed service accounts
- `gpos` - Find Group Policy Objects
- `containers` - Find containers
- `dynamicdistribution` - Find dynamic distribution groups
- `subnets` - Find AD subnets
- `sitelinks` - Find AD site links
- `hosts` - Find host accounts
