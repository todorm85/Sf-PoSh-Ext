function sfe-wcf-invoke {
    param(
        $body,
        $method = "POST"
    )

    # todo: check if not enabled already
    sfe-settings-BasicAuthToggle
    $authHeaderVal = sfe-settings-getBasicAuthGetHeaderValue
    $headers = @{
        "Pragma"="no-cache";
        "Cache-Control"="no-cache";
        "Accept"="*/*"; 
        "Authorization"=$authHeaderVal
    }
    
    $baseUrl = sf-iisSite-getUrl
    Invoke-WebRequest -Uri "$baseUrl/Sitefinity/Services/SiteSync/SiteSyncService.svc/StartSync/" -Method $method -Headers $headers -ContentType "application/json" -Body $body
}