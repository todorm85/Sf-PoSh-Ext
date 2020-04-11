$files = Get-ChildItem "$PSScriptRoot" -Filter "*.ps1" -Recurse
$files | % { . $_.FullName }
$functionNames = $files | Get-Content | % { $_.TrimStart() } | ? { $_.StartsWith("function") } |
    % {
        $_.Split(' ')[1]
    }

# $functionNames = $functionNames | ? { !$_.StartsWith("_") }

$Script:registeredServices = @()
if (!$Global:SfEvents_OnAfterProjectSelected) {$Global:SfEvents_OnAfterProjectSelected = @()}
$Global:SfEvents_OnAfterProjectSelected += {
    # s-utils-deploy # should be on after initialized
}

Export-ModuleMember -Function $functionNames