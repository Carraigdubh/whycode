# WhyCode Startup Evals

Use these deterministic checks to verify startup compliance.

## Expected Artifacts

- `docs/whycode/audit/startup-gate.json` exists with `status: "pass"`
- `docs/whycode/audit/startup-audit.json` exists with `status: "pass"`
- `docs/whycode/runs/{runId}/run.json` exists and is listed by `list-runs`

## Core Scenarios

1. New run startup
- Trigger: `/whycode`
- Must ask: completion mode, max iterations, run name
- Must produce: run record + branch + startup gate + startup audit pass

2. Fix startup with older run selection
- Trigger: `/whycode fix`
- Must show run list and allow expanding older runs
- Must not proceed to issue step until valid run selected
- Must create child `fix` run with `parentRunId`

3. Missing run record recovery
- Simulate: remove current run directory before startup audit
- Expected: backfill run record, append `backfill` event, startup audit pass

4. Startup fail-closed
- Simulate: startup-gate has a false/missing required field
- Expected: startup-audit status `fail` and hard stop with `startup incomplete`

## Pass Criteria

- No implementation, plan execution, or agent task runs before startup-audit pass.
- Active `runId` is discoverable in `list-runs` during startup.
- Failures are explicit and machine-checkable in startup audit artifacts.
