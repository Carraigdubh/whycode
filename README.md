# WhyCode

Development orchestrator with multi-agent workflows. Uses GSD+ methodology and whycode-loop for autonomous iteration.

**[Full Documentation](docs/WHYCODE.md)** - Comprehensive guide with all phases, agents, and troubleshooting.

> **v2.1.0**: WhyCode no longer requires the `ralph-wiggum` plugin. The new `whycode-loop` provides fresh 200k context per iteration with no external dependencies.

## Installation

### Method 1: Using the Plugin UI (Recommended)

The most reliable method inside Claude Code:

```bash
# Step 1: Add the marketplace
/plugin marketplace add Carraigdubh/whycode

# Step 2: Open plugin manager
/plugin

# Step 3: Go to "Discover" tab → Select "whycode" → Press Enter to install
# Step 4: Choose "project" scope when prompted
```

**Note:** WhyCode includes its own loop mechanism (whycode-loop) - no external plugins needed.

### Method 2: Using Terminal Commands

Run these commands in your terminal **before** starting Claude Code:

```bash
# Add marketplace
claude plugin marketplace add Carraigdubh/whycode

# Install whycode
claude plugin install whycode@whycode-marketplace --scope project

# Start Claude Code
claude
```

**Note:** WhyCode includes its own loop mechanism - no additional setup needed.

### Known Issues

**`/plugin install` returns conversational response instead of installing:**

This is a [known Claude Code bug](https://github.com/anthropics/claude-code/issues). The slash command sometimes triggers a conversational response instead of executing.

**Workarounds:**
1. Use the `/plugin` UI method (Method 1 above)
2. Use terminal commands (Method 2 above)
3. Try running the command again

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
/whycode log          # Record a manual change (no orchestration)
/whycode log "desc"   # Record a manual change with description
```

## Startup Switches (Interactive)

On startup, WhyCode prompts for:
- **Completion mode**: `strict` (all verifications must pass) or `partial` (build/typecheck clean with requirements logged)
- **Max iterations**: 20/30/50/custom
- **Run name**: suggested, editable

Fix runs (`/whycode fix`) must go through the same startup switches and run-selection gates before any implementation starts.
Run selection supports paging controls so older runs can be chosen: `more` (next page), `all` (show all), `continue`.
Selection is blocking: it stays on run selection until a valid run index/runId is chosen.
Run selection must include explicit options for `Show older runs` and `Show all runs` in the prompt UI.
Fix mode must ask which previous run to fix and what issues were found (unless included in `/whycode fix "desc"`).
Fix mode must always create a new `fix` child run linked via `parentRunId`; it must not silently resume.
For significant fixes (schema/cross-platform/core architecture changes), architecture approval is required before code changes.

## Mandatory Claude Rule (Exact Wording)

Add this to `CLAUDE.md` in projects that run WhyCode:

```md
## WhyCode (MANDATORY)

When `/whycode` is invoked, you MUST:
1. Read the FULL skill file before doing anything:
   - `plugins/whycode/skills/whycode/SKILL.md`
2. Read both reference files before orchestration:
   - `plugins/whycode/skills/whycode/reference/AGENTS.md`
   - `plugins/whycode/skills/whycode/reference/TEMPLATES.md`
3. Create or verify `docs/whycode/state.json` before executing any plan.
4. Follow the Trust No Agent verification loop:
   - Agent says done -> run validation -> pass -> then mark complete.
5. Do NOT improvise or substitute a custom orchestration flow.
6. If any required file above is not read, STOP and report startup incomplete.
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

**7 Specialized Agents:**

| Agent | Purpose |
|-------|---------|
| `backend-agent` | Backend APIs, database, server logic |
| `frontend-agent` | UI components, pages, client logic |
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
- **GitHub Workflow**: Per-run branch + PR, auto-push after each plan

## Repository Structure

```
whycode-marketplace/                    # Git repo root
├── .claude-plugin/
│   └── marketplace.json                # Marketplace definition
├── plugins/whycode/                    # Plugin files
│   ├── .claude-plugin/plugin.json
│   ├── CHANGELOG.md
│   ├── agents/                         # 7 agent definitions
│   │   ├── backend-agent.md
│   │   ├── frontend-agent.md
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
2. Update `plugins/whycode/CHANGELOG.md`
3. Commit and push

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
