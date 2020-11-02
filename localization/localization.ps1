$Global:SfEvents_OnAfterProjectSet += {
    sf-serverCode-deployDirectory "$PSScriptRoot\serverCode" "$($Global:sfe.appRelativeServerCodeRootPath)\localization"
}

function sfe-localization-enable {
    sf-serverCode-run "SitefinityWebApp.SfDev.Localization" -methodName "Multi" > $null
}

function sfe-localization-disable {
    sf-serverCode-run "SitefinityWebApp.SfDev.Localization" -methodName "Mono" > $null
}