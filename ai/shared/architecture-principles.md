# Architecture Principles

## 1. Purpose

This document defines architecture-level principles for AI-assisted software work.

It answers one question:

> When an AI agent changes or adds code, what architectural boundaries must be preserved or strengthened?

These principles focus on:
- separation of responsibilities
- dependency direction
- boundary protection
- integration isolation
- change containment

These principles do not define:
- AI workflow discipline
- test strategy details
- commit formatting
- repository-specific file locations
- path-specific implementation rules

Those belong in other documents.

---

## 2. Scope

These principles apply to:
- new code
- newly added logic
- materially modified logic
- explicit refactoring work

For untouched legacy areas:
- apply grandfathering
- do not force broad rewrites
- do not degrade compatibility just to improve architectural purity

If ideal structure conflicts with backward compatibility or repository stability, the agent must prefer:
1. correctness
2. compatibility
3. controlled local improvement
4. explicit follow-up recommendation instead of implicit redesign

---

## 3. Core Architectural Direction

AI agents should move code toward a structure where:

- business rules are separated from delivery mechanisms
- use-case orchestration is separated from transport and persistence details
- integration concerns are isolated
- dependencies flow inward toward business meaning, not outward toward framework convenience
- responsibilities remain explicit and reviewable

This direction may be expressed through Clean Architecture, layered architecture, hexagonal patterns, or repository-specific equivalents.

The exact pattern may vary by repository.
The required constant is not a specific diagram, but boundary discipline.

---

## 4. Preserve Clear Responsibility Layers

AI agents must preserve or improve responsibility separation.

Typical responsibility areas include:

- entrypoints / interfaces
- application / orchestration
- domain / business rules
- persistence / infrastructure
- external integration

A repository may use different names, but the responsibility split must remain understandable.

### Required behavior
- keep request handling near entrypoints
- keep orchestration in application/service-level components
- keep business rules in business-owning components
- keep persistence logic in repositories, gateways, DAOs, or equivalent infrastructure units
- keep external protocol handling at the integration boundary

### Forbidden behavior
- placing substantial business logic directly in controllers, routes, handlers, views, or UI components
- placing transport or persistence handling inside core business logic unless existing legacy structure already forces it
- mixing multiple responsibility layers into one new unit without explicit reason
- expanding an already mixed legacy area further when a clearer local boundary is possible

---

## 5. Protect Dependency Direction

Dependencies should point toward policy and business meaning, not toward accidental technical detail.

### Required behavior
- keep higher-level rules from depending directly on lower-level technical mechanisms when avoidable
- preserve repository-specific abstractions where they already exist
- prefer stable interfaces, repositories, gateways, or clients over direct low-level coupling
- isolate framework and infrastructure dependencies away from core business decisions

### Forbidden behavior
- introducing new cross-layer shortcuts for convenience
- letting business logic depend directly on protocol, ORM, database, UI, or SDK details without reason
- inverting the repository’s established dependency direction unless the task explicitly requires it

---

## 6. Isolate External Integration Boundaries

External systems must be handled at explicit boundaries.

This includes:
- REST
- SOAP
- FHIR
- database access
- message queues
- files
- third-party SDKs
- system APIs

### Required behavior
- keep protocol-specific handling near adapters, clients, repositories, gateways, or equivalent boundaries
- keep payload mapping, serialization, and transformation near the boundary
- keep retry, timeout, fallback, and transport-level concerns outside pure business logic

### Forbidden behavior
- embedding protocol handling deep inside domain logic
- duplicating external integration behavior across unrelated modules without clear reason
- mixing business decisions with payload parsing or transport logic in the same new component

---

## 7. Keep Business Logic Close to Business Meaning

Architectural quality is not only about layers; it is also about where business decisions live.

### Required behavior
- place business decisions where business ownership is clear
- keep use-case logic in components that represent application intent
- keep domain rules in domain-owning components when repository structure supports it
- keep orchestration separate from raw transport/persistence detail

### Forbidden behavior
- hiding business rules inside low-level helpers, utils, mappers, or adapters
- distributing one business decision across unrelated technical layers without explicit structure
- using architecture as a pretext to obscure where responsibility really belongs

---

## 8. Prefer Explicit Boundaries Over Implicit Coupling

AI agents should make system boundaries easier to see, not harder.

### Required behavior
- make responsibility boundaries visible in file/module/class structure where feasible
- preserve repository conventions that already communicate ownership clearly
- prefer explicit coordination points over hidden side effects

### Forbidden behavior
- introducing hidden coupling across modules
- using generic shared helpers to bypass layer responsibility
- creating unclear “god” services, managers, or utilities that absorb multiple architectural roles

---

## 9. Contain Change Scope

Architectural discipline includes limiting the blast radius of change.

### Required behavior
- keep changes as localized as possible
- avoid changing unrelated layers without explicit reason
- separate immediate fixes from optional structural improvements
- recommend broader refactor separately rather than mixing it into a small task

### Forbidden behavior
- using a small task to justify large architectural rewrites
- restructuring unrelated packages/modules while claiming a narrow task scope
- changing multiple architectural layers when a smaller, controlled boundary change would suffice

---

## 10. Respect Repository-Specific Architecture

Different repositories may implement different valid structural patterns.

An AI agent must not assume:
- every backend is Spring Boot
- every legacy backend is Grails
- every repository cleanly maps to textbook Clean Architecture
- every module name has the same role across repositories

### Required behavior
- infer architectural roles from actual repository structure and declared project context
- align new structure with the repository’s existing architectural vocabulary
- use shared principles without forcing identical shapes across all repositories

### Forbidden behavior
- imposing a universal structure blindly
- rewriting repository-specific conventions into abstract ideals without task authorization
- assuming architectural role names without checking source context

---

## 11. Architecture Improvement Must Be Incremental

Architecture principles define the direction of change, not blanket permission for cleanup.

### Required behavior
- apply better boundaries to new and materially modified code
- strengthen local structure where the task already touches the area
- record larger architectural problems as follow-up recommendations if needed
- preserve stable untouched areas when the task does not require wider change

### Forbidden behavior
- using architecture principles as justification for incidental refactor
- forcing repository-wide cleanup from a local task
- treating old structural impurity as an automatic reason to redesign

---

## 12. Legacy and Compatibility Clause

For legacy repositories or mixed-architecture repositories:

- preserve stable behavior first
- improve structure incrementally
- do not require full conformance in untouched code
- apply stronger architectural discipline mainly to:
  - new files
  - newly added logic
  - materially modified logic
  - explicitly scoped refactoring work

If architectural purity and compatibility conflict, compatibility wins unless the task explicitly authorizes managed breaking change work.

---

## 13. Relationship to Other Shared Rules

This file defines structural principles only.

It does not replace:
- `ai-working-rules.md` for agent behavior
- `design-principles.md` for domain language and modeling quality
- `code-quality-baseline.md` for implementation quality and validation discipline
- `contract-and-compatibility-rules.md` for external contract safety
- `commit-protocol.md` for delivery and traceability rules

When a rule is primarily about:
- how the agent works -> that belongs in `ai-working-rules.md`
- how business meaning is modeled -> that belongs in `design-principles.md`
- how code changes are validated -> that belongs in `code-quality-baseline.md`

---

## 14. One-Sentence Summary

> Preserve clear responsibility layers, protect dependency direction, isolate external integrations, keep business logic close to business meaning, and improve architecture incrementally without using local tasks as an excuse for uncontrolled redesign.