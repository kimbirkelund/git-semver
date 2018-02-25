Describe AssertInRepository {
    BeforeAll {
        $ErrorActionPreference = $true;
        Set-StrictMode -Version Latest;

        Get-ChildItem $PSScriptRoot *.helpers.ps1 | ForEach-Object { . $_.FullName }
        Get-ChildItem $PSScriptRoot\..\Internal *.ps1 | ForEach-Object { . $_.FullName }
    }

    It "Does nothing when in repository" {
        CreateGitRepositoryAndGoToIt;

        AssertInRepository
    }

    It "Raises error when not in repository" {
        GoToNonRepositoryPath;

        { AssertInRepository } | Should -Throw "Must be invoked in a git repository.";
    }
}
