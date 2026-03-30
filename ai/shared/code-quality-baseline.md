# Code Quality Baseline

## 1. Purpose

This document defines the baseline expectations for implementation quality in AI-assisted software work.

It answers one question:

> When an AI agent writes or changes code, what minimum quality discipline must it follow?

These rules focus on:
- implementation discipline
- validation discipline
- bug-fix discipline
- refactoring discipline
- defensive programming
- evidence-based completion

These rules do not define:
- AI workflow ordering across governance stages
- architecture boundary theory
- domain modeling vocabulary
- commit formatting
- repository-specific path ownership

Those belong in other documents.

---

## 2. Scope

These rules apply to:
- new code
- newly added logic
- materially modified logic
- bug fixes
- explicit refactoring work
- test additions and validation-related work

For untouched legacy code:
- apply grandfathering
- do not force broad cleanup
- improve quality where real change already occurs
- do not expand task scope just to satisfy quality ideals

If ideal implementation quality conflicts with compatibility or stability, preserve correct behavior first and improve incrementally.

---

## 3. Core Quality Direction

AI agents must treat code quality as a combination of:

- clear expected behavior
- explicit validation path
- safe handling of error and edge conditions
- controlled and reviewable changes
- evidence-based completion claims

The goal is not “clean-looking code” by itself.
The goal is code that is:
- understandable
- verifiable
- safer to change
- less fragile in real conditions

---

## 4. TDD Spirit is the Default Direction

AI agents should follow TDD spirit whenever making meaningful code changes.

TDD spirit means:
- define expected behavior before implementation
- define validation before claiming progress
- change code in small verifiable steps
- use evidence, not confidence, to describe completion

Strict automated test-first is preferred where feasible.
Where strict test-first is not practical, explicit validation planning is still mandatory.

### Forbidden behavior
- coding first and inventing verification later
- treating implementation completion as equivalent to behavior verification
- assuming “small change” means no validation discipline is needed

---

## 5. Define Expected Behavior Before Changing Code

Before making a meaningful implementation change, the agent must define what correct behavior means.

### Required behavior
The agent must identify, as applicable:
- expected behavior
- acceptance conditions
- normal scenarios
- edge cases
- failure scenarios
- behavior that must remain unchanged

This definition may appear as:
- tests
- explicit validation notes
- acceptance criteria
- bug reproduction and correction criteria
- refactor preservation criteria

### Forbidden behavior
- changing code without stating what is expected to happen
- making behavior-changing edits while leaving expected behavior implicit
- treating vague intention as sufficient quality definition

---

## 6. Define Validation Before Claiming Progress

Before claiming meaningful progress, the agent must know how the change will be checked.

### Required behavior
The agent must identify one or more validation paths, such as:
- unit tests
- integration tests
- contract tests
- build or compile checks
- lint or static analysis
- command or script verification
- reproducible manual checks
- log or response evidence

If validation cannot yet be executed, the agent must explicitly state:
- what validation is intended
- what is currently unavailable
- what remains unverified

### Forbidden behavior
- presenting code as done without a validation path
- assuming compile success proves behavioral correctness
- hiding missing validation behind vague language

---

## 7. Prefer Small, Verifiable Changes

AI agents should make changes in units that are understandable and verifiable.

### Required behavior
- prefer incremental change over broad rewrite
- keep changes reviewable
- separate immediate implementation from optional cleanup
- isolate risk where possible
- keep validation aligned with the actual change scope

### Forbidden behavior
- combining many unrelated changes into one implementation step
- mixing behavior change, cleanup, renaming, and restructuring without disclosure
- making broad edits that are hard to verify as a whole

---

## 8. Bug Fixes Require Reproduction and Regression Thinking

A bug fix is not complete just because the visible symptom appears reduced.

### Required behavior
For bug fixes, the agent must identify, as applicable:
- observed symptom
- triggering condition or closest reproducible condition
- corrected expected behavior
- how regression will be checked

If exact reproduction is not possible, the agent must state the limitation explicitly and still define the best available validation approach.

