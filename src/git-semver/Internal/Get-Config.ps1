function Get-Config
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
    PARAM()

    return [PSCustomObject]@{
        DefaultVersion = "1.0.0";
    }
}

