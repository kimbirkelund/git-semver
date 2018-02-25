Describe Get-GitSemanticVersionEnvironmentVariables {
    It "Should return list of hashtable with environment variables" {
        Get-GitSemanticVersionEnvironmentVariables | Should -BeOfType [hashtable]
    }
}
