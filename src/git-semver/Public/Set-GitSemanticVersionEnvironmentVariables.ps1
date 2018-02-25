function Set-GitSemanticVersionEnvironmentVariables
{
    <#
    .Synopsis
      Short description
    .DESCRIPTION
      Long description
    .EXAMPLE
      Example of how to use this cmdlet
  #>
    [CmdletBinding()]
    Param
    (

    )

    $ErrorActionPreference = "Stop";
    Set-StrictMode -Version Latest;
    AssertInRepository


}
