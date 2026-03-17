#!/usr/bin/pwsh
<#
.SYNOPSIS
測試 AutoReview 整合到 run-governance-tests-cli.ps1 的功能

.DESCRIPTION
此腳本驗證 -AutoReview 參數是否正確整合到 CLI 運行器中
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$ExistingReviewPath = $null
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
$cliScript = Join-Path $scriptDir 'run-governance-tests-cli.ps1'
$autoReviewScript = Join-Path $scriptDir 'auto-review-results-v2.ps1'
$testCasesPath = Join-Path $scriptDir 'test-cases.yaml'

Write-Host '=== AutoReview 整合驗證 ===' -ForegroundColor Cyan
Write-Host ''

# 檢查檔案是否存在
Write-Host '檢查必要的檔案...' -ForegroundColor Yellow
$checks = @(
    @{ Path = $cliScript; Name = 'CLI 運行器' },
    @{ Path = $autoReviewScript; Name = '自動評審腳本 (v2)' },
    @{ Path = $testCasesPath; Name = '測試案例定義' }
)

$allExist = $true
foreach ($check in $checks) {
    $exists = Test-Path -LiteralPath $check.Path
    $status = if ($exists) { '✓' } else { '✗' }
    Write-Host ("  {0} {1}: {2}" -f $status, $check.Name, $check.Path) -ForegroundColor $(if ($exists) { 'Green' } else { 'Red' })
    if (-not $exists) { $allExist = $false }
}

if (-not $allExist) {
    Write-Error '某些必要檔案不存在'
    exit 1
}

Write-Host ''
Write-Host '驗證 CLI 參數...' -ForegroundColor Yellow

# 檢查 AutoReview 參數是否在 CLI 中定義
$cliContent = Get-Content -LiteralPath $cliScript -Raw
if ($cliContent -match '\[switch\]\s*\$AutoReview') {
    Write-Host '  ✓ -AutoReview 參數已定義' -ForegroundColor Green
} else {
    Write-Host '  ✗ -AutoReview 參數未找到' -ForegroundColor Red
    exit 1
}

# 檢查自動評審邏輯是否在腳本中
if ($cliContent -match 'auto-review-results-v2\.ps1') {
    Write-Host '  ✓ 自動評審調用邏輯已整合' -ForegroundColor Green
} else {
    Write-Host '  ✗ 自動評審調用邏輯未找到' -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host '演示：使用 -AutoReview 選項' -ForegroundColor Yellow
Write-Host ('CLI 文件位置: {0}' -f $cliScript)
Write-Host ''
Write-Host '使用方式：' -ForegroundColor Cyan
Write-Host '  pwsh ./run-governance-tests-cli.ps1 -Provider copilot -ProviderModel gpt-5.4 -TargetRepo <path> -CaseIds T01 -AutoReview' -ForegroundColor DarkCyan
Write-Host ''
Write-Host '執行結果：' -ForegroundColor Yellow
Write-Host '  1. 執行治理測試案件 (T01)' -ForegroundColor DarkGray
Write-Host '  2. 自動執行 auto-review-results-v2.ps1' -ForegroundColor DarkGray
Write-Host '  3. 生成帶有自動評分的 review-template.auto-reviewed.csv 檔案' -ForegroundColor DarkGray
Write-Host '  4. 可直接用於 score-results.ps1 計分' -ForegroundColor DarkGray

if ($ExistingReviewPath -and (Test-Path -LiteralPath $ExistingReviewPath)) {
    Write-Host ''
    Write-Host '測試模擬：使用現有評審模板' -ForegroundColor Yellow
    Write-Host ("輸入檔案: {0}" -f $ExistingReviewPath) -ForegroundColor DarkGray
    
    $outputPath = [System.IO.Path]::ChangeExtension($ExistingReviewPath, '.auto-reviewed.test.csv')
    Write-Host ("輸出檔案: {0}" -f $outputPath) -ForegroundColor DarkGray
    
    try {
        Write-Host '正在執行自動評審...' -ForegroundColor DarkGray
        & $autoReviewScript -Path $ExistingReviewPath -OutputPath $outputPath -CasesPath $testCasesPath -Force
        
        if (Test-Path -LiteralPath $outputPath) {
            Write-Host '✓ 自動評審成功完成' -ForegroundColor Green
            
            # 檢查輸出內容
            $csvContent = @(Import-Csv -LiteralPath $outputPath)
            Write-Host ("  處理的行數: {0}" -f $csvContent.Count) -ForegroundColor DarkGray
            
            $passCount = @($csvContent | Where-Object Result -eq 'pass').Count
            $failCount = @($csvContent | Where-Object Result -eq 'fail').Count
            $partialCount = @($csvContent | Where-Object Result -eq 'partial').Count
            
            Write-Host ("  通過: {0}, 失敗: {1}, 部分: {2}" -f $passCount, $failCount, $partialCount) -ForegroundColor DarkGray
            
            # 清理測試檔案
            Remove-Item -LiteralPath $outputPath -Force
            Write-Host '  (測試檔案已清理)' -ForegroundColor DarkGray
        }
    } catch {
        Write-Error ("自動評審失敗: {0}" -f $_.Exception.Message)
    }
}

Write-Host ''
Write-Host '=== 驗證完成 ===' -ForegroundColor Green
Write-Host 'AutoReview 參數已成功整合到 run-governance-tests-cli.ps1' -ForegroundColor Green
Write-Host '現在可以使用 -AutoReview 參數自動進行評審並生成可計分的檔案' -ForegroundColor Green
