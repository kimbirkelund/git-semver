function Invoke-GitDescribe
{
    [CmdletBinding()]
    PARAM()

    $ErrorActionPreference = "Stop";
    Set-StrictMode -Version Latest;

    try
    {
        $result = git describe --exact-match 2>&1;
        Write-Verbose "Output from git describe --exact-match: $result"
        return $result;
    }
    catch
    {
        if ($_.Exception -and ($_.Exception.Message -eq "fatal: No names found, cannot describe anything."))
        {
            return $null;
        }
    }

    try
    {
        $result = git describe 2>&1;
        Write-Verbose "Output from git describe: $result";

        if ($result -match "^(?<prefix>.+-\d+)-[^-]+$")
        {
            Write-Verbose "$result -match '^(?<prefix>.+-\d+)-[^-]+$' => $Matches";
            return $Matches["prefix"];
        }

        Write-Error "Output of git describe was in an unknown format: $result";
    }
    catch
    {
        if ($_.Exception -and ($_.Exception.Message -eq "fatal: No names found, cannot describe anything."))
        {
            return $null;
        }

        throw;
    }
}
