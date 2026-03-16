/init

請不要只產出一般 repository summary。
我要的是一份可作為 HIS legacy 核心模組 pilot 的 AI instruction 初始化結果。

這個 repo 屬於：
- HIS 系統中的核心模組
- 舊架構 repo
- 組織整體為 SOA，多個 repo 依領域拆分
- 單一 repo 不混用新舊架構
- 我希望 AI 後續能遵守架構規範、設計規範、編碼規範、workflow、commit protocol

請根據目前 repo 中能確認的內容，產出結果時務必遵守以下要求：

1. 僅把可直接從 repository 掃描確認的內容列為事實
不要把推測寫成事實。

2. 任何不確定但可能重要的內容，都放進 Working Assumptions
並標示需要人工確認。

3. 請特別整理以下資訊：
- 真正的主要 entry points 是什麼
- 核心 orchestration flow 在哪一層
- 哪些區域屬於 architecture-sensitive
- 哪些區域可能屬於 compatibility-sensitive
- AI 最容易做錯的 modernization / cleanup 類型是什麼

4. 請產出一組 AI Guardrails
寫成規則句型，例如：
- preserve service boundaries
- prefer minimal localized changes
- do not perform modernization refactors
- do not rename external contracts without confirmation
- do not assume behaviour of other repositories

5. 請另外列出 Missing Human Context
也就是這個 repo 若要形成真正可用的 instruction，還需要由系統負責人補充哪些背景資訊。

6. 請不要只做介紹文件，要讓輸出結果能成為後續這些檔案的草稿來源：
- AGENTS.md
- .github/copilot-instructions.md
- ai/shared/commit-protocol.md
- ai/workflows/implement-change.md
- ai/repo-rules/grails-forbidden-patterns.md

禁止事項：
- 不要把推測寫成事實
- 不要只輸出一般 README 式介紹
- 不要直接推薦 modernization 重構
- 不要假設這個 repo 採用 Spring Boot / modern REST 慣例
- 不要忽略 legacy compatibility 風險

輸出格式固定為：

# Repository Facts
# Working Assumptions
# AI Guardrails
# Missing Human Context
# Suggested Next Files
