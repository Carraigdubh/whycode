#!/bin/bash
set -euo pipefail

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

ROOT="$(cd "$(/usr/bin/dirname "${BASH_SOURCE[0]}")/.." && /bin/pwd)"

failures=0

if command -v rg >/dev/null 2>&1; then
  SEARCH_BIN="$(command -v rg)"
else
  SEARCH_BIN="$(command -v grep)"
fi

check_contains() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if [[ "$SEARCH_BIN" == *"rg" ]]; then
    if ! "$SEARCH_BIN" -n --fixed-strings -- "$pattern" "$file" >/dev/null 2>&1; then
      echo "FAIL: $label ($file) missing: $pattern"
      failures=$((failures + 1))
    fi
    return
  fi

  if ! "$SEARCH_BIN" -n -F -- "$pattern" "$file" >/dev/null 2>&1; then
    echo "FAIL: $label ($file) missing: $pattern"
    failures=$((failures + 1))
  fi
}

check_file_exists() {
  local file="$1"
  local label="$2"
  if [[ ! -f "$file" ]]; then
    echo "FAIL: $label missing file: $file"
    failures=$((failures + 1))
  fi
}

CLAUDE_MD="$ROOT/CLAUDE.md"
AGENTS_MD="$ROOT/plugins/whycode/skills/whycode/reference/AGENTS.md"
README_MD="$ROOT/README.md"

check_file_exists "$CLAUDE_MD" "repo policy"
check_file_exists "$AGENTS_MD" "agent policy"
check_file_exists "$README_MD" "user docs"

check_contains "$CLAUDE_MD" "## Codex Pre-Edit Checklist (Mandatory)" "codex pre-edit policy"
check_contains "$CLAUDE_MD" 'Read `CLAUDE.md`.' "codex pre-edit policy"
check_contains "$CLAUDE_MD" 'Read `plugins/whycode/skills/whycode/reference/AGENTS.md`.' "codex pre-edit policy"

check_contains "$AGENTS_MD" "## Specialist Preflight Gate Contract (Mandatory)" "specialist contract"
check_contains "$AGENTS_MD" "## Specialist Metadata Contract (Mandatory)" "metadata contract"
check_contains "$AGENTS_MD" "## Codex Build Protocol (Mandatory for This Repo)" "codex build protocol"

check_contains "$README_MD" "## Mandatory Claude Rule (Exact Wording)" "canonical rule docs"
check_contains "$README_MD" "## WhyCode (MANDATORY)" "canonical rule block"
check_contains "$README_MD" '${CLAUDE_PLUGIN_ROOT}/skills/whycode/SKILL.md' "canonical skill path"
check_contains "$README_MD" 'docs/whycode/audit/startup-gate.json` has `status: pass' "startup gate rule"
check_contains "$README_MD" 'docs/whycode/audit/startup-audit.json` has `status: pass' "startup audit rule"

specialists=(
  "$ROOT/plugins/whycode/agents/frontend-web-agent.md"
  "$ROOT/plugins/whycode/agents/frontend-native-agent.md"
  "$ROOT/plugins/whycode/agents/backend-auth-agent.md"
  "$ROOT/plugins/whycode/agents/backend-convex-agent.md"
  "$ROOT/plugins/whycode/agents/deploy-vercel-agent.md"
)

for agent in "${specialists[@]}"; do
  check_file_exists "$agent" "specialist agent"
  check_contains "$agent" "## Specialist Preflight (Mandatory)" "specialist preflight heading"
  check_contains "$agent" "docs/whycode/audit/specialist-preflight-{planId}.json" "specialist preflight artifact"
  check_contains "$agent" "## Specialist Metadata (Mandatory)" "specialist metadata heading"
  check_contains "$agent" "- sourceDocs:" "specialist metadata sourceDocs"
  check_contains "$agent" "- versionScope:" "specialist metadata versionScope"
  check_contains "$agent" "- lastVerifiedAt:" "specialist metadata lastVerifiedAt"
  check_contains "$agent" "- driftTriggers:" "specialist metadata driftTriggers"
done

if (( failures > 0 )); then
  echo "Contract validation failed with $failures issue(s)."
  exit 1
fi

echo "Contract validation passed."
