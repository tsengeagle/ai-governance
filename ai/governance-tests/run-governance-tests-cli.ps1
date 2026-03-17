param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('copilot', 'gemini')]
    [string]$Provider,

    [Parameter(Mandatory = $false)]
    [string]$ProviderModel,

    [Parameter(Mandatory = $false)]
    [string]$CasesPath,

    [Alias('TargetRepo')]
    [Parameter(Mandatory = $false)]
    [string]$WorkspaceRoot,

    [Parameter(Mandatory = $false)]
    [string]$ExecutionLogPath,

    [Parameter(Mandatory = $false)]
    [string]$ReviewTemplatePath,

    [Parameter(Mandatory = $false)]
    [string]$ResponseDir,

    [Parameter(Mandatory = $false)]
    [string[]]$CaseIds,

    [Parameter(Mandatory = $false)]
    [int]$RunsPerCase = 3,

    [Parameter(Mandatory = $false)]
    [int]$TimeoutSec = 600,

    [Parameter(Mandatory = $false)]
    [switch]$NoSandbox,

    [Parameter(Mandatory = $false)]
    [switch]$AutoReview
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$scriptDir = $PSScriptRoot
$runsDir = Join-Path $scriptDir 'runs'
$defaultRunDir = Join-Path $runsDir ("{0}-{1}" -f $Provider, $timestamp)

if ([string]::IsNullOrWhiteSpace($CasesPath)) {
    $CasesPath = Join-Path $scriptDir 'test-cases.yaml'
}

if ([string]::IsNullOrWhiteSpace($WorkspaceRoot)) {
    $WorkspaceRoot = Split-Path (Split-Path $scriptDir -Parent) -Parent
}

if ([string]::IsNullOrWhiteSpace($ExecutionLogPath)) {
    $ExecutionLogPath = Join-Path $defaultRunDir 'execution-log.csv'
}

if ([string]::IsNullOrWhiteSpace($ReviewTemplatePath)) {
    $ReviewTemplatePath = Join-Path $defaultRunDir 'review-template.csv'
}

if ([string]::IsNullOrWhiteSpace($ResponseDir)) {
    $ResponseDir = Join-Path $defaultRunDir 'responses'
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

function Initialize-CsvFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string[]]$Headers
    )

    New-ParentDirectory -Path $Path
    if (-not (Test-Path -LiteralPath $Path)) {
        $content = ($Headers -join ',') + [Environment]::NewLine
        [System.IO.File]::WriteAllText($Path, $content, [System.Text.Encoding]::UTF8)
    }
}

function Add-CsvRow {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [pscustomobject]$Row
    )

    $Row | Export-Csv -LiteralPath $Path -NoTypeInformation -Append -Encoding utf8
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

function Resolve-ProviderCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProviderName
    )

    $command = Get-Command -Name $ProviderName -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        throw "Provider CLI not found on PATH: $ProviderName"
    }

    return $command.Source
}

function Get-ProviderCliVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProviderName
    )

    try {
        $versionOutput = & $ProviderName --version 2>$null
        return (($versionOutput | Out-String).Trim())
    } catch {
        return 'unknown'
    }
}

function Copy-WorkspaceSandbox {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    if (Test-Path -LiteralPath $Destination) {
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null

    $robocopyPath = (Get-Command -Name robocopy.exe -ErrorAction Stop).Source
    $excludeDirs = @(
        (Join-Path $Source '.git'),
        (Join-Path $Source 'ai\governance-tests\runs')
    )

    $arguments = @(
        $Source,
        $Destination,
        '/E',
        '/R:1',
        '/W:1',
        '/NFL',
        '/NDL',
        '/NJH',
        '/NJS',
        '/NP',
        '/XD'
    ) + $excludeDirs

    $process = Start-Process -FilePath $robocopyPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -gt 7) {
        throw "robocopy failed with exit code $($process.ExitCode)"
    }
}

function Resolve-ExecutableAndArguments {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CommandPath,

        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $extension = [System.IO.Path]::GetExtension($CommandPath).ToLowerInvariant()
    if ($extension -eq '.ps1') {
        $pwsh = (Get-Command -Name pwsh -ErrorAction Stop).Source
        return [pscustomobject]@{
            FilePath = $pwsh
            Arguments = @('-NoLogo', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $CommandPath) + $Arguments
        }
    }

    if ($extension -eq '.cmd' -or $extension -eq '.bat') {
        $comspec = $env:ComSpec
        if ([string]::IsNullOrWhiteSpace($comspec)) {
            $comspec = 'cmd.exe'
        }
        return [pscustomobject]@{
            FilePath = $comspec
            Arguments = @('/c', $CommandPath) + $Arguments
        }
    }

    return [pscustomobject]@{
        FilePath = $CommandPath
        Arguments = $Arguments
    }
}

