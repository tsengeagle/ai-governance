---
applyTo: "grails-app/domain/**/*.groovy,grails-app/services/**/*.groovy"
---

# Grails Domain And GORM Instructions

This file applies to Grails domain models and service code that reads or writes domain state.

Use `ai/project-context.yaml`, `copilot-instructions.md`, and `AGENTS.md` as governing context.

## Role Of Domain And Persistence Code

Domain and persistence code must preserve existing business behavior and storage semantics.

For this repository:

- domain classes define persisted structure and ORM behavior
- services coordinate business actions and persistence usage
- persistence changes must be treated as behavior changes, not style cleanup

## Core Rule

Treat existing GORM and Hibernate patterns as intentional unless the task explicitly requires a verified change.

Do not replace persistence style only for consistency, modernization, or readability.

Existing domain and persistence patterns are grandfathered.

Do not replace, relocate, or normalize existing GORM or Hibernate usage only to better align with these instructions unless the task explicitly requires a verified behavior-preserving change.

## Preserve Existing GORM Behavior

Unless explicitly requested, do not casually replace or reshape:

- dynamic finders
- existing `save`, `delete`, `merge`, or flush behavior
- criteria usage
- `where` queries
- `executeQuery`
- mapping definitions
- constraints
- lifecycle hooks
- lazy/eager loading assumptions
- transaction boundaries
- Oracle-specific persistence assumptions

If legacy code already uses a persistence pattern, prefer preserving that pattern over rewriting it.

## Service Boundary Expectations

Services may coordinate domain actions and persistence behavior.

When editing services:

- preserve existing service responsibility boundaries
- prefer extending an existing service path over introducing a parallel persistence path
- keep orchestration in services, not in domain classes
- do not move transport concerns into services
- do not move persistence behavior into entry points

## Domain Class Expectations

Domain classes should remain focused on persisted structure and domain-adjacent behavior already established in this repository.

Do not casually introduce into domain classes:

- transport parsing
- controller/resource concerns
- unrelated orchestration
- external integration logic
- retry or pipeline coordination
- broad refactoring of existing domain methods without behavior verification

## Behavior Change Requires Verification

If a change affects persistence behavior, query semantics, update ordering, transactional behavior, or loaded associations, treat it as behavior-sensitive.

In such cases:

- inspect the affected domain class
- inspect the calling service(s)
- inspect existing tests covering the flow
- add or update regression tests in the same change whenever behavior may be affected

Do not claim equivalence without verification.

## Dynamic Finder Safety

Dynamic finders are allowed legacy patterns in this repository.

Do not replace a dynamic finder with another query style unless:

1. the task explicitly requires it, or
2. the existing implementation is proven incorrect or insufficient

If a dynamic finder is replaced:

- preserve result semantics
- preserve null/not-found behavior
- preserve ordering and filtering behavior
- add or update regression tests that prove the replacement is behaviorally correct

## Mapping And Constraint Safety

Do not casually change:

- `static mapping`
- `static constraints`
- column names
- table names
- id generation behavior
- versioning behavior
- nullable/blank assumptions
- association ownership
- cascade behavior

Treat these as externally and operationally meaningful unless the task explicitly targets them.

## Query And Transaction Safety

When changing service-level persistence logic:

- inspect whether the flow depends on current transaction boundaries
- preserve existing write ordering unless explicitly changed
- avoid hidden changes to flush timing
- avoid broad rewrites from one query style to another without behavioral proof
- keep Oracle compatibility in mind when changing query or persistence behavior

## EventServer-Specific Safety

For this repository, persistence logic may interact with event publishing, retry, compensation, logging, cache usage, and scheduled processing.

Before changing persistence behavior in an event-related flow, inspect related:

- services
- event logs
- pipeline control
- retry/compensation flow
- scheduled jobs
- cache-aware logic

Do not treat a domain or query change as isolated if it participates in event flow behavior.

## Preferred Change Shape

For routine maintenance, prefer this pattern:

1. keep the existing domain model shape
2. change the narrowest relevant service or query path
3. preserve current GORM style unless change is necessary
4. add or update focused regression tests when behavior may shift

## When In Doubt

If a proposed persistence change is primarily stylistic, do not do it by default.

Explain the risk, preserve the existing pattern, and choose the smallest compliant change.