function Get-DiskSpace{

<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER ServerName

.PARAMETER PSCREDENTIAL

.EXAMPLE
A single computer name or an array of computer names. You may also provide IP addresses

.EXAMPLE
View percent of disk space free on local server
Get-DiskSpace -Percent
.NOTES

#>

[CmdletBinding()] param(
    [parameter(ValueFromPipeline=$True)][string]$ServerName,
    $PSCredential,
    [switch]$free,
    [switch]$Total,
    [switch]$Percent
    )
    $array = @()
    $parms = @{'class'='Win32_LogicalDisk';'filter'='Drivetype=3'}

    if ($PSCredential) {$parms.Add('Credential',$PSCredential)} #Add parameter if set, otherwise run locally.
    
    $ServerName | % {
    if ($_) {$parms.Set_Item('ComputerName',$_)}
        $array += Get-WMIObject @parms # 
    }

    Switch ($PSBoundParameters.Keys) {
        'Free'     { return $array | % {$_.FreeSpace} } # Return free space if switch specified
        'Total'    { return $array | % {$_.Size} } 
        'Percent'  { return $array | % {$_.FreeSpace / $_.Size } }
    }
    return $array

}