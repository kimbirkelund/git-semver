
Describe Invoke-GitDescribe.ps1 {
    BeforeAll {
        Get-ChildItem $PSScriptRoot *.helpers.ps1 | ForEach-Object { . $_.FullName }
        Get-ChildItem $PSScriptRoot\..\Internal *.ps1 | ForEach-Object { . $_.FullName }
    }

    BeforeEach {
        CreateGitRepositoryAndGoToIt;
    }

    It "Returns null when nothing to describe" {
        Invoke-GitDescribe | Should Be $null
    }

    It "Writes where when called in non-git repo" {
        Set-Location ([System.IO.Path]::GetTempPath());

        { Invoke-GitDescribe } | Should Throw;
    }

    It "Returns tag name when on a tag commit"{
        CreateTag "v1.0.0"
    }
}

