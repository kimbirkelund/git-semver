task . Clean, Build, Tests, ExportHelp, GenerateGraph, Stats
task Tests ImportCompiledModule, Pester
task CreateManifest CopyPSD, UpdatePublicFunctionsToExport
task Build Compile, CreateManifest
task Stats RemoveStats, WriteStats

$script:ModuleName = Split-Path -Path $PSScriptRoot -Leaf
$script:ModuleRoot = "$PSScriptRoot\src\$script:ModuleName"
$script:OutPutFolder = "$PSScriptRoot\Output"
$script:ImportFolders = @("Public", "Internal") | ForEach-Object { Join-Path $script:ModuleRoot $_ };
$script:PsmPath = Join-Path -Path $script:OutPutFolder -ChildPath "$($script:ModuleName)\$($script:ModuleName).psm1"
$script:PsdPath = Join-Path -Path $script:OutPutFolder -ChildPath "$($script:ModuleName)\$($script:ModuleName).psd1"
$script:HelpPath = Join-Path -Path $script:OutPutFolder -ChildPath "$($script:ModuleName)\en-US"

$script:PublicFolder = $script:ImportFolders | Where-Object { $_.EndsWith("Public") } | Select-Object -First 1;
$script:DSCResourceFolder = 'DSCResources'


task "Clean" {
    if (-not(Test-Path $script:OutPutFolder))
    {
        New-Item -ItemType Directory -Path $script:OutPutFolder > $null
    }

    Remove-Item -Path "$($script:OutPutFolder)\*" -Force -Recurse
}

$compileParams = @{
    Inputs = {
        foreach ($folder in $script:ImportFolders)
        {
            Get-ChildItem -Path $folder -Recurse -File -Filter '*.ps1'
        }
    }

    Output = {
        $script:PsmPath
    }
}

task Compile @compileParams {
    if (Test-Path -Path $script:PsmPath)
    {
        Remove-Item -Path $script:PsmPath -Recurse -Force
    }
    New-Item -Path $script:PsmPath -Force > $null

    foreach ($folder in $script:ImportFolders)
    {
        Write-Verbose -Message "Checking folder [$folder]"

        if (Test-Path -Path $folder)
        {
            $files = Get-ChildItem -Path $folder -File -Filter '*.ps1'
            foreach ($file in $files)
            {
                Write-Verbose -Message "Adding $($file.FullName)"
                Get-Content -Path $file.FullName >> $script:PsmPath
            }
        }
    }
}

task CopyPSD {
    New-Item -Path (Split-Path $script:PsdPath) -ItemType Directory -ErrorAction 0
    $copy = @{
        Path        = Join-Path -Path $script:ModuleRoot -ChildPath "$($script:ModuleName).psd1"
        Destination = $script:PsdPath
        Force       = $true
        Verbose     = $true
    }
    Copy-Item @copy
}

task UpdatePublicFunctionsToExport -if (Test-Path -Path $script:PublicFolder) {
    $publicFunctions = (Get-ChildItem -Path $script:PublicFolder |
            Select-Object -ExpandProperty BaseName) -join "', '"

    $publicFunctions = "FunctionsToExport = @('{0}')" -f $publicFunctions

    (Get-Content -Path $script:PsdPath) -replace "FunctionsToExport = '\*'", $publicFunctions |
        Set-Content -Path $script:PsdPath
}



task ImportCompiledModule -if (Test-Path -Path $script:PsmPath) {
    Get-Module -Name $script:ModuleName |
        Remove-Module -Force
    Import-Module -Name $script:PsdPath -Force
}

task Pester {
    $resultFile = "{0}\testResults{1}.xml" -f $script:OutPutFolder, (Get-date -Format 'yyyyMMdd_hhmmss')
    $testFolder = Join-Path -Path $script:ModuleRoot -ChildPath 'Tests\*'
    Invoke-Pester -Path $testFolder -OutputFile $resultFile -OutputFormat NUnitxml
}

task GenerateGraph -if (Test-Path -Path 'Graphs') {
    $Graphs = Get-ChildItem -Path "Graphs\*"

    Foreach ($graph in $Graphs)
    {
        $graphLocation = [IO.Path]::Combine($script:OutPutFolder, $script:ModuleName, "$($graph.BaseName).png")
        . $graph.FullName -DestinationPath $graphLocation -Hide
    }
}


task RemoveStats -if (Test-Path -Path "$($script:OutPutFolder)\stats.json") {
    if (Test-Path "$($script:OutPutFolder)\stats.json")
    {
        Remove-Item -Force -Verbose -Path "$($script:OutPutFolder)\stats.json"
    }
}

task WriteStats {
    $folders = Get-ChildItem -Directory |
        Where-Object {$PSItem.Name -ne 'Output'}

    $stats = foreach ($folder in $folders)
    {
        $files = Get-ChildItem "$($folder.FullName)\*" -File
        if ($files)
        {
            Get-Content -Path $files |
                Measure-Object -Word -Line -Character |
                Select-Object -Property @{N = "FolderName"; E = {$folder.Name}}, Words, Lines, Characters
        }
    }
    $stats | ConvertTo-Json > "$script:OutPutFolder\stats.json"
}

task ExportHelp -if (Test-Path -Path "$script:ModuleRoot\Help") {
    New-ExternalHelp -Path "$script:ModuleRoot\Help" -OutputPath $script:HelpPath
}
