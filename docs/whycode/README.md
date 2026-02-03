# WhyCode Folder Structure

This folder is the **WhyCode runtime root**. Run artifacts live here.
Project documentation stays in `docs/project documentation/`.

## What lives here
- `state.json` - Current run state
- `loop-state/` - Iteration history and results
- `runs/` - Archived run records
- `plans/` `specs/` `decisions/` `intake/` `audit/` `artifacts/` `features/`
- `reference/` - Agent protocols and templates

## What does NOT live here
- Project documentation (`docs/project documentation/`)

## Run Records
Every execution mode is recorded under `runs/` (full runs, fix, review, resolve, rerun, resume).
Each run contains `run.json` and a short `summary.md`.