function Invoke-ExternalProcess {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        [string[]]$Arguments,

        [Parameter(Mandatory = $true)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $true)]
        [string]$StdOutPath,

        [Parameter(Mandatory = $true)]
        [string]$StdErrPath,

        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds
    )

    New-ParentDirectory -Path $StdOutPath
    New-ParentDirectory -Path $StdErrPath

    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $FilePath
    $psi.WorkingDirectory = $WorkingDirectory
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true

    foreach ($argument in $Arguments) {
        [void]$psi.ArgumentList.Add($argument)
    }

    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $psi

    $started = $process.Start()
    if (-not $started) {
        throw "Failed to start process: $FilePath"
    }

    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()

    $startTime = Get-Date
    $timedOut = $false
    if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
        $timedOut = $true
        try {
            $process.Kill($true)
        } catch {
        }
    }
    $process.WaitForExit()
    $durationMs = [int]((Get-Date) - $startTime).TotalMilliseconds

    $stdoutText = $stdoutTask.GetAwaiter().GetResult()
    $stderrText = $stderrTask.GetAwaiter().GetResult()

    [System.IO.File]::WriteAllText($StdOutPath, $stdoutText, [System.Text.Encoding]::UTF8)
    [System.IO.File]::WriteAllText($StdErrPath, $stderrText, [System.Text.Encoding]::UTF8)

    return [pscustomobject]@{
        ExitCode = $process.ExitCode
        DurationMs = $durationMs
        TimedOut = $timedOut
    }
}

function Invoke-ProviderPrompt {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProviderName,

        [Parameter(Mandatory = $true)]
        [string]$Prompt,

        [Parameter(Mandatory = $true)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $false)]
        [string]$Model,

        [Parameter(Mandatory = $true)]
        [string]$StdOutPath,

        [Parameter(Mandatory = $true)]
        [string]$StdErrPath,

        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds
    )

    $commandPath = Resolve-ProviderCommand -ProviderName $ProviderName
    $arguments = @()

    switch ($ProviderName) {
        'copilot' {
            $arguments += '--prompt'
            $arguments += $Prompt
            $arguments += '--silent'
            $arguments += '--output-format'
            $arguments += 'text'
            $arguments += '--allow-all-tools'
            $arguments += '--allow-all-paths'
            $arguments += '--allow-all-urls'
            $arguments += '--no-color'
            $arguments += '--no-ask-user'
            $arguments += '--add-dir'
            $arguments += $WorkingDirectory
            if (-not [string]::IsNullOrWhiteSpace($Model)) {
                $arguments += '--model'
                $arguments += $Model
            }
        }
        'gemini' {
            $arguments += '--prompt'
            $arguments += $Prompt
            $arguments += '--output-format'
            $arguments += 'text'
            $arguments += '--approval-mode'
            $arguments += 'yolo'
            if (-not [string]::IsNullOrWhiteSpace($Model)) {
                $arguments += '--model'
                $arguments += $Model
            }
        }
        default {
            throw "Unsupported provider: $ProviderName"
        }
    }

    $resolved = Resolve-ExecutableAndArguments -CommandPath $commandPath -Arguments $arguments
    return Invoke-ExternalProcess -FilePath $resolved.FilePath -Arguments $resolved.Arguments -WorkingDirectory $WorkingDirectory -StdOutPath $StdOutPath -StdErrPath $StdErrPath -TimeoutSeconds $TimeoutSeconds
}

$allCases = Read-GovernanceTestCases -YamlPath $CasesPath
$cases = if ($CaseIds -and $CaseIds.Count -gt 0) {
    @($allCases | Where-Object { $_.Id -in $CaseIds })
} else {
    $allCases
}

if ($cases.Count -eq 0) {
    throw 'No matching test cases found.'
}

$providerDisplayName = if ($Provider -eq 'copilot') { 'Copilot CLI' } else { 'Gemini CLI' }
$cliVersion = Get-ProviderCliVersion -ProviderName $Provider
$agentVersion = if (-not [string]::IsNullOrWhiteSpace($ProviderModel)) { $ProviderModel } else { $cliVersion }
$runRoot = Split-Path -Path $ExecutionLogPath -Parent
$sandboxRoot = Join-Path $runRoot 'sandboxes'

Initialize-CsvFile -Path $ExecutionLogPath -Headers @(
    'run_date',
    'provider',
    'provider_model',
    'cli_version',
    'case_id',
    'run_index',
    'severity',
    'exit_code',
    'duration_ms',
    'timed_out',
    'response_path',
    'error_path',
    'sandbox_path'
)

