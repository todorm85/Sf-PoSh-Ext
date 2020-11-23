$sfFormatTableProperties = @(
    @{Label = "Title"; Expression = {
            if ($showFullName -or $_.displayName.length -lt 20) {
                $name = $_.displayName
            } 
            else {
                $name = $_.displayName.Substring(0, 20) 
            }

            $name
        } 
    },
    "id",
    @{Label = "branch"; Expression = {
            if (!$_.branch) { return }
            "$($_.branchDisplayName) ($($_.daysOld))" 
        } 
    },
    @{Label = "ver"; Expression = { 
            "$(sfe-project-getVersion $_)$(if ($_.solutionPath) { 's' })"
        } 
    },
    @{Label = "tags"; Expression = {
            $res = ""
            $_.tags | sort | % { $res = "$res, $_" }
            $res.TrimStart(',').TrimStart(' ')
        } 
    },
    "nlbId"
)

Add-Member -InputObject $Global:sfe -MemberType NoteProperty -Value $sfFormatTableProperties -Name formatTableProperties
    
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

    sf-project-select -tagsFilter $tags -propsToShow $Global:sfe.formatTableProperties
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
        $allProjects | Sort -Property tags, branch | ft -Property $Global:sfe.formatTableProperties
    }
}

New-Alias -Name pft -Value sfe-project-formatTable -Scope Global

function sfe-project-getVersion {
    param(
        [Parameter(Mandatory = $true)]
        [SfProject]
        $p
    )

    # try get from dll
    $dllPath = "$($p.webAppPath)\bin\Telerik.Sitefinity.dll"
    if (Test-Path $dllPath) {
        $version = (Get-Item $dllPath | Select-Object -ExpandProperty VersionInfo).ProductVersion
    }
                
    # try get from shared assembly
    $assemblyFilePath = "$($p.webAppPath)\..\AssemblyInfoShare\SharedAssemblyInfo.cs"
    if (Test-Path $assemblyFilePath) {
        $versionRaw = Get-Content -Path $assemblyFilePath | ? { $_.StartsWith("[assembly: AssemblyVersion(") }
        $version = $versionRaw.Split('"')[1]
    }

    if ($version) {
        # $version.TrimEnd('0').TrimEnd('.')
        $versionPart = $version.Split('.')
        "$($versionPart[0]).$($versionPart[1])"
    }
}