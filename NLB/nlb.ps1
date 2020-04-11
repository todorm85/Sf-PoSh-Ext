function s-nlb-setup {
    if (!(_nlb-isProjectValidForNlb)) { return }
    [SfProject]$firstNode = sd-project-getCurrent
    [SfProject]$secondNode = _nlb-createSecondProject -name $firstNode.displayName
    
    $nlbNodesUrls = _nlb-getNlbClusterUrls $firstNode $secondNode
    _nlb-setupNode -node $firstNode -urls $nlbNodesUrls
    _nlb-setupNode -node $secondNode -urls $nlbNodesUrls

    _nginx-createNewCluster $firstNode $secondNode
}

function s-nlb-getOtherNodes {
    [SfProject]$p = sd-project-getCurrent
    if (!$p) {
        throw "No project selected."
    }
    
    $tag = _nlbTags-filterNlbTag $p.tags
    if (!$tag) {
        throw "Project not part of NLB cluster."
    }

    $result = sd-project-getAll | ? tags -Contains $tag | ? id -ne $p.id
    if (!$result) {
        throw "No associated nodes "
    }

    $result
}

function s-nlb-forAllNodes {
    param (
        [Parameter(Mandatory=$true)]
        [ScriptBlock]$script
    )

    $p = sd-project-getCurrent
    if (!$p) {
        throw "No project selected."
    }

    Invoke-Command -ScriptBlock $script
    s-nlb-getOtherNodes | % {
        sd-project-setCurrent $_
        Invoke-Command -ScriptBlock $script
    }

    sd-project-setCurrent $p
}

function s-nlb-setSslOffloadForAll {
    param (
        [Parameter(Mandatory=$true)]
        [bool]$flag
    )
    
    s-nlb-forAllNodes {
        s-settings-setSslOffload -flag $flag
    }
}

function s-nlb-getUrl {
    $p = sd-project-getCurrent
    if (!$p) {
        throw "No project selected."
    }

    $nlbTag = _nlbTags-filterNlbTag $p.tags
    if (!$nlbTag) {
        throw "No nlb configured for current project."
    }
    
    _nlbTags-getUrlFromTag $nlbTag
}

function s-nlb-getStatus {
    $p = sd-project-getCurrent
    if (!$p) {
        throw "No project selected."
    }

    $nlbTag = _nlbTags-filterNlbTag $p.tags
    if ($nlbTag) {
        $otherNode = s-nlb-getOtherNodes
        $url = s-nlb-getUrl
        [PScustomObject]@{
            enabled = $true;
            url = $url;
            nodeIds = @($p.id, $otherNode.id)
        }
    }
    else {
        [PScustomObject]@{
            enabled = $false;
        }
    }
}

function s-nlb-openBrowser {
    $url = s-nlb-getUrl

}

function _s-app-setMachineKey {
    Param(
        $decryption = "AES",
        $decryptionKey = "53847BC18AFFC19E5C1AC792A4733216DAEB54215529A854",
        $validationKey = "DC38A2532B063784F23AEDBE821F733625AD1C05D4718D2E0D55D842DAC207FB8492043E2EE5861BB3C4B0C4742CF73BDA586A70BDDC4FD50209B465A6DBBB3D"
    )

    [SfProject]$project = sd-project-getCurrent
    if (!$project) {
        throw "You must select a project to work with first using sf-dev tool."
    }

    $webConfigPath = "$($project.webAppPath)/web.config"
    Set-ItemProperty $webConfigPath -name IsReadOnly -value $false

    [XML]$xmlDoc = Get-Content -Path $webConfigPath

    $systemWeb = $xmlDoc.Configuration["system.web"]
    $machineKey = $systemWeb.machineKey
    if (!$machineKey) {
        $machineKey = $xmlDoc.CreateElement("machineKey") 
        $systemWeb.AppendChild($machineKey) > $null
    }

    $machineKey.SetAttribute("decryption", $decryption)
    $machineKey.SetAttribute("decryptionKey", $decryptionKey)
    $machineKey.SetAttribute("validationKey", $validationKey)
    $xmlDoc.Save($webConfigPath) > $null
}

function _nlb-setupNode ([SfProject]$node, $urls) {
    $previous = sd-project-getCurrent
    try {
        sd-project-setCurrent $node
        _s-app-setMachineKey
        _s-execute-utilsRequest -typeName "NlbSetup" -methodName "AddNode" -parameters $urls
        s-settings-setSslOffload -flag $true
    }
    finally {
        sd-project-setCurrent $previous
    }
}

function _nlb-isProjectValidForNlb {
    if ((s-nlb-getStatus).enabled) {
        Write-Warning "Already setup in NLB"
        return $false
    }

    # check if project is initialized
    $dbName = sd-db-getNameFromDataConfig
    $dbServer = sql-get-dbs | ? { $_.name -eq $dbName }
    if (!$dbServer) {
        Write-Warning "Not initialized with db"
        return $false
    }
    
    return $true
}

function _nlb-createSecondProject ($name) {
    sd-project-clone -skipSourceControlMapping -skipDatabaseClone > $null
    sd-project-rename -newName $name > $null
    sd-project-getCurrent
}

function _nlb-getNlbClusterUrls {
    param (
        $firstNode,
        $secondNode
    )

    $firstNodeUrl = _bindings-getLocalhostUrl -websiteName $firstNode.websiteName
    $secondNodeUrl = _bindings-getLocalhostUrl -websiteName $secondNode.websiteName
    "$firstNodeUrl,$secondNodeUrl"
}
