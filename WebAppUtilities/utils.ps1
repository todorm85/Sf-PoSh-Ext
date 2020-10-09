$script:deploymentPaths = @(
    @{
        appRelativePath  = "sf-dev-extensions\pages"
        toolPath = "$PSScriptRoot\aspx"
    },
    @{
        appRelativePath  = "App_Code\sf-dev-extensions"
        toolPath = "$PSScriptRoot\csharp"
    }
)

function sfe-utils-deploy {
    param([switch]$toTool)
    [SfProject]$p = sf-project-get
    if (!$p) {
        throw "No project selected."
    }

    $webAppPath = $p.webAppPath
    $script:deploymentPaths | % {
        $dest = "$webAppPath\$($_.appRelativePath)"
        $src = $_.toolPath
        if ($toTool) {
            $src = "$webAppPath\$($_.appRelativePath)"
            $dest = $_.toolPath
        }

        if (!(Test-Path -Path $src)) {
            Write-Warning "Source path $src does not exist. Skipping update."
            return
        }

        if (!(Test-Path $dest)) {
            New-Item -Path $dest -ItemType Directory > $null
        }

        Remove-Item "$dest\*" -Recurse -Force
        Copy-Item -Path "$src\*" -Destination $dest -Recurse -ErrorAction Ignore
    }
}

function _s-execute-utilsRequest ([string]$typeName, [string]$methodName, [string[]]$parameters) {
    sf-serverCode-run "SitefinityWebApp.SfDev.$typeName" $methodName $parameters
}

function sfe-utils-open {
    param(
        [switch]$openInSameBrowser,
        $page = "uitest"
    )

    $url = sf-iisSite-getUrl
    $pagePath = "$url/sf-dev-extensions/pages/$page.aspx"

    os-browseUrl -url $pagePath -openInSameWindow:$openInSameBrowser
}
