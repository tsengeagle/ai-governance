# frontend-ui.instructions.md

## Purpose

This instruction applies when the repository contains frontend UI work or when the requested change affects presentation, interaction, layout, visual behavior, or user-facing flow.

The purpose is to ensure the agent:
- checks enterprise-standard UI components before implementation
- reuses approved wrapper and composition patterns
- preserves enterprise visual consistency
- prefers design tokens over hardcoded styling
- verifies UI behavior proportionally to the change impact

This file is path-specific guidance.
It does not replace global governance, workflow invariants, engineering principles, or evidence policy.

---

## 1. UI Scope Recognition

Before planning or implementing UI-related work, the agent must identify from repository evidence:

- which UI blocks are affected
- whether the repository is governed by an enterprise UI component system
- whether approved local wrappers or composition patterns already exist
- whether design tokens are already used by the repository
- whether the requested change is purely presentational, interaction-related, layout-related, or flow-related

Do not jump directly into implementation.

If enterprise UI governance, wrapper patterns, or token usage cannot be verified from repository evidence, record that uncertainty.
Do not invent a new standard based on preference.

---

## 2. Enterprise UI First Rule

When UI work is required, the agent must first check whether the enterprise-standard UI system already provides an appropriate component, pattern, or approved wrapper.

Preferred order:
1. approved repository wrapper around enterprise-standard UI
2. enterprise-standard UI component directly
3. existing repository composition pattern using enterprise-standard components
4. minimal custom local UI only when no suitable standard option exists

The agent must not:
- recreate a standard UI primitive locally when an equivalent enterprise component exists
- copy the visual style of an enterprise component without using the actual component or approved wrapper
- introduce a parallel local UI API for a standard enterprise pattern without evidence

Standard UI primitives include but are not limited to:
- button
- input
- select
- checkbox
- radio
- switch
- textarea
- form field
- modal
- dialog
- drawer
- table
- data grid
- tabs
- card
- badge
- tag
- alert
- toast
- tooltip
- dropdown
- pagination
- breadcrumb
- layout primitives
- typography primitives

---

## 3. Standard Component Discovery Requirement

Before implementation, the agent should explicitly identify:

- affected UI block
- candidate enterprise-standard component
- existing wrapper or composition candidate in the repository
- relevant token or style constraint
- whether any gap exists between requirement and available standard components

For meaningful UI tasks, this discovery step should appear in the plan, analysis, or implementation summary.

Do not skip component discovery just because a local implementation seems faster.

---

## 4. Wrapper and Composition Rule

If the repository already uses approved wrappers or established composition patterns, the agent must prefer them.

The agent must:
- reuse existing wrappers when they fit the need
- preserve wrapper API consistency
- preserve established composition patterns for tables, forms, dialogs, navigation, or status display

The agent must not:
- bypass an established wrapper without a repository-grounded reason
- create a second wrapper with overlapping purpose just for naming or stylistic preference
- fragment the repository into multiple inconsistent UI usage patterns

If an existing wrapper is insufficient, record why it is insufficient before introducing a new abstraction.

---

## 5. Custom UI Rule

Custom local UI is allowed only when at least one of the following is true:

- no suitable enterprise-standard component exists
- no approved wrapper or composition can satisfy the requirement
- the required behavior is domain-specific and cannot reasonably belong to the shared design system
- repository evidence shows an existing approved local pattern for the same special case

When custom local UI is introduced, the agent must explicitly document:

- what was checked
- which standard components or wrappers were considered
- why they were insufficient
- why the custom UI is the minimum necessary solution
- what compatibility or maintenance risk remains

The agent must keep custom UI minimal.
Do not use custom UI as a shortcut around enterprise standards.

---

## 6. Styling and Design Token Rule

The agent must prefer design tokens or existing theme variables for:

- color
- spacing
- typography
- border radius
- shadows or elevation
- breakpoint behavior
- z-index layers
- motion values where applicable

