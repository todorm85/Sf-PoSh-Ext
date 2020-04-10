function _s-app-setMachineKey {
    Param(
        $decryption = "AES",
        $decryptionKey = "53847BC18AFFC19E5C1AC792A4733216DAEB54215529A854",
        $validationKey = "DC38A2532B063784F23AEDBE821F733625AD1C05D4718D2E0D55D842DAC207FB8492043E2EE5861BB3C4B0C4742CF73BDA586A70BDDC4FD50209B465A6DBBB3D"
    )

    [SfProject]$project = sd-project-getCurrent
    if (!$project) {
        throw "You must select a project to work with first using sf-dev tool."
    }

    $webConfigPath = "$($project.webAppPath)/web.config"
    Set-ItemProperty $webConfigPath -name IsReadOnly -value $false

    [XML]$xmlDoc = Get-Content -Path $webConfigPath

    $systemWeb = $xmlDoc.Configuration["system.web"]
    $machineKey = $systemWeb.machineKey
    if (!$machineKey) {
        $machineKey = $xmlDoc.CreateElement("machineKey") 
        $systemWeb.AppendChild($machineKey) > $null
    }

    $machineKey.SetAttribute("decryption", $decryption)
    $machineKey.SetAttribute("decryptionKey", $decryptionKey)
    $machineKey.SetAttribute("validationKey", $validationKey)
    $xmlDoc.Save($webConfigPath) > $null
}

function s-nlb-add {
    # proj-setCurrent -newContext (data-getAllProjects -tagsFilter +a)[0]

    [SfProject]$project = sd-project-getCurrent
    if (!$project) {
        throw "You must select a project to work with first using dev tool."
    }

    # set machine key
   _s-app-setMachineKey

    # run services config
    $port = @(Get-WebBinding -Name $project.websiteName)[0].bindingInformation.split(':')[1]
    sf -start
    Invoke-WebRequest -Uri "http://localhost:$port/NlbSetup.svc/add/?port=$port"
    Invoke-WebRequest -Uri "http://localhost:$port/NlbSetup.svc/setSslOffload/?value=true"
    $nodePort = + $port + 1000
    Invoke-WebRequest -Uri "http://localhost:$port/NlbSetup.svc/add/?port=$nodePort"

    # detect if not already setup (another site pointing to same dir)
    $sites = @(Get-ChildItem -Path "IIS:\Sites" | ? physicalPath -eq $project.webAppPath)
    if ($sites.Count -eq 1) {
        $nodeName = "$($project.websiteName)_n2"
        New-WebAppPool -Name $nodeName
        New-Website -Name $nodeName -Port $nodePort -PhysicalPath $project.webAppPath -ApplicationPool $nodeName > $null
    }

    # add nginx config
    $balancerPort = + $port + 2000
}

function s-nlb-nginxReset {
    # Get-Process -Name "nginx" -ErrorAction "SilentlyContinue" | Stop-Process -Force
    Start-Job -ScriptBlock {
        Get-Process nginx | Stop-Process -Force
        Set-Location "C:\nginx\"
        ./nginx.exe
    }
}