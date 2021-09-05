function psf {
    param (
        [Parameter(ValueFromPipeline)]
        [SfProject]$project
    )
    
    Process {
        Run-InFunctionAcceptingProjectFromPipeline {
            param($project)
            $excludeTags = @("official", "archive")
            sf-PSproject-tags-get | ? { $excludeTags -notcontains $_ } | sf-PSproject-tags-remove > $null
            if ($project.branch) {
                sf-PSproject-rename -newName "free"
                if (sf-source-hasPendingChanges) {
                    sf-source-undoPendingChanges
                }
            }
            else {
                sf-PSproject-rename -newName "free_"
            }
        }
    }
}
