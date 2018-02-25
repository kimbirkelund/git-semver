Describe Get-GitSemanticVersion {
    It "Returns 1.0.0 when no version tags are present" {
        Get-GitSemanticVersion | Should Be "1.0.0"
    }

    It "Returns version part of tag when on tag"{
        CreateGitRepositoryAndGoToIt;
        
        safegit tag -a "release/1.2.3"
    }
}
