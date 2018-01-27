function safegit
{
    $exit = 0
    $path = [System.IO.Path]::GetTempFileName()
    try
    {
        try
        {
            git.exe $args 2> $path
        }
        catch
        {
            Write-Host "Error: $_`n$($_.ScriptStackTrace)"
        }

        $exit = $LASTEXITCODE
        if ($exit -gt 0)
        {
            Write-Error (Get-Content $path).ToString()
        }
        else
        {
            Get-Content $path | Select-Object -First 1
        }
    }
    finally
    {
        if (Test-Path $path)
        {
            Remove-Item $path
        }
    }
}

function CreateGitRepositoryAndGoToIt()
{
    $repositoryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid());

    New-Item -ItemType Directory $repositoryRoot;
    Set-Location $repositoryRoot;

    safegit init;
    safegit checkout -b master;

    MakeEmptyCommit -Message "Initial commit." > $null;

    Write-Host "Created empty repository at $repositoryRoot";
    return $repositoryRoot;
}

function MakeEmptyCommit
{
    PARAM (
        [string]$Message = ("A commit $([guid]::NewGuid())")
    )

    safegit commit -m $Message --allow-empty;
}

function CreateTag
{
    PARAM (
        [string]$TagName = "tag",
        [string]$Message = "some message"
    )

    safegit tag $TagName -a -m $Message;
}
