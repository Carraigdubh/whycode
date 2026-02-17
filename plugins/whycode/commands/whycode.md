---
description: "Start WhyCode development orchestrator workflow"
argument-hint: "[fix [description]]"
---

# WhyCode Command

Read and execute the WhyCode skill from disk (do not use cached or persisted command output).
You must read these files directly before startup:
- `${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md` (full file)
- `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/AGENTS.md`
- `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/TEMPLATES.md`

Follow the instructions in the skill file above. This is the WhyCode development orchestrator.

If the user provided "fix" as an argument, enter Fix and Learn mode as described in the skill.

Hard execution rule:
- Do not implement or mutate product code before startup gates are complete.
- Startup gates are complete only after ALL of these are done:
  1. Previous runs were listed and shown to user
  2. User selected completion mode (`strict|partial`)
  3. User selected max iterations
  4. User confirmed run name
  5. Run record was initialized AND visible in run list
  6. Run branch was initialized
  7. Startup auditor passed (`docs/whycode/audit/startup-audit.json`)
  8. If a Linear key is present, Linear is initialized with selected team (`linearEnabled=true`, `linearTeamId` set)
- If a startup gate is missing, stop and report: `startup incomplete`.
- For significant fixes (schema/data model changes, cross-platform changes, new core components, or >3 files changed), architecture design and user approval are mandatory before implementation.
- `/whycode fix` additional mandatory gates:
  - User selects which prior run to fix (parentRunId)
  - User provides a problem description (from argument or prompt)
  - Fix mode must create a new `runType=fix` child run; it must not silently route to `resume`
