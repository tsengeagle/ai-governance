# GitHub Copilot Instructions

Before implementation or refactoring, read:
1. `AGENTS.md`
2. `ai/project-context.yaml`

Treat `ai/project-context.yaml` as the authoritative source for architecture constraints, integration boundaries, and AI governance.

## Non-negotiable Rules

- Prefer minimal, localized, compatibility-preserving changes.
- Preserve existing service, resource, domain, and job boundaries during routine maintenance.
- Do not introduce modernization or architectural refactors as incidental cleanup.
- Do not reshape externally meaningful SOAP, Flex remoting, REST, URL, event-code, database, or UI contracts unless explicitly requested.
- Do not infer behavior from other HIS repositories. Reason only from this repository’s code and docs.
- Treat legacy patterns as intentional unless the task explicitly requires a verified change.
- When a requested implementation conflicts with these rules, explain the conflict and choose the compliant implementation.

## Event Flow Safety

When editing publish, retry, compensation, pipeline, or scheduled processing behavior:

- inspect the related services, jobs, cache usage, and event-log flow first
- preserve existing ordering, retry semantics, and compensation behavior unless explicitly changed
- avoid broad refactors around event flow as part of a narrow task

## Configuration Safety

- Keep configuration changes narrow and environment-aware.
- Review related settings in:
  - `grails-app/conf/application.groovy`
  - `grails-app/conf/application.yml`
  - `grails-app/conf/spring/resources.groovy`
- Do not casually change startup, bootstrap, timezone, routing, or bean wiring behavior.

## Legacy Grandfathering Rule

Existing legacy code that does not fully match the preferred layering or style rules is grandfathered.

Do not refactor, relocate, rename, extract, or normalize existing code only to make it comply with these instructions.

Apply these instructions primarily to:
- new code
- newly added logic
- materially modified logic

When touching legacy code, prefer the smallest compatible in-place change unless:
1. the task explicitly requests refactoring, or
2. a broader change is required to preserve correctness, and that need is stated explicitly.

If strict rule compliance and backward compatibility conflict, prioritize backward compatibility and explain the tradeoff.

## Validation

Use the repository Gradle wrapper when validation is possible.

Preferred validation sequence:
1. `gradlew.bat test`
2. `gradlew.bat build`

Prefer the narrowest relevant test scope first when changing a specific event flow or service.

If validation cannot be run, state that explicitly and identify the blocking dependency.

## Task Completion

For completed work, provide:
1. Change Summary
2. Validation Summary
3. Risks or follow-up checks
4. Proposed Commit Message