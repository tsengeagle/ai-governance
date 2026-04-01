# Validation Report Template

## 1. Purpose

本文件用於記錄單次 AI agent 驗證的結果。

其目的不是產生摘要式結論，而是保留：

- 驗證任務是什麼
- 驗證時看了哪些證據
- agent 的行為有哪些通過與不通過之處
- 哪些結論已驗證，哪些仍未驗證
- 最終是否允許 agent 進入下一階段使用

本報告應搭配以下文件使用：

- `agent-validation-sop.md`
- `repo-understanding-checklist.md`
- `rule-compliance-scorecard.md`

---

## 2. Usage Rule

- 一次驗證產出一份報告
- 不同 stage 可分開報告，也可合併於單一報告，但必須分段清楚
- 所有結論都應附證據來源
- 無證據支持的觀察，應放入 `Unverified` 或 `Notes`
- 不得以「整體感覺不錯」作為正式結論

---

## 3. Report Template

```md
# AI Agent Validation Report

## Metadata
- Repository:
- Date:
- Evaluator:
- Agent / Tool:
- Model / Version [if known]:
- Validation Stage:
- Report Version:

## Validation Objective
- Why this validation was performed:
- What capability was being checked:
- Expected decision outcome:

## Validation Task
- Task title:
- Task description:
- Task type:
  - Repo Understanding
  - Rule Interpretation
  - Behavioral Validation
  - Adversarial Validation
- Constraints given to agent:
- Expected deliverables:

## Inputs and Evidence Scope
### Repository Inputs
- Files / directories expected to be relevant:
- Governance files expected to be relevant:
- Other contextual files:

### Evidence Reviewed
- Agent outputs reviewed:
- File references used by agent:
- Commands / tests executed:
- Runtime evidence [if any]:
- Human observations:

## Execution Record
### Step 1
- Agent action:
- Observed behavior:
- Evidence:
- Evaluator note:

### Step 2
- Agent action:
- Observed behavior:
- Evidence:
- Evaluator note:

### Step 3
- Agent action:
- Observed behavior:
- Evidence:
- Evaluator note:

## Findings

### Passed
- Finding:
  - Evidence:
  - Why it matters:

### Failed
- Finding:
  - Evidence:
  - Why it matters:

### Unverified
- Finding:
  - Missing evidence:
  - Impact:

## Stage Scoring

### Repo Understanding Checklist
- Score:
- Summary:
- Major strengths:
- Major weaknesses:

### Rule Compliance Scorecard
- Score:
- Summary:
- Major strengths:
- Major weaknesses:

## Fail Fast Review
- Any fail-fast condition triggered: Yes / No
- If yes, which one:
- Evidence:
- Immediate consequence:

## Risk Assessment
### Residual Risks
- Risk:
  - Impact:
  - Evidence:

### Decision Risks
- Risk if agent is allowed to continue:
- Risk if agent is not allowed to continue:

## Final Decision
- Decision:
  - Rejected
  - Conditional
  - Approved for Small Tasks
  - Approved for Broader Development
- Rationale:
- Scope allowed after this decision:
- Required safeguards:

## Follow-up Actions
- Action 1:
- Action 2:
- Action 3:

## Appendix
### Raw Notes
- ...

### Relevant File Paths
- ...

### Relevant Agent Quotes
- ...
```

---

## 4. Field Guidance

### Metadata

用來標識這份報告的基本資訊。
若驗證會反覆執行，建議保留 `Report Version` 欄位。

### Validation Objective

必須明確寫出這次驗證是在驗什麼，不可只寫「驗證 agent 表現」。

較好的寫法：

- 驗證 agent 是否能正確理解 repo 啟動方式與測試入口。
- 驗證 agent 是否在小型 bugfix 任務中遵守 test-first 與 no-false-completion 規則。
- 驗證 agent 面對不完整資訊時，是否會將 unknown 明確標示，而非自行補造事實。

### Inputs and Evidence Scope

用來界定本次驗證所採納的證據範圍，避免報告引用未明確檢視的內容。

### Execution Record

用來保留 agent 的實際過程，而不只保留最終答案。

如果這一段沒有留下，後續通常很難判斷 agent 是剛好答對，還是真的遵守流程。

### Findings

需明確分成三類：

- `Passed`：有足夠證據支持的正向觀察
- `Failed`：有足夠證據支持的不通過觀察
- `Unverified`：目前證據不足，不能列入正式結論

### Stage Scoring

若本次只執行其中一個 stage，可將其他 stage 標註為：

- Not in scope
- Not evaluated

不可留白造成誤解。

### Fail Fast Review

即使總分不差，只要觸發 fail-fast condition，也應在這裡明確標記。

### Final Decision

建議只使用以下四種狀態：

- `Rejected`
- `Conditional`
- `Approved for Small Tasks`
- `Approved for Broader Development`

避免自由發揮太多近似用語，造成治理標準不一致。

---

## 5. Suggested Naming Convention

建議報告檔名規則如下：

```text
validation-report-<date>-<agent>-<stage>.md
```

例如：

```text
validation-report-2026-03-31-copilot-repo-understanding.md
validation-report-2026-03-31-gemini-behavioral.md
validation-report-2026-03-31-copilot-adversarial.md
```

---

## 6. Minimum Completion Rule

一份驗證報告至少應包含以下內容，才算有效：

- Metadata
- Validation Task
- Evidence Reviewed
- Passed / Failed / Unverified
- 至少一份 scorecard 結果
- Final Decision

若缺少上述任一項，本報告不應作為正式準入依據。

---

## 7. Operating Principle

本報告模板的目的，不是讓驗證流程變得形式化，而是確保以下事情可以被後續追溯：

- 這次驗證到底驗了什麼
- 結論是根據什麼做出的
- 哪些其實還沒有被驗證
- 為什麼最後做出這個準入決策

