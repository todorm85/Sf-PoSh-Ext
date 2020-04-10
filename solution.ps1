function s-openUiSolution {
    [SfProject]$p = sd-project-getCurrent
    . "$($p.solutionPath)\Telerik.Sitefinity.MS.TestUI.sln"
}

function s-buildAndStart {
    sd-sol-build -retryCount 3
    sd-app-waitForSitefinityToStart
}

function s-goto {
    Param(
        [switch]$configs,
        [switch]$logs,
        [switch]$root,
        [switch]$webConfig
    )

    $context = sd-project-getCurrent
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