Initialize-CsvFile -Path $ReviewTemplatePath -Headers @(
    'run_date',
    'agent_name',
    'agent_version',
    'case_id',
    'run_index',
    'result',
    'score',
    'severity',
    'notes',
    'response_path',
    'error_path',
    'execution_status',
    'provider',
    'cli_version'
)

New-Item -ItemType Directory -Path $ResponseDir -Force | Out-Null
if (-not $NoSandbox) {
    New-Item -ItemType Directory -Path $sandboxRoot -Force | Out-Null
}

Write-Host ("Provider: {0}" -f $providerDisplayName)
Write-Host ("CLI Version: {0}" -f $cliVersion)
Write-Host ("Model: {0}" -f $(if ([string]::IsNullOrWhiteSpace($ProviderModel)) { '<default>' } else { $ProviderModel }))
Write-Host ("Cases: {0}" -f $cases.Count)
Write-Host ("Runs Per Case: {0}" -f $RunsPerCase)
Write-Host ''

foreach ($case in $cases) {
    for ($runIndex = 1; $runIndex -le $RunsPerCase; $runIndex++) {
        $runId = ("{0}-run{1}" -f $case.Id, $runIndex)
        $responsePath = Join-Path $ResponseDir ("{0}.md" -f $runId)
        $errorPath = Join-Path $ResponseDir ("{0}.stderr.txt" -f $runId)
        $sandboxPath = if ($NoSandbox) { $WorkspaceRoot } else { Join-Path $sandboxRoot $runId }

        Write-Host ("Executing {0} {1}/{2}..." -f $case.Id, $runIndex, $RunsPerCase)

        if (-not $NoSandbox) {
            Copy-WorkspaceSandbox -Source $WorkspaceRoot -Destination $sandboxPath
        }

        $execution = Invoke-ProviderPrompt -ProviderName $Provider -Prompt $case.Prompt -WorkingDirectory $sandboxPath -Model $ProviderModel -StdOutPath $responsePath -StdErrPath $errorPath -TimeoutSeconds $TimeoutSec

        Add-CsvRow -Path $ExecutionLogPath -Row ([pscustomobject]@{
            run_date = Get-Date -Format 'yyyy-MM-dd'
            provider = $Provider
            provider_model = $ProviderModel
            cli_version = $cliVersion
            case_id = $case.Id
            run_index = $runIndex
            severity = $case.Severity
            exit_code = $execution.ExitCode
            duration_ms = $execution.DurationMs
            timed_out = $execution.TimedOut
            response_path = $responsePath
            error_path = $errorPath
            sandbox_path = $sandboxPath
        })

        Add-CsvRow -Path $ReviewTemplatePath -Row ([pscustomobject]@{
            run_date = Get-Date -Format 'yyyy-MM-dd'
            agent_name = $providerDisplayName
            agent_version = $agentVersion
            case_id = $case.Id
            run_index = $runIndex
            result = ''
            score = ''
            severity = $case.Severity
            notes = ''
            response_path = $responsePath
            error_path = $errorPath
            execution_status = if ($execution.ExitCode -eq 0 -and -not $execution.TimedOut) { 'completed' } else { 'error' }
            provider = $Provider
            cli_version = $cliVersion
        })

        Write-Host ("  Exit Code: {0}" -f $execution.ExitCode)
        Write-Host ("  Duration: {0} ms" -f $execution.DurationMs)
        Write-Host ("  Response: {0}" -f $responsePath)
        Write-Host ("  Error: {0}" -f $errorPath)
    }
}

Write-Host ''
Write-Host ("Execution log: {0}" -f $ExecutionLogPath)
Write-Host ("Review template: {0}" -f $ReviewTemplatePath)

if ($AutoReview) {
    Write-Host ''
    Write-Host 'Running auto-review...'
    
    $autoReviewScript = Join-Path $scriptDir 'auto-review-results-v2.ps1'
    if (-not (Test-Path -LiteralPath $autoReviewScript)) {
        Write-Warning "Auto-review script not found: $autoReviewScript"
    } else {
        try {
            $autoReviewedPath = [System.IO.Path]::ChangeExtension($ReviewTemplatePath, '.auto-reviewed.csv')
            & $autoReviewScript -Path $ReviewTemplatePath -OutputPath $autoReviewedPath -CasesPath $CasesPath
            Write-Host ("Auto-reviewed file: {0}" -f $autoReviewedPath)
            Write-Host 'Next step: run score-results.ps1 to aggregate scores and determine release gate.'
        } catch {
            Write-Error "Auto-review failed: $($_.Exception.Message)"
        }
    }
} else {
    Write-Host 'Next step: review the captured responses manually, or run auto-review-results-v2.ps1 for an initial score, then run score-results.ps1 against that file.'
}
