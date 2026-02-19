# WhyCode

Development orchestrator with multi-agent workflows. Uses GSD+ methodology and whycode-loop for autonomous iteration.

**[Full Documentation](docs/WHYCODE.md)** - Comprehensive guide with all phases, agents, and troubleshooting.

> **v3.0.0**: WhyCode now enforces specialist-agent preflight contracts, issue+drift intake in the WhyCode repo, and metadata-backed agent maintenance.

## Installation

### Terminal Install (Preferred)

Run these commands in your terminal before starting Claude Code:

```bash
# Add marketplace
claude plugin marketplace add Carraigdubh/whycode

# Install whycode
claude plugin install whycode@whycode-marketplace --scope project

# Start Claude Code
claude
```

### Terminal Reinstall (Clean Reset, Recommended)

Use this exact sequence when updating or fixing install issues:

```bash
claude plugin uninstall whycode@whycode-marketplace --scope project || true
claude plugin marketplace remove whycode-marketplace || true
claude plugin marketplace add Carraigdubh/whycode
claude plugin install whycode@whycode-marketplace --scope project
claude plugin list
```

Then restart Claude Code.

If the version is not current after reinstall, run:

```bash
claude plugin update whycode@whycode-marketplace --scope project
claude plugin list
```

### Known Issues

**`/plugin install` returns conversational response instead of installing:**

