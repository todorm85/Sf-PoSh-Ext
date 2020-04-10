<#
.SYNOPSIS
Seeds a hierarchy of pages into Sitefinity instance. The system must have an Admin user with email and username admin@test.test
.PARAMETER pagesPerLevelCount
The number of child pages for each page
.PARAMETER levelsCount
The depth of the hierarchy of pages
.PARAMETER forAllSites
Whether to generate the same hierarchy for every site in Sitefinity
#>
function s-seedPages {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ -gt 0 })]
        [int]
        $pagesPerLevelCount,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ -gt 0 })]
        [int]
        $levelsCount,
        
        [switch]
        $forAllSites
    )
    
    $allSitesValue = "false"
    if ($forAllSites) { $allSitesValue = "true" }

    _s-execute-utilsRequest -typeName "Pages" -methodName "Seed" -parameters @($pagesPerLevelCount, $levelsCount, $allSitesValue) > $null
}

function s-seedPages-deleteAll {
    param (
        [switch]$allSites
    )

    $allSitesValue = "false"
    if ($forAllSites) { $allSitesValue = "true" }
    _s-execute-utilsRequest -typeName "Pages" -methodName "DeleteAll" -parameters @($allSitesValue) > $null
}

function s-seedPages-AddContentWidgetToAllPages {
    _s-execute-utilsRequest -typeName "Pages" -methodName "AddContentWidgetToAllPages" > $null
}

function s-seedPages-CreateChildPages {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$urlName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$countRaw,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$pageTitle
    )

    _s-execute-utilsRequest -typeName "Pages" -methodName "CreateChildPages" -parameters @($urlName, $countRaw, $pageTitle) > $null
}