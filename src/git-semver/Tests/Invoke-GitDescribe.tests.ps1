
Describe Invoke-GitDescribe.ps1 {
    BeforeAll {
        $ErrorActionPreference = $true;
        Set-StrictMode -Version Latest;

        Get-ChildItem $PSScriptRoot *.helpers.ps1 | ForEach-Object { . $_.FullName }
        Get-ChildItem $PSScriptRoot\..\Internal *.ps1 | ForEach-Object { . $_.FullName }
    }

    BeforeEach {
        CreateGitRepositoryAndGoToIt;
    }

    It "Returns null when nothing to describe" {
        Invoke-GitDescribe -Verbose | Should Be $null
    }

    It "Writes where when called in non-git repo" {
        Set-Location ([System.IO.Path]::GetTempPath());

        { Invoke-GitDescribe -Verbose } | Should Throw;
    }

    It "Returns tag name when on a tag commit" {
        $tagName = "releases/v1.0.0"
        CreateTag $tagName

        Invoke-GitDescribe -Verbose | Should Be $tagName
    }

    It "Returns nearest tag and commits since" {
        $tagName = "releases/v1.0.0"
        CreateTag $tagName
        MakeEmptyCommit
        MakeEmptyCommit
        MakeEmptyCommit

        Invoke-GitDescribe -Verbose | Should Be "$tagName-3"
    }

    It "Returns tag name when on a tag commit, even when tag has a -" {
        $tagName = "atag-3-gf17"
        CreateTag $tagName

        Invoke-GitDescribe -Verbose | Should Be $tagName
    }

    It "Returns nearest tag and commits since, even when tag has a -" {
        $tagName = "atag-3-gf17"
        CreateTag $tagName
        MakeEmptyCommit
        MakeEmptyCommit
        MakeEmptyCommit

        Invoke-GitDescribe -Verbose | Should Be "$tagName-3"
    }
}

