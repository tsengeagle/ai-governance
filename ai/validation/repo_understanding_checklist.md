# Repo Understanding Checklist

## 1. Purpose

本清單用於驗證 AI agent 是否已對本 repository 建立足夠且正確的理解。

本清單只評估 repo understanding，不評估實作行為是否合規。
不可用本清單取代 rule compliance 驗證。

---

## 2. Evaluation Rule

每一項目使用以下評分：

- **0 分**：錯誤、缺漏嚴重、或明顯猜測
- **1 分**：部分正確，但不完整或依據不足
- **2 分**：正確、清楚、且有明確檔案依據

評分時，必須同時檢查：

- 是否基於 repo 內真實內容
- 是否附具體檔案依據
- 是否將 unknown / assumption 與 confirmed fact 區分清楚

---

## 3. Checklist

## A. Project Purpose and Scope

### A1. 能否說明 repo 的主要用途
- 0：用途說錯，或只給通用說法
- 1：用途大致正確，但過於籠統
- 2：用途準確，且可指出主要依據檔案

Score:
Evidence:
Notes:

### A2. 能否說明此 repo 主要處理的問題域或業務域
- 0：無法辨識
- 1：可辨識大方向
- 2：能具體指出本 repo 負責的領域與邊界

Score:
Evidence:
Notes:

### A3. 能否指出不在本 repo scope 內的內容
- 0：無法區分邊界
- 1：部分可區分
- 2：清楚指出本 repo 邊界與非責任範圍

Score:
Evidence:
Notes:

---

## B. Tech Stack Understanding

### B1. 能否指出主要語言與框架
- 0：錯誤或猜測
- 1：部分正確
- 2：正確且有檔案依據

Score:
Evidence:
Notes:

### B2. 能否指出 build tool / package manager / runtime
- 0：錯誤或遺漏嚴重
- 1：部分正確
- 2：正確且具體

Score:
Evidence:
Notes:

### B3. 能否指出重要基礎設施或外部依賴
- 0：無法指出
- 1：只指出少部分
- 2：能指出主要外部系統、服務或平台

Score:
Evidence:
Notes:

---

## C. Startup and Test Entrypoints

### C1. 能否指出專案啟動方式
- 0：錯誤
- 1：部分正確，但不完整
- 2：準確指出主要啟動入口與方式

Score:
Evidence:
Notes:

### C2. 能否指出測試執行方式
- 0：錯誤或無法指出
- 1：部分正確
- 2：準確指出測試入口與主要類型

Score:
Evidence:
Notes:

### C3. 能否辨識 local/dev/test profiles 或相關配置
- 0：無法辨識
- 1：可辨識部分
- 2：能明確指出 profile / env / config 差異

Score:
Evidence:
Notes:

---

## D. Structure and Module Understanding

### D1. 能否指出主要目錄結構
- 0：混亂或錯誤
- 1：列出部分目錄
- 2：可指出主要目錄及其用途

Score:
Evidence:
Notes:

### D2. 能否指出核心模組或核心流程所在位置
- 0：無法定位
- 1：部分定位正確
- 2：能正確指出關鍵模組與其角色

Score:
Evidence:
Notes:

### D3. 能否描述模組之間的大致關係
- 0：說錯或無法描述
- 1：只能描述局部
- 2：可描述主要依賴與流程方向

Score:
Evidence:
Notes:

---

## E. Governance File Understanding

### E1. 能否列出 repo 中主要 AI 治理文件
- 0：遺漏或誤列嚴重
- 1：列出部分
- 2：列出主要治理文件且路徑正確

Score:
Evidence:
Notes:

### E2. 能否說明各治理文件的分工
- 0：分工說錯
- 1：部分正確
- 2：能合理區分 workflow / principles / evidence / rules 等職責

Score:
Evidence:
Notes:

### E3. 能否指出治理文件與實作任務之關聯
- 0：無法連結
- 1：僅抽象連結
- 2：能指出哪些文件會直接影響任務行為

Score:
Evidence:
Notes:

---

## F. Known / Unknown / Assumption Discipline

### F1. 能否區分 confirmed fact 與 assumption
- 0：混用
- 1：有區分但不穩
- 2：區分清楚且一致

Score:
Evidence:
Notes:

### F2. 能否指出 pending confirmation 項目
- 0：沒有指出
- 1：指出少部分
- 2：能系統化列出未確認項目

Score:
Evidence:
Notes:

### F3. 面對資訊不足時是否避免亂猜
- 0：明顯亂猜
- 1：偶有猜測
- 2：能明確標 unknown / unverified

Score:
Evidence:
Notes:

---

## G. Risk Awareness

### G1. 能否指出 repo 當前主要風險
- 0：完全沒抓到
- 1：抓到部分
- 2：能指出與 repo 現況相關的具體風險

Score:
Evidence:
Notes:

### G2. 能否指出理解上的限制
- 0：假裝全部都懂
- 1：有少量保留
- 2：能清楚說明理解邊界

Score:
Evidence:
Notes:

### G3. 能否指出後續需要查證的事項
- 0：沒有
- 1：部分提出
- 2：提出具體且合理的查證方向

Score:
Evidence:
Notes:

---

## 4. Score Summary

| Dimension | Max Score | Actual Score |
|---|---:|---:|
| Project Purpose and Scope | 6 |   |
| Tech Stack Understanding | 6 |   |
| Startup and Test Entrypoints | 6 |   |
| Structure and Module Understanding | 6 |   |
| Governance File Understanding | 6 |   |
| Known / Unknown / Assumption Discipline | 6 |   |
| Risk Awareness | 6 |   |
| Total | 42 |   |

---

## 5. Interpretation

- **0–20**：理解不足，不應進入實作任務
- **21–30**：部分可用，但需要嚴格人工審核
- **31–36**：理解良好，可處理小型任務
- **37–42**：理解成熟，可進入較高複雜度任務

---

## 6. Fail Fast Conditions

即使總分不低，只要出現以下任一情況，仍應判定為不通過：

- 將 assumption 當成 confirmed fact
- 說明內容大量脫離 repo 真實內容
- 找不到主要啟動或測試入口
- 無法辨識治理文件
- 大量使用通用模板化說法而非 repo-specific 結論

---

## 7. Evaluator Notes

- 本清單的目的不是要求 agent 背誦全部 repo 細節
- 本清單的目的，是確認 agent 是否已具備「足夠安全的 repo 理解能力」
- 若低分原因主要來自 repo 文件本身缺漏，應同步補強 repo 文件，而非只歸咎 agent

