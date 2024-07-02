# Get-PSADSiteToSubnetMapping
Generates a list of subnets based on the provided site information. 

## DESCRIPTION
    Script takes the provided $ReplicationSiteSearchString and searches for all sites that match that string. 
    It then grabs the subnets associated with any discovered sites and displays the data as a table. 

    If the ExportCsv switch is set, the script will generate a CSV in the script's location with the same
    information displayed on the screen.

    If the CompareSiteSearchString parameter is provided a site, the script will search for any sites matching 
    that name displaying the two tables of data side-by-side. 

    If the OutGridView switch is provided, the output is displayed as a Grid View Window. 

## Examples
### EXAMPLE
    PS C:\> .\Get-ADSiteToSubnetMapping.ps1
    Script will prompt for the ReplicationSiteSearchString and display any matching site-to-subnet mappings. 

### EXAMPLE
    PS C:\> .\Get-PSADSiteToSubnetMapping.ps1 -ExportCsv
    Script will prompt for the ReplicationSiteSearchString and display any matching site-to-subnet mappings
    and will export the found mappings to a csv in the same folder as the script.

### EXAMPLE
    PS C:\> .\Get-PSADSiteToSubnetMapping.ps1 -ReplicationSiteSearchString "SITE1" -CompareSiteSearchString "SITE2"
    Script will search for the sites specified by ReplicationSiteSearchString and CompareSiteSearchString and display them
    side by side. 

## Parameters
### PARAMETER ReplicationSiteSearchString
    [string]ReplicationSiteSearchString
    Determines which site search string is used to discover sites and subnets. 

### PARAMETER CompareSiteSearchString
    [string]ReplicationSiteSearchString
    Adds an additioanl site search string to be searched and have its subnets display.

### PARAMETER ExportCsv
    [switch]ExportCsv
    Exports the found sites and subnet mapping to a csv file in the same folder as the script.

### PARAMETER OutGridView
    [switch]OutGridView
    Displays the output in a GridView Window.

## INPUTS
    Script does not take any pipeline input. Please see the various parameter sections for details about the parameter inputs.

## OUTPUTS
    Outputs the Sites to Subnets mapping to the screen or to a grid view depending on the parameters specified. Will create a 
    csv file if the ExportCsv swtich is used. 

## NOTES
    Created On: 03/04/2020
    Version 1.0

    How To:
    1. Run the script as is. It will prompt you for the Site Name you want to query.
        a. You can do a short site name, the script will look up
        b. If this returns multiple sites, you'll get a list of multiple sites. 
        c. If you put in an asterisk (*) the script will return all site links. 
    2. If you wish to export as CSV, include the -ExportCSV switch.
        This dumps the CSV in the same directory as the script.

## COPYRIGHT
Copyright (c) ActiveDirectoryKC.NET. All Rights Reserved

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

The website "ActiveDirectoryKC.NET" or it's administrators, moderators, 
affiliates, or associates are not affilitated with Microsoft and no 
support or sustainability guarantee is provided. 