### Forbidden behavior
- changing code without clarifying the bug symptom
- declaring a bug fixed with no regression-oriented check
- silently widening a bug-fix task into unrelated cleanup

---

## 9. Refactoring Requires Behavior Preservation Discipline

Refactoring must preserve intended behavior unless behavior change is explicitly part of the task.

### Required behavior
Before refactoring, the agent must identify:
- what behavior must remain unchanged
- how unchanged behavior will be checked
- what local risks exist

### Forbidden behavior
- mixing hidden behavior changes into refactoring work
- treating structural cleanup as self-validating
- using refactoring as cover for unscoped redesign

---

## 10. Defensive Programming is Required

AI agents must assume that real systems receive imperfect inputs, partial states, unstable dependencies, and legacy inconsistencies.

### Required behavior
The agent should account for, where relevant:
- null or missing values
- empty inputs
- malformed data
- invalid state transitions
- timeout or external failure
- partial or inconsistent data
- backward compatibility constraints
- error handling and observable failure paths

The exact handling may vary by repository and task, but failure and edge conditions must not be ignored by default.

### Forbidden behavior
- handling only the happy path when failure modes are relevant
- assuming inputs are always valid without evidence
- assuming dependencies always succeed
- letting unhandled edge cases remain invisible in code changes

---

## 11. Gate-Friendly Quality is Preferred

Quality should be expressed in ways that can be checked.

### Required behavior
Whenever feasible, the agent should align work with checkable gates such as:
- build
- compile
- unit test
- integration test
- contract check
- lint
- static analysis
- scriptable verification
- reproducible manual procedure

Even when full automation is unavailable, the agent should still define a repeatable validation path.

### Forbidden behavior
- using only subjective language to describe code quality
- treating unverifiable quality claims as acceptable completion
- leaving no clear path for another person to re-check the change

---

## 12. Evidence-Based Completion is Mandatory

Completion claims must stay within what has actually been verified.

### Required behavior
The agent must distinguish clearly between:
- what changed
- what was validated
- what was not validated
- what remains assumption or pending confirmation
- what risks or uncovered areas remain

### Forbidden behavior
- claiming full correctness without sufficient evidence
- describing unverified work as complete
- overstating confidence beyond the validation scope

---

## 13. Repository-Specific Quality Must Be Respected

Different repositories may have different practical quality mechanisms.

Some repositories may rely heavily on:
- automated tests

Others may rely more on:
- compile checks
- integration scripts
- manual reproducible verification
- log or response inspection

### Required behavior
- use the repository’s real validation mechanisms where they exist
- respect repository-specific test/build/lint conventions
- strengthen existing quality paths rather than inventing disconnected ones

### Forbidden behavior
- assuming every repository has full automated test coverage
- treating absence of perfect test infrastructure as permission to skip discipline
- imposing unrealistic validation patterns without repository context

---

## 14. Legacy and Compatibility Clause

For legacy repositories:

- preserve stable behavior first
- improve quality where code is already being changed
- avoid broad cleanup of untouched areas
- apply stricter discipline mainly to:
  - new files
  - new logic
  - materially modified logic
  - explicitly scoped quality improvement work

If strict quality ideal conflicts with backward compatibility or operational safety, protect compatibility first and document the limitation.

---

## 15. Relationship to Other Shared Rules

This file defines implementation quality discipline only.

It does not replace:
- `ai-working-rules.md` for AI working behavior
- `architecture-principles.md` for structural boundaries and dependency direction
- `design-principles.md` for domain meaning and responsibility clarity
- `contract-and-compatibility-rules.md` for external contract and compatibility safety
- `commit-protocol.md` for delivery and traceability conventions

Use this file when the question is:
- how should code changes be validated?
- what quality discipline should bug fixes follow?
- what does safe refactoring require?
- what minimum standard applies before claiming code work is complete?

---

## 16. One-Sentence Summary

> Define expected behavior first, define validation first, make small verifiable changes, handle failure paths explicitly, treat bug fixes and refactors with discipline, and never present unverified implementation work as completed work.