function seed-formsResponses {
    param(
        [int]$count = 50000,
        $domain = "sf2",
        $port = 57134,
        $tokenId = "5524d339-e2cf-424d-9eb9-5603b90446f3",
        $authCookie = "RymFG1cYcM482k3aciXbziBVZzqBRMUenH6IB3iacvQvMhFuFzFmDTadD01A_gZH2RGyuT3omw1t4h6KSIBzWYd_0MJw9jJo0kfAgXW57xXEg54AOZKpPgFnNpa_4VDPoVj5xkPAdBEx7qvNpn3E99sHu5xp-V0ERMz4g13nPPZ0wpb_i9g2Nv_FngSHRJDcoc5mGVCMLjUyydLziXzHOwkJGIojSqqUyaA08gKYwwX3BmFfp9LjLDhRusTiDtVix-pdNiPbls5_NCrYvYsWIVm2Z71lGMiXh-82j9YX_Oa6ddTZxhTBrrMyrHC201ihI00P22rm-4ECUKR5azf8-XGa4w4-Df2g4g4ScxKw7N-cMI3KApxGJ-JeVbII-Hjnq5lfYKxOgeIxMCsUEDU94Jtz7LgG8uvSzpr9C-csLkBtVYOjKuKLS4DAp7wCjjJtJYhQ8ifVUux90hGX9UrPpTK0OA9MXAdh-6KU5rcopD1oaZYyVHqHjzK-b7ePawxgqcvSsynlMC5WiQ1-RciDErQGsWlNtx3FH0FOvlwIo8BzE61H3wSDplAlnuDd7myBgVM96729snau_e7JCA6g5pxZhGuTkiWpobG4QBCO80dFLegelsMU0nRA8dEZU_ytSWMdEDtwoRd0MHMyboOGv6lpV89exWeHf24LuL6x-dA_hnO3D3eHuWPJcSTtShwSw1cL0gVJid5cwE5cfbdFw0MKXVP6PpUxPjnVMkBLircxLGHOBH51Wk2xgDyBbH47Lb00gSUjsyANfLI1JsAzEUtxyZROhnvC4IAnFCsMqN4JZ9RV2yrHNvxicpayaRJE3hKetkqNc2GNOhEcNNlw4hQrSVOT4BkpuveFSEwK1fPeMIMw6kMbdxEbc3v82iL9xClO0l1p5E9aCWlPaU10Nd0dLjMJbpbSNk8Ll4C4ld__3H0GIdfAaUBliQ4NNHhaNQDS0O3ez41xLpsl7ZkAjLi4afUC1jBzZJR37OCCjDpuAklMhlqUv0bteF14dZIyHN87oLKI3IvnVT__wvujisKwZse7eXQhwOt8Qi4-n7lbuD7nhXIVaqtWy37ECKy8QBDug4-oIXF8gsCYazip6PP5WWgHEaqCHd6ObxN72dDDcGuZZ-lse6zRF6Bpg3tB4DMPwb3euWwHajKdqwBvEIiAe365PLZQzbNOXkv44O95OhDMkIHBMbM18zOgjr5zd3nEWtwccd4axVdYp9s6KqWPwKdMEAB2baBhnBvvZ9MPWk9OP4GWCdnSeuwawT5a-kw9gRXtRwwt0pr2zvCq6PNfBcUzK0TK_l8f-IGFR_lNi3dzQEIbBdYClSgkyUU03LYG44M3s53KwFWWfRwPKnsKGn5OIkjljIoS4b2o8kpuARATmHsu4PVG3tqd8Zw1HWC_bCP52mzJDyvKn9m0WgzhYY6ywtIWE5OBbljIvxHnEpnQxRpIcYU0meQcY4HzzW50ON63yC_g5pI64zc5xFRSHdbnWFHNC-fmeGQqPi1yRoy5nDLNW0chQQQWUi9W2L-XSXTkNyw8mXrQrQVa-RXBlCacVR4rivFtmJnzyUS5Z2O8yPB3T-AvV0QWdFAgi1IK_mHZ1ozFloAgwUkHG0sePGpNOPdGoWk8EDNhpVVZ7rMz37_kqpRw7SaRpGnrMj4idT7931aDk-8ZsB5bVAKUFAap-YpE3tboRKXBibe3rR_BiMzICUbkyyGrl0woBOzojlyrRdipHmh88HV4cFIv4cUe3gSEKxSGENqE6RG1unCUD4Q5xQizZqAFzGiLKUf9mSmQhTJw6pLWdR-v51PhgAD-Y05sdpLUHglbT8PccKxSXZXLcecVkcqXUDvxMNhL1YbUsOxg0vF14Fg3_QtuWRs-WYrbBZePW1buVC9cilPwsRM-hSZ8PuORAOhCizYndvfAcwqfVYtYp2ayPs1_GSRV1jgn-bsuSpqiyqv4OGrWMqEvMhd_EFuhzfCcI5lILfYFbHJ8qOnFDe9Bsr7DFSFktg0kGns9cvcQo32NFxMbFk5Ej_SQhN_GbiVBvGm4vFcW03wA4TFLZBz6jB-1fBW_-39DzSiNSc27_dQGYLuzsq-_Q9F2NBnxu5cIgQnENZCNZLi1S-AQ38s03R1qNwkjpmI2qotz0C-SHCppG5nDGhu70kKp1EFyUECBBYj-oymS19udpXDa07HP0XH80EOUPnNcoRQfAUdCd8U"
    )

    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $cookie = New-Object System.Net.Cookie 
    $cookie.Name = "${port}SF-TokenId"
    $cookie.Value = $tokenId
    $cookie.Domain = $domain
    $session.Cookies.Add($cookie);
    $cookie = New-Object System.Net.Cookie 
    $cookie.Name = "${port}.AspNet.Cookies"
    $cookie.Value = $authCookie
    $cookie.Domain = $domain

    $session.Cookies.Add($cookie);

    for ($i = 1; $i -le $count; $i++) {
        # cookies part of headers collection are not sent
        $res = Invoke-WebRequest -Uri "http://${domain}:${port}/Sitefinity/Services/Forms/FormsService.svc/entry/sf_testform/00000000-0000-0000-0000-000000000000/?itemType=Telerik.Sitefinity.DynamicTypes.Model.sf_testform" `
            -Method "PUT" `
            -Headers @{
            "Pragma"           = "no-cache"
            "Cache-Control"    = "no-cache"
            "User-Agent"       = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36"
            "X-Requested-With" = "XMLHttpRequest"
            "Accept"           = "*/*"
            "Origin"           = "http://${domain}:${port}"
            "Referer"          = "http://${domain}:${port}/Sitefinity/Dialog/FormEntryEditDialog?formName=sf_testform&viewName=create&provider=OpenAccessDataProvider"
            "Accept-Encoding"  = "gzip, deflate"
            "Accept-Language"  = "en-GB,en-US;q=0.9,en;q=0.8"
        } `
            -WebSession $session `
            -ErrorAction 'SilentlyContinue' `
            -ContentType "application/json" `
            -Body "{`"Item`":{`"DateCreated`":`"\/Date($(1627997901282 + $i))\/`",`"Description`":{`"PersistedValue`":`"`",`"Value`":`"`"},`"ExpirationDate`":null,`"IpAddress`":null,`"Language`":null,`"Owner`":`"62706d55-a6bc-4f71-ad83-51b64f219dea`",`"PublicationDate`":`"\/Date($(1627997901282 + $i))\/`",`"ReferralCode`":null,`"SourceSiteDisplayName`":`"Default`",`"SourceSiteId`":`"0a590289-147c-496b-96d4-1c21c0ad32b1`",`"SourceSiteName`":`"Default`",`"Status`":2,`"SubmittedOn`":`"\/Date($(1627997901282 + $i))\/`",`"Title`":{`"PersistedValue`":`"`",`"Value`":`"`"},`"Username`":`"`",`"Visible`":false,`"TextFieldController`":`"test_response_$i`",`"LastModified`":`"\/Date($(1627997913523 + $i))\/`"}}";
        $code = $res.StatusCode
        if ($code -ne 200) { 
            Write-Host "$code Failed" -ForegroundColor Red
        }
        $complete = ($i / $count) * 100;
        Write-Progress -Activity "Creation in Progress" -Status "$complete% Complete:" -PercentComplete $complete 
    }
}