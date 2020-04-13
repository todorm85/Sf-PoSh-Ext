function sfe-sitesync-setupTarget {
    _s-execute-utilsRequest -typeName "SiteSync" -methodName "SetupDestination" > $null
}

function sfe-sitesync-setupSource {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $targetUrl
    )

    _s-execute-utilsRequest -typeName "SiteSync" -methodName "SetupSrc" -parameters $targetUrl > $null
}

function sfe-sitesync-sync {
    param (
        [string]$types
    )

    if (!$types) {
        $types = "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Flat" + "," +
        "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Parenttype" + "," +
        "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Childtype" + "," +
        "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Grandchild2" + "," +
        "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Grandchild"
    }

    _s-execute-utilsRequest -typeName "SiteSync" -methodName "Sync" -parameters $types > $null
}

function sfe-siteSync-install {
    [SfProject]$source = sf-project-getCurrent
    $siteSyncTag = "SiteSync-$([Guid]::NewGuid().ToString().Split('-')[0])"

    # # check if not already setup
    # $targetUrl = sfe-siteSync-getTargetUrl
    # if ($targetUrl) {
    #     throw "Sitesync already enabled. $targetUrl"
    # }

    # check if project is initialized
    $dbName = sf-db-getNameFromDataConfig
    $dbServer = sql-get-dbs | ? { $_.name -eq $dbName }
    if (!$dbServer) {
        Write-Warning "Not initialized with db. Initializing..."
        sf-app-reinitializeAndStart
    }

    # clone with database clone
    sf-project-clone -skipSourceControlMapping

    # setup the target
    sf-project-rename -newName "$($source.displayName)_trg"
    sf-projectTags-addToCurrent $siteSyncTag
    sfe-sitesync-setupTarget
    sf-appStates-save -stateName "siteSyncInit"
    $targetUrl = sf-iisSite-getUrl

    # setup the source
    sf-project-setCurrent -newContext $source
    sf-projectTags-addToCurrent $siteSyncTag
    sf-project-rename -newName "$($source.displayName)_src"
    sfe-sitesync-setupSource -targetUrl $targetUrl
    sf-appStates-save -stateName "siteSyncInit"
}

function sfe-siteSync-getTargetUrl {
    _s-execute-utilsRequest -typeName "SiteSync" -methodName "GetTargetUrl" > $null
}

function sfe-siteSync-uninstall {
    _s-execute-utilsRequest -typeName "SiteSync" -methodName "Uninstall" > $null
    # TODO remove all counterparts with relevant tags
}