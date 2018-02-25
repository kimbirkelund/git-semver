function AssertInRepository
{
    try
    {
        if ([bool]::Parse((git rev-parse --is-inside-work-tree 2> $null)))
        {
            return;
        }
    }
    catch { }

    throw [System.InvalidOperationException]::new("Must be invoked in a git repository.");
}

