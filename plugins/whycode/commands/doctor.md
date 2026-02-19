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
7. Specialist contract checks (for each specialist agent file):
   - required section exists: `## Specialist Preflight (Mandatory)` (or equivalent mode-gate section for Convex/Vercel)
   - required section exists: `## Specialist Metadata (Mandatory)`
   - metadata fields exist:
     - `sourceDocs:`
     - `versionScope:`
     - `lastVerifiedAt:`
     - `driftTriggers:`
8. Staleness check for specialist metadata:
   - if `lastVerifiedAt` is older than 90 days, mark WARNING and recommend metadata refresh.

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

If critical mismatches remain after optional auto-fixes, print `Doctor Status: FAIL`.

Specialist contract severity:
- Missing specialist preflight section or metadata section/fields => `FAIL`
- Stale `lastVerifiedAt` (> 90 days) => `WARNING`
