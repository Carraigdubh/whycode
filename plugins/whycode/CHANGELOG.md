# Changelog

All notable changes to WhyCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

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
  - Memory persists only through filesystem (`docs/loop-state/`, git, PLAN.md)
  - No external plugin dependency required
  - Based on [The Ralph Wiggum Playbook](https://humanlayer.dev/blog/ralph-wiggum-playbook)

### Added
- New state file pattern: `docs/loop-state/{plan-id}.json` for iteration tracking
- Result file pattern: `docs/loop-state/{plan-id}-result.json` for agent results
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
