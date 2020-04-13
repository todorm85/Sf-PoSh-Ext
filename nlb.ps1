function sfe-nlb-overrideOtherNodeConfigs ([switch]$skipWait) {
    [SfProject]$currentNode = sf-project-getCurrent
    $srcConfigs = _sfe-nlb-getConfigsPath $currentNode
    if (!(Test-Path $srcConfigs)) {
        throw "No source config files."
    }

    $srcWebConfig = _sfe-nlb-getWebConfigPath $currentNode
    $otherNodes = sf-nlb-getOtherNodes
    $otherNodes | % {
        sf-project-setCurrent $_
        $trg = _sfe-nlb-getConfigsPath $_
        if (!(Test-Path $trg)) {
            New-Item $trg -ItemType Directory
        }

        Remove-Item -Path "$trg\*" -Recurse -Force
        Copy-Item "$srcConfigs\*" $trg
        
        $trgWebConfig = _sfe-nlb-getWebConfigPath $_
        Copy-Item $srcWebConfig $trgWebConfig -Force
    }

    sf-project-setCurrent $currentNode
    if (!$skipWait) {
        sf-nlb-forAllNodes {
            sf-app-sendRequestAndEnsureInitialized
        }
    }
}

function sfe-nlb-resetAllNodes {
    param([switch]$skipWait)
    sf-nlb-forAllNodes {
        sf-iisAppPool-Reset
        if (!$skipWait) {
            sf-app-sendRequestAndEnsureInitialized
        }
    }
}

function _sfe-nlb-getConfigsPath ([SfProject]$project) {
    "$($project.webAppPath)\App_Data\Sitefinity\Configuration"
}

function _sfe-nlb-getWebConfigPath ([SfProject]$project) {
    "$($project.webAppPath)\web.config"
}