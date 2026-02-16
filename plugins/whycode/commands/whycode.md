---
description: "Start WhyCode development orchestrator workflow"
argument-hint: "[fix [description]]"
---

# WhyCode Command

Read and execute the WhyCode skill:

```!
cat "${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md"
```

Follow the instructions in the skill file above. This is the WhyCode development orchestrator.

If the user provided "fix" as an argument, enter Fix and Learn mode as described in the skill.

Hard execution rule:
- Do not implement or mutate product code before startup gates are complete.
- Startup gates are complete only after ALL of these are done:
  1. Previous runs were listed and shown to user
  2. User selected startup action (`resume|rerun|review|resolve|new`)
  3. User selected completion mode (`strict|partial`)
  4. User selected max iterations
  5. User confirmed run name
  6. Run branch was initialized
- If a startup gate is missing, stop and report: `startup incomplete`.
- For significant fixes (schema/data model changes, cross-platform changes, new core components, or >3 files changed), architecture design and user approval are mandatory before implementation.
