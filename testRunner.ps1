function s-startWebTestRunner {
    [SfProject]$p = sd-project-getCurrent
    if ($p) {
        $testRunnerPath = "D:\IntegrationTestsRunner"
        $testRunnerConfigPath = "$testRunnerPath\Telerik.WebTestRunner.Client.exe.Config"
        $allLines = Get-Content -Path $testRunnerConfigPath
        $newLines = $allLines | % {
            if ($_.Contains("TMITSKOV")) {
                return "<machine name=""TMITSKOV"" testingInstanceUrl=""$(sd-iisSite-getUrl)"" />"
            } else {
                return $_
            }
        } 

        Remove-Item -Path $testRunnerConfigPath -Force
        $newLines | Out-File -FilePath $testRunnerConfigPath -Append -Encoding utf8
    }

    & "$testRunnerPath\Telerik.WebTestRunner.Client.exe"
}
