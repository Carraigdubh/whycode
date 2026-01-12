# Templates & Formats

This file contains XML plan formats and document templates for the Development Harness.

---

## XML Plan Format (GSD+ Style)

Plans use XML format. **Maximum 3 tasks per plan.**

```xml
<plan id="01-02" linear-id="ABC-104">
  <name>Auth API Endpoints</name>
  <type>standard</type>
  <phase>1</phase>

  <immutable-decisions>
    <!-- NEVER substitute these -->
    <package-manager>pnpm</package-manager>
    <framework>next</framework>
    <database>supabase</database>
    <auth>clerk</auth>
  </immutable-decisions>

  <pm-commands>
    <install>pnpm install</install>
    <add-dep>pnpm add</add-dep>
    <build>pnpm run build</build>
    <test>pnpm run test</test>
  </pm-commands>

  <available-tools>
    <linear enabled="true">Update issues after each task</linear>
    <context7 enabled="true">Look up library docs</context7>
  </available-tools>

  <tasks>
    <task type="auto" linear-id="ABC-105">
      <name>Create login endpoint</name>
      <files>src/app/api/auth/login/route.ts</files>
      <action>Use jose for JWT. Validate credentials. Return httpOnly cookie.</action>
      <verify>curl -X POST localhost:3000/api/auth/login returns 200</verify>
      <done>Valid credentials return cookie, invalid return 401</done>
      <docs>
        <api>docs/api/auth.md#login</api>
      </docs>
    </task>
    <!-- Max 3 tasks per plan -->
  </tasks>
</plan>
```

---

## Task Record Template

Location: `docs/tasks/{plan-id}-{task-id}.md`

```markdown
# Task: {task-name}

## Metadata
- **Plan**: {plan-id} ({plan-name})
- **Linear**: [{linear-id}](https://linear.app/team/issue/{linear-id})
- **Status**: ✅ Complete | ❌ Failed | ⚠️ Partial
- **Started**: {ISO timestamp}
- **Completed**: {ISO timestamp}
- **Duration**: {duration}

## Objective
{From <action> in plan XML}

## Files Changed
| File | Action | Lines |
|------|--------|-------|
| src/components/Login.tsx | Created | +127 |
| src/lib/auth.ts | Modified | +45, -12 |

## Implementation Notes
{What was actually done, any deviations from plan}

## Verification
```bash
{<verify> command}
```
**Result**: ✅ Pass / ❌ Fail

## Issues Encountered
- {Any bugs fixed via Deviation Rule 1}
- {Any blockers resolved via Deviation Rule 3}

## Related
- Feature: [Feature Name](../features/{feature}.md)
- ADR: [ADR-001: Tech Stack](../adr/ADR-001-tech-stack.md)
```

---

## Audit Log Format

Location: `docs/audit/log.md` (append-only)

```markdown
# Audit Log

## {ISO timestamp} - Harness Started
- **Phase**: 0 (Intake)
- **User**: {user}
- **Documents provided**: {count}

## {ISO timestamp} - Tech Stack Decision
- **Phase**: 2 (Tech Stack)
- **Decision**: {package-manager} + {framework} + {database}
- **Rationale**: User specified

## {ISO timestamp} - Task Started
- **Phase**: 5 (Implementation)
- **Plan**: {plan-id}
- **Task**: {task-name}
- **Agent**: {agent-type}
- **Linear**: {linear-id}

## {ISO timestamp} - Task Completed
- **Plan**: {plan-id}
- **Task**: {task-name}
- **Result**: ✅ Pass
- **Files**: {file-list}
- **Commit**: {commit-hash}

## {ISO timestamp} - Task Failed
- **Plan**: {plan-id}
- **Task**: {task-name}
- **Result**: ❌ Fail
- **Error**: {error-message}
- **Recovery**: {action-taken}

## {ISO timestamp} - Harness Completed
- **Status**: ✅ Success | ❌ Failed
- **Duration**: {duration}
- **Tasks**: {completed}/{total} complete
- **Issues**: {auto-fixed} auto-fixed, {deferred} deferred
```

