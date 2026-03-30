# Contract and Compatibility Rules

## 1. Purpose

This document defines the baseline rules for contract safety and compatibility in AI-assisted software work.

It answers one question:

> When an AI agent changes code that may affect existing consumers, integrations, data shapes, or stable behavior, how must compatibility be protected?

These rules focus on:
- backward compatibility
- external contract safety
- compatibility risk disclosure
- controlled breaking change handling
- grandfathering and migration discipline

These rules do not define:
- AI workflow ordering
- architecture boundary theory
- domain modeling principles
- implementation validation mechanics in general
- commit formatting

Those belong in other documents.

---

## 2. Scope

These rules apply whenever work may affect any of the following:

- public or internal APIs
- request / response payloads
- event schemas
- file formats
- database-visible behavior relied on by other modules
- integration contracts with external systems
- stable command-line behaviors
- configuration behaviors relied on operationally
- repository-level conventions that other code already depends on

These rules also apply to behavior changes that are not formally versioned but are already depended on in practice.

For untouched legacy behavior:
- apply grandfathering
- preserve compatibility unless explicitly authorized otherwise
- avoid silent contract drift

---

## 3. Compatibility First as the Default

The default assumption is:

> Existing working integrations and expected behaviors must not be broken silently.

AI agents must treat compatibility as a first-class constraint, not as an optional polish step.

### Required behavior
- assume existing consumers may rely on current behavior
- protect backward compatibility by default
- consider both formal contracts and de facto runtime expectations
- prefer additive change over breaking replacement where practical

### Forbidden behavior
- changing externally visible behavior without evaluating compatibility impact
- assuming “internal only” means “safe to break”
- treating absence of explicit versioning as permission to change shape freely

---

## 4. Identify the Contract Surface Before Changing It

Before modifying a potentially shared behavior, the agent must identify what contract surface is involved.

Contract surface may include:
- endpoint paths
- HTTP methods
- request fields
- response fields
- status codes
- header usage
- event names and payloads
- file names and formats
- DB columns or derived outputs consumed elsewhere
- CLI arguments or command output shape
- expected nullability / optionality / enum ranges
- semantic behavior relied on by downstream users

### Required behavior
Before making a contract-affecting change, identify:
- what consumers may exist
- what part of the contract is changing
- whether the change is additive, restrictive, or breaking
- what compatibility protection is required

### Forbidden behavior
- changing payload shape or semantics without mapping the affected contract surface
- assuming only direct code references matter
- ignoring de facto behavior that downstream users may already depend on

---

## 5. Prefer Additive Change Over Breaking Change

When evolution is necessary, prefer changes that preserve existing consumers.

### Preferred patterns
- adding optional fields instead of replacing existing ones
- accepting old and new input forms during a transition window
- introducing new endpoints/messages rather than silently changing old ones
- marking behavior as deprecated before removal where feasible
- preserving old semantics while introducing new capability under explicit versioning or flags

### Forbidden behavior
- removing or renaming fields without explicit compatibility handling
- changing data meaning while keeping the same field name silently
- narrowing accepted input without disclosure
- converting previously optional behavior into mandatory behavior without transition handling

---

## 6. Breaking Changes Must Be Explicit

Breaking changes are not forbidden in all cases, but they are never the default.

A breaking change is any change that may cause an existing consumer, workflow, script, or dependent module to fail or behave differently in an incompatible way.

### Required behavior
If a breaking change is unavoidable, the agent must explicitly identify:
- what is breaking
- who may be affected
- why additive or compatible alternatives are insufficient
- what migration or rollout handling is required
- what evidence exists that the break is authorized

### Forbidden behavior
- hiding breaking changes inside refactoring or cleanup
- presenting breaking changes as harmless simplification
- making contract changes first and documenting them later
- assuming review will “catch it later”

---

## 7. Preserve Semantic Compatibility, Not Only Structural Compatibility

Compatibility is not only about field presence.
It also includes meaning.

### Required behavior
Protect:
- field meaning
- business semantics
- ordering assumptions where meaningful
- status code expectations
- error behavior relied upon by clients
- accepted value ranges and interpretations
- default behaviors and side effects

### Forbidden behavior
- keeping the same shape while silently changing business meaning
- changing success/failure semantics without disclosure
- changing default values or interpretation in ways that surprise existing consumers

---

## 8. Grandfathering for Legacy Contracts

