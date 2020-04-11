$script:deploymentPaths = @(
    @{
        appRelativePath  = "sf-dev-extensions\pages"
        toolPath = "$PSScriptRoot\aspx"
    },
    @{
        appRelativePath  = "App_Code\sf-dev-extensions"
        toolPath = "$PSScriptRoot\csharp"
    },
    @{
        appRelativePath  = "sf-dev-extensions\services"
        toolPath = "$PSScriptRoot\svc"
    }
)

function s-utils-deploy {
    param([switch]$toTool)
    [SfProject]$p = sd-project-getCurrent
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
    $parametersString = ""
    $parameters | %{ $parametersString += ";$_" }
    $parametersString = $parametersString.TrimStart(';')

    $encodedType = [System.Web.HttpUtility]::UrlEncode("SitefinityWebApp.$typeName")
    $encodedParams = [System.Web.HttpUtility]::UrlEncode($parametersString)
    $encodedMethod = [System.Web.HttpUtility]::UrlEncode($methodName)
    $serviceRequestPath = "CodeRunner.svc/CallMethod?methodName=$encodedMethod&typeName=$encodedType&params=$encodedParams"

    sf -start
    
    $baseUrl = sd-iisSite-getUrl
    $response = Invoke-WebRequest -Uri "$baseUrl/sf-dev-extensions/services/$serviceRequestPath"
    if ($response.StatusCode -ne 200) {
        Write-Error "Response status code was not 200 OK."
    }
    else {
        Write-Information "Operation complete!"
    }

    if ($response.Content) {
        return $response.Content | ConvertFrom-Json
    }
    else {
        return $response
    }
}

function s-utils-open {
    param(
        [switch]$openInSameBrowser,
        $page = "uitest"
    )

    $url = sd-iisSite-getUrl
    $pagePath = "$url/sf-dev-pages/$page.aspx"

    _s-utils-openBrowser $pagePath -openInSameWindow:$openInSameBrowser
}

function _s-utils-openBrowser {
    param (
        [string]$url,
        [switch]$openInSameWindow
    )

    $browser = $GLOBAL:sf.config.browserPath
    if (!$openInSameBrowser) {
        Start-Process $browser
        Start-Sleep 1
    }
    
    & "$browser" $url -noframemerging
}