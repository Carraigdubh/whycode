#!/bin/bash
set -euo pipefail

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

PLUGIN_ROOT="$(cd "$(/usr/bin/dirname "${BASH_SOURCE[0]}")/.." && /bin/pwd)"
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

specialists=(
  "$PLUGIN_ROOT/agents/frontend-web-agent.md"
  "$PLUGIN_ROOT/agents/frontend-native-agent.md"
  "$PLUGIN_ROOT/agents/backend-auth-agent.md"
  "$PLUGIN_ROOT/agents/backend-convex-agent.md"
  "$PLUGIN_ROOT/agents/deploy-vercel-agent.md"
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
  echo "Specialist contract validation failed with $failures issue(s)."
  exit 1
fi

echo "Specialist contract validation passed."
