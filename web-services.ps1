function s-wcf-invoke {
    param(
        $body,
        $method = "POST"
    )

    # todo: check if not enabled already
    s-settings-BasicAuthToggle
    $authHeaderVal = s-settings-getBasicAuthGetHeaderValue
    $headers = @{
        "Pragma"="no-cache";
        "Cache-Control"="no-cache";
        "Accept"="*/*"; 
        "Authorization"=$authHeaderVal
    }
    
    $baseUrl = sd-iisSite-getUrl
    Invoke-WebRequest -Uri "$baseUrl/Sitefinity/Services/SiteSync/SiteSyncService.svc/StartSync/" -Method $method -Headers $headers -ContentType "application/json" -Body $body
}