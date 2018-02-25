Describe Get-Config {
    BeforeAll {
        $ErrorActionPreference = $true;
        Set-StrictMode -Version Latest;

        Get-ChildItem $PSScriptRoot *.helpers.ps1 | ForEach-Object { . $_.FullName }
        Get-ChildItem $PSScriptRoot\..\Internal *.ps1 | ForEach-Object { . $_.FullName }
    }

    BeforeEach {
        CreateGitRepositoryAndGoToIt;
    }

    It "Should return object with config values" {
        Get-Config | Should -BeOfType [pscustomobject]
    }
}
