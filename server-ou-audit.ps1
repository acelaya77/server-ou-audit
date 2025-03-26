<#
.SYNOPSIS
    A script that processes a list of server names from an input file and retrieves their Distinguished Name (OU location) from Active Directory, outputting the results to a CSV file.

.DESCRIPTION
    This script reads server names from a provided input file, queries Active Directory for each server, and retrieves its Distinguished Name (DN). 
    The script constructs a path based on the DN and exports the results to a CSV file in the same directory as the input file.

.PARAMETER inputFile
    The input file containing a list of server names (one per line). The file must be a plain text file (.txt) with server names listed line by line.

.EXAMPLE
    .\Get-ServerInfo.ps1 -inputFile "C:\path\to\servers.txt"
    This command will run the script, using the file `servers.txt` to obtain server names and output the results as a CSV file.

.NOTES
    File version: 1.0
    Author: Your Name
    Last updated: Date

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [System.IO.FileInfo]$inputFile
)

# Import ActiveDirectory module (add verbose flag if desired)
Import-Module ActiveDirectory -Verbose:$VerbosePreference

$domain = Get-AdDomain


# Load server names from the input file and filter out empty or null names
$serverNames = Get-Content $inputFile | Where-Object { -not [string]::IsNullOrEmpty($_) }

# Get all server objects in one call to reduce redundancy
$servers = $serverNames | Get-AdComputer

# Process each server to get Distinguished Name (OU location)
$results = $servers | ForEach-Object {
    # Since the 'Computers' built-in location is not an OU;
    # we build the "CN=Computers" path explicitly
    $path = if ($_.DistinguishedName -match $domain.ComputersContainer) {
        $domain.ComputersContainer
    } else {
        # Remove the CN portion of the DistinguishedName and join the remaining parts
        [string]::Join(',', ($_.DistinguishedName.Split(',') | Where-Object { $_ -notmatch "^CN" }))
    }

    # Create the output object
    [PSCustomObject]@{
        ServerName        = $_.Name
        DistinguishedName = $_.DistinguishedName
        _Path             = $path
    }
}

# Export results to a CSV file in the same directory as the input file
$results | Export-Csv -Path (Join-Path (Split-Path $inputFile -Parent) "$($inputFile.BaseName).csv") -NoTypeInformation
