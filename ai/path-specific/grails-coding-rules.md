# Grails Coding Rules

## Controllers / Entry Points
- Keep transport concerns at entry points.
- Do not move orchestration logic into controllers or resources.

## Services
- Place orchestration and business coordination in services.
- Preserve existing service responsibility boundaries.

## Domain / GORM
- Respect existing GORM patterns unless change is explicitly required.
- Do not replace dynamic finders or persistence logic without behaviour verification.

## Legacy Safety
- Prefer compatibility-preserving changes.
- Keep modifications localized.
