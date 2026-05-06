# wego Agent Prompts

每次只发一个任务给 agent。不要一开始让 agent 同时做 4 个任务。

## Task 1 Prompt

Goal: Run `wego` in a clean config environment and verify that the default config file is created.

Rules:

- Work only inside this repository and temporary shell environment.
- Use a clean config location by setting `XDG_CONFIG_HOME` or `WEGORC`.
- Record `stdout`, `stderr`, exit code, and the resolved config file path.
- Check whether the config file exists and whether it is non-empty.
- Report success only if the file is created at the expected path.

Deliver:

- The exact command used
- The observed config path
- Whether the file exists
- File size
- Exit code
- Final pass/fail decision

## Task 2 Prompt

Goal: Run `wego` with the local JSON fixture and verify that switching frontends changes the output format correctly.

Rules:

- Use `benchmarks/wego/fixtures/weather-sample.json` as the input fixture.
- Keep backend, location, and days fixed.
- Run three variants: `--frontend json`, `--frontend markdown`, and `--frontend ascii-art-table`.
- Record `stdout`, `stderr`, and exit code for each run.
- Validate that JSON output is parseable, markdown output has stable markdown structure, and ascii-art-table output is visibly different from the other two.

Deliver:

- The three exact commands
- Output signatures for each frontend
- Exit codes
- Final pass/fail decision

## Task 3 Prompt

Goal: Verify cache creation, cache reuse, and cache disabling behavior in `wego`.

Rules:

- Choose one fixed parameter combination for the cache-enabled runs.
- Run the same command twice with cache enabled.
- Record the cache file path and modification time after each run.
- Then use a fresh parameter combination with `--cache-ttl=0`.
- Record whether a new cache file is created.
- Report success only if the first run creates a cache file, the second run does not rewrite it, and the disabled-cache run does not create a new cache entry.

Deliver:

- The exact commands used
- The cache file path
- File existence and modification times
- Exit codes
- Final pass/fail decision

## Task 4 Prompt

Goal: Run `wego` offline using the local JSON backend and verify successful execution without network dependence.

Rules:

- Use `--backend json`.
- Use `benchmarks/wego/fixtures/weather-sample.json` as the location.
- Prefer `--frontend json` for easy validation.
- Record `stdout`, `stderr`, and exit code.
- Report success only if the program reads the local file and exits successfully.

Deliver:

- The exact command used
- Whether the fixture was read successfully
- Exit code
- Final pass/fail decision
