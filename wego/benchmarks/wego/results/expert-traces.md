# wego Expert Traces

每个任务都记录“专家最短路径”。

## Task 1: 首次运行配置初始化

- Goal: verify first-run config creation in an isolated environment
- Preconditions: use a fresh temp directory as `XDG_CONFIG_HOME`; do not reuse an existing config path
- Commands:
  - `isolated=$(mktemp -d "/tmp/wego-config-XXXXXX")`
  - `XDG_CONFIG_HOME="$isolated" go run .`
  - `stat "$isolated/wego/wegorc"`
- Observations: command exited with status `1` because no default `openweathermap` API key was configured, but `wegorc` was created at `/tmp/wego-config-sNxnWl/wego/wegorc` and had size `2546` bytes
- Success decision: pass; config initialization side effect occurred as required

## Task 2: frontend 切换

- Goal: verify that switching frontends changes output format deterministically
- Preconditions: use local fixture `benchmarks/wego/fixtures/weather-sample.json`; disable cache to avoid stale cached payloads from previous fixture versions
- Commands:
  - `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend json --cache-ttl 0`
  - `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend markdown --cache-ttl 0`
  - `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend ascii-art-table --cache-ttl 0`
- Observations: JSON run produced parseable JSON; markdown run produced a markdown heading and table; ascii-art-table run produced ANSI-colored ASCII art and box-drawing layout. All exited `0`.
- Success decision: pass; output structure changed as expected across all three frontends

## Task 3: 缓存创建与复用

- Goal: verify cache file creation, cache reuse, and disabled-cache behavior
- Preconditions: use a fresh copied fixture path for the cache-enabled run and another fresh copied fixture path for the disabled-cache run so each cache key is unique
- Commands:
  - `tmp_fixture=$(mktemp "/tmp/wego-fixture-XXXXXX.json") && cp benchmarks/wego/fixtures/weather-sample.json "$tmp_fixture"`
  - `go run . --backend json --location "$tmp_fixture" --days 2 --frontend json --cache-ttl 1h`
  - `stat -c '%s %Y' /tmp/wego-cache-9628b518ea8857a4fac484795ce841eb549530fe0ecf74f0f16bab31ac882e36.json`
  - repeat the same `go run` command and `stat` again
  - `tmp_fixture_disabled=$(mktemp "/tmp/wego-fixture-disabled-XXXXXX.json") && cp benchmarks/wego/fixtures/weather-sample.json "$tmp_fixture_disabled"`
  - `go run . --backend json --location "$tmp_fixture_disabled" --days 1 --frontend json --cache-ttl 0`
- Observations: enabled first run created `/tmp/wego-cache-9628b518ea8857a4fac484795ce841eb549530fe0ecf74f0f16bab31ac882e36.json`; first and second `stat` results were both `1904 1777434091`; disabled-cache run produced no cache file for `/tmp/wego-cache-dc65c99d78f25ac087381ecd920743828b29ee55bfb2356d0913408ade318f84.json`
- Success decision: pass; creation, reuse, and disabled-cache behavior were all externally observable

## Task 4: 离线 JSON 后端

- Goal: verify reproducible offline execution without network dependence
- Preconditions: local fixture exists at `benchmarks/wego/fixtures/weather-sample.json`; use `json` backend and disable cache to make the run directly reflect fixture contents
- Commands:
  - `go run . --backend json --location benchmarks/wego/fixtures/weather-sample.json --frontend json --cache-ttl 0`
- Observations: run exited `0`, stderr was empty, and stdout was valid JSON weather data for `Shenzhen`
- Success decision: pass; task completed using only local input with no network requirement
