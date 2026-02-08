# Changelog

All notable changes to WhyCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

## [2.3.0] - 2026-02-08

### Added
- Hard startup compliance gate in SKILL.md requiring full read of skill + references before orchestration
- Startup compliance artifact: `docs/whycode/audit/startup-check.json`
- Explicit mandatory `/whycode` execution rule block in repository `CLAUDE.md`
- README section with exact `CLAUDE.md` wording for mandatory WhyCode flow

## [2.2.9] - 2026-02-03

### Added
- `/whycode log` to record manual fixes without running orchestration

## [2.2.8] - 2026-02-03

### Added
- Run records for fix/review/resolve/rerun/resume modes
- Backfill of missing run.json entries during startup
- Run event logging via state-agent

## [2.2.7] - 2026-01-25

### Added
- Optional docs sync during review mode

## [2.2.6] - 2026-01-25

### Changed
- Run selection is now an explicit startup prompt

## [2.2.5] - 2026-01-25

### Added
- Run selection step (resume/rerun/review/resolve/new)
- Legacy state migration for docs/whycode-state.json

## [2.2.4] - 2026-01-25

### Fixed
- Version check now reads plugin.json from CLAUDE_PLUGIN_ROOT

## [2.2.3] - 2026-01-25

### Changed
- README now documents the preferred documentation structure (docs/whycode vs project docs)

## [2.2.2] - 2026-01-25

### Changed
- WhyCode runtime artifacts now live under docs/whycode
- Documentation updated to match new structure

## [2.2.1] - 2026-01-25

### Changed
- Documentation updated with run management, completion modes, and GitHub workflow

## [2.2.0] - 2026-01-25

### Added
- Project documentation sync after each plan

### Changed
- docs-agent now treats docs/project documentation as source of truth

## [2.1.9] - 2026-01-25

### Added
- GitHub run branches with friendly name + runId
- Auto push after each plan
- Auto PR creation per run

### Changed
- Git operations routed via new git-agent

## [2.1.8] - 2026-01-25

### Added
- Partial completion mode with requirements tracking
- Requirements list stored in docs/whycode/requirements/pending.json

### Changed
- Completion mode prompt added at startup

## [2.1.7] - 2026-01-25

### Added
- Run listing at startup
- Friendly run names (suggested + editable)

### Changed
- Completed runs are archived automatically at startup

## [2.1.6] - 2026-01-25

### Added
- Run archive folders under docs/whycode/runs/{runId}
- Run metadata file docs/whycode/runs/{runId}/run.json

### Changed
- Existing in-progress run is archived before starting a new run

## [2.1.5] - 2026-01-25

### Added
- Subagent runId and run log entries in loop-state
- JSON-only subagent output with note length cap

### Changed
- Explicit subagent banner includes runId for visibility
- Degraded mode guidance when Task tool is unavailable

## [2.1.4] - 2026-01-25

### Added
- Explicit subagent banner in Task prompts
- Subagent start timestamp in loop-state

## [2.1.3] - 2026-01-25

### Added
- Pre-flight check to skip tasks already implemented

## [2.1.2] - 2026-01-25

### Added
- Checkpoint commit rule after repeated verification failures
- Explicit Task tool usage language for subagents

### Changed
- Linear integration docs now reference direct API usage (no MCP)

## [2.1.1] - 2026-01-25

### Fixed
- Removed MCP dependencies from agent definitions
- Hardened whycode-loop for more reliable iteration

## [2.1.0] - 2025-01-16

### Changed
- **BREAKING**: Replaced `ralph-wiggum` dependency with native `whycode-loop`
  - Each iteration now spawns in a **fresh 200k token context** (no context degradation)
  - Memory persists only through filesystem (`docs/whycode/loop-state/`, git, PLAN.md)
  - No external plugin dependency required
  - Based on [The Ralph Wiggum Playbook](https://humanlayer.dev/blog/ralph-wiggum-playbook)

### Added
- New state file pattern: `docs/whycode/loop-state/{plan-id}.json` for iteration tracking
- Result file pattern: `docs/whycode/loop-state/{plan-id}-result.json` for agent results
- All agents now read state from files at start (fresh context awareness)
- External validation after `PLAN_COMPLETE` (orchestrator verifies independently)

### Fixed
- Context degradation over iterations (each iteration now starts fresh)
- Cross-session hook issues (#15047 workaround)
- Agents now properly document their work in result files

### Removed
- Dependency on `ralph-wiggum` plugin
- `/ralph-loop` command usage

## [2.0.0] - 2025-01-12

### Added
- **e2e-agent**: New agent for E2E UI testing
  - Chrome integration for web projects (automatic)
  - Maestro support for Expo/React Native
  - Auto-detects project type
- **docs-agent**: New agent for documentation generation
  - README, CHANGELOG, CONTRIBUTING, API docs, DEPLOYMENT
  - Respects IMMUTABLE_DECISIONS for correct commands
- **Version checking**: Shows version on startup, checks GitHub for updates
- **Changelog display**: Shows what's new when updates are available

### Changed
- Split SKILL.md into smaller files for better context management
  - `reference/AGENTS.md` - Agent execution protocols
  - `reference/TEMPLATES.md` - Document templates
- Reduced orchestrator context from ~25k to ~3k tokens
- test-agent now focused on unit/integration tests only (E2E moved to e2e-agent)

### Fixed
- Agent definitions now properly included in plugin (not just referenced)

## [1.0.0] - 2025-01-10

### Added
- Initial release
- GSD+ methodology integration
- ralph-wiggum integration for autonomous iteration
- XML plan format (max 3 tasks per plan)
- Linear integration for issue tracking
- 8-phase workflow: Intake → Setup → Spec → Architecture → Implementation → Review → Docs → Handoff
- IMMUTABLE_DECISIONS enforcement
- Agents: backend-agent, frontend-agent, test-agent, review-agent, tech-stack-setup-agent
