# Agent Definitions

This file contains execution protocols for WhyCode.
Agents read this file AND their specific definition file when spawned.

## Agent Definition Files

Full agent definitions are in `../../../agents/`:

| Agent | Definition File | Description |
|-------|-----------------|-------------|
| `backend-agent` | `agents/backend-agent.md` | Backend APIs, database, server logic |
| `frontend-agent` | `agents/frontend-agent.md` | UI components, pages, client logic |
| `test-agent` | `agents/test-agent.md` | Unit/integration testing |
| `e2e-agent` | `agents/e2e-agent.md` | E2E UI testing (Chrome for web, Maestro for Expo) |
| `review-agent` | `agents/review-agent.md` | Code quality, bugs, security |
| `tech-stack-setup-agent` | `agents/tech-stack-setup-agent.md` | Project setup, configuration |
| `docs-agent` | `agents/docs-agent.md` | Documentation generation |

Each agent file contains:
- **Frontmatter**: `name`, `description`, `tools` (scoped)
- **IMMUTABLE_DECISIONS enforcement**: Rules agents MUST follow
- **Workflow**: Step-by-step execution
- **Artifact format**: Output structure
- **What NOT to do**: Constraints

---

## Autonomous Execution via ralph-wiggum

All agents execute autonomously using `/ralph-loop` from the **ralph-wiggum** plugin.

**What ralph-wiggum provides:**
- `/ralph-loop` command wraps agent execution
- **Stop hook** prevents agents from exiting prematurely
- Automatic re-prompting until completion marker is output
- Configurable max iterations

**Invocation format:**
```bash
/ralph-loop '<prompt>' --completion-promise PLAN_COMPLETE --max-iterations {configured}
```

**Key principles:**
1. The prompt **never changes** between iterations
2. Claude sees its previous work in files/git history
3. `--completion-promise` uses **exact string matching**
4. `--max-iterations` is the safety net

---

## Agent Execution Protocol

All agents follow this protocol within `/ralph-loop`:

```
1. READ docs/PLAN.md (XML format)

2. PARSE CONFIGURATION:
   - <immutable-decisions>: Use ONLY these technologies
   - <available-tools>: What integrations are enabled

3. FOR EACH <task> IN <tasks>:

   a. READ task requirements:
      - <name>: What to implement
      - <files>: Target files
      - <action>: Implementation steps
      - <verify>: Validation command
      - <done>: Success criteria

   b. IF <context7 enabled="true">:
      - resolve-library-id("library-name")
      - get-library-docs(library-id)

   c. IMPLEMENT the task per <action>

   d. RUN <verify> command
      - IF passes: Continue
      - IF fails: Fix and retry

   e. COMMIT:
      git add [<files>]
      git commit -m "feat({plan-id}): {task-name}"

   f. UPDATE LINEAR (if enabled):
      mcp__linear__update_issue(task.linear-id, state: "done")

   g. DOCUMENT THE TASK:
      - CREATE docs/tasks/{plan-id}-{task-id}.md
      - APPEND to docs/audit/log.md
      - UPDATE CHANGELOG.md (unreleased section)

   h. APPLY DEVIATION RULES if needed:
      - Rule 1: Auto-fix bugs, document in task record
      - Rule 2: Auto-add security/correctness
      - Rule 3: Auto-fix blockers
      - Rule 4: STOP for architectural changes
      - Rule 5: Log enhancements to docs/ISSUES.md

4. AFTER ALL TASKS:
   - Append summary to docs/SUMMARY.md
   - UPDATE docs/features/{feature}.md
   - Output exactly: PLAN_COMPLETE
```

---

## Standard Agent Prompt

```
/ralph-loop 'You are executing a plan. Read docs/PLAN.md for XML specification.

FIRST:
1. Read your agent definition: agents/{agent-type}.md (e.g., agents/backend-agent.md)
2. Read docs/whycode/reference/AGENTS.md for execution protocol

EXECUTION:
1. Read docs/PLAN.md - tasks in XML format
2. Read <immutable-decisions> - use ONLY these technologies
3. Read <available-tools> - your allowed integrations

FOR EACH <task>:
  a. Read <action> for implementation steps
  b. IF context7 enabled: Look up library docs first
  c. Implement the task
  d. Run <verify> command
  e. IF passes: commit and update Linear
  f. IF fails: fix and retry
  g. Document: Create docs/tasks/{plan-id}-{task-id}.md
  h. Append to docs/audit/log.md
  i. Update CHANGELOG.md

AFTER ALL TASKS:
  - Append to docs/SUMMARY.md
  - Update docs/features/{feature}.md
  - Output exactly: PLAN_COMPLETE

' --completion-promise PLAN_COMPLETE --max-iterations {MAX_ITERATIONS}
```

