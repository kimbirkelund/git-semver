function New-GitRelease
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

    )

    $ErrorActionPreference = "Stop";
    Set-StrictMode -Version Latest;
    AssertInRepository
}

