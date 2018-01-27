function Invoke-GitDescribe
{
    [CmdletBinding()]
    PARAM()

    try
    {
        git describe 2>$null;
    }
    catch
    {
        if (!$_.Exception)
        {
            throw;
        }

        if ($_.Exception.Message -eq "fatal: No names found, cannot describe anything.")
        {
            return $null;
        }

        throw;
    }
}
