function s-sitesync-setupTarget {
    _s-execute-utilsRequest -typeName "SiteSync" -methodName "SetupDestination" > $null
}

function s-sitesync-setupSource {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $targetUrl
    )

    _s-execute-utilsRequest -typeName "SiteSync" -methodName "SetupSrc" -parameters $targetUrl > $null
}

function s-sitesync-sync {
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

function s-siteSync-install {
    [SfProject]$source = sd-project-getCurrent
    $siteSyncTag = "SiteSync-$([Guid]::NewGuid().ToString().Split('-')[0])"

    # # check if not already setup
    # $targetUrl = s-siteSync-getTargetUrl
    # if ($targetUrl) {
    #     throw "Sitesync already enabled. $targetUrl"
    # }

    # check if project is initialized
    $dbName = sd-db-getNameFromDataConfig
    $dbServer = sql-get-dbs | ? { $_.name -eq $dbName }
    if (!$dbServer) {
        Write-Warning "Not initialized with db. Initializing..."
        sd-app-reinitializeAndStart
    }

    # clone with database clone
    sd-project-clone -skipSourceControlMapping

    # setup the target
    sd-project-rename -newName "$($source.displayName)_trg"
    sd-projectTags-addToCurrent $siteSyncTag
    s-sitesync-setupTarget
    sd-appStates-save -stateName "siteSyncInit"
    $targetUrl = sd-iisSite-getUrl

    # setup the source
    sd-project-setCurrent -newContext $source
    sd-projectTags-addToCurrent $siteSyncTag
    sd-project-rename -newName "$($source.displayName)_src"
    s-sitesync-setupSource -targetUrl $targetUrl
    sd-appStates-save -stateName "siteSyncInit"
}

function s-siteSync-getTargetUrl {
    _s-execute-utilsRequest -typeName "SiteSync" -methodName "GetTargetUrl"
}

function s-siteSync-uninstall {
    _s-execute-utilsRequest -typeName "SiteSync" -methodName "Uninstall" > $null
    # TODO remove all counterparts with relevant tags
}