The agent must not:
- hardcode theme values when a token or theme variable already exists
- introduce inconsistent spacing, sizing, or typography without evidence
- override enterprise-standard component styling in a way that breaks consistency unless explicitly justified

If token availability is unclear, record the gap.
Do not invent a styling convention and present it as standard.

---

## 7. Accessibility Rule

UI changes must preserve or improve accessibility.

The agent must consider, where relevant:

- semantic structure
- keyboard interaction
- focus order and focus trapping
- accessible naming and labeling
- validation and error feedback
- status messaging
- table readability
- overlay or dialog behavior
- interaction affordance for disabled, loading, and error states

The agent must not claim UI completion if meaningful interaction behavior changed but accessibility-sensitive behavior was not considered.

---

## 8. Behavior and Flow Consistency Rule

The agent must preserve established user-facing behavior unless the task explicitly requires a change.

The agent must check whether the requested UI change affects:

- form interaction behavior
- validation timing
- modal or dialog lifecycle
- sorting, filtering, or pagination behavior
- loading, empty, and error states
- route-level user flow
- cross-page consistency
- status and feedback presentation

Do not treat UI work as cosmetic if it changes user behavior.

Behavior-changing UI work must be reviewed as compatibility-sensitive.

---

## 9. Change Strategy

For UI implementation strategy, the agent must prefer:

1. reuse of existing repository UI patterns
2. enterprise-standard components and approved wrappers
3. minimal behavior-preserving change
4. minimal surface-area styling change
5. explicit documentation of custom gaps
6. verification proportional to the impact

Do not turn a local UI task into an uncontrolled design rewrite.

Do not replace existing enterprise-aligned UI usage with a new local pattern unless the task explicitly requires it and repository evidence supports the change.

The agent must not introduce a new third-party UI library for a local task when the repository is governed by an enterprise-standard UI system, unless the task explicitly requires it and the deviation is clearly justified.

---

## 10. Evidence Rule for UI Tasks

For meaningful UI tasks, the agent should explicitly state before implementation:

- affected UI blocks
- standard component candidates
- existing wrapper or composition candidates
- design token or style constraints
- whether custom UI is necessary
- expected behavior impact
- verification plan
- assumptions and evidence gaps

If any of these cannot be verified, say so clearly.
Do not hide uncertainty behind generic frontend advice.

---

## 11. Verification Rule

Verification must match the real UI impact.

Possible verification targets include:
- component tests for isolated rendering or interaction behavior
- interaction tests for forms, dialogs, tables, sorting, filtering, and async feedback
- route or page-level verification for composed user flow
- visual impact summary for meaningful layout or visible component changes
- manual evidence notes when automated verification is unavailable

The agent must not claim completion if:
- enterprise-standard component discovery was skipped
- custom UI was introduced without explicit justification
- behavior changed without corresponding verification
- styling diverged from token-based conventions without being acknowledged
- verification covered only code execution but not user-visible behavior

If verification is partial, say so explicitly.

---

## 12. Review Checklist

Before finalizing, verify all of the following:

- enterprise-standard UI was checked first
- approved wrappers or repository patterns were reused where appropriate
- avoidable custom UI was not introduced
- design tokens or existing theme variables were preferred
- accessibility-sensitive behavior was considered
- user-visible behavior changes were treated as compatibility-sensitive
- verification matches the real UI impact
- assumptions and evidence gaps are explicitly recorded

---

## 13. Required Behavior in Review or Planning Output

For planning, implementation, or review tasks involving UI work, the agent should produce output that covers:

- affected UI scope
- candidate standard components
- wrapper or composition reuse decision
- custom UI justification if any
- styling and token considerations
- behavior impact
- verification performed
- remaining evidence gaps and uncovered scope

This output should be concrete and repository-grounded.
Avoid generic UI advice that is not anchored to repository evidence.
For non-trivial UI work, include a component mapping summary that maps each affected UI block to the selected enterprise-standard component, wrapper, or justified custom implementation.