This is a [known Claude Code bug](https://github.com/anthropics/claude-code/issues). The slash command sometimes triggers a conversational response instead of executing.

**Workarounds:**
1. Use terminal commands (Installation section above)
2. Run the terminal reinstall sequence (clean reset)

**Plugin shows "already installed" but `/whycode` not available:**

```bash
# Restart Claude Code after installation
# The slash command registers on restart
```

### Dependencies

| Dependency | Required | Purpose |
|------------|----------|---------|
| Linear API (LINEAR_API_KEY) | No | Issue tracking integration |
| Context7 | No | Library documentation lookup (disabled in marketplace build) |
| Chrome extension | No | E2E testing for web projects |

## Usage

```bash
/whycode              # Start full 8-phase workflow
/whycode fix          # Fix and Learn mode
/whycode fix "desc"   # Fix with description
/whycode doctor       # Diagnose active plugin/version/path/cache issues
/whycode log          # Record a manual change (no orchestration)
/whycode log "desc"   # Record a manual change with description
```

`/whycode doctor` can now offer to auto-fix stale WhyCode path references in project `CLAUDE.md` and then re-run diagnostics.

## How WhyCode Works (v3)

WhyCode now runs as a contract-driven orchestration system:

1. Startup gates (fail-closed)
- Required reads, run selection, run recording, branch setup, startup gate + startup audit.
- If any required gate fails, WhyCode stops with `startup incomplete`.

2. Capability + context planning
- Builds `docs/whycode/capability-plan.json` and `docs/whycode/tech-capabilities.json`.
- Detects stack, routing, specialist gaps, and deployment/context modes.

3. User decision points (no silent assumptions)
- Required choices for capability gaps (`fallback|issue|pr-scaffold|cancel`).
- Mode confirmations when context is ambiguous (for example Convex mode).

4. Specialist preflight contract
- Specialist agents must resolve context deterministically and fail closed on ambiguity.
- They must write `docs/whycode/audit/specialist-preflight-{planId}.json` before implementation.
- Orchestrator blocks specialist plan execution if preflight artifact is missing or failing.

5. Trust-no-agent execution loop
- Agents run in fresh context via whycode-loop.
- `PLAN_COMPLETE` is externally verified (typecheck/lint/test/build/smoke).
- Failed verification loops back until pass, blocked, or max iterations.

6. Run history + auditability
- Each run writes structured artifacts under `docs/whycode/runs/{runId}`.
- Startup/decision/progress artifacts are recorded for replay and diagnosis.

7. WhyCode-repo maintenance mode
- In this repository, work starts with open issue intake plus drift intake (API/docs/dependency/runtime changes).
- Specialist agents are maintained as living contracts with required metadata:
  - `sourceDocs`
  - `versionScope`
  - `lastVerifiedAt`
  - `driftTriggers`

## Startup Switches (Interactive)

On startup, WhyCode prompts for:
- **Completion mode**: `strict` (all verifications must pass) or `partial` (build/typecheck clean with requirements logged)
- **Max iterations**: 20/30/50/custom
- **Execution speed mode**: `off`, `review-teams`, or `turbo-teams` (experimental Agent Teams acceleration)
- **Capability decision** (when gaps are detected): `fallback`, `issue`, `pr-scaffold`, or `cancel`
  - `issue` now attempts immediate GitHub issue creation via `gh issue create` (with fallback requirement logging if GitHub auth is missing)
- **Convex mode confirmation** (when Convex is detected but ambiguous): `local-dev`, `cloud-dev`, or `cloud-live` (fail-closed)
- **Run name**: suggested, editable

Fix runs (`/whycode fix`) must go through the same startup switches and run-selection gates before any implementation starts.
Run selection supports paging controls so older runs can be chosen: `more` (next page), `all` (show all), `continue`.
Selection is blocking: it stays on run selection until a valid run index/runId is chosen.
Run selection must include explicit options for `Show older runs` and `Show all runs` in the prompt UI.
Fix mode must ask which previous run to fix and what issues were found (unless included in `/whycode fix "desc"`).
Fix mode must always create a new `fix` child run linked via `parentRunId`; it must not silently resume.
If Linear is configured, fix runs must also create/update Linear records (same as normal WhyCode runs).
If a Linear key is detected at startup, WhyCode now fails closed unless Linear initializes successfully and a team is selected.
If more than 5 runs exist, fix mode must show explicit `Show older runs` and `Show all runs` controls before Parent Run can continue.
Startup now includes a run-visibility gate: the current run must exist in `docs/whycode/runs` and appear in `list-runs` before execution continues.
Startup now includes an independent startup-auditor gate: `docs/whycode/audit/startup-audit.json` must be `pass` before any implementation starts.
Startup now includes capability planning: `docs/whycode/capability-plan.json` is generated and any capability-gap decision is user-selected and audited.
Capability preflight now runs before Run Action selection so users can see detected stack/routing/gaps early.
WhyCode now maintains `docs/whycode/tech-capabilities.json` as a persistent tech catalog (created when missing, updated each run).
When Convex is detected, WhyCode now tracks `convexContext.mode` and persists the selected mode in `docs/whycode/decisions/convex-mode.json` so Convex agents do not assume local workflows.
Capability output is now independently audited against `docs/whycode/reference/AGENTS.md`; missing required specialists force `gaps_found` (fail-closed).
For significant fixes (schema/cross-platform/core architecture changes), architecture approval is required before code changes.

### Specialist Agent Creation Rule (Mandatory)

Any new specialist agent (manual addition or capability-gap issue/PR request) must include a specialist preflight gate:
- Resolve specialist context from capability outputs + `docs/whycode/decisions/*.json`.
- Fail closed when context is ambiguous.
- Write `docs/whycode/audit/specialist-preflight-{planId}.json` before implementation.
- Include blocked commands/reasons when safety gates prevent execution.
- For new specialist-agent builds in WhyCode repo, read `CLAUDE.md` + `AGENTS.md` first, and update `CLAUDE.md`/`AGENTS.md`/`README.md` when policy or user-visible behavior changes.
- Add Specialist Metadata in each specialist agent:
  - `sourceDocs`
  - `versionScope`
  - `lastVerifiedAt`
  - `driftTriggers`

### WhyCode Repo Intake Rule (Mandatory)

When working in the WhyCode repository itself:
- Start with open-issue intake and classify candidates (`new-agent`, `agent-update`, `policy/docs`).
- Run drift intake for existing specialist agents (API/docs/dependency/runtime changes).
- Propose prioritized queue; do not auto-implement all issues without explicit selection.
- Update specialist metadata (`lastVerifiedAt`) when agent guidance is refreshed.

### Agent Teams (Experimental)

- `off`: default behavior (fully backward compatible)
- `review-teams`: Agent Teams only in Phase 6 review
- `turbo-teams`: Agent Teams lead/delegate in Phases 5, 6, and 7 for maximum speed

Startup/fix gates and run recording remain unchanged across all modes.

Enable in Claude settings:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "teammateMode": "tmux"
}
```

If teams are unavailable at runtime, WhyCode falls back to standard review execution.

## Mandatory Claude Rule (Exact Wording)

In each project that runs WhyCode, replace any existing WhyCode section in `CLAUDE.md` with the block below exactly.

Use this instruction text in Claude Code (copy/paste):

```text
Open CLAUDE.md and replace the entire section titled "WhyCode (MANDATORY)" with the exact block below. Do not paraphrase, merge, or keep older WhyCode rules.
Also remove any project-local `plugins/whycode/` rule references from CLAUDE.md; the mandatory reads must use `${CLAUDE_PLUGIN_ROOT}` paths.
```

Exact block to insert:

```md
## WhyCode (MANDATORY)

