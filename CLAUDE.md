# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

WhyCode is a Claude Code plugin that provides a development orchestrator with multi-agent workflows. It uses GSD+ methodology and **whycode-loop** for autonomous iteration with fresh context per iteration. This repository is the **marketplace distribution** for the WhyCode plugin.

## Repository Structure

```
whycode-marketplace/
├── .claude-plugin/marketplace.json    # Marketplace definition
├── plugins/whycode/                   # The actual plugin
│   ├── .claude-plugin/plugin.json     # Plugin metadata (name, version)
│   ├── CHANGELOG.md                   # Version history
│   ├── commands/whycode.md            # Slash command definition
│   ├── agents/                        # 7 agent definitions
│   │   ├── backend-agent.md
│   │   ├── frontend-agent.md
│   │   ├── test-agent.md
│   │   ├── e2e-agent.md
│   │   ├── review-agent.md
│   │   ├── tech-stack-setup-agent.md
│   │   └── docs-agent.md
│   └── skills/whycode/
│       ├── SKILL.md                   # Main orchestrator logic
│       └── reference/
│           ├── AGENTS.md              # Agent execution protocols
│           └── TEMPLATES.md           # Document templates
├── docs/WHYCODE.md                    # Full documentation
└── README.md                          # Installation guide
```

## Key Files

- **`plugins/whycode/.claude-plugin/plugin.json`** - Plugin version number (update this for releases)
- **`plugins/whycode/skills/whycode/SKILL.md`** - Main orchestrator logic and phase definitions
- **`plugins/whycode/agents/*.md`** - Individual agent behavior definitions
- **`plugins/whycode/CHANGELOG.md`** - Update this with version changes

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

## Development Workflow

### Testing Locally
```bash
# In a test project directory, install from local path:
/plugin install /Users/martinquinlan/dev/whycode-marketplace/plugins/whycode --scope project
```

### Making Changes
1. Edit files in `plugins/whycode/`
2. Test locally in a separate project
3. Update version in `plugins/whycode/.claude-plugin/plugin.json`
4. Update `plugins/whycode/CHANGELOG.md`
5. Update version in `.claude-plugin/marketplace.json` to match
6. Commit and push

### Version Bump Checklist
- [ ] `plugins/whycode/.claude-plugin/plugin.json` → `version`
- [ ] `.claude-plugin/marketplace.json` → `version` in plugins array
- [ ] `plugins/whycode/CHANGELOG.md` → add new version section

## Architecture Concepts

### 8-Phase Workflow
The WhyCode orchestrator runs projects through 8 phases:
0. Document Intake (Interactive) → 0.5. Codebase Mapping (Auto for brownfield) → 1. Discovery (Optional) → 2. Tech Stack Setup (Interactive) → 3. Specification (Semi-interactive) → 4. Architecture (Semi-interactive) → 5. Implementation (Autonomous) → 6. Quality Review (Autonomous) → 7. Documentation (Autonomous) → 8. Handoff (Autonomous)

### IMMUTABLE_DECISIONS
User technology choices (package manager, framework, database, auth) are captured in Phase 2 and enforced throughout. Agents must NEVER substitute alternatives.

### Context Management
- Each plan runs in a fresh 200k token subagent context
- Max 3 tasks per plan
- Agents return artifact paths, not full contents
- `/compact` runs automatically to manage context

### Agent Spawning
Agents must be referenced with the `whycode:` namespace prefix when spawning.

**Implementation Agents (Heavy Work):**
- `whycode:backend-agent` (opus, blue)
- `whycode:frontend-agent` (opus, green)
- `whycode:test-agent` (haiku, yellow)
- `whycode:e2e-agent` (haiku, orange)
- `whycode:review-agent` (opus, red)
- `whycode:tech-stack-setup-agent` (sonnet, purple)
- `whycode:docs-agent` (haiku, cyan)

**Utility Agents (Keep Orchestrator Context Clean):**
- `whycode:dependency-agent` (haiku, pink) - Install packages, verify lockfiles
- `whycode:validation-agent` (haiku, teal) - Run build/typecheck/lint/test
- `whycode:linear-agent` (haiku, indigo) - Linear API interactions
- `whycode:context-loader-agent` (haiku, gray) - Read files, return summaries
- `whycode:state-agent` (haiku, brown) - Update state files

**Context Management Rule:** The orchestrator should delegate to utility agents instead of:
- Loading files directly → use `whycode:context-loader-agent`
- Running npm/pnpm commands → use `whycode:dependency-agent`
- Running build/test commands → use `whycode:validation-agent`
- Calling Linear API → use `whycode:linear-agent`
- Updating state files → use `whycode:state-agent`

Agents are spawned via **whycode-loop** with fresh context per iteration:
- Each iteration spawns a fresh agent via the Task tool
- Memory persists only through filesystem (git, docs/whycode/loop-state/, docs/whycode/PLAN.md)
- No external plugin dependency

### Dependencies
- **Linear API (LINEAR_API_KEY)** (optional) - Issue tracking integration
- **Context7** (optional) - Library documentation lookup (disabled in marketplace build)
