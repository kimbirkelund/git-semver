Describe Get-ConfigValue {
    BeforeAll {
        $ErrorActionPreference = $true;
        Set-StrictMode -Version Latest;

        Get-ChildItem $PSScriptRoot *.helpers.ps1 | ForEach-Object { . $_.FullName }
        Get-ChildItem $PSScriptRoot\..\Internal *.ps1 | ForEach-Object { . $_.FullName }
    }

    BeforeEach {
        CreateGitRepositoryAndGoToIt;
    }

    It "DefaultVersion should return 1.0.0" {
        Get-ConfigValue -DefaultVersion -Verbose | Should Be "1.0.0"
    }
}
