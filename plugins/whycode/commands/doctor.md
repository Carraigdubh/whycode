---
description: "Diagnose active WhyCode command/version/provenance and cache issues"
argument-hint: ""
---

# WhyCode Doctor

Run diagnosis first, then offer safe auto-fixes for configuration drift.

Checks (in order):
1. Read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` and report version.
2. Read `${CLAUDE_PLUGIN_ROOT}/commands/whycode.md` and verify it references `${CLAUDE_PLUGIN_ROOT}` paths (not `plugins/whycode/...`).
3. Read `${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md` and verify startup required-reads use `${CLAUDE_PLUGIN_ROOT}` paths.
4. Check project overrides:
   - `.claude/commands/whycode.md` (must not exist)
   - `plugins/whycode/` in project root (must not exist for consumer projects)
5. Check likely stale cache markers in `~/.claude/paste-cache` and `~/.claude/plugins/cache/whycode-marketplace/whycode/`.
6. Check `docs/whycode/audit/startup-check.json` and `docs/whycode/audit/startup-audit.json` (if present) for path/version mismatches.
6.6. Project root isolation check (if startup artifacts exist):
   - Resolve current project root from `git rev-parse --show-toplevel` (fallback: cwd).
   - Verify `docs/whycode/audit/startup-gate.json` contains:
     - `projectRoot` equal to current project root
     - `projectRootBound: true`
   - If startup artifacts reference another project path, mark `FAIL`.
6.5. Strict `CLAUDE.md` policy-block validation:
   - Verify section heading exists exactly: `## WhyCode (MANDATORY)`.
   - Verify required rule lines are present in that section:
     - `${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md`
     - `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/AGENTS.md`
     - `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/TEMPLATES.md`
     - `docs/whycode/audit/startup-gate.json` has `status: pass`
     - `docs/whycode/audit/startup-audit.json` has `status: pass`
     - `STOP and report startup incomplete`
   - If heading missing or required lines missing, mark `FAIL`.
7. Specialist contract checks (for each specialist agent file):
   - source of truth is installed plugin files at `${CLAUDE_PLUGIN_ROOT}/agents/*.md` (not project-local copies)
   - required section exists: `## Specialist Preflight (Mandatory)` (or equivalent mode-gate section for Convex/Vercel)
   - required section exists: `## Specialist Metadata (Mandatory)`
   - metadata fields exist:
     - `sourceDocs:`
     - `versionScope:`
     - `lastVerifiedAt:`
     - `driftTriggers:`
8. Staleness check for specialist metadata:
   - if `lastVerifiedAt` is older than 90 days, mark WARNING and recommend metadata refresh.
9. If repository contract validator exists:
   - run `${CLAUDE_PLUGIN_ROOT}/scripts/validate-specialist-contracts.sh`
   - fail doctor if script is missing or reports contract violations.

Output format:
- `Doctor Status: PASS|FAIL`
- `Active Plugin Version: ...`
- `Findings:` bullet list
- `Applied Fixes:` bullet list (if any)
- `Fix Commands:` exact terminal commands for unresolved items

Auto-fix policy:
- Do not change product code.
- You MAY patch project configuration files when drift is detected and the user approves.
- Primary auto-fix target: `CLAUDE.md` WhyCode path drift.
- Secondary auto-fix target: `CLAUDE.md` WhyCode policy-block drift.

`CLAUDE.md` remediation (interactive):
1. If `CLAUDE.md` contains any of:
   - `plugins/whycode/skills/whycode/SKILL.md`
   - `plugins/whycode/skills/whycode/reference/AGENTS.md`
   - `plugins/whycode/skills/whycode/reference/TEMPLATES.md`
2. Show a concise diff preview for replacements:
   - `plugins/whycode/skills/whycode/SKILL.md` -> `${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md`
   - `plugins/whycode/skills/whycode/reference/AGENTS.md` -> `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/AGENTS.md`
   - `plugins/whycode/skills/whycode/reference/TEMPLATES.md` -> `${CLAUDE_PLUGIN_ROOT}/skills/whycode/reference/TEMPLATES.md`
3. Ask: `Apply these CLAUDE.md fixes now? [Y/n]`
4. If approved, apply replacements, report updated lines, then re-run all doctor checks.
5. If declined, keep `Doctor Status: FAIL` and provide fix commands.

`CLAUDE.md` strict policy-block remediation (interactive):
1. If `CLAUDE.md` is missing `## WhyCode (MANDATORY)` OR required lines from check `6.5` are missing:
2. Load canonical block text from plugin README section:
   - `## Mandatory Claude Rule (Exact Wording)` -> `Exact block to insert:`
3. Show concise plan:
   - replace existing `## WhyCode (MANDATORY)` block if present
   - otherwise append canonical block to `CLAUDE.md`
4. Ask: `Replace CLAUDE.md WhyCode section with canonical block now? [Y/n]`
5. If approved, apply replacement and re-run all doctor checks.
6. If declined, keep `Doctor Status: FAIL` and print exact replacement instruction.

If critical mismatches remain after optional auto-fixes, print `Doctor Status: FAIL`.

Specialist contract severity:
- Missing specialist preflight section or metadata section/fields => `FAIL`
- Stale `lastVerifiedAt` (> 90 days) => `WARNING`

CLAUDE.md policy-block severity:
- Missing `## WhyCode (MANDATORY)` section => `FAIL`
- Missing required lines in WhyCode block => `FAIL`
