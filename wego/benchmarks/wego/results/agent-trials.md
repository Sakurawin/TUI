# wego Agent Trials

本文件记录使用 OpenCode `Task` 子代理（`general`）执行的第一轮 agent benchmark 试跑结果。

## Trial Setup

- Controller: OpenCode main session
- Agent mechanism: OpenCode `Task` subagent
- Subagent type: `general`
- Trial style: one agent per task, read-only execution, no repository edits by subagents
- Oracle comparison source: `manual-validation.md`

## Task 1: 首次运行配置初始化

- Agent command: `XDG_CONFIG_HOME=/tmp/wego-task1-Z82m6g go run .`
- Agent-reported exit code: `1`
- Agent-reported config path: `/tmp/wego-task1-Z82m6g/wego/wegorc`
- Agent-reported file exists: `true`
- Agent-reported file size: `2546`
- Agent stderr summary: `No openweathermap.org API key specified; prompts to register for one; process exited with status 1.`
- Agent self-report: pass
- External oracle result: pass
- Oracle agreement: yes
- Notes: The agent correctly treated controlled first-run failure as acceptable because config creation is the real success criterion.

## Task 2: frontend 切换

- Agent JSON command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend json --cache-ttl 0`
- Agent markdown command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend markdown --cache-ttl 0`
- Agent ascii command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend ascii-art-table --cache-ttl 0`
- Agent-reported exit codes: `json=0, markdown=0, ascii-art-table=0`
- Agent-reported JSON parseable: yes
- Agent-reported markdown signature: markdown headings and pipe-delimited table rows with separator lines
- Agent-reported ascii signature: box-drawing layout, ANSI color escapes, and weather ASCII art distinct from JSON/markdown
- Agent stderr summary: no stderr observed
- Agent self-report: pass
- External oracle result: pass
- Oracle agreement: yes
- Notes: The agent correctly identified distinct frontend output signatures.

## Task 3: 缓存创建与复用

- Agent cache-enabled command: `go run . --backend json --location /tmp/wego-bench-cache-enabled-1p_su8re.json --days 2 --frontend json --cache-ttl 1h`
- Agent second identical command: same as above
- Agent cache-disabled command: `go run . --backend json --location /tmp/wego-bench-cache-disabled-lqbq2j4k.json --days 1 --frontend json --cache-ttl 0`
- Agent cache path: `/tmp/wego-cache-6cebf0349ae5b330c149c00239c5b2647f2da5600e743bd15459951952084769.json`
- Agent first stat: `exists,size=1904,mtime=2026-04-29T12:29:20.956793`
- Agent second stat: `exists,size=1904,mtime=2026-04-29T12:29:20.956793`
- Agent disabled cache path: `/tmp/wego-cache-50a5771dbd0c79a295beaf0833884e351d045f1d85c5f1e1495dff2153d687d3.json`
- Agent disabled result: `before=missing,after=missing,no_new_cache_file`
- Agent self-report: pass
- External oracle result: pass
- Oracle agreement: yes
- Notes: The agent correctly demonstrated create/reuse/disable cache behavior using fresh temporary fixture paths.

## Task 4: 离线 JSON 后端

- Agent command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend json --cache-ttl 0`
- Agent-reported exit code: `0`
- Agent stdout summary: `Printed a weather JSON payload for Shenzhen with current conditions, a 2-day forecast, and geolocation data.`
- Agent stderr summary: `No stderr output.`
- Agent-reported JSON parseable: yes
- Agent-reported network required: no
- Agent self-report: pass
- External oracle result: pass
- Oracle agreement: yes
- Notes: The agent correctly recognized the run as fully offline and parseable.

## Summary

- Tasks run: 4
- Agent self-reported pass: 4
- External oracle pass: 4
- Oracle agreement count: 4/4
- Observed mismatch count: 0

## First-Pass Assessment

The OpenCode `general` subagent successfully completed all four `wego` pilot tasks under explicit task prompts. For this benchmark slice, agent self-assessment matched external oracle judgment in every case. The strongest tasks for future automated trials are Task 4 and Task 2 because they are deterministic and do not depend on external services. Task 3 is also stable when fresh temporary fixture paths are used. Task 1 is usable, but its oracle must continue to distinguish acceptable controlled backend failure from true initialization failure.
