$Script:projectPropertiesFormatMapping = @(
    @{  
        Name       = "title";
        Expression = {
            if ($showFullName -or $_.displayName.length -lt 20) {
                $name = $_.displayName
            } 
            else {
                $name = $_.displayName.Substring(0, 20) 
            }

            $name
        } 
    },
    @{
        Name       = "branch";
        Expression = {
            if (!$_.branch) { return }
            "$($_.branchDisplayName) ($($_.daysOld))" 
        } 
    },
    @{
        Name       = "version";
        Label      = "ver";
        Expression = {
            if ($_.version) {
                $versionPart = $_.version.Split('.')
                $version = "$($versionPart[0]).$($versionPart[1]).$($versionPart[2])"
                "$version$(if ($_.solutionPath) { 's' })"
            }
        }
    },
    @{
        Name       = "tags";
        Expression = {
            $res = ""
            $_.tags | sort | % { $res = "$res, $_" }
            $res.TrimStart(',').TrimStart(' ')
        } 
    }
)

function sfe-project-mapPropertiesFor {
    param (
        [string[]]$props,
        [switch]$display,
        [switch]$sort
    )

    if ($display) {
        _mapProperties $props {
            param($mp)
            @{
                Expression = $mp.Expression
                Label      = if ($mp.Label) { $mp.Label } else { $mp.Name }
            }
        }
    }
    
    if ($sort) {
        _mapProperties $props {
            param($mp)
            @{
                Expression = $mp.Expression
            }
        }
    }
}

function _mapProperties {
    param(
        [string[]]$props,
        [ScriptBlock]$mappingScript
    )

    foreach ($p in $props) {
        $mp = $Script:projectPropertiesFormatMapping | ? Name -eq $p
        if ($mp) {
            & $mappingScript $mp
        }
        else {
            $p
        }
    }
}
