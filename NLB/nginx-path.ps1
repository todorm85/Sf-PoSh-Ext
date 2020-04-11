$script:pathToNginxConfig = "C:\nginx\conf\nginx.conf"

function _get-toolsConfigDirPath {
    $nginxConfigsDirPath = _getNginxConfigDirPath
    "$nginxConfigsDirPath\sf-dev-ext"
}

function _getNginxConfigDirPath {
    (Get-Item $script:pathToNginxConfig).Directory.FullName
}
