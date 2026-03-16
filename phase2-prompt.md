/derive-organization-rules

This repository was used as a pilot project for AI-assisted development governance.

Analyze the existing governance artifacts in this repository:

- ai/project-context.yaml
- AGENTS.md
- ai/repo-rules/
- ai/shared/
- ai/workflows/

The goal is to derive a baseline **organization-wide AI governance framework** for the HIS system.

---

Analysis Goals

Separate rules into three categories:

1. Repository-Specific Rules
   Rules tied to this repository’s technology stack, framework, or legacy architecture.

2. Candidate Organization Rules
   Rules likely applicable across repositories.

3. Rules That Require Abstraction
   Rules that appear general but currently reference specific frameworks or components.

---

Produce the following sections.

# Repository-Specific Rules
Rules that should remain at the repository level.

Examples:
- grails-specific coding rules
- flex-specific UI constraints
- repository-specific integration contracts

---

# Candidate Organization Rules
Rules that appear reusable across repositories.

Focus on:

- architecture principles
- design principles
- AI working rules
- commit protocol
- workflow structure

These should be rewritten to remove repository-specific references.

---

# Rules That Require Abstraction
Rules that may apply organization-wide but currently depend on a specific stack.

Example:

"Do not bypass Grails services"

should become

"Do not bypass application service layers".

---

# Proposed Organization AI Governance Structure

Suggest a directory structure for a shared baseline such as:

organization-ai/

shared/
  architecture-principles.md
  design-principles.md
  ai-working-rules.md
  commit-protocol.md
  contract-and-compatibility-rules.md

workflow-templates/
  implement-change.md
  fix-bug.md
  review-code.md

---

# Migration Plan

Explain how future repositories should adopt the organization baseline.

Include:

- which files should be copied
- which files should remain repo-specific
- how project-context.yaml should reference organization rules

---

Constraints

Do not assume this repository represents all repositories.
When uncertain, keep rules repository-specific rather than over-generalizing.
