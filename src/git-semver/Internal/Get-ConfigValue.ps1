function Get-ConfigValue
{
    <#
    .SYNOPSIS
      Short description
    .DESCRIPTION
      Long description
    .EXAMPLE
      Example of how to use this cmdlet
    #>
    [CmdletBinding()]
    PARAM
    (
        [switch]$DefaultVersion
    )

    $config = Get-Config;
    Write-Verbose "Config: $($config | Out-String)"
    Write-Verbose "Bound keys: $($PSBoundParameters.Keys -join ", ")";

    $key = $PSBoundParameters.Keys | Select-Object -First 1;

    return $config.$key;
}

