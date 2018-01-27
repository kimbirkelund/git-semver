function CreateGitRepositoryAndGoToIt()
{
    $repositoryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid());

    New-Item -ItemType Directory $repositoryRoot;
    Set-Location $repositoryRoot;

    git init;
    git checkout -b master;

    MakeEmptyCommit -Message "Initial commit." > $null;

    Write-Host "Created empty repository at $repositoryRoot";
    return $repositoryRoot;
}

function MakeEmptyCommit
{
    PARAM(
        [string]$Message = ("A commit $([guid]::NewGuid())")
    )

    git commit -m $Message --allow-empty;
}

function CreateTag{
    PARAM (
        [string]$TagName = "tag"
    )
}
