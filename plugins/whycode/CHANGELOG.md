# Changelog

All notable changes to WhyCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

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
