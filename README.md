# AI Governance Bootstrap and Prompt Flow

## 1. 目的

本目錄用來支撐 repository 的 AI agent 導入與治理流程。

這套機制的目標不是單純提供幾段 prompt，而是建立一條可持續運作的導入鏈，讓 AI agent：

* 先讀取專案 context 與治理規則
* 再依 repository 實況建立或延續治理文件
* 在既有治理結構內工作，而不是每次重新發明規則
* 在治理規則升級後，可回頭對齊既有 repository

核心流程如下：

```text
project-context-bootstrap.yaml
  -> 1.init-prompt.md
  -> repository governance files
  -> 2.continue-prompt.md
  -> 3.rule-alignment-prompt.md
```

---

## 2. 核心概念

### 2.1 bootstrap 不是最終 context

`project-context-bootstrap.yaml` 是初始化規格，不是最終專案 context。

它提供：

* 專案基本身分
* 組織假設
* 技術棧與架構初始欄位
* 約束條件
* AI 治理設定
* governance repo 與 shared rules baseline

init prompt 會根據：

* bootstrap
* repository 實際結構
* governance repo
* shared rules baseline

收斂出 repository 的第一版治理文件與 `ai/project-context.yaml`。

### 2.2 shared rules 是 authority source

若 `project-context-bootstrap.yaml` 中：

* `ai_governance.use_shared_rules: true`
* 且有 `governance_repo`
* 且有 `shared_rules.required`

則 shared rules 應視為 repository 治理初始化與後續 alignment 的 authority source 之一。

這些 shared rules 不應被原文整份複製到專案 repo，而應經過：

* 去重
* 分工
* repo-specific 收斂

再落到：

* `.github/copilot-instructions.md`
* `AGENTS.md`
* `ai/project-context.yaml`
* `.github/instructions/*.instructions.md`

### 2.3 continue 與 alignment 是不同任務

* `2.continue-prompt.md`：用於日常延續工作
* `3.rule-alignment-prompt.md`：用於治理規則升級後的對齊工作

continue 不是 re-init。
alignment 也不是 re-init。
兩者都必須尊重既有治理結構與文件分工。

---

## 3. 檔案說明

### 3.1 `project-context-bootstrap.yaml`

初始化規格來源。

主要責任：

* 定義專案最小 context 骨架
* 指定 governance repo
* 指定 shared rules baseline
* 定義 AI 治理的最低輸出要求

目前重點欄位包括：

* `project`
* `organization`
* `tech_stack`
* `architecture`
* `constraints`
* `ai_governance`

其中 `ai_governance` 目前負責：

* `pilot_scope`
* `use_shared_rules`
* `workflows`
* `commit_protocol`
* `required_output`
* `governance_repo`
* `shared_rules`

### 3.2 `1.init-prompt.md`

repository 初始化 prompt。

主要責任：

* 根據 bootstrap、repo 結構、governance repo 與 shared rules baseline 初始化治理文件
* 判斷主要技術棧
* 產出共通治理文件
* 產出 path-specific instructions

典型產物包括：

* `.github/copilot-instructions.md`
* `AGENTS.md`
* `ai/project-context.yaml`
* `.github/instructions/*.instructions.md`

### 3.3 `2.continue-prompt.md`

日常延續 prompt。

主要責任：

* 在既有治理結構內繼續工作
* 尊重既有文件分工
* 不另立新治理邏輯
* 必要時回看 bootstrap 與 baseline 以理解既有治理來源

### 3.4 `3.rule-alignment-prompt.md`

治理規則對齊 prompt。

主要責任：

* 針對已運作一段時間的 repository
* 讀取 bootstrap baseline、專案現有治理文件、governance repo 新規則
* 做 delta analysis
* 以最小必要修改完成治理規則對齊

---

## 4. shared rules baseline

bootstrap 中的 `shared_rules.required` 定義了此 repository 初始化與後續治理對齊時所依據的 baseline shared rules。

目前 baseline 包括：

* `ai-working-rules.md`
* `architecture-principles.md`
* `design-principles.md`
* `code-quality-baseline.md`
* `contract-and-compatibility-rules.md`
* `commit-protocol.md`

這些檔案位於 governance repo 中，屬於 shared rules authority source，而不是直接當成專案 repo 的最終文件。

