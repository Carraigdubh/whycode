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
If file preview is truncated/too large, continue with chunked direct-disk reads; never substitute persisted/cached output.
If required-read output says it will use persisted/cached output, STOP immediately with `startup incomplete`.

Follow the instructions in the skill file above. This is the WhyCode development orchestrator.

If the user provided "fix" as an argument, enter Fix and Learn mode as described in the skill.

Hard execution rule:
- Do not implement or mutate product code before startup gates are complete.
- Startup gate prompts must be interactive Q&A prompts (one decision at a time) using explicit selectable options.
- Do not batch startup prompts into a single summary block (for example "Startup Decisions Needed ... Please confirm or adjust").
- Startup gates are complete only after ALL of these are done:
  1. Previous runs were listed and shown to user
  2. User selected completion mode (`strict|partial`)
  3. User selected max iterations
  4. User confirmed run name
  5. Run record was initialized AND visible in run list
  6. Run branch was initialized
  7. Startup auditor passed (`docs/whycode/audit/startup-audit.json`)
  8. If a Linear key is present, Linear is initialized with selected team (`linearEnabled=true`, `linearTeamId` set)
  9. Project root isolation is bound (`projectRootBound=true`) and no cross-project WhyCode paths are referenced
  10. Request anchoring gate passed (`requestAnchored=true`) or explicit greenfield approval recorded (`greenfieldApproved=true`)
  11. Startup action selection used interactive choice UI (`runActionInteractive=true`)
- If a startup gate is missing, stop and report: `startup incomplete`.
- For significant fixes (schema/data model changes, cross-platform changes, new core components, or >3 files changed), architecture design and user approval are mandatory before implementation.
- `/whycode fix` additional mandatory gates:
  - User selects which prior run to fix (parentRunId)
  - Fix target selection must use interactive Q&A choice UI (not plain text step output)
  - User provides a problem description (from argument or prompt)
  - Fix mode must create a new `runType=fix` child run; it must not silently route to `resume`
