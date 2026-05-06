# wego Manual Validation Record

按任务顺序填写。每一项都尽量用客观证据，不要只写主观判断。

## Task 1: 首次运行配置初始化

- Date: 2026-04-29
- Operator: OpenCode
- Command: `XDG_CONFIG_HOME=/tmp/wego-config-sNxnWl go run .`
- Environment isolation: isolated `XDG_CONFIG_HOME` temp directory
- Expected config path: `/tmp/wego-config-sNxnWl/wego/wegorc`
- Stdout summary: empty
- Stderr summary: controlled first-run failure from default `openweathermap` backend: `No openweathermap.org API key specified.`
- Exit code: `1`
- File exists: yes
- File size: `2546` bytes
- Pass or fail: pass
- Reason: task oracle only requires config creation, non-empty file content, and no unexpected crash. The run produced the expected config file before a controlled backend configuration error.

## Task 2: frontend 切换

- Date: 2026-04-29
- Operator: OpenCode
- Fixture path: `benchmarks/wego/fixtures/weather-sample.json`
- JSON command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend json --cache-ttl 0`
- Markdown command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend markdown --cache-ttl 0`
- ASCII command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend ascii-art-table --cache-ttl 0`
- JSON parseable: yes
- Markdown signature: starts with `## Weather for Shenzhen` and contains markdown table rows such as `| Morning | Noon | ... |`
- ASCII signature: starts with `Weather for Shenzhen` and contains ANSI-colored ASCII art blocks and box-drawing table layout
- Exit codes: `0 / 0 / 0`
- Pass or fail: pass
- Reason: all three runs succeeded with distinct output structures. `--cache-ttl 0` was required to avoid stale cache created from an earlier version of the fixture.

## Task 3: 缓存创建与复用

- Date: 2026-04-29
- Operator: OpenCode
- Cache-enabled command: `go run . --backend json --location /tmp/wego-fixture-KCOtXa.json --days 2 --frontend json --cache-ttl 1h`
- Second identical command: same as above
- Cache-disabled command: `go run . --backend json --location /tmp/wego-fixture-disabled-i4kgwF.json --days 1 --frontend json --cache-ttl 0`
- Cache path: `/tmp/wego-cache-9628b518ea8857a4fac484795ce841eb549530fe0ecf74f0f16bab31ac882e36.json`
- First run created file: yes
- Second run rewrote file: no
- Disabled run created file: no
- File mtimes: first run `1904 1777434091`, second run `1904 1777434091`
- Exit codes: `0 / 0 / 0`
- Pass or fail: pass
- Reason: the first run created a cache file, the second identical run preserved the same size and modification timestamp, and the disabled-cache run left no new cache file for the fresh parameter combination.

## Task 4: 离线 JSON 后端

- Date: 2026-04-29
- Operator: OpenCode
- Command: `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend json --cache-ttl 0`
- Fixture path: `benchmarks/wego/fixtures/weather-sample.json`
- Stdout summary: valid JSON weather payload with top-level keys `Current`, `Forecast`, `Location`, and `GeoLoc`
- Stderr summary: empty
- Exit code: `0`
- Network required: no
- Pass or fail: pass
- Reason: `wego` successfully read the local fixture through the `json` backend and emitted parseable JSON without contacting any external service.
