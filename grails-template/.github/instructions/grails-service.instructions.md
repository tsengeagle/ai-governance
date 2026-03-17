---
applyTo: "grails-app/services/**/*.groovy"
---

# Grails Service Instructions

This file applies to Grails service code.

Use `ai/project-context.yaml`, `copilot-instructions.md`, and `AGENTS.md` as governing context.

## Role Of Services

Services are the primary place for business coordination and orchestration in this repository.

For routine maintenance and feature work, services may:

- coordinate multi-step business flow
- call domain and persistence logic
- enforce business sequencing
- coordinate integration-facing behavior
- mediate between entry points and persistence/domain state

Services must preserve existing responsibility boundaries unless the task explicitly requires a verified boundary change.

## Core Rule

Keep orchestration in services.

Do not move orchestration upward into resources or controllers.  
Do not spread orchestration sideways across unrelated services as incidental cleanup.  
Do not push transport concerns or UI concerns into services.

Existing service boundaries and legacy service shapes are grandfathered.

Do not split, merge, relocate, or normalize existing service logic only to better match these instructions unless the task explicitly requires a verified refactor.

## Service Boundary Expectations

When editing service code:

- preserve the existing service’s responsibility unless the task explicitly targets a boundary change
- prefer extending the existing service path over creating a parallel orchestration path
- prefer reusing an existing service method when it already represents the business flow
- keep changes localized to the smallest service surface that satisfies the task

Do not introduce broad service extraction, merging, or renaming as part of routine maintenance.

## Forbidden Service Changes During Routine Maintenance

Unless explicitly requested, do not:

- move orchestration logic into resources, controllers, GSPs, jobs, or domain classes
- split one service into many services for style reasons
- merge multiple services for architectural cleanup
- rename services, major methods, or coordination paths for readability alone
- replace existing business flow with a new parallel workflow without behavior verification
- rewrite legacy service coordination only to “modernize” structure

## Entry Point Boundary

Services should receive already parsed or normalized inputs from entry points.

Do not introduce into services:

- HTTP-specific response handling
- URL or route concerns
- resource/controller transport branching
- direct GSP/UI rendering concerns
- request parsing that belongs at the entry point unless already established by existing repository pattern

If an entry point currently mixes transport and orchestration, do not broaden that pattern. Prefer keeping new business flow inside the service layer.

## Domain And Persistence Boundary

Services may coordinate persistence, but should not casually change persistence semantics.

When editing service-level persistence behavior:

- preserve existing GORM and Hibernate usage style unless change is explicitly required
- preserve current transaction assumptions unless explicitly targeted
- preserve write ordering and side-effect ordering unless explicitly changed
- inspect related domain classes and tests before altering persistence flow

If a service change affects query semantics, persistence behavior, transactional timing, or association loading behavior, add or update regression tests in the same change.

## EventServer-Specific Service Safety

For this repository, services often sit at the center of event flow coordination.

Treat the following as service-level concerns:

- event publishing
- retry handling
- compensation flow
- pipeline sequencing
- cache-aware event coordination
- external integration coordination
- scheduled-flow interaction where business logic is involved

Before changing service behavior in these areas, inspect the related:

- pipeline services
- event logs
- scheduled jobs
- cache usage
- integration entry points
- focused tests under `src/test/groovy/com/hcsaastech/ehis/event`

Do not treat a service edit as isolated if it changes observable event behavior.

## Preferred Change Shape

For routine service changes, prefer this pattern:

1. keep the current service boundary
2. add or adjust the smallest relevant orchestration path
3. delegate persistence through existing domain/GORM patterns
4. keep transport concerns at entry points
5. keep the change localized
6. add or update focused tests when behavior may shift

## When To Escalate

Ask for confirmation before proceeding if the service change would require:

- changing business flow ownership between services
- changing externally meaningful sequencing or side effects
- changing retry, compensation, or pipeline semantics
- changing integration contract behavior indirectly through service refactoring
- replacing an established persistence pattern with a different query or write approach
- introducing a new architectural pattern as part of a narrow task

## When In Doubt

If the fastest implementation would cross a service boundary, duplicate orchestration, or refactor the workflow structure beyond the task’s scope, do not do that by default.

Explain the boundary risk and choose the smallest compliant service-layer change.