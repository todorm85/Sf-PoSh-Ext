function sfe-openUiSolution {
    [SfProject]$p = sf-project-getCurrent
    . "$($p.solutionPath)\Telerik.Sitefinity.MS.TestUI.sln"
}

function sfe-buildAndStart {
    sf-sol-build -retryCount 3
    sf-app-waitForSitefinityToStart
}

function sfe-goto {
    Param(
        [switch]$configs,
        [switch]$logs,
        [switch]$root,
        [switch]$webConfig
    )

    $context = sf-project-getCurrent
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