---

## TDD Agent Prompt

```
/ralph-loop 'You are executing a TDD plan. Read docs/PLAN.md for specification.

FIRST:
1. Read your agent definition: agents/test-agent.md
2. Read docs/whycode/reference/AGENTS.md for execution protocol

TDD PROTOCOL (Red-Green-Refactor):
FOR EACH <task>:

  RED:
  - Write failing test based on <done> criteria
  - Run tests - MUST fail
  - git commit -m "test({plan-id}): add failing test for {task-name}"

  GREEN:
  - Implement minimal code from <action>
  - Run tests - MUST pass
  - git commit -m "feat({plan-id}): implement {task-name}"

  REFACTOR:
  - Clean up if needed
  - Run tests - MUST still pass
  - git commit -m "refactor({plan-id}): clean up {task-name}"

  - Update Linear: task.linear-id → done
  - Document: Create docs/tasks/{plan-id}-{task-id}.md
  - Update CHANGELOG.md

AFTER ALL TASKS:
  - Append to docs/SUMMARY.md
  - Output exactly: PLAN_COMPLETE

' --completion-promise PLAN_COMPLETE --max-iterations {MAX_ITERATIONS}
```

---

## Documentation Agent Prompt

```
/ralph-loop 'You are a documentation agent. Generate SE documentation.

FIRST:
1. Read your agent definition: agents/docs-agent.md
2. Read docs/whycode/reference/TEMPLATES.md for document formats

DOCUMENTATION PROTOCOL:
1. Read context from:
   - docs/PROJECT.md (vision)
   - docs/ROADMAP.md (phases)
   - docs/SUMMARY.md (what was built)
   - Source code files

2. FOR EACH documentation task:
   a. Gather relevant information
   b. Generate/update the document
   c. Use templates from TEMPLATES.md
   d. Cross-reference related docs
   e. git commit -m "docs({scope}): {description}"

DOCUMENTS TO GENERATE:
- README.md (project overview, setup, usage)
- CHANGELOG.md (Keep a Changelog format)
- CONTRIBUTING.md (dev setup, standards)
- docs/api/*.md (API documentation)
- docs/DEPLOYMENT.md (deployment guide)

AFTER ALL TASKS:
  - Update docs/SUMMARY.md
  - Output exactly: PLAN_COMPLETE

' --completion-promise PLAN_COMPLETE --max-iterations {MAX_ITERATIONS}
```

---

## Linear Integration in Agents

When `<linear enabled="true">` in the plan:

```
# Before starting task:
mcp__linear__update_issue({
  id: task.linear-id,
  state: "in_progress"
})

# After completing task:
mcp__linear__update_issue({
  id: task.linear-id,
  state: "done"
})

mcp__linear__create_comment({
  issueId: task.linear-id,
  body: "✅ Completed: {<done> text}"
})
```

---

## Specialized Agent Types

| Agent | Use Case | Special Capabilities |
|-------|----------|---------------------|
| `general-purpose` | Standard implementation | All enabled tools |
| `test-agent` | TDD plans | Test runners, TDD protocol |
| `frontend-agent` | UI work | frontend-design skill |
| `backend-agent` | API/DB work | Database tools |
| `docs-agent` | Documentation | Document generation |

All agents follow the same XML plan format and execution protocol.

---

## IMMUTABLE_DECISIONS Enforcement

**AGENTS MUST:**
- Check `<immutable-decisions>` before any implementation
- Use EXACTLY the technologies specified
- Use ONLY commands from `<pm-commands>`

**AGENTS MUST NEVER:**
- Substitute a different package manager
- Use a different library because it's "better"
- Change any user-specified technology choice

**VIOLATIONS ARE TASK FAILURES.**
