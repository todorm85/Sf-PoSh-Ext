function sfe {
    param (
        [Parameter(ParameterSetName = "recreate")][switch]$fullReset,
        [Parameter(ParameterSetName = "startNew")][switch]$resetSourceCode,
        [Parameter(ParameterSetName = "sync")][switch]$syncSourceCode
    )
    
    Process {
        Run-InFunctionAcceptingProjectFromPipeline {
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

            if ($resetSourceCodeReset){
                sf-appPrecompiledTemplates-remove
                sf -getLatestChanges -discardExistingChanges -stopWhenNoNewChanges -build
                sf -ensureRunning
                return
            }
        }
    }
}