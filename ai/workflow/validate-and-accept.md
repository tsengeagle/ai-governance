# Validation and Acceptance Workflow

## 1. Purpose
This workflow defines the common execution flow that an agent must follow when validating and accepting work after implementation, bug fixing, refactoring, or specification alignment.

This workflow defines:
- validation input inventory
- validation layer selection
- execution of available validation paths
- failure and gap classification
- evidence and coverage consolidation
- completion judgement output

This workflow does not define:
- repository-specific commands
- framework-specific test tools
- fixed CI products
- repository-local gate implementation details

## 2. Workflow Steps

### W1. Inventory validation inputs
Before running validation, the agent must inventory the validation inputs and entry points available in the current task context, including when applicable:
- change target and acceptance target
- repository build, test, run, and gate entry points
- unit, integration, and acceptance validation paths currently available in the repository
- environment limitations and external dependency constraints
- known gaps and pending confirmations

The purpose of this step is to determine what is actually verifiable before execution begins.

### W2. Select validation layers and strategy
The agent must select the validation layers and validation strategy according to:
- change risk
- impact scope
- dependency boundary
- repository reality

The agent must at least consider these abstract layers:
- unit-level validation
- integration-level validation
- acceptance-level validation

If any layer is not executed, the agent must later disclose the reason, limitation, and risk.

### W3. Execute available validation paths
The agent must execute the validation paths that are actually available in the repository and applicable to the current task.

Execution should preferentially reuse existing validation paths such as:
- established test entry points
- existing acceptance scripts
- existing CI or gate paths
- existing replay or diagnostic paths

The agent should not invent an alternative validation flow unless necessary. If fallback is necessary, the difference and impact must be disclosed.

### W4. Classify failures and validation gaps
If validation does not pass, cannot be completed, or can only be partially executed, the agent must first classify:
- failure layer
- validation gap
- environment limitation
- dependency limitation
- not verifiable in this run

Before this basic classification is done, the agent must not prematurely claim that the root cause is confirmed. If only the failure layer is known, the output must say so directly.

### W5. Consolidate evidence and coverage
The agent must consolidate the current run into traceable evidence and a clear coverage boundary, including:
- covered validation layers
- uncovered validation layers
- partially covered areas
- gaps and limitations
- separation between verified facts and pending confirmation

This step prepares the evidence base required for the final completion judgement.

### W6. Output completion judgement
The agent must output a completion judgement based on the evidence consolidated in this run.

The output must at least answer:
- whether implementation was completed in this run
- whether validation was completed in this run
- which validation layers were covered
- which areas remain uncovered
- whether the current judgement is completed, partial, failed, pending confirmation, or not verifiable

If the current run is validation-only, that must be stated explicitly. Validation-only work must not be presented as an implementation fix.

## 3. Fixed Output Format
Every validation and acceptance output must include the following sections.

### 3.1 Implementation Status
State whether implementation changed in the current run, including at least:
- implementation completed or not completed
- whether code, config, spec, or test assets were modified
- whether the current run is validation-only if no implementation change occurred

### 3.2 Validation Scope
State the intended and actual validation scope, including at least:
- validation layers that should be considered
- validation layers actually executed
- validation layers not executed
- reasons, limitations, and risks for layers not executed

### 3.3 Evidence Summary
Summarize the main evidence supporting the current run, including at least:
- traceable validation or execution evidence
- key gate, diagnostic, replay, or artifact evidence when applicable
- verified facts
- pending confirmation or not verifiable items

A summary without supporting evidence is not sufficient.

### 3.4 Coverage Boundary
Explicitly state the coverage boundary, including at least:
- covered scope
- uncovered scope
- partially covered scope
- areas blocked by environment, dependency, or repository reality

This section is mandatory.

### 3.5 Validation Gaps and Failure Classification
If any validation failure, incomplete validation, or blocked validation exists, list at least:
- failure layer or gap type
- known impact
- items still unconfirmed
- whether only the failure layer is known and root cause analysis remains incomplete

If no notable failure was identified in the current run, this section may state that none were identified in this run.

### 3.6 Completion Judgement
The output must end with an overall completion judgement, choosing at least one of:
- completed
- partial
- failed
- pending confirmation
- not verifiable

This section must also include a short explanation of:
- why this judgement was made
- which evidence supports it
- whether uncovered risks remain

## 4. Minimal Output Skeleton

```md
## Implementation Status
- ...

## Validation Scope
- ...

## Evidence Summary
- ...

## Coverage Boundary
- ...

## Validation Gaps and Failure Classification
- ...

## Completion Judgement
- ...
```
