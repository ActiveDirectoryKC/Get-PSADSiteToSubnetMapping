<# Help Section
.SYNOPSIS
    Generates a list of subnets based on the provided site information. 

.DESCRIPTION
    Script takes the provided $ReplicationSiteSearchString and searches for all sites that match that string. 
    It then grabs the subnets associated with any discovered sites and displays the data as a table. 

    If the ExportCsv switch is set, the script will generate a CSV in the script's location with the same
    information displayed on the screen.

    If the CompareSiteSearchString parameter is provided a site, the script will search for any sites matching 
    that name displaying the two tables of data side-by-side. 

    If the OutGridView switch is provided, the output is displayed as a Grid View Window. 

.EXAMPLE
    PS C:\> .\Get-ADSiteToSubnetMapping.ps1
    Script will prompt for the ReplicationSiteSearchString and display any matching site-to-subnet mappings. 

.EXAMPLE
    PS C:\> .\Get-PSADSiteToSubnetMapping.ps1 -ExportCsv
    Script will prompt for the ReplicationSiteSearchString and display any matching site-to-subnet mappings
    and will export the found mappings to a csv in the same folder as the script.

.EXAMPLE
    PS C:\> .\Get-PSADSiteToSubnetMapping.ps1 -ReplicationSiteSearchString "SITE1" -CompareSiteSearchString "SITE2"
    Script will search for the sites specified by ReplicationSiteSearchString and CompareSiteSearchString and display them
    side by side. 

.PARAMETER ReplicationSiteSearchString
    [string]ReplicationSiteSearchString
    Determines which site search string is used to discover sites and subnets. 

.PARAMETER CompareSiteSearchString
    [string]ReplicationSiteSearchString
    Adds an additioanl site search string to be searched and have its subnets display.

.PARAMETER ExportCsv
    [switch]ExportCsv
    Exports the found sites and subnet mapping to a csv file in the same folder as the script.

.PARAMETER OutGridView
    [switch]OutGridView
    Displays the output in a GridView Window.

.INPUTS
    Script does not take any pipeline input. Please see the various parameter sections for details about the parameter inputs.

.OUTPUTS
    Outputs the Sites to Subnets mapping to the screen or to a grid view depending on the parameters specified. Will create a 
    csv file if the ExportCsv swtich is used. 

.NOTES
    Created On: 03/04/2020
    Version 1.0

    How To:
    1. Run the script as is. It will prompt you for the Site Name you want to query.
        a. You can do a short site name, the script will look up
        b. If this returns multiple sites, you'll get a list of multiple sites. 
        c. If you put in an asterisk (*) the script will return all site links. 
    2. If you wish to export as CSV, include the -ExportCSV switch.
        This dumps the CSV in the same directory as the script.

.COPYRIGHT
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
#>

function Get-PSADSiteToSubnetMapping
{
    Param(
        [string]$ReplicationSiteSearchString,
        [string]$CompareSiteSearchString,
        [switch]$ExportCsv,
        [switch]$OutGridView
    )

    # Variables
    $SitesToSubnetList = New-Object "System.Collections.ArrayList" # Stores the Raw Data
    $DataTable = New-Object "System.Data.DataTable"

    # If we didn't supply it as a parameter, prompt.
    if(!$ReplicationSiteSearchString)
    {
        $ReplicationSiteSearchString = Read-Host "Please enter part or all of the site name"
    }

    # Grab sites based on the supplied search string
    if($CompareSiteSearchString)
    {
        [array]$ReplicationSites = Get-ADReplicationSite -Filter { (Name -like "*$ReplicationSiteSearchString*") -or (Name -like "*$CompareSiteSearchString*") } -Properties * | Select-Object Name,DistinguishedName
    }
    else
    {
        [array]$ReplicationSites = Get-ADReplicationSite -Filter { Name -like "*$ReplicationSiteSearchString*" } -Properties * | Select-Object Name,DistinguishedName
    }
    Write-Host ""

    # Loop through the found sites. 
    foreach($ReplicationSite in $ReplicationSites)
    {

        $SiteToSubnetList = New-Object "System.Collections.ArrayList"
        $SiteDN = $ReplicationSite.DistinguishedName # Set this to a variable to prevent weird errors. 

        $DataColumn = New-Object "System.Data.DataColumn"
        $DataColumn.ColumnName = $ReplicationSite.Name
        $DataTable.Columns.Add($DataColumn)

        # Get the subnets associated with that site and return only the name.
        $Subnets = Get-ADReplicationSubnet -Filter { Site -eq $SiteDN } -Properties Site | Select-Object -ExpandProperty Name

        $null = $SitesToSubnetList.Add( @{($ReplicationSite.Name)=($Subnets | Sort-Object)} )
    }

    # Variables for our Export and Display
    $SitesAsColumns = ($SitesToSubnetList.Keys | Select-Object -Unique)
    $LoopSize = 0;
    
    # Loop through the different "columns" 
    foreach($SiteColumn in $SitesAsColumns)
    {
        # Find the column whose size is larger set that to our loop size
        if($SitesToSubnetList.$SiteColumn.Count -gt $LoopSize)
        {
            $LoopSize = $SitesToSubnetList.$SiteColumn.Count
        }
    }

    # Loop through the columns and the data mapping one to one 
    for($i=0;$i -lt $LoopSize;$i++){
        $DataRow = $DataTable.NewRow()
        foreach($SiteColumn in $SitesAsColumns)
        {
            $DataRow[$SiteColumn] = $SitesToSubnetList.($SiteColumn)[$i]
        }
        $DataTable.Rows.Add($DataRow)
    }

    # Output the data table
    if($OutGridView)
    {
        $DataTable | Out-GridView -Title "Site to Subnet Mapping View"
    }
    else
    {
        $DataTable | Format-Table
    }

    # Export to CSV
    if($ExportCSV)
    {
        $DataTable | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$PSScriptRoot\ADSiteToSubnetMapping_$($env:USERNAME)_$(Get-Date -Format yyyyMMddHHmm).csv" -Encoding utf8
    }
}