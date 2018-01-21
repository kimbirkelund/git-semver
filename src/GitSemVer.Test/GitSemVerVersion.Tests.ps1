Describe "git semver" {
    It "outputs version when called with -v" {
        $expected = "semver git plugin v\d+.\d+.\d+(-.+)?";
        $actual = git semver -v;

        "$actual" | Should -Match $expected;
    }

    It "outputs version when called with --version" {
        $expected = "semver git plugin v\d+.\d+.\d+(-.+)?";
        $actual = git semver --version;

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