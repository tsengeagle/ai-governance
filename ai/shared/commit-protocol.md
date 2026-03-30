# Commit Protocol

## 1. Purpose

This document defines the baseline rules for commit and delivery protocol in AI-assisted software work.

It answers one question:

> After an AI agent completes a unit of work, how should the result be described and recorded so that it is reviewable, traceable, and not misleading?

These rules focus on:
- commit message structure
- traceability
- delivery summary
- validation summary
- risk disclosure
- assumption disclosure
- AI-generated work attribution

These rules do not define:
- architecture principles
- design modeling rules
- implementation quality rules in general
- compatibility policy in full
- governance workflow ordering

Those belong in other documents.

---

## 2. Scope

These rules apply to:
- code changes
- documentation changes
- governance file changes
- configuration changes
- generated artifact updates when committed
- repository-level guidance updates

These rules apply whenever AI-assisted work produces a change that is ready to be handed off for review, commit, or formal summary.

---

## 3. Core Principle

A commit or delivery description must help a reviewer answer all of the following:

- what changed
- why it changed
- how it was validated
- what remains uncertain
- what risk or uncovered scope remains
- whether the result is additive, corrective, structural, or governance-related

The goal is not just to produce a syntactically valid commit message.
The goal is to produce a traceable record of intent and evidence.

---

## 4. Commit Scope Must Match Actual Scope

The described scope must match the actual change.

### Required behavior
- describe the real primary purpose of the change
- keep the commit description aligned with the actual modified area
- distinguish implementation, bug fix, refactor, governance alignment, compatibility handling, and documentation work
- if a change bundle includes more than one type of work, disclose that clearly

### Forbidden behavior
- labeling broad mixed work as if it were a tiny focused change
- hiding refactor inside a bug-fix description
- hiding contract-impacting change inside generic wording like “cleanup”
- using a commit label that understates the real review risk

---

## 5. Preferred Commit Message Structure

Use a structured conventional style whenever the repository or organization expects it.

A preferred baseline is:

```text
<type>(<scope>): <short summary>
```

Examples of common `type` values:

* feat
* fix
* refactor
* docs
* chore
* test
* build
* ci

The exact allowed set may be repository-specific.

### Required behavior

* keep the summary short and factual
* use scope when it clarifies review context
* align the type with the actual dominant purpose

### Forbidden behavior

* vague summaries like “update stuff” or “misc changes”
* overstated summaries like “fully fixes everything”
* using feat/fix/refactor labels carelessly when the actual change does not match

---

## 6. Commit Message Body Must Add Review Value

When a body is used, it should help a reviewer understand the change beyond the title line.

### Recommended body content

* what was changed
* why the change was needed
* what was intentionally not changed
* what assumptions were made
* what validation was performed
* what remains pending or unverified

### Forbidden behavior

* repeating the title line with no added value
* using the body only for motivational language
* hiding major limitations outside the body

---

## 7. AI Trailer is Required When Organization Policy Demands It

When AI-generated or AI-assisted work must be traceable, a trailer should be added.

Example patterns may include:

* `AI-Assisted: yes`
* `AI-Generated: partial`
* `AI-Reviewed: yes`
* repository-specific trailer formats

The exact wording may be repository- or organization-specific.

### Required behavior

* use the repository or organization’s expected trailer format
* keep AI attribution factual
* distinguish AI-assisted from fully human-authored only if the policy requires that distinction

### Forbidden behavior

* omitting required AI traceability markers
* overstating or understating AI involvement contrary to policy
* inventing a trailer format when a repository standard already exists

---

## 8. Change Summary Must Be Included in Delivery Context

For AI-assisted work, the delivery should include a concise change summary, whether in commit body, PR text, task output, or accompanying summary.

### Required behavior

The change summary should state:

* the main files or areas changed
* the purpose of the change
* the intended behavioral or structural effect

### Forbidden behavior

* forcing reviewers to infer the change purpose only from raw diff
* using generic text that gives no real inspection shortcut

---

## 9. Validation Summary Must Be Included

A delivery without validation context is incomplete.

### Required behavior

The validation summary should distinguish:

* what validation was executed
* what passed
* what was not executed
* what remains unverified

Validation may include:

