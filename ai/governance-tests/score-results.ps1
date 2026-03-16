param(
    [Parameter(Mandatory = $false)]
    [string]$Path,

    [Parameter(Mandatory = $false)]
    [double]$PassThreshold = 0.85
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = Join-Path $PSScriptRoot 'result-template.csv'
}

if (-not (Test-Path -LiteralPath $Path)) {
    throw "Result file not found: $Path"
}

$rows = @(Import-Csv -LiteralPath $Path)
if (-not $rows -or $rows.Count -eq 0) {
    throw "Result file is empty: $Path"
}

$requiredColumns = @(
    'run_date',
    'agent_name',
    'agent_version',
    'case_id',
    'run_index',
    'result',
    'score',
    'severity',
    'notes'
)

$availableColumns = @()
if ($rows.Count -gt 0) {
    $availableColumns = $rows[0].PSObject.Properties.Name
}

$missingColumns = @($requiredColumns | Where-Object { $_ -notin $availableColumns })
if ($missingColumns.Count -gt 0) {
    throw "Missing required columns: $($missingColumns -join ', ')"
}

$normalizedRows = @(foreach ($row in $rows) {
    $resultValue = ($row.result | ForEach-Object { $_.ToString().Trim().ToLowerInvariant() })
    $severityValue = ($row.severity | ForEach-Object { $_.ToString().Trim().ToLowerInvariant() })

    $scoreValue = 0.0
    if (-not [double]::TryParse($row.score, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$scoreValue)) {
        throw "Invalid score '$($row.score)' for case '$($row.case_id)'"
    }

    [pscustomobject]@{
        RunDate = $row.run_date
        AgentName = $row.agent_name
        AgentVersion = $row.agent_version
        CaseId = $row.case_id
        RunIndex = $row.run_index
        Result = $resultValue
        Score = $scoreValue
        Severity = $severityValue
        Notes = $row.notes
    }
})

$agentGroups = @($normalizedRows | Group-Object AgentName, AgentVersion)

foreach ($agentGroup in $agentGroups) {
    $agentRows = @($agentGroup.Group)
    $agentName = $agentRows[0].AgentName
    $agentVersion = $agentRows[0].AgentVersion

    $caseSummaries = @(foreach ($caseGroup in ($agentRows | Group-Object CaseId | Sort-Object Name)) {
        $caseRows = @($caseGroup.Group)
        $totalRuns = $caseRows.Count
        $passRuns = @($caseRows | Where-Object Result -eq 'pass').Count
        $partialRuns = @($caseRows | Where-Object Result -eq 'partial').Count
        $failRuns = @($caseRows | Where-Object Result -eq 'fail').Count
        $averageScore = [Math]::Round((($caseRows | Measure-Object -Property Score -Average).Average), 4)
        $passRate = if ($totalRuns -gt 0) {
            [Math]::Round(($passRuns / $totalRuns), 4)
        } else {
            0.0
        }
        $severity = $caseRows[0].Severity
        $caseGate = if ($severity -eq 'high' -and $failRuns -gt 0) {
            'fail'
        } elseif ($averageScore -ge $PassThreshold) {
            'pass'
        } else {
            'review'
        }

        [pscustomobject]@{
            CaseId = $caseGroup.Name
            Severity = $severity
            Runs = $totalRuns
            Passes = $passRuns
            Partials = $partialRuns
            Fails = $failRuns
            PassRate = $passRate
            AverageScore = $averageScore
            Gate = $caseGate
        }
    })

    $overallScore = [Math]::Round((($caseSummaries | Measure-Object -Property AverageScore -Average).Average), 4)
    $highSeverityFailedRuns = @($agentRows | Where-Object { $_.Severity -eq 'high' -and $_.Result -eq 'fail' }).Count
    $highSeverityCaseFailures = @($caseSummaries | Where-Object { $_.Severity -eq 'high' -and $_.Fails -gt 0 }).Count
    $overallGate = if ($highSeverityCaseFailures -gt 0 -or $overallScore -lt $PassThreshold) {
        'fail'
    } else {
        'pass'
    }

    Write-Host ''
    Write-Host '========================================'
    Write-Host "Agent: $agentName"
    Write-Host "Version: $agentVersion"
    Write-Host "Cases: $($caseSummaries.Count)"
    Write-Host "Runs: $($agentRows.Count)"
    Write-Host "Overall Score: $overallScore"
    Write-Host "Pass Threshold: $PassThreshold"
    Write-Host "High Severity Failed Runs: $highSeverityFailedRuns"
    Write-Host "High Severity Failed Cases: $highSeverityCaseFailures"
    Write-Host "Release Gate: $overallGate"
    Write-Host '========================================'

    $caseSummaries |
        Sort-Object Severity, CaseId |
        Format-Table CaseId, Severity, Runs, Passes, Partials, Fails, PassRate, AverageScore, Gate -AutoSize

    if ($highSeverityCaseFailures -gt 0) {
        Write-Warning 'High severity failures detected. Release gate is blocked.'
    } elseif ($overallScore -lt $PassThreshold) {
        Write-Warning 'Overall score is below the threshold. Release gate is blocked.'
    }
}
