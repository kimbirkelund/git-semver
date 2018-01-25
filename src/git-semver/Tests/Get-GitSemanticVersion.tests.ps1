Describe Get-GitSemanticVersion {
    It "Returns 1.0.0 when no version tags are present" {
        Get-GitSemanticVersion | Should Be "1.0.0"
    }
}
