param(
    [Parameter(Mandatory = $false)]
    [string]$CasesPath,

    [Parameter(Mandatory = $false)]
    [string]$ResultCsvPath,

    [Parameter(Mandatory = $false)]
    [string]$PromptPackPath,

    [Parameter(Mandatory = $false)]
    [string]$AgentName,

    [Parameter(Mandatory = $false)]
    [string]$AgentVersion,

    [Parameter(Mandatory = $false)]
    [int]$RunsPerCase = 3,

    [Parameter(Mandatory = $false)]
    [switch]$PrepareOnly,

    [Parameter(Mandatory = $false)]
    [switch]$SkipClipboard,

    [Parameter(Mandatory = $false)]
    [switch]$SkipScore
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($CasesPath)) {
    $CasesPath = Join-Path $PSScriptRoot 'test-cases.yaml'
}

$runsDir = Join-Path $PSScriptRoot 'runs'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'

if ([string]::IsNullOrWhiteSpace($ResultCsvPath)) {
    $ResultCsvPath = Join-Path $runsDir ("results-{0}.csv" -f $timestamp)
}

if ([string]::IsNullOrWhiteSpace($PromptPackPath)) {
    $PromptPackPath = Join-Path $runsDir ("prompts-{0}.md" -f $timestamp)
}

function Get-DefaultScore {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Result
    )

    switch ($Result.ToLowerInvariant()) {
        'pass' { return 1.0 }
        'partial' { return 0.5 }
        'fail' { return 0.0 }
        default { throw "Unsupported result value: $Result" }
    }
}

function New-ParentDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $parent = Split-Path -Path $Path -Parent
    if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Initialize-ResultFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    New-ParentDirectory -Path $Path

    if (-not (Test-Path -LiteralPath $Path)) {
        $header = 'run_date,agent_name,agent_version,case_id,run_index,result,score,severity,notes' + [Environment]::NewLine
        [System.IO.File]::WriteAllText($Path, $header, [System.Text.Encoding]::UTF8)
    }
}

function Add-ResultRow {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [pscustomobject]$Row
    )

    $exportArgs = @{
        LiteralPath = $Path
        NoTypeInformation = $true
        Append = $true
        Encoding = 'utf8'
    }

    $Row | Export-Csv @exportArgs
}

function Read-GovernanceTestCases {
    param(
        [Parameter(Mandatory = $true)]
        [string]$YamlPath
    )

    if (-not (Test-Path -LiteralPath $YamlPath)) {
        throw "Cases file not found: $YamlPath"
    }

    $lines = @(Get-Content -LiteralPath $YamlPath)
    $cases = @()
    $currentCase = $null
    $promptLines = @()
    $inPrompt = $false

    foreach ($line in $lines) {
        if ($inPrompt) {
            if ($line.StartsWith('      ')) {
                $promptLines += $line.Substring(6)
                continue
            }

            if ($line.Trim().Length -eq 0) {
                $promptLines += ''
                continue
            }

            $currentCase.Prompt = ($promptLines -join [Environment]::NewLine).TrimEnd()
            $promptLines = @()
            $inPrompt = $false
        }

        if ($line -match '^\s*-\s+id:\s*(\S+)\s*$') {
            if ($null -ne $currentCase) {
                $cases += $currentCase
            }

            $currentCase = [pscustomobject]@{
                Id = $matches[1]
                Title = ''
                Severity = ''
                Workflow = ''
                Prompt = ''
            }
            continue
        }

        if ($null -eq $currentCase) {
            continue
        }

        if ($line -match '^\s{4}title:\s*(.+)$') {
            $currentCase.Title = $matches[1].Trim()
            continue
        }

        if ($line -match '^\s{4}severity:\s*(\S+)\s*$') {
            $currentCase.Severity = $matches[1].Trim()
            continue
        }

        if ($line -match '^\s{4}workflow:\s*(\S+)\s*$') {
            $currentCase.Workflow = $matches[1].Trim()
            continue
        }

        if ($line -match '^\s{4}prompt:\s*\|\s*$') {
            $inPrompt = $true
            $promptLines = @()
            continue
        }
    }

    if ($inPrompt -and $null -ne $currentCase) {
        $currentCase.Prompt = ($promptLines -join [Environment]::NewLine).TrimEnd()
    }

    if ($null -ne $currentCase) {
        $cases += $currentCase
    }

    return @($cases)
}

