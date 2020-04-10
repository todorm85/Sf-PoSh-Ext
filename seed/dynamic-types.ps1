function s-seedDynamicTypes {
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

function s-seedDynamicTypes-uninstall {
    _s-execute-utilsRequest -typeName "DynamicModule" -methodName "Uninstall" > $null
}