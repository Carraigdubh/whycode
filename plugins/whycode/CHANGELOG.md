# Changelog

All notable changes to WhyCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

## [2.3.25] - 2026-02-19

### Fixed
- Applied fail-closed specialist coverage audit to early capability preflight (startup step 3.5), not only final capability planning.
- Prevents preflight from displaying false "full coverage" when required specialist agents are missing.

## [2.3.24] - 2026-02-19

### Changed
- Added independent capability consistency audit in startup (orchestrator-side) to verify planner output against `docs/whycode/reference/AGENTS.md`.
- Added fail-closed override: if required specialists for detected stack are missing, capability status is forced to `gaps_found` even if planner claimed full coverage.
- Prevents false "fully covered" results for stacks requiring not-yet-built specialist agents.

## [2.3.23] - 2026-02-17

### Added
- Added persistent tech catalog output: `docs/whycode/tech-capabilities.json`.
- Capability planner now creates the tech catalog when missing and updates it on each run.

### Changed
- Startup capability preflight and final capability planning now both require tech-catalog update.
- Startup gate/auditor now include `techCapabilityFileUpdated=true`.

## [2.3.22] - 2026-02-17

### Changed
- Capability preflight now runs before Run Action selection, so stack/routing/gaps are visible earlier in startup.
- Capability planner now uses deterministic stack checks for Expo, Next/Web, Clerk, Convex, and Vercel against available agent catalog.
- Tightened gap logic so mandatory specialist gaps cannot be reported as `status=ok`.
- Fix mode startup now includes early capability preflight (`STARTUP step 3.5`).

## [2.3.21] - 2026-02-17

### Added
- Added `whycode:capability-planner-agent` to detect stack coverage and capability gaps before execution.
- Startup now generates `docs/whycode/capability-plan.json` and requires explicit user decision on gap handling (`fallback`, `issue`, `pr-scaffold`, `cancel`).

### Changed
- Startup gate/auditor now require capability-planning completion and capability-decision recording.
- Fix mode startup flow now includes capability planning and decision recording before execution.

## [2.3.20] - 2026-02-17

### Added
- Added `turbo-teams` execution speed mode for maximum throughput with Agent Teams lead/delegate flow.

### Changed
- Startup now prompts for `agentTeamsMode` with three options: `off`, `review-teams`, `turbo-teams`.
- Phase 5 implementation loop can run in turbo lead/delegate mode with automatic fallback to standard execution if teams are unavailable.
- Phase 6 review teams mode now accepts both `review-teams` and `turbo-teams`.
- Phase 7 docs loop can run in turbo lead/delegate mode with fallback to standard docs-agent execution.
- Fix mode startup flow now explicitly includes execution speed mode selection.
- Added backward-compatibility default: if `agentTeamsMode` is missing in resumed/legacy state, default to `off`.

## [2.3.19] - 2026-02-17

### Added
- Startup now prompts for `agentTeamsMode` (`off` or `review-teams`) and persists it in state.

### Changed
- Phase 6 review can now run in `review-teams` mode, using an Agent Teams lead/delegate pattern when available.
- Added fail-safe fallback: if teams are unavailable at runtime, review falls back to standard execution.
- Startup gate/auditor now requires `agentTeamsModeSelected=true`.

## [2.3.18] - 2026-02-17

### Changed
- `/whycode:doctor` now supports interactive self-heal for project `CLAUDE.md` path drift:
  - detects stale `plugins/whycode/...` path references
  - shows replacement preview
  - asks approval
  - applies fixes and re-runs checks
- Doctor output now reports `Applied Fixes` in addition to remaining fix commands.

## [2.3.17] - 2026-02-17

### Added
- Added `/whycode:doctor` command to diagnose active plugin/version/path provenance and detect stale cache or override conditions before running WhyCode.

### Changed
- Updated marketplace metadata version to `2.3.17` so marketplace update signaling aligns with plugin releases.

## [2.3.16] - 2026-02-17

### Changed
- Hardened command loading to avoid stale persisted-output reuse: `/whycode` command no longer injects SKILL content via inline `cat`; it now requires direct file reads from `${CLAUDE_PLUGIN_ROOT}` at runtime.
- This prevents old command payload cache artifacts from pinning execution to outdated skill text after plugin upgrades.

## [2.3.15] - 2026-02-17

### Changed
- Hardened docs sync behavior to auto-create `docs/project documentation/` and `docs/project documentation/INDEX.md` when missing before documentation updates.
- Added fail-closed verification for docs sync: post-plan, pre-review, and phase-7 docs flows now require `INDEX.md` run markers (`runId` + `planId`) or stop with `docs sync incomplete`.
- Startup auditor now explicitly requires `runActionSelected=true` alongside other mandatory startup gate fields.
- Tightened `.env.local` Linear detection to ignore commented/example lines and only accept valid `LINEAR_API_KEY=...` assignments.

