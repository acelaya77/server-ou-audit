# Get-ServerInfo PowerShell Script

## Overview

This PowerShell script reads a list of server names from a specified input file, queries Active Directory for each server's Distinguished Name (DN), and constructs a path from the DN. The results are then exported to a CSV file.

## Prerequisites

- PowerShell (version 5.1 or later)
- Active Directory module for PowerShell
- A valid Active Directory environment
- The input file should be a text file containing a list of server names, one per line

## Install

1. Open a powershell terminal, and choose a path in which to save the repo.
2. Run the following to clone the repo into a local directory:

```shell
git clone https://github.com/acelaya77/server-ou-audit.git

pushd server-ou-audit
```

## Usage

### Running the Script

1. Download the script `Get-ServerInfo.ps1` to your local machine.
2. Prepare a text file (e.g., `servers.txt`) that contains a list of server names, each on a new line.
3. Open a PowerShell window and navigate to the directory where the script is located.
4. Run the script using the following command:

   ```powershell
   .\Get-ServerInfo.ps1 -inputFile "C:\path\to\servers.txt"
   ```

   Replace `C:\path\to\servers.txt` with the actual path to your server names file.

### Output

The script will generate a CSV file with the following columns:

- `ServerName`: The name of the server.
- `DistinguishedName`: The Distinguished Name of the server in Active Directory.
- `_Path`: A constructed path based on the Distinguished Name, excluding the `CN` portion.

The CSV file will be saved in the same directory as the input file and named after the input file (e.g., `servers.csv`).

## Examples

### Example 1: Running the script with an input file

```powershell
.\Get-ServerInfo.ps1 -inputFile "C:\path\to\servers.txt"
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
