---
description: "Diagnose active WhyCode command/version/provenance and cache issues"
argument-hint: ""
---

# WhyCode Doctor

Run a diagnosis only. Do not mutate product code.

Checks (in order):
1. Read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` and report version.
2. Read `${CLAUDE_PLUGIN_ROOT}/commands/whycode.md` and verify it references `${CLAUDE_PLUGIN_ROOT}` paths (not `plugins/whycode/...`).
3. Read `${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md` and verify startup required-reads use `${CLAUDE_PLUGIN_ROOT}` paths.
4. Check project overrides:
   - `.claude/commands/whycode.md` (must not exist)
   - `plugins/whycode/` in project root (must not exist for consumer projects)
5. Check likely stale cache markers in `~/.claude/paste-cache` and `~/.claude/plugins/cache/whycode-marketplace/whycode/`.
6. Check `docs/whycode/audit/startup-check.json` and `docs/whycode/audit/startup-audit.json` (if present) for path/version mismatches.

Output format:
- `Doctor Status: PASS|FAIL`
- `Active Plugin Version: ...`
- `Findings:` bullet list
- `Fix Commands:` exact terminal commands to resolve any failures

If any critical mismatch is detected, print `Doctor Status: FAIL` and include full remediation commands.
