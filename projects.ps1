function sfe-project-remove {
    $p = sf-project-get
    if (!$p) {
        throw "No project."
    }

    $result = Read-Host "Are you sure you want to remove the current project $($p.displayName)? y/n: ";
    if ($result -eq "y") {
        sf-project-remove
    }
}

function sfe-project-select {
    param(
        [string[]]$tags,
        [switch]$showFullName
    )

    $props = @(
        @{Label = "Title"; Expression = { if ($showFullName -or $_.displayName.length -lt 30) { $_.displayName } else { $_.displayName.Substring(0, 30) } } },
        "id",
        @{Label = "branch"; Expression = { $_.branchDisplayName } },
        @{Label = "days"; Expression = { $_.daysOld } },
        @{Label = "tags"; Expression = { $_.tags | sort } },
        "nlbId"
    )

    sf-project-select -tagsFilter $tags -propsToShow $props
}

Register-ArgumentCompleter -CommandName sfe-project-select -ParameterName tags -ScriptBlock $Global:SfTagFilterCompleter

function sfe-project-getAll {
    [OutputType([SfProject[]])]
    param (
        $tags
    )
    
    sf-project-get -all | sf-tags-filter -tags $tags
}

Register-ArgumentCompleter -CommandName sfe-project-getAll -ParameterName tags -ScriptBlock $Global:SfTagFilterCompleter
