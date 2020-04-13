function sfe-seedDynamicTypes {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$parentsCount,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$childCount
    )
    
    _s-execute-utilsRequest -typeName "DynamicModule" -methodName "Seed" -parameters @($parentsCount, $childCount) > $null
}

function sfe-seedDynamicTypes-uninstall {
    _s-execute-utilsRequest -typeName "DynamicModule" -methodName "Uninstall" > $null
}