function s-nginx-reset {
    # Get-Process -Name "nginx" -ErrorAction "SilentlyContinue" | Stop-Process -Force
    $job = Start-Job -ScriptBlock {
        Get-Process nginx | Stop-Process -Force
        Set-Location "C:\nginx\"
        ./nginx.exe
    }
}

function _nginx-createNewCluster {
    param (
        [SfProject]$firstNode,
        [SfProject]$secondNode
    )

    _nginx-initializeConfig

    $nlbTag = _nlbTags-create
    
    os-hosts-add -hostname (_nlbTags-getDomain $nlbTag)

    _nginx-createNlbClusterConfig $nlbTag $firstNode $secondNode
    
    # update project tags
    $firstNode.tags.Add($nlbTag)
    sd-project-save $firstNode
    $secondNode.tags.Add($nlbTag)
    sd-project-save $secondNode

    s-nginx-reset
}

function _nginx-createNlbClusterConfig {
    param (
        [string]$nlbTag,
        [SfProject]$firstNode,
        [SfProject]$secondNode
    )

    $nlbClusterId = _nlbTags-getClusterIdFromTag -tag $nlbTag
    if (!$nlbClusterId) {
        throw "Invalid cluster id."
    }

    $nlbDomain = _nlbTags-getDomain -tag $nlbTag

    [SiteBinding]$firstNodeBinding = _bindings-getOrCreateLocalhostBinding -project $firstNode
    [SiteBinding]$secondNodeBinding = _bindings-getOrCreateLocalhostBinding -project $secondNode

    $nlbPairConfig = "upstream $nlbClusterId {
    server localhost:$($firstNodeBinding.port);
    server localhost:$($secondNodeBinding.port);
}

server {
    listen 443 ssl;
    server_name $nlbDomain;
    proxy_set_header Host `$host;
    include sf-dev-ext/common.conf;
    location / {
        proxy_pass http://$nlbClusterId;
    }
}

server {
    listen 80;
    server_name $nlbDomain;
    proxy_set_header Host `$host;
    include sf-dev-ext/common.conf;
    location / {
        proxy_pass http://$nlbClusterId;
    }
}"

    $nlbPairConfigPath = "$(_get-toolsConfigDirPath)\$($nlbClusterId).config"
    $nlbPairConfig | _nginx-writeConfig -path $nlbPairConfigPath
}

function _nginx-escapePathForConfig {
    param (
        [string]$value
    )
    
    $value.Replace("\", "\\")
}

function _nginx-initializeConfig {
    $toolConfDirPath = _get-toolsConfigDirPath
    if (!(Test-Path $toolConfDirPath)) {
        Copy-Item "$PSScriptRoot\resources\*" (_getNginxConfigDirPath) -Recurse -Force
        Import-Certificate -FilePath "$PSScriptRoot\resources\sf-dev-ext\sfdev.crt" -CertStoreLocation "Cert:\LocalMachine\Root"
    }
}

function _nginx-writeConfig {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $content,
        $path
    )

    process {
        if (!(Test-Path $path)) {
            New-Item $path -ItemType File > $null
        }

        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines($path, $content, $Utf8NoBomEncoding) > $null
    }
}