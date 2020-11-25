$script:defaultProjectPropsToShow = @("title", "id", "branch", "version", "tags", "nlbId")
 
$script:defaultProjectPropsToOrderBy = @("nlbId", "tags", "branch")

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
        $props,
        $orderProps,
        [switch]$showFullName,
        [Parameter(ValueFromPipeline)]
        [SfProject]
        $project
    )

    begin {
        $projects = @()
    }

    process {
        $projects += $project
    }

    end {
        if (!$props) {
            $props = $script:defaultProjectPropsToShow
        }

        if (!$orderProps) {
            $orderProps = $script:defaultProjectPropsToOrderBy
        }

        $props = sfe-project-mapPropertiesFor -props $props -display
        $orderProps = sfe-project-mapPropertiesFor -props $orderProps -sort
        
        $projects | sf-project-select -tagsFilter $tags -propsToShow $props -propsToSort $orderProps
    }
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
        $allProjects | ft -Property (sfe-project-mapPropertiesFor $script:defaultProjectPropsToShow -display)
    }
}

New-Alias -Name pft -Value sfe-project-formatTable -Scope Global
