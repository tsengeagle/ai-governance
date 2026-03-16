/init

This repository uses a bootstrap manifest located at:

ai/project-context-bootstrap.yaml

Your task is to generate the full AI governance context for this repository.

---

Step 1 — Read the bootstrap manifest

Load:

ai/project-context-bootstrap.yaml

This file contains the authoritative human context for the repository.

Important rules:

Fields may contain the following markers:

AUTO
→ infer from repository structure, build files, and code

UNKNOWN
→ do not guess
→ leave unchanged and mark for human completion

Any explicit value
→ treat as authoritative
→ do not override

---

Step 2 — Analyze the repository

Inspect the repository to infer:

technology stack
framework
API style
entry points
persistence layer
integration patterns

Use evidence from:

build files
directory structure
framework annotations
dependency configuration

---

Step 3 — Produce the full project context

Create the file:

ai/project-context.yaml

This file should be a fully resolved version of the bootstrap manifest.

Rules:

AUTO values must be replaced with inferred values.

UNKNOWN values must remain unchanged.

Do not change human-provided fields.

---

Step 4 — Report the inference

Provide a short report describing:

which fields were inferred
what evidence was used
which UNKNOWN fields require human input

---

Constraints

This repository belongs to a legacy SOA system.

If legacy frameworks or legacy patterns are detected:

prefer minimal-change analysis
do not recommend modernization

Do not assume other repositories’ behavior.

Cross-repository assumptions are forbidden.

---

Expected outputs

1️⃣ ai/project-context.yaml  
2️⃣ inference summary
