function sfe {
    param (
        [Parameter(ParameterSetName = "recreate")][switch]$fullReset,
        [Parameter(ParameterSetName = "startNew")][switch]$resetSourceCode,
        [Parameter(ParameterSetName = "sync")][switch]$syncSourceCode,
        [Parameter(ParameterSetName = "setFree")][switch]$setFree,
        [Parameter(ValueFromPipeline)]
        [SfProject]$project
    )
    
    Process {
        Run-InFunctionAcceptingProjectFromPipeline {
            param($project)
            if ($syncSourceCode) {
                sf-appPrecompiledTemplates-remove
                sf -getLatestChanges -stopWhenNoNewChanges -build
                sf -ensureRunning
                return
            }

            if ($fullReset) {
                sf -getLatestChanges -forceGetChanges -discardExistingChanges -cleanSolution -build -resetApp -precompile -saveInitialState
                return
            }

            if ($resetSourceCodeReset) {
                sf-appPrecompiledTemplates-remove
                sf -getLatestChanges -discardExistingChanges -stopWhenNoNewChanges -build
                sf -ensureRunning
                return
            }

            if ($setFree) {
                $excludeTags = @("official", "archive")
                sf-tags-get | ? {$excludeTags -notcontains $_} | sf-tags-remove
                if ($project.branch) {
                    sf-project-rename -newName "free"
                    if (sf-sourceControl-hasPendingChanges) {
                        sf-sourceControl-undoPendingChanges
                    }
                }
                else {
                    sf-project-rename -newName "free_"
                }
            }
        }
    }
}
