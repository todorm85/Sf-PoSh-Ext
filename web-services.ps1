function sfe-wcf-invoke {
    param(
        $body,
        $method = "POST"
    )

    # todo: check if not enabled already
    sfe-auth-basic
    $authHeaderVal = sfe-auth-basic-getHeaderValue -user "admin@test.test"
    $headers = @{
        "Pragma"="no-cache";
        "Cache-Control"="no-cache";
        "Accept"="*/*"; 
        "Authorization"=$authHeaderVal
    }
    
    $baseUrl = sf-iisSite-getUrl
    Invoke-WebRequest -Uri "$baseUrl/Sitefinity/Services/SiteSync/SiteSyncService.svc/StartSync/" -Method $method -Headers $headers -ContentType "application/json" -Body $body
}