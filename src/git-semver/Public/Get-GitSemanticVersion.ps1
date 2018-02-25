function Get-GitSemanticVersion
{
    <#
    .SYNOPSIS
      Gets the semantic version of the repository.
    .DESCRIPTION
      Gets the semantic version as computed by this module for the repository at the specified path (default to current directory).
      Parameters allows for getting the version in other commons formats.
    .EXAMPLE
      Example of how to use this cmdlet
    #>
    [CmdletBinding()]
    PARAM
    (
        [switch]$DotnetAssemblyVersion
    )

    $ErrorActionPreference = "Stop";
    Set-StrictMode -Version Latest;
    AssertInRepository

    $describe = Invoke-GitDescribe;
    Write-Verbose "Invoke-GitDescribe => $describe";

    if (!$describe)
    {
        Write-Verbose "Empty describe, returning default value.";
        return (Get-ConfigValue -DefaultVersion);
    }
}
