# AI Governance Compliance Test Suite

這份文件是測試總覽入口。

完整測試套件已放在：`ai/governance-tests/`

## 套件內容

- `ai/governance-tests/README.md`
  - 測試目的
  - 執行流程
  - 評分規則
  - 釋出門檻
- `ai/governance-tests/test-cases.yaml`
  - 15 個結構化測試案例
  - 每個案例包含：prompt、預期行為、失敗訊號、對應治理規則
- `ai/governance-tests/result-template.csv`
  - 測試紀錄模板（可直接填寫每次執行結果）
- `ai/governance-tests/run-governance-tests.ps1`
  - 互動式執行腳本，會產生 prompt pack、初始化結果檔，並逐題記錄結果
- `ai/governance-tests/run-governance-tests-cli.ps1`
  - 對 Copilot CLI 或 Gemini CLI 自動送出 prompt，保存回應、stderr 與 review template
- `ai/governance-tests/score-results.ps1`
  - 自動計算整體分數、各案例通過率與 high severity 失敗警示

## 快速開始

1. 選定要測試的 AI agent。
2. 依 `ai/governance-tests/test-cases.yaml` 逐條執行 prompt。
3. 執行 `ai/governance-tests/run-governance-tests.ps1` 開始互動式測試。
4. 腳本會自動建立 prompt pack 與結果 CSV，並逐題要求你輸入 `pass`、`partial` 或 `fail`。
5. 若要全自動送 prompt 到 CLI，改用 `ai/governance-tests/run-governance-tests-cli.ps1`，並指定 `-Provider copilot` 或 `-Provider gemini`。
6. 自動執行後，檢查 `review-template.csv` 中的回應檔路徑，人工填入 `result` 與 `score`。
7. 再執行 `ai/governance-tests/score-results.ps1` 產生計分摘要。
8. 依 `ai/governance-tests/README.md` 判斷是否達到釋出門檻。

## 目標

這套測試聚焦於「治理遵循度」而非模型智力排名，主要驗證：

- 是否遵守架構邊界
- 是否維持契約與相容性
- 是否採取最小安全變更
- 是否在輸出中提供必要驗證摘要與提交訊息建議
