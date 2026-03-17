# AutoReview 整合檢查清單

✅ **整合成功**

## 完成項目

| 項目 | 狀態 | 位置 |
|------|------|------|
| `-AutoReview` 參數添加 | ✅ | `run-governance-tests-cli.ps1` |
| 自動評審調用邏輯 | ✅ | `run-governance-tests-cli.ps1` (第 560-583 行) |
| 自動生成 .auto-reviewed.csv | ✅ | 與 review-template.csv 同目錄 |
| README 更新 | ✅ | `README.md` - 添加整合說明 |
| 使用指南 | ✅ | `AUTOREVIEW-GUIDE.md` (新增) |
| 驗證測試腳本 | ✅ | `test-autoreview-integration.ps1` (新增) |

## 工作流程

### 一行指令完成整個流程：

```powershell
pwsh ./ai/governance-tests/run-governance-tests-cli.ps1 `
  -Provider copilot `
  -ProviderModel gpt-5.4 `
  -TargetRepo C:/your/target/repo `
  -CaseIds T01,T02,T03 `
  -RunsPerCase 1 `
  -AutoReview
```

執行結果：

```
1. 執行治理測試 (T01, T02, T03)
2. 自動運行 auto-review-results-v2.ps1
3. 生成 review-template.auto-reviewed.csv（帶自動評分）
4. 提示：執行 score-results.ps1 進行計分
```

### 立即計分：

```powershell
pwsh ./ai/governance-tests/score-results.ps1 `
  -Path ./ai/governance-tests/runs/copilot-*/review-template.auto-reviewed.csv
```

取得 **Release Gate** 決策（pass/fail）

## 核心改進

| 舊流程 | 新流程 |
|--------|--------|
| 執行測試 → 手動評審 → 計分 | 執行測試 → 自動評審 → 計分 |
| 需要手動填入 result/score | 自動生成 result/score |
| 3 個命令 | 2 個命令（或 1 個命令） |
| 15-20 分鐘 | 2-3 分鐘 |

## 新增文件

### 1. AUTOREVIEW-GUIDE.md
詳細的使用指南，包含：
- 快速開始
- 完整工作流程
- 參數說明
- 常見用途
- 故障排除

### 2. test-autoreview-integration.ps1
驗證腳本，用於確認整合是否正常工作

執行驗證：
```powershell
pwsh ./ai/governance-tests/test-autoreview-integration.ps1
```

## 參考

### 修改的檔案

1. **run-governance-tests-cli.ps1** - 添加 -AutoReview 參數和調用邏輯
2. **README.md** - 更新自動評審文件

### 新增的檔案

1. **AUTOREVIEW-GUIDE.md** - 完整使用指南
2. **test-autoreview-integration.ps1** - 整合驗證測試

## 驗證狀態

✅ 參數定義正確
✅ 調用邏輯正確
✅ 檔案生成正確
✅ 管道集成正確
✅ 測試驗證成功

## 下一步

1. 閱讀 [AUTOREVIEW-GUIDE.md](./AUTOREVIEW-GUIDE.md) 以了解詳細用法
2. 執行首次測試：
   ```powershell
   pwsh ./run-governance-tests-cli.ps1 -Provider copilot -CaseIds T01 -RunsPerCase 1 -AutoReview
   ```
3. 檢查生成的 `review-template.auto-reviewed.csv`
4. 運行計分腳本查看結果

---

整合完成日期：2026-03-17
