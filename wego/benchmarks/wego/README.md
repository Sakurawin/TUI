# wego Benchmark Assets

This directory contains the assets required to run the `wego` benchmark used in the Agent-as-a-User usability study.

## What each directory is for

- `START-HERE.md`: the simplest entry point, including what to do first and in what order.
- `tasks/`: one task card per benchmark task, including instruction, preconditions, evidence, success criteria, and failure criteria.
- `fixtures/`: static data for deterministic offline execution.
- `results/`: templates and records for manual validation, expert traces, and agent runs.

## Recommended reading order

1. Read `START-HERE.md`.
2. Run `tasks/04-offline-json-backend.md` first.
3. Fill `results/manual-validation.md` while running tasks manually.
4. Fill `results/expert-traces.md` after your manual pass is stable.
5. Use `results/agent-prompts.md` to hand one task at a time to an agent.

## Benchmark scope

This benchmark is intentionally low-interaction and is used to validate:

- task schema design
- oracle stability
- expert trace capture
- agent execution reliability

It is not meant to stand alone as evidence for highly interactive full-screen TUI usability.

## Offline-first recommendation

Prefer the local fixture in `fixtures/weather-sample.json` when validating oracles, because it avoids network instability and makes results more reproducible.