Legacy contracts may be imperfect, inconsistent, or poorly structured.
They must still be treated carefully if consumers already depend on them.

### Required behavior
- preserve stable legacy contracts by default
- apply stronger compatibility discipline to new or materially modified logic
- isolate improvement behind new versions, adapters, or migration paths where practical
- document legacy oddities instead of breaking them casually

### Forbidden behavior
- “fixing” legacy contract quirks without confirming impact
- using quality or architecture cleanup as a reason to break long-lived consumers
- forcing downstream systems to adapt unexpectedly just to improve local neatness

---

## 9. Migration and Deprecation Must Be Deliberate

If change must occur over time, migration handling must be explicit.

### Required behavior
Where applicable, define:
- old behavior
- new behavior
- transition strategy
- deprecation status
- coexistence window
- required consumer action
- rollback or fallback strategy if relevant

### Forbidden behavior
- silent cutover without migration thinking
- removing old behavior with no transition plan when consumers may still rely on it
- labeling something “deprecated” without any actual transition guidance

---

## 10. Contract Safety Applies to Internal Systems Too

Internal consumers still count as consumers.

### Required behavior
Treat the following as compatibility-sensitive when relied on by other modules or teams:
- internal REST endpoints
- shared DTOs
- repository-visible outputs
- DB interfaces used across modules
- shared event payloads
- generated artifacts
- scripts and automation hooks

### Forbidden behavior
- assuming private/internal means no compatibility obligations
- changing internal contracts casually because they are “not public”
- ignoring cross-module coupling inside a multi-repo or SOA environment

---

## 11. Validation Must Match Compatibility Risk

Compatibility-sensitive changes require validation that matches the risk level.

### Required behavior
As applicable, use:
- contract tests
- integration tests
- replay or sample payload verification
- backward compatibility checks
- schema comparisons
- consumer-impact review
- manual reproducible checks for legacy workflows
- diff-based behavior inspection for generated outputs

If compatibility cannot be fully verified, the agent must state that limitation explicitly.

### Forbidden behavior
- treating compile success as proof of compatibility
- validating only the producer side while ignoring consumer expectations
- claiming compatibility preservation with no evidence path

---

## 12. Compatibility Impact Must Be Reported Clearly

For compatibility-relevant work, the agent must report the impact clearly.

### Required behavior
The result should distinguish:
- what contract surface was touched
- whether the change is compatible, additive, or potentially breaking
- what validation was used
- what remains unverified
- whether grandfathering, migration, or deprecation applies

### Forbidden behavior
- burying compatibility impact in general change summaries
- failing to mention affected consumers or downstream risk
- presenting compatibility-sensitive changes as ordinary code cleanup

---

## 13. Repository and Environment Context Matter

Compatibility handling must match actual repository and environment context.

### Required behavior
- use project context and repository evidence to determine what must remain stable
- respect repository-specific contract conventions
- consider real operational usage, not only ideal documentation state
- prefer conservative interpretation when dependency visibility is incomplete

### Forbidden behavior
- assuming all repositories have clean versioned contracts
- assuming undocumented behavior is unimportant
- imposing a generic compatibility policy while ignoring local system realities

---

## 14. Legacy and Compatibility Clause

For repositories with legacy or long-lived integrations:

- preserve stable behavior first
- treat undocumented but relied-upon behavior as compatibility-relevant
- apply stronger change discipline to:
  - shared interfaces
  - external integrations
  - materially modified contract surfaces
  - migration-sensitive areas

If ideal cleanup conflicts with compatibility, compatibility wins unless the task explicitly authorizes managed breaking change handling.

---

## 15. Relationship to Other Shared Rules

This file defines compatibility and contract safety rules only.

It does not replace:
- `ai-working-rules.md` for AI working behavior
- `architecture-principles.md` for structural boundaries
- `design-principles.md` for domain meaning and modeling
- `code-quality-baseline.md` for implementation quality and validation discipline in general
- `commit-protocol.md` for delivery and traceability conventions

Use this file when the question is:
- will this change break an existing consumer?
- is this contract change additive or breaking?
- what migration or grandfathering is required?
- how should compatibility impact be disclosed?

---

## 16. One-Sentence Summary

> Treat existing consumers and stable behavior as protected by default, identify contract surfaces before changing them, prefer additive evolution, make breaking changes explicit, and never allow cleanup or redesign goals to silently override compatibility obligations.