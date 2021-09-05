$script:defaultProjectPropsToShow = @("id", "title", "branch")
 
$script:defaultProjectPropsToOrderBy = @("nlbId", "tags", "branch")

function sfe-project-remove {
    $p = sf-PSproject-get
    if (!$p) {
        throw "No project."
    }

    $result = Read-Host "Are you sure you want to remove the current project $($p.displayName)? y/n: ";
    if ($result -eq "y") {
        sf-PSproject-remove
    }
}

function sfe-project-select {
    param(
        [string[]]$tags,
        [object[]]$additionalProps,
        $orderProps,
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
        $props = $script:defaultProjectPropsToShow
        if ($additionalProps) {
            $props = $additionalProps + $props
        }
        if (!$orderProps) {
            $orderProps = $script:defaultProjectPropsToOrderBy
        }

        $props = _project-mapPropertiesFor -props $props -display
        $orderProps = _project-mapPropertiesFor -props $orderProps -sort
        
        $projects | sf-PSproject-select -tagsFilter $tags -propsToShow $props -propsToSort $orderProps
    }
}

Register-ArgumentCompleter -CommandName sfe-project-select -ParameterName tags -ScriptBlock $Global:SfTagFilterCompleter

function sfe-project-getAll {
    [OutputType([SfProject[]])]
    param (
        $tags
    )
    
    sf-PSproject-get -all | sf-PSproject-tags-filter -tags $tags
}

Register-ArgumentCompleter -CommandName sfe-project-getAll -ParameterName tags -ScriptBlock $Global:SfTagFilterCompleter

function sfe-project-formatTable {
    param (
        [string[]]$additionalProps,
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
        $props = $script:defaultProjectPropsToShow
        if ($additionalProps) {
            $props = $additionalProps + $props
        }
        $allProjects | ft -Property (_project-mapPropertiesFor $props -display) -Wrap
    }
}

New-Alias -Name pft -Value sfe-project-formatTable -Scope Global