* build
* compile
* tests
* lint
* contract verification
* script execution
* manual reproducible checks
* log / response inspection

### Forbidden behavior

* saying “validated” with no explanation
* implying full verification when only partial verification was done
* omitting major validation gaps from delivery summary

---

## 10. Assumptions and Pending Confirmation Must Be Visible

If the work relied on assumptions or incomplete repository knowledge, that must be disclosed.

### Required behavior

Explicitly note:

* assumptions used
* pending confirmation items
* unknowns that may affect confidence

### Forbidden behavior

* presenting assumption-based work as fully confirmed
* burying uncertainty in vague wording
* omitting dependency on unconfirmed repository facts

---

## 11. Risk and Uncovered Scope Must Be Visible

AI-assisted delivery must help reviewers understand remaining risk.

### Required behavior

Where relevant, disclose:

* uncovered scenarios
* unvalidated paths
* compatibility-sensitive areas
* known local limitations
* follow-up work that may still be needed

### Forbidden behavior

* presenting a risky change as routine with no disclosure
* hiding unverified edge cases
* implying “done” means “no remaining risk”

---

## 12. Compatibility Impact Must Be Explicit When Relevant

If a change affects contract or compatibility, delivery text must say so.

### Required behavior

State whether the change is:

* compatible
* additive
* potentially breaking
* grandfathered
* migration-sensitive

When applicable, summarize:

* what contract surface changed
* who may be affected
* what compatibility validation was done

### Forbidden behavior

* burying compatibility-sensitive changes in generic summaries
* treating external-facing changes as ordinary cleanup
* omitting downstream impact where it is relevant

---

## 13. Governance Changes Must Be Labeled Clearly

Changes to governance files are not ordinary code changes and should be described as such.

### Required behavior

When updating governance structure, rules, context, or alignment-related files, state clearly:

* whether the change is init-related, continue-related, or alignment-related
* what governance layer was changed
* whether the change adds, updates, or reconciles existing rules

### Forbidden behavior

* describing governance changes as generic docs cleanup
* hiding rule changes under unrelated commit types
* making reviewers guess whether repository behavior expectations changed

---

## 14. Delivery Language Must Stay Within Evidence

Commit and delivery wording must not exceed verified reality.

### Required behavior

Use factual language such as:

* added
* updated
* aligned
* clarified
* validated with
* pending confirmation
* partially verified

### Forbidden behavior

* “fully solved” without evidence
* “complete” when significant scope remains unverified
* “safe” when compatibility or runtime impact is still uncertain
* confidence wording that exceeds actual validation

---

## 15. Repository-Specific Commit Policy Wins on Format

This file defines the baseline protocol.
If the repository already has a stricter or more specific commit format, trailer format, or PR protocol, that repository rule wins.

### Required behavior

* adapt this protocol to repository-specific format rules
* keep the meaning and evidence discipline even if formatting changes
* preserve traceability even when delivery medium is not a git commit itself

### Forbidden behavior

* ignoring repository-specific commit conventions
* treating format flexibility as permission to remove substance
* using “different repo style” as an excuse to omit validation or risk disclosure

---

## 16. Minimum Delivery Fields for AI-Assisted Work

Unless a repository defines stricter requirements, the minimum delivery information should include:

* change-summary
* validation-summary
* assumptions-and-pending-confirmation
* risk-and-uncovered-scope
* proposed-commit-message

This may be recorded in:

* commit body
* PR description
* task output
* governance alignment report
* repository-defined review template

---

## 17. Relationship to Other Shared Rules

This file defines delivery and traceability protocol only.

It does not replace:

* `ai-working-rules.md` for agent workflow discipline
* `architecture-principles.md` for structural rules
* `design-principles.md` for domain meaning and modeling
* `code-quality-baseline.md` for implementation quality and validation discipline
* `contract-and-compatibility-rules.md` for compatibility and contract safety

Use this file when the question is:

* how should this work be described for review?
* what delivery metadata must be included?
* how should AI-assisted work remain traceable?
* how should validation and residual risk be reported?

---

## 18. One-Sentence Summary

> Describe the real scope of change, use structured commit wording, include validation and residual risk explicitly, disclose assumptions and compatibility impact when relevant, and never let delivery language overstate what has actually been verified.
