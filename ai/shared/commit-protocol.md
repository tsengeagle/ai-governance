# Commit Protocol

A commit message must be generated only when the work is commit-ready.

## Commit-ready conditions
- one primary purpose
- implementation complete for intended scope
- validation identified or completed
- no unrelated edits mixed in

Do not generate a commit message if:
- work is exploratory
- implementation is partial
- required validation is missing
- compatibility impact is unresolved

## Required output
1. Change Summary
2. Validation Summary
3. Proposed Commit Message

## Format
<type>: <summary>

<body if needed>

AI-Assisted: yes
AI-Origin: assisted
Risk-Class: <low|medium|high|legacy-contract-sensitive>

## Rules
- type must be one of: feat, fix, refactor, test, docs, chore
- first line under 72 characters
- do not present unfinished work as completed
- for legacy systems, prefer wording that emphasizes compatibility preservation and minimal scope
