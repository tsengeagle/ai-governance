---
applyTo: "grails-app/resources/**/*.groovy,grails-app/controllers/**/*.groovy"
---

# Grails Entry Points Instructions

This file applies to HTTP entry points and routing-facing Grails code.

Use `ai/project-context.yaml`, `copilot-instructions.md`, and `AGENTS.md` as governing context.

## Role Of Entry Points

Entry points are transport-facing adapters.

They may:
- parse request inputs
- validate request shape
- normalize transport-specific fields
- call services
- map service results to response payloads
- set HTTP or transport status
- perform logging directly related to the request boundary

They must not become the place for orchestration or business coordination.

## Forbidden In Entry Points

Do not place the following in resources or controllers unless the task explicitly requires it and the reason is stated:

- business orchestration across multiple steps
- cross-service coordination logic
- retry, compensation, or pipeline control logic
- persistence decisions
- direct GORM query or write logic
- replacement of existing service behavior by inlining logic into the entry point
- incidental refactoring of unrelated transport endpoints

Legacy entry points that already contain mixed concerns are grandfathered.

Do not broaden that pattern, but do not refactor existing logic out of the entry point only to satisfy these instructions unless the task explicitly requests it.

## GORM And Persistence Restrictions

In resources and controllers, do not introduce or expand direct use of persistence logic such as:

- dynamic finders
- `save`, `delete`, `merge`
- `executeQuery`
- `createCriteria`
- `where`
- transaction handling
- Hibernate session manipulation

If existing entry-point code already contains legacy persistence behavior, do not broaden it casually. Prefer moving new behavior into the appropriate service instead of extending the legacy pattern.

## Service Boundary Expectations

When implementing or modifying an entry point:

- keep orchestration in services
- preserve existing service responsibility boundaries
- prefer calling an existing service over introducing new workflow logic in the resource or controller
- if multiple actions are needed, the entry point should delegate to a service-level method that coordinates them

## EventServer-Specific Safety

For this repository, treat the following as service-level concerns, not entry-point concerns:

- event publishing flow
- retry handling
- compensation logic
- pipeline sequencing
- scheduled-job interactions
- cache-aware event behavior
- external integration coordination

Before changing an entry point that affects event behavior, inspect the called services and related pipeline/job flow first.

## Contract Safety

Entry points often expose externally meaningful contracts.

Do not casually reshape:
- REST payload structure
- field names
- URLs
- request parameter expectations
- response codes
- SOAP/Flex-adjacent adapter behavior exposed through service entry paths

If a contract change appears necessary, state it explicitly instead of silently folding it into routine maintenance.

## Preferred Change Shape

For routine maintenance, prefer this pattern:

1. keep request parsing and response mapping in the entry point
2. place decision-making and orchestration in a service
3. keep persistence behavior behind service and domain boundaries
4. keep the change localized to the smallest affected path

## When In Doubt

If the fastest implementation would require moving orchestration, persistence, or event-flow logic into an entry point, do not do that by default.

Explain the boundary conflict and choose the compliant implementation.