function s-domain-add {
    Param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $domain,
        [int]
        $port
    )

    [SfProject]$project = sd-project-getCurrent
    if (!$port) {
        $port = sd-getFreePort
    }

    New-WebBinding -Name $project.websiteName -IPAddress "*" -Port $port -HostHeader $domain
}

function s-domain-get {
    [SfProject]$p = sd-project-getCurrent
    $s = $p.websiteName
    Get-WebBinding -Name $s    
}

function s-domain-remove {
    Param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $domain,
        [Parameter(Mandatory = $true)]
        [int]
        $port
    )

    [SfProject]$project = sd-project-getCurrent
    Remove-WebBinding -Name $project.websiteName -HostHeader $domain -Port $port
}