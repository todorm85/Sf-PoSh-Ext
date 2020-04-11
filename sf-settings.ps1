function s-settings-BasicAuthToggle {
    param (
        [switch]$disable
    )

    $enabled = 'true'
    if ($disable) {
        $enabled = 'false'
    }

    _s-execute-utilsRequest -typeName "Settings" -methodName "BasicAuthSet" -parameters @($enabled) > $null
    if ($enabled) {
        s-seedUsers -mail "basicAuth@test.test" -roles "Administrators,BackendUsers"
    }
}

function s-settings-getBasicAuthGetHeaderValue ($user = "basicAuth@test.test", $pass = "admin@2") {
    $Text = "$($user):$pass"
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $EncodedText = [Convert]::ToBase64String($Bytes)
    "Basic $EncodedText"
}

function s-settings-setSslOffload {
    param (
        [bool]$flag
    )
    
    _s-execute-utilsRequest -typeName "NlbSetup" -methodName "SetSslOffload" -parameters $flag.ToString()
}
