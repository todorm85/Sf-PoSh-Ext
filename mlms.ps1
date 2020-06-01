function s-upgradeMl {
    $current = sf-project-get
    $source = sf-project-get -all | ? displayName -eq "upgrade_to_this"
    $trgPath = $current.webAppPath
    _copySrcFile -srcApp "$($source.webAppPath)" -trgApp "$($current.webAppPath)"
}

function s-downgradeMl {
    $current = sf-project-get
    $source = sf-project-get -all | ? displayName -eq "upgrade_from_this"    
    _copySrcFile -srcApp "$($source.webAppPath)" -trgApp "$($current.webAppPath)"
    Write-Warning "Do not forget to restore app state."
}

function _copySrcFile ($srcApp, $trgApp) {
    unlock-allFiles -path "$trgApp\bin\*"
    Remove-Item -Path "$trgApp\bin\*" -Recurse -Force
    Copy-Item "$srcApp\bin\*" -Destination "$trgApp\bin" -Force -recurse
    Copy-Item "$srcApp\web.config" -Destination "$trgApp\web.config" -Force -recurse
    Copy-Item "$srcApp\App_Data\Sitefinity\Sitefinity.lic" -Destination "$trgApp\App_Data\Sitefinity\Sitefinity.lic" -Force -recurse
}