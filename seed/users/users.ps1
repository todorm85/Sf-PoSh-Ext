$Global:SfEvents_OnAfterProjectSet += {
    # sf-serverCode-deployDirectory "$PSScriptRoot\serverCode" "$($Global:sfe.appRelativeServerCodeRootPath)\users"
}

<#
.PARAMETER roles
Comma separated list of roles. (Administrators,Editors,Users,Authors,BackendUsers)
#>
function sfe-seedUsers {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $mail,
        [Parameter()]
        [ValidateSet("Administrators,BackendUsers","Editors,BackendUsers","Users","Authors,BackendUsers")]
        [string]
        $roles = "Users"
    )

   sf-serverCode-run "SitefinityWebApp.SfDev.Users" -methodName "Seed" -parameters @($mail, $roles) > $null
}
