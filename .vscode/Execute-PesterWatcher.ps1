[CmdletBinding()]
PARAM()

Write-Host "Watching Project $PWD";

Remove-Guard;

New-Guard `
    -Path "$PWD" `
    -PathFilter "*.ps1" `
    -MonitorSubdirectories `
    -TestCommand { Write-Host "Invoking Watch.Project"; Invoke-Build; Write-Host } `
    -Wait;

