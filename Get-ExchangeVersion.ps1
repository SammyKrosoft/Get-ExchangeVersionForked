Function Get-ExchangeVersion {
<#
.SYNOPSIS
    This script will get the cumulative update version for the specified exchange server.
 
.DESCRIPTION
    BuildNumbers link:
    https://docs.microsoft.com/en-us/exchange/new-features/build-numbers-and-release-dates?view=exchserver-2019
 
 
.NOTES  
    Name: Get-ExchangeVersion
    Author: theSysadminChannel
    Version: 1.0
    LastUpdated: 2020-July-1
 
 
.LINK
    https://thesysadminchannel.com/get-exchange-cumulative-update-version-and-build-numbers-using-powershell/ -
 
 
.EXAMPLE
    Get-ExchangeServer | Get-ExchangeVersion
 
 
.EXAMPLE
    Get-ExchangeVersion -ComputerName ExchSrv01, ExchSrv02
#>
 
 
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            )]
 
        [string[]]  $ComputerName
 
    )
 
    BEGIN {
        #Creating the hash table with build numbers and cumulative updates
        $BuildToProductName = @{
            '14.3.123.4'   = 'Microsoft Exchange Server 2010 SP3'
            #
            '15.0.620.29'  = 'Exchange Server 2013 Cumulative Update 1 (CU1)'
            '15.0.712.24'  = 'Exchange Server 2013 Cumulative Update 2 (CU2)'
            '15.0.775.38'  = 'Exchange Server 2013 Cumulative Update 3 (CU3)'
            '15.0.847.32'  = 'Exchange Server 2013 Service Pack 1 (CU4)'
            '15.0.913.22'  = 'Exchange Server 2013 Cumulative Update 5 (CU5)'
            '15.0.995.29'  = 'Exchange Server 2013 Cumulative Update 6 (CU6)'
            '15.0.1044.25' = 'Exchange Server 2013 Cumulative Update 7 (CU7)'
            '15.0.1076.9'  = 'Exchange Server 2013 Cumulative Update 8 (CU8)'
            '15.0.1104.5'  = 'Exchange Server 2013 Cumulative Update 9 (CU9)'
            '15.0.1130.7'  = 'Exchange Server 2013 Cumulative Update 10 (CU10)'
            '15.0.1156.6'  = 'Exchange Server 2013 Cumulative Update 11 (CU11)'
            '15.0.1178.4'  = 'Exchange Server 2013 Cumulative Update 12 (CU12)'
            '15.0.1210.3'  = 'Exchange Server 2013 Cumulative Update 13 (CU13)'
            '15.0.1236.3'  = 'Exchange Server 2013 Cumulative Update 14 (CU14)'
            '15.0.1263.5'  = 'Exchange Server 2013 Cumulative Update 15 (CU15)'
            '15.0.1293.2'  = 'Exchange Server 2013 Cumulative Update 16 (CU16)'
            '15.0.1320.4'  = 'Exchange Server 2013 Cumulative Update 17 (CU17)'
            '15.0.1347.2'  = 'Exchange Server 2013 Cumulative Update 18 (CU18)'
            '15.0.1365.1'  = 'Exchange Server 2013 Cumulative Update 19 (CU19)'
            '15.0.1367.3'  = 'Exchange Server 2013 Cumulative Update 20 (CU20)'
            '15.0.1395.4'  = 'Exchange Server 2013 Cumulative Update 21 (CU21)'
            '15.0.1473.3'  = 'Exchange Server 2013 Cumulative Update 22 (CU22)'
            '15.0.1497.2'  = 'Exchange Server 2013 Cumulative Update 23 (CU23)'
            #
            '15.1.396.30'  = 'Exchange Server 2016 Cumulative Update 1 (CU1)'
            '15.1.466.34'  = 'Exchange Server 2016 Cumulative Update 2 (CU2)'
            '15.1.544.27'  = 'Exchange Server 2016 Cumulative Update 3 (CU3)'
            '15.1.669.32'  = 'Exchange Server 2016 Cumulative Update 4 (CU4)'
            '15.1.845.34'  = 'Exchange Server 2016 Cumulative Update 5 (CU5)'
            '15.1.1034.26' = 'Exchange Server 2016 Cumulative Update 6 (CU6)'
            '15.1.1261.35' = 'Exchange Server 2016 Cumulative Update 7 (CU7)'
            '15.1.1415.2'  = 'Exchange Server 2016 Cumulative Update 8 (CU8)'
            '15.1.1466.3'  = 'Exchange Server 2016 Cumulative Update 9 (CU9)'
            '15.1.1531.3'  = 'Exchange Server 2016 Cumulative Update 10 (CU10)'
            '15.1.1591.10' = 'Exchange Server 2016 Cumulative Update 11 (CU11)'
            '15.1.1713.5'  = 'Exchange Server 2016 Cumulative Update 12 (CU12)'
            '15.1.1779.2'  = 'Exchange Server 2016 Cumulative Update 13 (CU13)'
            '15.1.1847.3'  = 'Exchange Server 2016 Cumulative Update 14 (CU14)'
            '15.1.1913.5'  = 'Exchange Server 2016 Cumulative Update 15 (CU15)'
            '15.1.1979.3'  = 'Exchange Server 2016 Cumulative Update 16 (CU16)'
            '15.1.2044.4'  = 'Exchange Server 2016 Cumulative Update 17 (CU17)'
            '15.1.2106.2'  = 'Exchange Server 2016 Cumulative Update 18 (CU18)'
            '15.1.2176.2'  = 'Exchange Server 2016 Cumulative Update 19 (CU19)'
            #
            '15.2.330.5'   = 'Exchange Server 2019 Cumulative Update 1 (CU1)'
            '15.2.397.3'   = 'Exchange Server 2019 Cumulative Update 2 (CU2)'
            '15.2.464.5'   = 'Exchange Server 2019 Cumulative Update 3 (CU3)'
            '15.2.529.5'   = 'Exchange Server 2019 Cumulative Update 4 (CU4)'
            '15.2.595.3'   = 'Exchange Server 2019 Cumulative Update 5 (CU5)'
            '15.2.659.4'   = 'Exchange Server 2019 Cumulative Update 6 (CU6)'
            '15.2.721.2'   = 'Exchange Server 2019 Cumulative Update 7 (CU7)'
            '15.2.792.3'   = 'Exchange Server 2019 Cumulative Update 8 (CU8)'
        }
    }
 
    PROCESS {
        foreach ($Computer in $ComputerName) {
            try {
                $Computer = $Computer.ToUpper()
                $Server = Get-ExchangeServer $Computer -ErrorAction Stop
 
                $Version = $Server.AdminDisplayVersion
                $Version = [regex]::Matches($Version, "(\d*\.\d*)").value -join '.'
 
                $Product = $BuildToProductName[$Version]
 
                $Object = [pscustomobject]@{
                    ComputerName = $Computer
                    Edition      = $Server.Edition
                    BuildNumber  = $Version
                    ProductName  = $Product
                     
                }
                Write-Output $Object
 
            } catch {
                Write-Error "$_.Exception.Message"
 
            } finally {
                $Server  = $null
                $Version = $null
                $Product = $null
 
            }
        }
    }
 
 
    END {}
}
