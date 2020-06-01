function sfe-nlb-getAllNodeStatus {
    $Script:result = @()
    $prevInfo = $Global:InformationPreference
    $prevWarn = $Global:WarningPreference
    $Global:InformationPreference = "SilentlyContinue"
    $Global:WarningPreference = "SilentlyContinue"
    sf-nlb-forAllNodes {
        [SfProject]$proj = sf-project-get
        $Script:result += @([PSCustomObject]@{ id = $proj.id; name = $proj.displayName; isRunning = sf-app-isInitialized })
    }

    $Global:InformationPreference = $prevInfo
    $Global:WarningPreference = $prevWarn

    $Script:result
}