When `/whycode` is invoked, you MUST:
1. Read the FULL skill file before doing anything:
   - `${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md`
2. Read both reference files before orchestration:
   - `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/AGENTS.md`
   - `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/TEMPLATES.md`
3. Create or verify `docs/whycode/state.json` before executing any plan.
4. Follow the Trust No Agent verification loop:
   - Agent says done -> run validation -> pass -> then mark complete.
5. Do NOT improvise or substitute a custom orchestration flow.
6. Verify startup artifacts before execution:
   - `docs/whycode/audit/startup-gate.json` has `status: pass`
   - `docs/whycode/audit/startup-audit.json` has `status: pass`
7. If any required file above is not read or any startup artifact is failing/missing, STOP and report startup incomplete.
```

## Run Records

Each run is archived under `docs/whycode/runs/{runId}` with:
- `run.json` (name, version, completionMode, branch/PR)
- `loop-state/` (iteration history)
- `commits.json` (per-plan commit list)
- `summary.md` (what happened, validations, next steps)

All execution modes are recorded:
- full runs (`/whycode`)
- fix runs (`/whycode fix`)
- review/resolve/rerun/resume actions
- log-only records (`/whycode log`)

Project source-of-truth docs live in `docs/project documentation/` and are synced after each plan.
`CLAUDE.md` is policy/config and is out of scope for docs sync.

## Preferred Documentation Structure

- `docs/whycode/` → **WhyCode runtime root** (state, loop-state, runs, plans, specs, decisions, intake, audit, artifacts, features)
- `docs/project documentation/` → **Canonical project documentation** (PRD, tech specs, API specs, etc.)

WhyCode run artifacts live under `docs/whycode/` and should not be mixed with project docs.

## GitHub Workflow

WhyCode creates a **run branch** per run, pushes after each plan, and opens a PR:
- Branch: `whycode/{friendly-name}-{runId}`
- PR title: `WhyCode: {runName}`
- If a plan is partial, the Linear issue is marked **Blocked** with requirements.

## What It Does

**8-Phase Workflow:**

| Phase | Name | Mode |
|-------|------|------|
| 0 | Document Intake | Interactive |
| 0.5 | Codebase Mapping | Auto (brownfield) |
| 1 | Discovery | Optional |
| 2 | Tech Stack Setup | Interactive |
| 3 | Specification | Semi-interactive |
| 4 | Architecture | Semi-interactive |
| 5 | Implementation | Autonomous |
| 6 | Quality Review | Autonomous |
| 7 | Documentation | Autonomous |
| 8 | Handoff | Autonomous |

**Specialist + Core Agents:**

| Agent | Purpose |
|-------|---------|
| `backend-agent` | Backend APIs, database, server logic |
| `backend-convex-agent` | Convex schema/functions/index/auth patterns |
| `backend-auth-agent` | Clerk-focused authN/authZ, middleware, webhook safety |
| `frontend-agent` | UI components, pages, client logic |
| `frontend-web-agent` | Next.js/web frontend specialist |
| `frontend-native-agent` | Expo/React Native frontend specialist |
| `deploy-vercel-agent` | Vercel deploy/env/runtime specialist |
| `test-agent` | Unit/integration testing |
| `e2e-agent` | E2E UI testing (Chrome for web, Maestro for Expo) |
| `review-agent` | Code quality, bugs, security |
| `tech-stack-setup-agent` | Project setup, configuration |
| `docs-agent` | Documentation generation |

## Key Features

- **IMMUTABLE_DECISIONS**: User technology choices are never substituted
- **GSD+ Methodology**: Fresh 200k context per plan, max 3 tasks per plan
- **whycode-loop**: Autonomous iteration with fresh context per iteration
- **Linear Integration**: Issue tracking (optional)
- **Version Checking**: Shows updates on startup with changelog
- **Run Archiving**: Each run stored under `docs/whycode/runs/{runId}`
- **Partial Completion**: Records unmet requirements without blocking all progress
- **GitHub Workflow**: Per-run branch + PR, auto-push after each plan; capability-gap issue option can open GitHub issues directly
- **Deployment Topology Aware**: Vercel specialist now detects `github-integration` vs `vercel-cli` vs `hybrid` and applies safe mode-aware behavior

## Repository Structure

```
whycode-marketplace/                    # Git repo root
├── .claude-plugin/
│   └── marketplace.json                # Marketplace definition
├── plugins/whycode/                    # Plugin files
│   ├── .claude-plugin/plugin.json
│   ├── CHANGELOG.md
│   ├── agents/                         # Core + specialist agent definitions
│   │   ├── backend-agent.md
│   │   ├── backend-convex-agent.md
│   │   ├── backend-auth-agent.md
│   │   ├── frontend-agent.md
│   │   ├── frontend-web-agent.md
│   │   ├── frontend-native-agent.md
│   │   ├── deploy-vercel-agent.md
│   │   ├── test-agent.md
│   │   ├── e2e-agent.md
│   │   ├── review-agent.md
│   │   ├── tech-stack-setup-agent.md
│   │   └── docs-agent.md
│   └── skills/whycode/
│       ├── SKILL.md                    # Main orchestrator
│       └── reference/
│           ├── AGENTS.md               # Agent execution protocols
│           └── TEMPLATES.md            # Document templates
└── README.md                           # This file
```

## Development

### Editing Plugin Files
```bash
cd /Users/martinquinlan/dev/whycode-marketplace/plugins/whycode
# Edit agents, skills, etc.
```

### Committing Changes
```bash
cd /Users/martinquinlan/dev/whycode-marketplace
git add .
git commit -m "feat: description of change"
git push
```

### Version Bump
1. Update `plugins/whycode/.claude-plugin/plugin.json` → `version`
2. Update `.claude-plugin/marketplace.json` → plugin `version`
3. Update `plugins/whycode/CHANGELOG.md`
4. Commit and push

### Testing Locally
```bash
# In test project
/plugin install /Users/martinquinlan/dev/whycode-marketplace/plugins/whycode --scope project
```

## Dependencies

- **Linear API (LINEAR_API_KEY)** (optional): For issue tracking integration
- **Context7** (optional): For library documentation lookup (disabled in marketplace build)
- **Chrome extension** (optional): For E2E testing of web projects

## References

- [GSD: Get Shit Done](https://github.com/glittercowboy/get-shit-done)
- [The Ralph Wiggum Playbook](https://humanlayer.dev/blog/ralph-wiggum-playbook) - Inspiration for whycode-loop
- [Anthropic: Multi-agent best practices](https://www.anthropic.com/engineering/multi-agent-research-system)
