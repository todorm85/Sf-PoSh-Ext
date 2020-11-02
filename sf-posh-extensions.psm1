$GLOBAL:sfe = [PSCustomObject]@{ }

# server code functionality
Add-Member -InputObject $GLOBAL:sfe -MemberType NoteProperty -Name appRelativeServerCodeRootPath -Value "App_Code\sf-posh-extensions"

$Global:SfEvents_OnAfterProjectSet += {
    $p = sf-project-get
    $oldDestinationRoot = "$($p.webAppPath)\App_Code\sf-dev-extensions"
    if ((Test-Path $oldDestinationRoot)) {
        Remove-Item $oldDestinationRoot -Force -Recurse
    }
}

$files = Get-ChildItem "$PSScriptRoot" -Filter "*.ps1" -Recurse
$files | % { . $_.FullName }
$functionNames = $files | Get-Content | % { $_.TrimStart() } | ? { $_.StartsWith("function") } |
    % {
        $_.Split(' ')[1]
    }

# $functionNames = $functionNames | ? { !$_.StartsWith("_") }

Export-ModuleMember -Function $functionNames
