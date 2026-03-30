# Design Principles

## 1. Purpose

This document defines design-level principles for AI-assisted software work.

It answers one question:

> When an AI agent designs or reshapes code, how should business meaning, responsibility, and modeling quality be preserved?

These principles focus on:
- domain meaning
- naming quality
- responsibility clarity
- modeling discipline
- cohesion of business concepts

These principles do not define:
- AI workflow discipline
- dependency direction at architecture level
- validation mechanics
- commit formatting
- repository-specific file paths

Those belong in other documents.

---

## 2. Scope

These principles apply to:
- new code
- newly added logic
- materially modified logic
- explicit design improvement work
- refactoring where design responsibility is affected

For untouched legacy areas:
- apply grandfathering
- do not force broad redesign
- improve only where the task already creates legitimate change scope

If ideal design conflicts with compatibility or repository stability, preserve stable behavior first and improve design incrementally.

---

## 3. Core Design Direction

AI agents should move code toward designs where:

- business concepts are represented clearly
- responsibilities are understandable and cohesive
- naming reflects domain meaning
- one unit owns one kind of decision as much as practical
- technical convenience does not erase business intent

This direction may be expressed through DDD ideas such as:
- ubiquitous language
- bounded contexts
- explicit domain concepts
- responsibility-centered design

The repository does not need to match textbook DDD mechanically.
The requirement is design clarity, not terminology theater.

---

## 4. Prefer Business Meaning Over Technical Convenience

Design should reflect what the system is doing for the business, not just what mechanism is being used.

### Required behavior
- use names that reflect business meaning
- keep business concepts visible in modules, classes, and functions
- align code structure with domain responsibilities where feasible
- prefer language already used by the repository, project context, specs, or domain experts

### Forbidden behavior
- naming important components only by technical mechanism
- hiding business responsibilities behind generic names like `Helper`, `Manager`, `Processor`, or `Util` when more meaningful naming is possible
- introducing new domain terminology that conflicts with existing repository vocabulary without reason

---

## 5. Keep Responsibility Cohesive

A design unit should have a clear reason to exist and a coherent responsibility.

### Required behavior
- keep related business decisions together
- avoid scattering one business rule across many unrelated units
- define components so their responsibility can be explained in a short sentence
- keep orchestration, business rules, mapping, persistence, and integration concerns from collapsing into one ambiguous unit unless legacy structure already forces that shape

### Forbidden behavior
- creating “god” services or generic components that absorb unrelated responsibilities
- splitting tightly related business behavior across multiple layers without clear ownership
- using vague abstractions that make responsibility harder to locate

---

## 6. Use Ubiquitous Language Carefully

AI agents should preserve or strengthen shared domain language.

### Required behavior
- prefer terminology that matches actual business usage
- keep naming consistent within the same business area
- use repository context, project context, specs, and existing domain language as naming sources
- when introducing new terms, make sure they clarify rather than obscure meaning

### Forbidden behavior
- using multiple names for the same domain concept without reason
- using the same term for multiple different concepts in the same context
- replacing existing meaningful domain language with fashionable but less precise vocabulary

---

## 7. Model Domain Concepts Explicitly When Useful

Business concepts should not disappear into generic technical code when explicit modeling would improve clarity.

### Required behavior
- represent important domain concepts explicitly where the repository structure supports it
- keep decision-making logic close to the concept that owns it
- use clear distinctions between business concepts when those distinctions matter to behavior

### Forbidden behavior
- flattening all business meaning into generic DTO/service/helper flows
- encoding important business rules only as incidental conditionals with no conceptual ownership
- creating pseudo-domain structures with no real business meaning just to appear “DDD-like”

---

## 8. Avoid Design by Indirection Alone

Abstraction is not automatically good design.
A design is better only if it improves meaning, ownership, and changeability.

### Required behavior
- use abstraction when it clarifies responsibility or reduces harmful coupling
- keep indirection justified by real design value
- prefer direct and understandable structure over ceremony

### Forbidden behavior
- introducing layers, factories, wrappers, or indirection with no clear ownership benefit
- replacing understandable code with abstract patterns purely for appearance
- using design jargon to justify unnecessary complexity

---

## 9. Keep Data Shape and Business Meaning Distinct

Not every data container is a domain model, and not every domain concept should be reduced to transport shape.

### Required behavior
- distinguish business meaning from transport or persistence representation when the distinction matters
- avoid letting request/response payload shape define the entire design of core logic
- preserve business intent even when adapting to external schemas or legacy structures

### Forbidden behavior
- treating external payload structure as the domain model by default
- letting storage format or wire format erase business distinctions
- collapsing all domain decisions into flat mapping code

---

## 10. Design for Change in the Right Place

Good design places likely change in contained, understandable locations.

### Required behavior
- keep policy decisions near their natural owners
- isolate volatile external or technical details from stable business meaning
- structure code so changes in one business area do not require unnecessary edits elsewhere

### Forbidden behavior
- placing change-prone business rules in low-visibility helpers or shared utilities
- coupling unrelated business areas through overly generic abstractions
- making simple business changes require edits across many technical layers without need

---

## 11. Prefer Incremental Design Improvement

Design quality should improve progressively as real changes happen.

### Required behavior
- improve naming, responsibility clarity, and concept ownership when already touching the relevant area
- use new code as an opportunity to set cleaner design direction
- separate local improvement from broad redesign
- record larger design issues as follow-up recommendations when necessary

### Forbidden behavior
- using a small task to justify large-scale design overhaul
- forcing repository-wide redesign just because a better model is imaginable
- rewriting stable legacy structures without explicit task scope

---

## 12. Respect Repository Vocabulary and Context

The same technical pattern may mean different things in different repositories.
AI agents must not assume that terms like:
- service
- domain
- adapter
- manager
- client
- module

have the same meaning everywhere.

### Required behavior
- infer design meaning from repository context and project context
- check how terms are already used in the repository
- preserve local consistency unless there is a strong reason to improve it

### Forbidden behavior
- imposing external naming conventions blindly
- renaming concepts just to match theory without repository justification
- assuming one repository’s design vocabulary applies universally

---

## 13. Legacy and Compatibility Clause

For legacy repositories and mixed-quality codebases:

- preserve stable behavior first
- improve design where new or materially modified logic creates legitimate opportunity
- avoid broad redesign for untouched code
- keep stronger design discipline focused on:
  - new files
  - newly added logic
  - materially modified logic
  - explicitly scoped refactoring

If design purity and backward compatibility conflict, backward compatibility wins unless the task explicitly authorizes managed breaking change work.

---

## 14. Relationship to Other Shared Rules

This file defines design meaning and responsibility rules only.

It does not replace:
- `ai-working-rules.md` for AI behavior and workflow
- `architecture-principles.md` for structural boundaries and dependency direction
- `code-quality-baseline.md` for implementation quality and validation discipline
- `contract-and-compatibility-rules.md` for compatibility and external contract rules
- `commit-protocol.md` for delivery and traceability conventions

Use this file when the question is:
- does this design reflect business meaning clearly?
- is responsibility placed coherently?
- is naming aligned with domain understanding?

Do not use this file as the main place for:
- test strategy
- validation policy
- lint/build rules
- transport/persistence dependency control
- commit metadata rules

---

## 15. One-Sentence Summary

> Prefer designs where business meaning is explicit, naming reflects domain intent, responsibilities remain cohesive, and improvements are made incrementally without forcing broad redesign of stable legacy code.