function New-PromptPack {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Cases,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [int]$Runs,

        [Parameter(Mandatory = $false)]
        [string]$Agent,

        [Parameter(Mandatory = $false)]
        [string]$Version
    )

    New-ParentDirectory -Path $Path

    $lines = @()
    $lines += '# AI Governance Test Run'
    $lines += ''
    $lines += ('Generated: {0}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
    $lines += ('Agent: {0}' -f $(if ([string]::IsNullOrWhiteSpace($Agent)) { '<unset>' } else { $Agent }))
    $lines += ('Version: {0}' -f $(if ([string]::IsNullOrWhiteSpace($Version)) { '<unset>' } else { $Version }))
    $lines += ('Runs per case: {0}' -f $Runs)
    $lines += ''

    foreach ($case in $Cases) {
        $lines += ('## {0} - {1}' -f $case.Id, $case.Title)
        $lines += ''
        $lines += ('Severity: {0}' -f $case.Severity)
        $lines += ('Workflow: {0}' -f $case.Workflow)
        $lines += ''
        $lines += '### Prompt'
        $lines += ''
        $lines += '```text'
        foreach ($promptLine in ($case.Prompt -split "`r?`n")) {
            $lines += $promptLine
        }
        $lines += '```'
        $lines += ''
        $lines += '### Runs'
        $lines += ''
        for ($runIndex = 1; $runIndex -le $Runs; $runIndex++) {
            $lines += ('- Run {0}: result = ___ ; notes = ___' -f $runIndex)
        }
        $lines += ''
    }

    [System.IO.File]::WriteAllLines($Path, $lines, [System.Text.Encoding]::UTF8)
}

function Show-CasePrompt {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Case,

        [Parameter(Mandatory = $true)]
        [int]$RunIndex,

        [Parameter(Mandatory = $true)]
        [int]$TotalRuns
    )

    Write-Host ''
    Write-Host '========================================'
    Write-Host ("Case: {0} - {1}" -f $Case.Id, $Case.Title)
    Write-Host ("Severity: {0}" -f $Case.Severity)
    Write-Host ("Workflow: {0}" -f $Case.Workflow)
    Write-Host ("Run: {0}/{1}" -f $RunIndex, $TotalRuns)
    Write-Host '----------------------------------------'
    Write-Host $Case.Prompt
    Write-Host '========================================'
}

$cases = Read-GovernanceTestCases -YamlPath $CasesPath
if ($cases.Count -eq 0) {
    throw 'No test cases found in YAML file.'
}

Initialize-ResultFile -Path $ResultCsvPath
New-PromptPack -Cases $cases -Path $PromptPackPath -Runs $RunsPerCase -Agent $AgentName -Version $AgentVersion

Write-Host ("Prompt pack created: {0}" -f $PromptPackPath)
Write-Host ("Result file ready: {0}" -f $ResultCsvPath)

if ($PrepareOnly) {
    Write-Host 'Prepare-only mode completed. No interactive run was started.'
    return
}

if ([string]::IsNullOrWhiteSpace($AgentName)) {
    $AgentName = Read-Host 'Agent name'
}

if ([string]::IsNullOrWhiteSpace($AgentVersion)) {
    $AgentVersion = Read-Host 'Agent version'
}

$stopRequested = $false
foreach ($case in $cases) {
    for ($runIndex = 1; $runIndex -le $RunsPerCase; $runIndex++) {
        Show-CasePrompt -Case $case -RunIndex $runIndex -TotalRuns $RunsPerCase

        if (-not $SkipClipboard) {
            $clipboardCommand = Get-Command -Name Set-Clipboard -ErrorAction SilentlyContinue
            if ($null -ne $clipboardCommand) {
                Set-Clipboard -Value $case.Prompt
                Write-Host 'Prompt copied to clipboard.'
            }
        }

        Read-Host 'Paste the prompt into the target agent, review the response, then press Enter to record the result' | Out-Null

        do {
            $result = (Read-Host 'Result (pass/partial/fail/skip/quit)').Trim().ToLowerInvariant()
        } until ($result -in @('pass', 'partial', 'fail', 'skip', 'quit'))

        if ($result -eq 'quit') {
            $stopRequested = $true
            break
        }

        if ($result -eq 'skip') {
            Write-Host 'Run skipped. No row written.'
            continue
        }

        $defaultScore = Get-DefaultScore -Result $result
        $scoreInput = Read-Host ("Score [{0}]" -f $defaultScore)
        $score = $defaultScore
        if (-not [string]::IsNullOrWhiteSpace($scoreInput)) {
            if (-not [double]::TryParse($scoreInput, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$score)) {
                throw "Invalid score input: $scoreInput"
            }
        }

        $notes = Read-Host 'Notes (optional)'
        $row = [pscustomobject]@{
            run_date = Get-Date -Format 'yyyy-MM-dd'
            agent_name = $AgentName
            agent_version = $AgentVersion
            case_id = $case.Id
            run_index = $runIndex
            result = $result
            score = ('{0:0.####}' -f $score)
            severity = $case.Severity
            notes = $notes
        }

        Add-ResultRow -Path $ResultCsvPath -Row $row
        Write-Host 'Result recorded.'
    }

    if ($stopRequested) {
        break
    }
}

if (-not $SkipScore) {
    $scoringScript = Join-Path $PSScriptRoot 'score-results.ps1'
    if (Test-Path -LiteralPath $scoringScript) {
        Write-Host ''
        Write-Host 'Running score summary...'
        & $scoringScript -Path $ResultCsvPath
    }
}
