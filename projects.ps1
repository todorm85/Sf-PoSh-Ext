function sfe-project-set {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline = $true)]
        [SfProject]
        $project
    )
    
    process {
        sf-project-setCurrent -newContext $project
        $project
    }
}

function sfe-project-remove {
    $p = sf-project-getCurrent
    if (!$p) {
        throw "No project."
    }

    $result = Read-Host "Are you sure you want to remove the current project $($p.displayName)? y/n: ";
    if ($result -eq "y") {
        sf-project-remove
    }
}