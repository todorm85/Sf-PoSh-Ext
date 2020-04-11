function _bindings-getOrCreateLocalhostBinding ($project) {
    $previous = sd-project-getCurrent
    try {
        $firstNodeBinding = _bindings-getLocalhostBinding $project.websiteName
        if (!$firstNodeBinding) {
            $freePort = sd-getFreePort
            sd-project-setCurrent $project
            s-domain-add -domain "" -port $freePort
            $firstNodeBinding = _bindings-getLocalhostBinding $project.websiteName
        }

        $firstNodeBinding
    }
    finally {
        sd-project-setCurrent $previous
    }
}

function _bindings-getLocalhostBinding ($websiteName) {
    iis-bindings-getAll -siteName $websiteName | ? domain -like "" | select -First 1
}

function _bindings-getLocalhostUrl ($websiteName) {
    [SiteBinding]$b = _bindings-getLocalhostBinding $websiteName
    "$($b.protocol)://localhost:$($b.port)"
}
