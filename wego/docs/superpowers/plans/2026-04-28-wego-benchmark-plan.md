# wego Benchmark Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Define, validate, and document a reproducible `wego` benchmark centered on low-interaction tasks, stable oracles, and agent execution reliability.

**Architecture:** The work is split into benchmark assets rather than product features. First create a local offline fixture and benchmark task cards, then validate each oracle manually, then run agent trials and record outcome metrics. The benchmark should prefer deterministic evidence sources such as filesystem state, parseable stdout, and cache metadata.

**Tech Stack:** Go CLI application, local JSON fixture, shell commands, markdown benchmark docs

---

### Task 1: Create Benchmark Asset Layout

**Files:**
- Create: `benchmarks/wego/README.md`
- Create: `benchmarks/wego/tasks/`
- Create: `benchmarks/wego/fixtures/`
- Create: `benchmarks/wego/results/`

- [ ] **Step 1: Create the benchmark directories**

Run: `mkdir -p benchmarks/wego/tasks benchmarks/wego/fixtures benchmarks/wego/results`
Expected: directories are created without errors

- [ ] **Step 2: Write the benchmark README**

Add a short README explaining that this benchmark stores task cards, fixture data, and result records for `wego`.

- [ ] **Step 3: Verify the directory layout exists**

Run: `ls benchmarks/wego benchmarks/wego/tasks benchmarks/wego/fixtures benchmarks/wego/results`
Expected: all paths exist and list successfully

### Task 2: Create an Offline JSON Fixture

**Files:**
- Create: `benchmarks/wego/fixtures/weather-sample.json`
- Test: manual run using `--backend json`

- [ ] **Step 1: Capture or construct a minimal valid JSON weather sample**

Use one successful `wego --frontend json` run as the source format, then save a small stable sample to `benchmarks/wego/fixtures/weather-sample.json`.

- [ ] **Step 2: Run `wego` against the fixture**

Run: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend json`
Expected: command exits successfully and prints valid JSON

- [ ] **Step 3: Verify the fixture is reusable**

Run the same command again.
Expected: identical or semantically equivalent valid JSON output

### Task 3: Write Task Cards

**Files:**
- Create: `benchmarks/wego/tasks/01-first-run-config.md`
- Create: `benchmarks/wego/tasks/02-frontend-switch.md`
- Create: `benchmarks/wego/tasks/03-cache-reuse.md`
- Create: `benchmarks/wego/tasks/04-offline-json-backend.md`

- [ ] **Step 1: Write Task 1 card**

Document instruction, preconditions, evidence, success rules, and failure rules for first-run config initialization.

- [ ] **Step 2: Write Task 2 card**

Document instruction, preconditions, evidence, success rules, and failure rules for frontend switching.

- [ ] **Step 3: Write Task 3 card**

Document instruction, preconditions, evidence, success rules, and failure rules for cache creation and reuse.

- [ ] **Step 4: Write Task 4 card**

Document instruction, preconditions, evidence, success rules, and failure rules for offline JSON backend execution.

### Task 4: Validate Oracles Manually

**Files:**
- Modify: `benchmarks/wego/tasks/01-first-run-config.md`
- Modify: `benchmarks/wego/tasks/02-frontend-switch.md`
- Modify: `benchmarks/wego/tasks/03-cache-reuse.md`
- Modify: `benchmarks/wego/tasks/04-offline-json-backend.md`
- Create: `benchmarks/wego/results/manual-validation.md`

- [ ] **Step 1: Validate config oracle**

Run `wego` in a clean config environment and record whether the config file is created at the expected path.
Expected: evidence clearly supports a pass or fail outcome.

- [ ] **Step 2: Validate frontend oracle**

Run `wego` with `json`, `markdown`, and `ascii-art-table` frontends and record the output signatures used for automated judgment.
Expected: each frontend has a distinct and stable output pattern.

- [ ] **Step 3: Validate cache oracle**

Run `wego` twice with identical parameters and once with `--cache-ttl=0`, then record cache-file existence and modification-time behavior.
Expected: cache behavior is distinguishable across the three cases.

- [ ] **Step 4: Validate offline oracle**

Run `wego` against the local fixture and verify that success does not depend on live network access.
Expected: output succeeds consistently using only local input.

### Task 5: Record Expert Traces

**Files:**
- Create: `benchmarks/wego/results/expert-traces.md`

- [ ] **Step 1: Record command trace for Task 1**

List the exact commands, environment, observations, and success decision used by an expert.

- [ ] **Step 2: Record command trace for Task 2**

List the exact commands, environment, observations, and success decision used by an expert.

- [ ] **Step 3: Record command trace for Task 3**

List the exact commands, environment, observations, and success decision used by an expert.

- [ ] **Step 4: Record command trace for Task 4**

List the exact commands, environment, observations, and success decision used by an expert.

### Task 6: Run Initial Agent Trials

**Files:**
- Create: `benchmarks/wego/results/agent-trials.md`

- [ ] **Step 1: Run one agent trial per task**

Execute each task once with the current agent setup.
Expected: each run produces stdout, stderr, exit status, and a task outcome.

- [ ] **Step 2: Record trial metrics**

For each task, record success/fail, action count, retry count, and total turns.

- [ ] **Step 3: Compare self-report with oracle result**

Record whether the agent claimed success and whether the oracle agreed.
Expected: mismatches are explicitly visible.

### Task 7: Freeze First-Pass Benchmark Package

**Files:**
- Modify: `benchmarks/wego/README.md`
- Modify: `docs/superpowers/specs/2026-04-28-wego-benchmark-design.md`
- Modify: `docs/superpowers/plans/2026-04-28-wego-benchmark-plan.md`

- [ ] **Step 1: Summarize what is stable and what is still provisional**

Mark which task cards and oracles are ready for reuse and which still depend on manual review.

- [ ] **Step 2: Check pilot exit criteria**

Confirm whether `wego` has met the defined pilot exit criteria from the design doc.
Expected: a clear yes/no decision with short justification.

- [ ] **Step 3: Decide whether to keep `wego` as a benchmark candidate**

Write a short conclusion stating whether `wego` stays in the benchmark pool and what kind of second project should be added next.
