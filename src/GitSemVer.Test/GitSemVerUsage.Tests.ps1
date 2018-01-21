Describe "git semver" {
    It "outputs usage when called with no arguments" {
        $expected = "usage: git semver <subcommand> .+";
        $actual = git semver;

        "$actual" | Should -Match $expected;
    }

    It "outputs usage when called with -h" {
        $expected = "usage: git semver <subcommand> .+";
        $actual = git semver -h;

        "$actual" | Should -Match $expected;
    }

    BeforeEach {
        $semverPath = Resolve-Path (Join-Path (Split-Path -Parent $PSScriptRoot) "GitSemVer");
        $env:Path += ";$semverPath;"
    }

    AfterEach {
        $semverPath = Resolve-Path (Join-Path (Split-Path -Parent $PSScriptRoot) "GitSemVer");
        $env:Path = $env:Path -replace ([regex]::Escape(";$semverPath;")), ""
    }
}