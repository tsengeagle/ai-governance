# Frontend UI Governance

## 1. Enterprise UI First
When implementing or modifying UI:
- always check whether the enterprise UI library already provides an equivalent component
- prefer direct usage of enterprise-standard components over custom local implementation
- do not recreate buttons, dialogs, inputs, tables, tabs, cards, badges, layout primitives, or form controls if standard components already exist

## 2. Allowed Custom UI Cases
Custom local UI is allowed only when:
- no equivalent component exists in the enterprise UI library
- composition of existing standard components cannot satisfy the requirement
- the gap is explicitly documented in the change summary

## 3. Required Evidence
Before implementing UI changes, the agent must identify:
- which enterprise component should be used
- where it is located
- whether any wrapper or composition pattern already exists in the repo

## 4. Forbidden Actions
- copying visual style without using the official component
- introducing alternative component APIs for an existing standard component
- hardcoding colors, spacing, or typography when design tokens already exist
- bypassing enterprise form, modal, table, or navigation patterns