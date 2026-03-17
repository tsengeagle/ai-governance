# AutoReview 整合使用指南

## 概述

`-AutoReview` 參數將自動評審整合到 CLI 運行器中，實現一鍵執行測試、評審、計分的完整工作流程。

執行結果：
```
測試執行 → 自動評審 → 可計分檔案
   (2 mins)  (10 secs)  (ready)
```

## 快速開始

### 基本用法

```powershell
pwsh ./ai/governance-tests/run-governance-tests-cli.ps1 `
    -Provider copilot `
    -ProviderModel gpt-5.4 `
    -TargetRepo C:/Users/you/source/target-repo `
    -CaseIds T01 `
    -RunsPerCase 1 `
    -AutoReview
```

### 執行結果

執行完成後，會自動生成：

1. **execution-log.csv** — 每次執行的詳細日誌（沙箱路徑、退出碼、持續時間等）
2. **review-template.csv** — 原始的評審模板（未評分）
3. **review-template.auto-reviewed.csv** ✨ — 帶有自動評審評分的檔案

## 完整工作流程

### 方案 A：使用 -AutoReview（推薦）

一個命令完成所有工作：

```powershell
# 1. 執行測試 + 自動評審
pwsh ./run-governance-tests-cli.ps1 `
    -Provider copilot `
    -ProviderModel gpt-5.4 `
    -TargetRepo ./target-repo `
    -CaseIds T01,T02,T03 `
    -RunsPerCase 3 `
    -AutoReview

# 2. 計分並查看結果
pwsh ./score-results.ps1 -Path ./runs/copilot-YYYYMMDD-HHMMSS/review-template.auto-reviewed.csv
```

### 方案 B：分步執行

適合需要手動檢查的場景：

```powershell
# 1. 執行測試
pwsh ./run-governance-tests-cli.ps1 `
    -Provider copilot `
    -ProviderModel gpt-5.4 `
    -TargetRepo ./target-repo `
    -CaseIds T01,T02

# 2. 手動檢查並編輯 review-template.csv

# 3. 執行自動評審（對空的欄位）
pwsh ./auto-review-results-v2.ps1 `
    -Path ./runs/copilot-YYYYMMDD-HHMMSS/review-template.csv `
    -Force

# 4. 計分
pwsh ./score-results.ps1 -Path ./runs/copilot-YYYYMMDD-HHMMSS/review-template.auto-reviewed.csv
```

## 參數說明

### 必需參數

| 參數 | 說明 | 範例 |
|------|------|------|
| `-Provider` | AI 提供商（copilot 或 gemini） | `copilot` |

### 可選參數

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `-ProviderModel` | 模型版本 | 由 CLI 決定 |
| `-TargetRepo` | 目標倉庫路徑 | 當前工作空間 |
| `-CaseIds` | 執行的測試案例 | 全部 |
| `-RunsPerCase` | 每個案例的運行次數 | 3 |
| `-TimeoutSec` | CLI 超時時間（秒） | 600 |
| `-NoSandbox` | 不使用沙箱副本 | false |
| **`-AutoReview`** | **自動評審（新增功能）** | **false** |

## 輸出檔案說明

### review-template.auto-reviewed.csv

包含以下欄位：

| 欄位 | 說明 |
|------|------|
| `case_id` | 測試案例 ID |
| `run_index` | 執行序號 |
| `result` | 自動評審結果：`pass`、`partial`、`fail` |
| `score` | 自動評審分數：`1.0`、`0.5`、`0.0` |
| `notes` | 評審詳細說明 |
| `confidence` | 置信度：`high`、`medium`、`low` |
| `tests` | 測試統計：`{總數}/{失敗}/{錯誤}` |

### 自動評審置信度說明

- **high** — 所有 must 檢查通過、測試無故障、構件充分
- **medium** — 部分檢查通過或有測試結果
- **low** — 檢查項不足或遺失構件

## 常見用途

### 快速驗證一個案例

```powershell
pwsh ./run-governance-tests-cli.ps1 -Provider copilot -CaseIds T01 -RunsPerCase 1 -AutoReview
```

輸出：立即得到 `pass`/`fail` 結果 (15-20 秒)

### 完整的迴歸測試

```powershell
pwsh ./run-governance-tests-cli.ps1 -Provider copilot -RunsPerCase 5 -AutoReview

pwsh ./score-results.ps1 -Path ./runs/copilot-YYYYMMDD-HHMMSS/review-template.auto-reviewed.csv
```

輸出：Release Gate 決策（pass/fail）

### 對比多個模型

```powershell
# Copilot gpt-5.4
pwsh ./run-governance-tests-cli.ps1 -Provider copilot -ProviderModel gpt-5.4 -CaseIds T01,T02 -AutoReview

# Gemini 3.0
pwsh ./run-governance-tests-cli.ps1 -Provider gemini -ProviderModel gemini-3-pro-preview -CaseIds T01,T02 -AutoReview
```

比較 `review-template.auto-reviewed.csv` 中的評分差異

## 故障排除

### 自動評審失敗

檢查：
1. `auto-review-results-v2.ps1` 是否存在於同目錄
2. `test-cases.yaml` 是否完整

### 評分不符預期

檢查：
1. `-Force` 參數強制重新評審（如果已有手動結果）
2. 檢查 `notes` 欄位中的詳細評審說明

### 文件權限問題

使用 PowerShell 管理員模式：

```powershell
Start-Process powershell -Verb RunAs
pwsh ./run-governance-tests-cli.ps1 ...
```

## 工作流程建議

### 本地開發

```powershell
# 快速迴圈
pwsh ./run-governance-tests-cli.ps1 -Provider copilot -CaseIds T01 -RunsPerCase 1 -AutoReview
```

### 關鍵變更前

```powershell
# 完整驗證
pwsh ./run-governance-tests-cli.ps1 -Provider copilot -RunsPerCase 3 -AutoReview

pwsh ./score-results.ps1 -Path ./runs/copilot-.../review-template.auto-reviewed.csv
```

驗證 Release Gate = `pass`

### 模型更新後

```powershell
# 側邊對比
foreach ($model in @('gpt-5.3', 'gpt-5.4')) {
    pwsh ./run-governance-tests-cli.ps1 -Provider copilot -ProviderModel $model -AutoReview
}
```

比較結果差異

## 技術詳節

### 自動評審規則

v2 引擎使用：
- **文本模式匹配** — must/should/fail 檢查
- **構件驗證** — 測試執行結果（JUnit XML）
- **矛盾檢測** — 同時宣稱拒絕且實現的風險
- **置信度評分** — 基於構件完整性

### 支援的模型

| CLI | 提供商 | 參數值 |
|-----|--------|--------|
| Copilot CLI | GitHub Copilot | `copilot` |
| Gemini CLI | Google Gemini | `gemini` |

## 後續操作

評審完成後：

1. **Pass** — 可進行下一步
2. **Partial** — 手動檢查並決定
3. **Fail** — 需要調查並修復

編輯 `review-template.csv` 中的 `result` 和 `score` 欄位，然後重新計分。
