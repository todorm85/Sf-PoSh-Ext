$Global:SfEvents_OnAfterProjectSet += {
    sf-serverCode-deployDirectory "$PSScriptRoot\serverCode" "$($Global:sfe.appRelativeServerCodeRootPath)\sites"
}

function sfe-seedSites-create {
    param (
        $totalSitesCount = 2,
        [switch]$duplicateFromDefaultSite
    )
    
    sf-serverCode-run "SitefinityWebApp.SfDev.Sites" -methodName "Seed" -parameters @($totalSitesCount, $duplicateFromDefaultSite) > $null
}