## [2.3.14] - 2026-02-17

### Changed
- Linear integration is now fail-closed at startup: if a Linear key is detected, startup must successfully initialize Linear and capture `linearTeamId` or stop with `startup incomplete`.
- Startup gate/auditor now validate `linearKeyDetected` and `linearInitialized` when a key is present.

## [2.3.13] - 2026-02-17

### Changed
- Replaced repo-relative mandatory-read paths with `${CLAUDE_PLUGIN_ROOT}` in startup compliance and project CLAUDE template text.
- Prevents stale local `plugins/whycode/...` files from overriding the installed plugin skill/reference reads.
- README instructions now explicitly require removing local path references and using `${CLAUDE_PLUGIN_ROOT}` paths.

## [2.3.12] - 2026-02-17

### Changed
- Added a fail-closed fix-target gate: when runs exceed 5, `Show older runs` and `Show all runs` controls must be present before Parent Run selection continues.
- Fix mode now writes `docs/whycode/audit/fix-target-gate.json` and stops with `startup incomplete` if controls are missing.

## [2.3.11] - 2026-02-17

### Changed
- Startup/fix version banner now has a hard source-of-truth rule: read only from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`.
- Added explicit guardrail to prevent showing version from run/state metadata.

## [2.3.10] - 2026-02-17

### Changed
- Fix mode now mandates Linear tracking when Linear is enabled (create/update fix issue + summary comment).
- Phase 7 docs generation now prioritizes `docs/project documentation/` and explicitly excludes `CLAUDE.md`.
- docs-agent guardrails now forbid editing `CLAUDE.md`.

## [2.3.9] - 2026-02-17

### Changed
- README now specifies terminal-first installation and a terminal-only clean reinstall flow as the reliable path.
- README now includes exact instruction text for Claude Code to replace the entire `WhyCode (MANDATORY)` section in project `CLAUDE.md`.
- README explicitly requires replacing older WhyCode rule blocks rather than merging/paraphrasing.

## [2.3.8] - 2026-02-17

### Changed
- Added mandatory startup auditor gate (`docs/whycode/audit/startup-audit.json`) with fail-closed behavior.
- Startup now independently verifies run visibility, run.json integrity, and startup-gate pass before execution.
- Added deterministic startup evaluation checklist at `docs/STARTUP_EVALS.md`.
- Updated `CLAUDE.md`/README mandatory rule text to require both startup gate and startup audit pass.

## [2.3.7] - 2026-02-17

### Changed
- Added a mandatory run-record visibility gate after `init-run`; startup now re-lists runs and verifies the active runId is discoverable.
- If the active run is missing from run listing, WhyCode backfills the run record and appends a `backfill` event before continuing.
- Startup gate receipt now includes `runRecordInitialized` and `runRecordVisible`.

## [2.3.6] - 2026-02-16

### Changed
- Fix-target run selection now requires explicit UI options for `Show older runs` and `Show all runs`.
- Run selection loop now maps those options to paging actions and stays on Fix target until valid run selection.

## [2.3.5] - 2026-02-16

### Changed
- Startup run listing now supports paging controls (`more`, `all`, `continue`) so older runs can be selected.
- Run selection now requires concrete runId selection and allows expanding the run list before proceeding.
- Fix mode run selection explicitly supports paging controls for older run browsing.
- Run selection now loops on invalid input and stays on target selection until a valid run index/runId is chosen.

## [2.3.4] - 2026-02-16

### Changed
- Startup run listing now supports paging controls (`more`, `all`, `continue`) so older runs can be selected.
- Run selection now requires concrete runId selection and allows expanding the run list before proceeding.
- Fix mode run selection explicitly supports paging controls for older run browsing.
- Run selection now loops on invalid input and stays on target selection until a valid run index/runId is chosen.

## [2.3.3] - 2026-02-16

### Changed
- Fix mode now requires explicit parent run selection and explicit issue description before any implementation work.
- Fix mode no longer reuses generic startup action routing (`resume|rerun|review|resolve|new`); it always creates a new `runType=fix` child run linked by `parentRunId`.

## [2.3.2] - 2026-02-16

### Changed
- `/whycode` command now includes a hard execution rule that blocks implementation until startup gates are complete.
- Fix mode now requires the same interactive startup gates as normal runs (run listing, action selection, completion mode, max iterations, run name, branch init).
- Added mandatory startup gate receipt at `docs/whycode/audit/startup-gate.json`; orchestration must stop with `startup incomplete` if any gate is missing.
- Fix mode now enforces a significance check and mandatory architecture approval before implementation for significant changes.

## [2.3.1] - 2026-02-08

### Changed
- Version bump only

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
