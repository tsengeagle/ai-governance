你現在要執行「AI agent 規則理解檢查」。

請讀取 repo 內現有的 AI 治理文件，整理出：

1. 你在此 repo 中必須遵守的工作流程規則
2. 你在此 repo 中必須遵守的工程規則
3. 哪些行為是被禁止的
4. 若要修改程式碼，事前必須先完成哪些步驟
5. 若任務無法驗證，你應如何回報
6. 對於完成宣稱，你必須遵守哪些 validation / acceptance 規則
7. completion judgement 與 coverage boundary 應如何表達
8. 若本輪只是 validation-only，你應如何表達，哪些說法不可以用
9. 這些規則分別是從哪一份文件得出

限制：
- 僅可依 repo 內現有治理文件回答
- 不可用通用最佳實務取代 repo 規則
- 每一條規則都要附來源檔案
- 若規則不完整或互相衝突，要明確指出
- 若 repo 內尚未落實 validation / acceptance 規則，必須明確指出缺口，不可自行補造

輸出格式：
- required_workflow_rules
- required_engineering_rules
- prohibited_behaviors
- pre_execution_checklist
- completion_claim_rules
- validation_acceptance_rules
- completion_judgement_and_coverage_boundary_rules
- validation_only_scope_rules
- rule_gaps_or_conflicts