# Validation and Acceptance Governance Principles

## 1. Purpose
This document defines the governance principles that an agent must follow when validating and accepting work after implementation, bug fixing, refactoring, or specification alignment.

This document defines:
- completion requirements before an agent may claim a task is done
- validation layer selection principles
- evidence and reporting requirements
- disclosure requirements for validation gaps, uncovered scope, and incomplete verification

This document does not define:
- repository-specific commands
- framework-specific test tooling
- repository-local CI or gate implementation details
- step-by-step execution procedures

## 2. Principles

### G1. No task completion claim without sufficient validation
An agent must not claim that a requirement, fix, or change is completed without sufficient validation evidence.

The agent must distinguish among:
- implementation completed
- validation completed
- task completed

If implementation is completed but sufficient validation is not, the agent must explicitly report that state, for example:
- implementation completed but not fully validated
- partially validated
- validation pending

Implementation completed must not be presented as task completed.

### G2. Validation layers must be proportionate to change risk
The agent must choose validation layers in proportion to the change type, impact scope, failure cost, and dependency boundary.

Validation planning must at least consider these abstract layers:
- unit-level validation
- integration-level validation
- acceptance-level validation

These three layers are a validation thinking framework, not a rule that every task must execute all three. If any layer is not covered, the agent must disclose the reason, limitation, and risk.

### G3. Validation approach must converge from repository reality
The agent must determine executable validation paths from repository reality and verifiable gate evidence.

Examples include:
- existing build, test, run, or gate entry points
- integration test entry points
- acceptance scripts or replay paths
- CI, static analysis, or other existing verification evidence

If a validation layer does not exist in the repository, is unavailable, is not yet established, or is not verifiable in the current run, the agent must not fabricate coverage. The gap, limitation, and impact must be disclosed explicitly.

### G4. Completion judgement must include a coverage boundary
When the agent outputs a completion judgement, it must also disclose the coverage boundary, including at least:
- which validation layers were covered
- which validation layers were not covered
- which areas were only partially covered
- which areas were out of scope for the current validation run

The agent must not output summary-level claims such as completed, validated, or acceptance passed without a coverage boundary.

### G5. Validation evidence and reporting must be traceable and must distinguish facts from assumptions
All validation conclusions must be traceable to concrete evidence.

Validation reporting must clearly distinguish:
- verified facts
- grounded inference
- assumption
- pending confirmation
- not verifiable in this run

Assumptions, unverified inferences, and incomplete observations must not be presented as verified facts.

### G6. Acceptance is judged by requirement satisfaction
The final validation and acceptance criterion must be whether the current requirement, fix target, specification requirement, or explicit acceptance criteria have been satisfied, not merely whether some tests passed.

Tests, execution results, and other validation evidence are supporting evidence. If the available evidence does not support requirement satisfaction, the agent must not claim task completion merely because some tests passed.

### G7. Validation gaps and failure layers must be disclosed explicitly
If any validation gap exists, the agent must disclose its nature, impact, and current status.

If validation does not pass, the agent must first classify the failure layer or failure nature before escalating the conclusion. Examples include:
- test failure
- invocation or script failure
- environment or configuration failure
- integration failure
- external dependency failure
- acceptance mismatch

The agent must not conceal validation gaps behind a success summary, and must not present incomplete investigation as completed root cause analysis.

### G8. Validation-only work must not be presented as an implementation fix, and governance must stay faithful to repository reality
If the current work only includes rerun, diagnosis, acceptance replay, evidence consolidation, validation, or other verification activity without implementation change, the agent must explicitly state that the scope is validation-only.

Without implementation change, the agent must not imply that the problem has been fixed, the requirement has been implemented, or the runtime behavior has changed because of the current run.

If the ideal validation model conflicts with actual repository reality, the agent must first disclose the repository's current validation capability, existing gates, known gaps, and limitations, then propose improvements. The agent must not fabricate validation entry points, validation layers, or validation capabilities that the repository does not actually have.
