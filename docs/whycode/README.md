# WhyCode Folder Structure

This folder is the **skill home** for WhyCode. It should stay small and stable.
Do not place run artifacts or project documentation here.

## What lives here
- `reference/AGENTS.md` - Agent execution protocols
- `reference/TEMPLATES.md` - Plan and document templates

## What does NOT live here
- Run state (`docs/whycode-state.json`)
- Run artifacts (`docs/loop-state/`, `docs/runs/`)
- Plans/specs/decisions (`docs/plans/`, `docs/specs/`, `docs/decisions/`)
- Project docs (`docs/project documentation/`)

## Related paths (outside this folder)
- `docs/whycode-state.json` - Current run state
- `docs/runs/{runId}/` - Archived run records
- `docs/project documentation/` - Canonical project documentation
