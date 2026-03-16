# Design Principles

1. Identify the change type before implementation:
   - bug fix
   - behaviour adjustment
   - contract extension
   - refactor
   - investigation

2. Prefer the smallest safe change.

3. Preserve existing behaviour unless the request explicitly changes it.

4. Do not mix unrelated cleanup with requested business changes.

5. When requirements are incomplete, list assumptions rather than inventing business rules.

6. Keep validation proportional to risk.
