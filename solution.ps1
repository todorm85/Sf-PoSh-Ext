function sfe-goto {
    Param(
        [switch]$configs,
        [switch]$logs,
        [switch]$root,
        [switch]$webConfig
    )

    $context = sf-project-get
    $webAppPath = $context.webAppPath

    if ($configs) {
        Set-Location "${webAppPath}\App_Data\Sitefinity\Configuration"
        Get-ChildItem
    }
    elseif ($logs) {
        Set-Location "${webAppPath}\App_Data\Sitefinity\Logs"
        Get-ChildItem
    }
    elseif ($root) {
        Set-Location "${webAppPath}"
        Get-ChildItem
    }
    elseif ($webConfig) {
        & "${webAppPath}\Web.config"
    }
}
