# wego Benchmark Design

## Goal

Use `wego` as a pilot project and benchmark candidate for validating the early evaluation pipeline of an Agent-as-a-User TUI usability study.

This project is not intended to represent a highly interactive full-screen TUI. Instead, it provides a low-interaction, configuration-driven terminal application that is well-suited for validating task schema design, oracle stability, expert trace capture, and agent execution reliability.

## Project Characterization

- Project: `wego`
- Category: terminal weather client
- Interaction level: low
- UI type: command-line program with formatted terminal output
- Statefulness: medium
- Research role:
  - pilot project
  - benchmark candidate
- Primary oracle types:
  - filesystem oracle
  - stdout oracle
  - exit-status oracle
  - cache-behavior oracle

## Why `wego` Is a Good First Benchmark Target

`wego` has several properties that make it suitable for early-stage evaluation infrastructure work:

- It exposes multiple observable behaviors through command-line flags and config files.
- It supports multiple frontends that change output format without changing task intent.
- It has cache behavior that can be observed through filesystem side effects.
- It supports a local `json` backend, which enables reproducible offline evaluation.

These properties make it easier to design stable automated success criteria than in visually complex or highly interactive TUIs.

## Non-Goals

This benchmark should not be used as the only evidence for claims about:

- complex focus navigation
- multi-panel layout interaction
- high-frequency keyboard exploration
- full-screen visual usability assessment

Those claims require at least one additional higher-interaction TUI benchmark later.

## Benchmark Structure

The first `wego` benchmark iteration should contain four tasks.

### Task 1: First-Run Config Initialization

Objective: verify that an agent can run `wego` in a clean environment and confirm that the default config file is created.

Observable artifacts:

- stdout
- stderr
- exit code
- config file path and file metadata

Primary oracle:

- filesystem oracle
- exit-status oracle

Success conditions:

- a config file is created at the resolved config path
- the file is non-empty
- the program does not crash unexpectedly

Failure conditions:

- no config file is created
- config file is written to the wrong place
- the run terminates abnormally without initialization side effects

### Task 2: Frontend Switching

Objective: verify that an agent can switch frontends and that the output format changes accordingly.

Recommended frontends for the first benchmark version:

- `json`
- `markdown`
- `ascii-art-table`

Observable artifacts:

- stdout
- stderr
- exit code

Primary oracle:

- stdout oracle
- exit-status oracle

Success conditions:

- `json` output can be parsed as valid JSON
- `markdown` output contains expected markdown table markers or markdown-like structure
- `ascii-art-table` output is visibly distinct from JSON and markdown output

Failure conditions:

- output format does not change when frontend changes
- `json` output is not parseable
- the program exits with an error for a valid frontend choice

### Task 3: Cache Creation and Reuse

Objective: verify that an agent can demonstrate cache creation on first run and cache reuse on second run with identical parameters.

Observable artifacts:

- cache file presence
- cache file modification time
- stdout
- stderr
- exit code

Primary oracle:

- cache-behavior oracle
- filesystem oracle

Success conditions:

- first run creates a cache file
- second run with the same backend, location, and day count does not rewrite the cache file
- `--cache-ttl=0` prevents creation of a new cache entry for a fresh parameter combination

Failure conditions:

- no cache file is created when caching is enabled
- repeated identical runs always rewrite cache
- disabled cache still creates a new cache artifact

### Task 4: Offline Execution via JSON Backend

Objective: verify that an agent can use a local JSON data source to run `wego` without network dependence.

Observable artifacts:

- stdout
- stderr
- exit code
- local JSON fixture path

Primary oracle:

- stdout oracle
- exit-status oracle

Success conditions:

- `wego` reads the local JSON file successfully
- the program emits output in the selected frontend
- the program exits successfully

Failure conditions:

- the JSON backend cannot read the file
- the output is malformed for the chosen frontend
- the task still depends on external network access

## Oracle Design Principles

Each task oracle must satisfy the following requirements:

1. It must use observable evidence rather than agent self-report.
2. It must support both positive and negative cases.
3. It should minimize dependence on remote APIs when an offline alternative exists.
4. It should be stable under repeated execution.

For `wego`, oracle design should favor the following evidence sources in priority order:

1. filesystem state
2. stdout structure
3. exit status
4. cache metadata
5. stderr diagnostics

## Negative and Boundary Cases

Each oracle must be validated against:

- positive cases: expected successful task completion
- negative cases: invalid frontend, wrong file path, missing config, or missing cache side effect
- boundary cases: output formatting differences that should still count as success

This prevents the benchmark from only checking ideal success paths.

## Evaluation Metrics

The first iteration should track a small set of metrics:

- success rate
- action count
- retry or recovery count
- total interaction turns
- oracle agreement rate

`oracle agreement rate` measures whether the agent's self-assessment matches the external oracle result.

## Exit Criteria For `wego` As Pilot

Stop expanding `wego` once the following are true:

- all four tasks are clearly specified
- their oracles are stable under repeated execution
- expert traces are captured for each task
- at least one agent can complete a meaningful subset reliably

At that point, keep `wego` in the benchmark candidate pool and shift effort toward a higher-interaction TUI for contrast.

## Expected Deliverables

- `wego` benchmark task cards
- per-task oracle definitions
- expert traces for each task
- one local JSON fixture for offline execution
- a first-pass agent evaluation record