---

## 5. shared rules 角色分工

### `ai-working-rules.md`

定義 AI agent 的共通工作規則：

* 先讀 context
* 先分析再修改
* 不可虛構
* 先定義驗證再宣稱進度
* 不得未驗證宣稱完成

### `architecture-principles.md`

定義架構邊界與依賴方向：

* 分層責任
* dependency direction
* external integration isolation
* change containment

### `design-principles.md`

定義設計語意與領域建模方向：

* DDD direction
* business meaning
* naming consistency
* responsibility clarity

### `code-quality-baseline.md`

定義實作與修改品質要求：

* TDD spirit
* validation first
* defensive programming
* gate-friendly
* bug fix / refactor discipline
* evidence-based completion

### `contract-and-compatibility-rules.md`

定義契約與相容性保護：

* backward compatibility
* contract surface identification
* additive vs breaking change
* migration / deprecation / grandfathering

### `commit-protocol.md`

定義交付與追溯格式：

* commit message structure
* AI trailers
* change summary
* validation summary
* assumptions disclosure
* risk disclosure

---

## 6. 三種 prompt 的使用時機

### 6.1 init

使用時機：

* 新 repository 首次導入 AI agent 治理
* 舊 repo 尚未建立第一版治理文件

作用：

* 建立第一版治理結構
* 吃進 bootstrap + shared rules baseline + repo 實況

### 6.2 continue

使用時機：

* repository 已完成 init
* 後續日常工作、文件補齊、path-specific 文件延伸

作用：

* 在既有治理結構中持續工作
* 不重建、不 re-init

### 6.3 rule alignment

使用時機：

* governance repo 新增或調整 shared rules
* 已運作中的 repository 要同步新治理規則

作用：

* 讀 bootstrap baseline
* 讀 repo 既有治理文件
* 讀 governance repo 新規則
* 區分 baseline 缺口與新規則升級
* 以最小必要修改完成對齊

---

## 7. 一致性原則

整套流程應遵守以下一致性原則：

### 7.1 不得虛構

若 bootstrap、repo 實況或 governance repo 無法確認某件事，應標示：

* `assumption`
* `pending confirmation`

不得自行補造。

### 7.2 不得整套重建

continue 與 rule alignment 都不是 re-init。

* continue：延續既有治理
* alignment：最小必要對齊

不得以日常任務或規則升級為由，整套重寫治理文件。

### 7.3 保護 legacy 與 backward compatibility

所有 shared rules 與 prompt 都應遵守：

* grandfathering for untouched legacy code
* backward compatibility first when ideal rules conflict with stability
* 新規則主要約束新程式碼、實質修改邏輯與新增邏輯

### 7.4 shared rules 不應原文整份複製

shared rules 是 authority source，不是專案 repo 的最終文件。

init / continue / alignment 的工作應是：

* 收斂
* 去重
* 分工
* repo-specific 落地

---

## 8. 最低輸出要求

來自 bootstrap 的最低輸出要求目前包括：

* `change-summary`
* `validation-summary`
* `assumptions-and-pending-confirmation`
* `risk-and-uncovered-scope`
* `proposed-commit-message`

這些要求應由 init / continue / alignment 產物與後續 AI 任務共同遵守。

---

## 9. 建議使用順序

### Repository 首次導入

1. 準備 `ai/project-context-bootstrap.yaml`
2. 執行 `1.init-prompt.md`
3. review 產出的治理文件
4. 確認 `ai/project-context.yaml` 與 repo 實況一致

### Repository 日常工作

1. 先讀既有治理文件
2. 使用 `2.continue-prompt.md`
3. 在既有分工下更新或新增內容

### 治理規則升級後

1. 更新 governance repo 中 shared rules
2. 對目標 repo 執行 `3.rule-alignment-prompt.md`
3. review baseline 缺口與新規則升級差異
4. 驗證最小必要更新結果

---

## 10. 一句話總結

> `project-context-bootstrap.yaml` 提供初始化骨架與治理來源，`1.init-prompt.md` 建立第一版治理結構，`2.continue-prompt.md` 保持日常工作在既有治理之內，`3.rule-alignment-prompt.md` 讓已運作的 repository 可在 shared rules 升級後進行最小必要對齊。