---

## Architecture Decision Record (ADR) Template

Location: `docs/adr/ADR-{number}-{title}.md`

```markdown
# ADR-{number}: {title}

## Status
{Proposed | Accepted | Deprecated | Superseded}

## Date
{YYYY-MM-DD}

## Context
{What is the issue that we're seeing that motivates this decision?}

## Decision
{What is the decision that was made?}

## Consequences

### Positive
- {Good outcomes}

### Negative
- {Trade-offs accepted}

### Neutral
- {Other impacts}

## Related
- ADR-{n}: {Related decision}
- Feature: {Related feature}
```

---

## Feature Documentation Template

Location: `docs/features/{feature-name}.md`

```markdown
# Feature: {Feature Name}

## Status
{Planning | In Progress | Complete | Blocked}

## Overview
{Brief description of the feature}

## User Story
As a {user type}, I want to {action} so that {benefit}.

## Acceptance Criteria
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

## Technical Approach
{How this feature is implemented}

## Dependencies
- {Other features this depends on}
- {External services required}

## Tasks
| Task | Plan | Status | Linear |
|------|------|--------|--------|
| {task-name} | {plan-id} | ✅ | {linear-id} |

## Notes
{Any additional information}
```

---

## GSD+ Persistent Documents

### PROJECT.md (~100 lines max)
```markdown
# {Project Name}

## Vision
{One paragraph describing what this project is and why it exists}

## Core Value
{The single most important thing this project delivers}

## Goals
1. {Primary goal}
2. {Secondary goal}
3. {Tertiary goal}

## Non-Goals
- {What this project explicitly does NOT do}

## Success Criteria
- {Measurable outcome 1}
- {Measurable outcome 2}

## Target User
{Who this is for}

## Key Constraints
- {Technical constraint}
- {Business constraint}
- {Time constraint}
```

### ROADMAP.md (~150 lines max)
```markdown
# Roadmap

## Progress: [██████░░░░] 60%

## Phase 1: {Name} ✅ COMPLETE
- {Summary of what was done}

## Phase 2: {Name} 🔄 IN PROGRESS
- Plan 02-01: {name} ✅
- Plan 02-02: {name} 🔄
- Plan 02-03: {name} ⏳

## Phase 3: {Name} ⏳ PENDING
- {What will be done}

## Milestones
| Milestone | Target | Status |
|-----------|--------|--------|
| MVP | {date} | 🔄 |
| Beta | {date} | ⏳ |
```

### STATE.md (~100 lines max, living memory)
```markdown
# State

## Current Position
- **Phase**: {current-phase}
- **Plan**: {current-plan}
- **Blockers**: {any blockers}

## IMMUTABLE_DECISIONS
{Copy from tech-stack.json}

## Recent Changes
- {What just happened}

## Next Actions
- {What happens next}

## Context for Next Session
{Critical information to preserve}
```

---

## README Template

```markdown
# {Project Name}

{One-line description}

## Features
- {Feature 1}
- {Feature 2}

## Prerequisites
- {Runtime} v{version}
- {Other requirements}

## Installation

```bash
{install-command}
```

## Configuration

Copy `.env.example` to `.env.local` and fill in:
```
{REQUIRED_VAR}=
{OPTIONAL_VAR}=  # Optional: {description}
```

## Usage

```bash
{run-command}
```

## API

See [API Documentation](docs/api/README.md)

## Contributing

See [Contributing Guide](CONTRIBUTING.md)

## License

{License type}
```

---

## CHANGELOG Template (Keep a Changelog)

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- {New feature}

### Changed
- {Change to existing functionality}

### Fixed
- {Bug fix}

## [1.0.0] - {YYYY-MM-DD}

### Added
- Initial release
- {Feature 1}
- {Feature 2}
```
