$Global:SfEvents_OnAfterProjectSet += {
    # REMOVE DEPENDENCY TO TEST PROJECT UTILITIES
    # sf-serverCode-deployDirectory "$PSScriptRoot\serverCode" "$($Global:sfe.appRelativeServerCodeRootPath)\dynamic"
}

function sfe-seedDynamicTypes {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$parentsCount,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$childCount
    )
    
    sf-serverCode-run "SitefinityWebApp.SfDev.DynamicModule" -methodName "Seed" -parameters @($parentsCount, $childCount) > $null
}

function sfe-seedDynamicTypes-uninstall {
    sf-serverCode-run "SitefinityWebApp.SfDev.DynamicModule" -methodName "Uninstall" > $null
}