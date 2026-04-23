# frontend-microfrontend.instructions.md

## Purpose

This instruction applies when the repository is a frontend repository and the architecture is identified as microfrontend.

The purpose is to ensure the agent:
- preserves microfrontend boundaries
- respects shell integration contracts
- avoids hidden cross-module coupling
- limits changes to the owned repository scope
- verifies behavior at the correct architectural boundary

This file is path-specific guidance.
It does not replace global governance, workflow invariants, engineering principles, or evidence policy.

---

## 1. Scope Recognition

Before planning or implementing any change, the agent must identify from repository evidence:

- whether this repository is a microfrontend shell or a microfrontend child module
- the owned route boundary of this repository
- the entry point and mount mechanism used by this repository
- the shell integration contract or hosting expectation
- the shared dependencies used by this repository
- whether the requested change stays inside this repository boundary

Do not assume ownership beyond the current repository.

If shell behavior, sibling microfrontend behavior, or cross-repository contracts are not verifiable from repository evidence, record them as assumptions or dependencies.
Do not treat them as confirmed facts.

---

## 2. Architectural Boundary Rule

The agent must preserve the existing microfrontend boundary.

Allowed direction:
- modify behavior inside the owned repository boundary
- extend the existing integration pattern already used by this repository
- reuse existing shared platform contracts already proven by code

Disallowed direction:
- introduce direct imports from another microfrontend repository
- create hidden runtime coupling with sibling microfrontends
- move responsibilities between shell and child modules without evidence
- silently compensate in this repository for unknown shell behavior
- implement cross-repository integration assumptions as if they were verified

If the requested outcome appears to require shell changes or sibling microfrontend changes, the agent must explicitly mark those as external dependencies or follow-up items.

---

## 3. Shell and Hosting Contract Rule

When the repository is hosted by a shell, the agent must identify and preserve:

- mount lifecycle expectations
- unmount lifecycle expectations
- route ownership boundaries
- shared context injection patterns
- shared dependency expectations
- bootstrap contract used by the shell

The agent must not:
- redefine shell lifecycle behavior
- hijack shell-owned navigation
- alter route prefix ownership without evidence
- introduce startup assumptions that are not already present in the repository

If lifecycle hooks or shell contracts cannot be verified, record the uncertainty.
Do not claim full integration verification.

---

## 4. Routing Boundary Rule

The agent must determine whether this repository owns:

- top-level routes
- a route subtree
- view composition inside a shell-provided outlet
- local navigation only

The agent must preserve current route ownership.

The agent must not:
- expand route ownership beyond repository evidence
- introduce direct navigation to areas owned by other modules unless an existing contract already proves this pattern
- change route semantics in a way that may break shell composition without verification

Route-related changes must be reviewed as compatibility-sensitive.

---

## 5. Shared Dependency Rule

The agent must identify existing shared dependencies relevant to the task, such as:

- enterprise UI library
- design tokens
- shared auth SDK
- shared routing utilities
- platform event bus
- shared state bridge
- common API client
- shared telemetry or logging utilities

The agent must prefer reuse over duplication.

The agent must not:
- introduce an alternative competing platform mechanism without strong evidence
- duplicate platform integration logic already provided through shared packages
- wrap or replace a shared dependency casually when the repository already follows an established pattern

When shared dependencies are changed, the agent must treat the change as compatibility-sensitive and verify accordingly.

The agent must not upgrade or replace an existing shared integration pattern unless the task explicitly requires it and repository evidence supports the change.

---

## 6. State and Data Boundary Rule

The agent must distinguish clearly between:

- local component state
- repository-owned application state
- shell-provided context
- cross-module shared context
- external persisted state such as browser storage

The agent must prefer the narrowest valid state boundary.

The agent must not:
- create hidden coupling through ad-hoc localStorage or sessionStorage contracts
- replicate shell-owned context into a second source of truth without evidence
- introduce implicit cross-module state sharing
- blur repository-owned state and platform-owned state

If the repository already contains a state pattern, the agent should preserve it unless repository evidence supports a change.

---

## 7. Change Strategy

For implementation strategy, the agent must prefer:

1. smallest change inside the repository boundary
2. reuse of existing integration mechanisms
3. preservation of current shell and routing contracts
4. explicit identification of assumptions and external dependencies
5. verification proportional to the changed boundary

Do not turn a local change into an architectural rewrite.

Do not use the task as justification to redesign shell integration, replace shared contracts, or normalize unrelated frontend architecture unless such work is explicitly requested and supported by repository evidence.

Do not implement repository-local workarounds for shell-level defects unless the workaround is explicitly requested, clearly labeled, and risk-assessed.

---

## 8. Evidence Rule for Microfrontend Tasks

For meaningful microfrontend tasks, the agent should explicitly state before implementation:

- repository role [shell or child module or unknown]
- owned architectural boundary
- relevant entry point or mount mechanism
- affected routing boundary
- affected shared dependencies
- contract-sensitive risk
- assumptions and external dependencies
- planned verification scope

If any of the above cannot be verified, state that clearly.
Do not silently fill gaps with plausible architecture guesses.

---

## 9. Verification Rule

Verification must match the actual boundary of change.

Possible verification targets include:
- unit or component tests for local behavior
- integration tests for bootstrap, mount, unmount, or hosted rendering behavior
- route-level verification for owned route boundaries
- compatibility checks for shared dependency usage
- manual evidence notes when automated verification is unavailable

The agent must not claim completion if:
- shell integration assumptions were not verified
- route ownership was unclear but treated as fact
- cross-module behavior was inferred without evidence
- compatibility-sensitive changes were made without corresponding verification

If verification is partial, say so explicitly.

---

## 10. Review Checklist

Before finalizing, verify all of the following:

- the change stays within repository ownership
- no direct sibling-microfrontend coupling was introduced
- shell lifecycle behavior was not silently changed
- route ownership boundaries were preserved
- shared platform dependencies were reused rather than duplicated
- hidden cross-module state coupling was not introduced
- assumptions are explicitly recorded
- validation matches the actual changed boundary

---

## 11. Required Behavior in Review or Planning Output

For planning, implementation, or review tasks involving a microfrontend repository, the agent should produce output that covers:

- current repository role
- relevant architectural boundary
- integration contract touchpoints
- change scope
- risks to shell compatibility
- risks to routing compatibility
- risks to shared dependency compatibility
- verification performed
- uncovered scope and remaining assumptions

This output should be concrete and repository-grounded.
Avoid generic frontend advice that is not anchored to repository evidence.
