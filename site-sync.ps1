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
    Param(
        [switch]$skipSourceControlMapping,
        [switch]$skipSolutionClone
    )

    [SfProject]$source = sf-project-get
    $sourceName = $source.displayName
    sfe-utils-deploy
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
        sf-app-sendRequestAndEnsureInitialized
    }

    # clone with database clone
    sf-project-clone -skipSourceControlMapping:$skipSourceControlMapping -skipSolutionClone:$skipSolutionClone
    
    # iisreset.exe # for some reason site is stopped and cannot be started and some other problems arise after its creation

    # setup the target
    sf-project-rename -newName "$($sourceName)_trg"
    sfe-sitesync-setupTarget
    $siteSyncSuffix = "sitesync-$([Guid]::NewGuid().ToString().Split('-')[0].Substring(0,3))"
    $siteSyncSuffix | sf-tags-add
    sf-appStates-save -stateName $siteSyncSuffix
    $targetUrl = sf-iisSite-getUrl
    
    # setup the source
    sf-project-setCurrent -newContext $source
    sf-project-rename -newName "$($sourceName)_src"
    $siteSyncSuffix | sf-tags-add
    sfe-sitesync-setupSource -targetUrl $targetUrl
    sf-appStates-save -stateName $siteSyncSuffix
}

function sfe-siteSync-getTargetUrl {
    _s-execute-utilsRequest -typeName "SiteSync" -methodName "GetTargetUrl" > $null
}

function sfe-siteSync-uninstall {
    param (
        [Parameter(ValueFromPipeline)]
        [SfProject]
        $project,
        [switch]
        $passThruProject
    )
    
    process {
        $project = Get-SfProjectFromPipeInput $project
        InProjectScope $project {
            _s-execute-utilsRequest -typeName "SiteSync" -methodName "Uninstall" > $null
            # TODO remove all counterparts with relevant tags
            sf-tags-get | ? { $_ -like "sitesync-*" } | sf-tags-remove
            sf-appStates-get | ? name -Like "sitesync-*" | sf-appStates-remove
            $name = $project.displayName.Replace("_src", "").Replace("_trg", "")
            if ($name -ne $project.displayName) {
                sf-project-rename $name
            }
        }
    }
}

function sfe-sitesync-copySourceCode {
    $src = sf-project-get
    $tag = sf-tags-get | ? { $_ -like "sitesync-*" }
    $trg = sf-project-get -all | ? tags -Contains $tag | ? id -ne $src.id
    Remove-Item "$($trg.webAppPath)\*" -Force -ErrorAction Stop
    Copy-Item "$($src.webAppPath)\*" "$($trg.webAppPath)" -Force
}