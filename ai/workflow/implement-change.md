# Workflow: Implement Change

Use this workflow for feature work, behaviour adjustments, or localized enhancements.

## Step 1 – Understand the request
Identify:
- primary goal
- affected module
- compatibility-sensitive areas

Output:
Task Summary

## Step 2 – Analyze architecture and contract impact
Check:
- service boundary impact
- orchestration impact
- external contract impact
- legacy compatibility impact

Output:
Impact Summary

## Step 3 – Plan minimal change
Define:
- smallest safe modification point
- files to change
- validation approach

Avoid:
- unrelated refactor
- modernization
- broad cleanup

Output:
Implementation Plan

## Step 4 – Implement
Apply only the planned code changes.

Output:
Code Changes

## Step 5 – Validate
Describe:
- tests added or updated
- manual verification
- compatibility checks

Output:
Validation Summary

## Step 6 – Summarize
Provide:
- what changed
- why it changed
- affected components
- compatibility notes

Output:
Change Summary

## Step 7 – Commit
Generate commit message using ai/shared/commit-protocol.md.

Output:
Proposed Commit Message
