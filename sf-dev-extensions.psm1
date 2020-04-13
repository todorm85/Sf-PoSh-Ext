$files = Get-ChildItem "$PSScriptRoot" -Filter "*.ps1" -Recurse
$files | % { . $_.FullName }
$functionNames = $files | Get-Content | % { $_.TrimStart() } | ? { $_.StartsWith("function") } |
    % {
        $_.Split(' ')[1]
    }

# $functionNames = $functionNames | ? { !$_.StartsWith("_") }

$Global:SfEvents_OnAfterProjectSelected += {
    # sfe-utils-deploy # should be on after initialized
}

Export-ModuleMember -Function $functionNames