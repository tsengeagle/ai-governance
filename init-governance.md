/init

This repository contains a project manifest:

ai/project-context.yaml

Use this file as the authoritative project context.

The manifest defines:
- system context
- organization architecture rules
- AI governance expectations

Do not duplicate this information in the output.
Instead use it to guide reasoning.

---

Manifest placeholders

The manifest may contain placeholders such as:

AUTO
  The agent should infer this information from repository analysis
  (e.g. frameworks, build tools, API style, ORM).

UNKNOWN
  The agent cannot infer this automatically and should leave it unchanged.
  Questions related to UNKNOWN fields should be listed under "Missing Human Context".

When AUTO fields exist, analyze repository evidence (build files, dependencies, directory structure) and propose inferred values.

---

Pilot Objective

This repository is being used as a **pilot project** to derive future **organization-wide AI governance rules**.

The goal of this initialization is **not to produce documentation**, but to bootstrap a governance model that will later be reused across repositories.

When analyzing the repository, distinguish between:

1. Repository-specific rules  
   Rules tied to this repository’s stack, framework, entry points, or legacy contracts.

2. Candidate shared rules  
   Rules that may generalize across repositories in the organization.

Typical shared rule categories include:
- architecture principles
- design principles
- AI working rules
- commit protocol
- workflow structure

When uncertain, classify rules as repository-specific rather than prematurely generalizing them.

---

Analysis Inputs

Use the following sources:

1. Repository contents
2. ai/project-context.yaml
3. Build configuration and dependencies
4. Directory structure and framework conventions

Treat repository evidence as the primary source of truth.

---

Output Sections

Produce the following sections.

# Repository Facts
Facts directly observable from the repository.

Examples:
- framework detected
- build system
- API style
- module structure
- entry point patterns

Do not include speculation.

---

# Working Assumptions
Reasonable inferences that require human confirmation.

Examples:
- probable orchestration layer
- inferred entry points
- likely integration patterns

Clearly label them as assumptions.

---

# AI Guardrails
Explicit rule-style constraints AI agents must follow when modifying this repository.

Examples:

- prefer minimal localized changes
- preserve service boundaries
- preserve existing module boundaries
- avoid modifying external contracts without confirmation
- do not assume behavior of other repositories

Guardrails should be written as rules, not descriptions.

---

# Candidate Shared Rules
Rules that may generalize across the organization.

Focus on patterns such as:

- architecture principles
- design conventions
- AI working rules
- commit protocol expectations
- workflow structures

These rules should be written generically enough to apply across repositories.

---

# Missing Human Context
Information that cannot be inferred automatically but is required to produce reliable AI instructions.

Examples:
- external integration contracts
- critical domain workflows
- backward compatibility guarantees
- operational constraints

List questions for system owners.

---

# Suggested Next Files
Recommend governance files to generate next, aligned with the repository structure.

Possible outputs include:

AGENTS.md

ai/repo-rules/
- <stack>-coding-rules.md
- <stack>-forbidden-patterns.md

ai/workflows/
- implement-change.md
- fix-bug.md
- review-code.md

ai/shared/
- architecture-principles.md
- design-principles.md
- ai-working-rules.md
- commit-protocol.md

Prefer generating repository-specific rules before shared rules.

---

Constraints

Do:
- Prefer minimal localized changes.
- Preserve existing architecture and service boundaries.
- Treat legacy frameworks and patterns as intentional unless explicitly told otherwise.
- Distinguish repository-specific rules from candidate organization-wide rules.

Do not:
- Convert assumptions into facts.
- Recommend modernization refactors by default.
- Assume modern frameworks unless confirmed.
- Ignore legacy compatibility risks.
- Generalize repository-specific legacy behavior into organization-wide rules without justification.
