function sfe-localization-enable {
    _s-execute-utilsRequest -typeName "Localization" -methodName "Multi" > $null
}

function sfe-localization-disable {
    _s-execute-utilsRequest -typeName "Localization" -methodName "Mono" > $null
}