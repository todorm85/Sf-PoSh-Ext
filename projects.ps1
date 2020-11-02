$Global:sfFormatTableProperties = @(
    @{Label = "Title"; Expression = { if ($showFullName -or $_.displayName.length -lt 30) { $_.displayName } else { $_.displayName.Substring(0, 30) } } },
    "id",
    @{Label = "branch"; Expression = { $_.branchDisplayName } },
    @{Label = "days"; Expression = { $_.daysOld } },
    @{Label = "tags"; Expression = { $_.tags | sort } },
    "nlbId"
)
    
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

    sf-project-select -tagsFilter $tags -propsToShow $Global:sfFormatTableProperties
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

function sfe-project-formatTable {
    param (
        [Parameter(ValueFromPipeline)]
        [SfProject]
        $project
    )

    begin {
        $allProjects = @()
    }

    process {
        $allProjects += $project
    }

    end {
        $allProjects | Sort -Property tags, branch | ft -Property $Global:sfFormatTableProperties
    }
}

New-Alias -Name pft -Value sfe-project-formatTable -Scope Global

function sfe-project-setFree {
    param(
        [Parameter(ValueFromPipeline)]
        [SfProject]
        $project
    )

    process {
        Run-InFunctionAcceptingProjectFromPipeline {
            sf-project-rename -newName free
            sf-tags-remove -all
            if (sf-sourceControl-hasPendingChanges) {
                sf-sourceControl-undoPendingChanges
            }
        }
    }
}

New-Alias -Name psf -Value sfe-project-setFree -Scope Global

Remove-Item -Path "Alias:\psf" -Force
New-Alias -Name psf -Value sfe-project-setFree -Scope Global
