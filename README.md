# TUI Usability Benchmark

Automated usability evaluation of terminal user interfaces (TUI) using LLM-based agents. This repository serves as the benchmark and data platform for the research project **"Agent-as-a-User: Generative TUI Usability Automated Evaluation"** (targeting ICSE 2027).

## Motivation

TUI applications are critical in developer tooling, yet their design and testing rely heavily on manual intuition. Traditional automated testing verifies *correctness* (does it work?) but not *usability* (is it easy to use?). With LLMs now capable of operating terminal interfaces, we can simulate real user behavior to systematically evaluate TUI usability.

## Research Overview

| Phase | Timeline | Focus |
|-------|----------|-------|
| P1: Infrastructure | Weeks 1-4 | `agent-tui` driver framework (keystroke ops, screen capture, strace) |
| P2: Data Mining | Weeks 5-10 | Atomic/composite function mining, build ~10 TUI benchmark library |
| P3: Experiment | Weeks 11-16 | Large-scale agent testing and usability data collection |
| P4: Paper | Week 17+ | Analysis, writing, and submission |

**Metrics:** Keystroke count + think time (K+T), LLM cognitive load (token length), task success rate.

## Repository Structure

```
.
├── pokete/                     # Benchmark TUI: terminal Pokemon-like game (Python)
├── wego/                       # Benchmark TUI: terminal weather client (Go)
│   └── benchmarks/
│       └── wego/
│           ├── tasks/          # Task definitions (config, frontend, cache, offline)
│           ├── fixtures/       # Static test data for reproducible runs
│           └── results/        # Expert traces, agent trials, manual validation
├── tui-candidates.md           # Candidate TUI pool (lazygit, nnn, btop, k9s, Helix)
└── selected-benchmarks.md      # Selected benchmark projects and rationale
```

## Benchmark Projects

### pokete

A terminal-based Pokemon-like game written in Python. Players explore maps, encounter wild creatures, engage in turn-based battles, and interact with NPCs. Built on the `scrap_engine` terminal rendering library.

- **Language:** Python 3.12+
- **License:** GPL-3.0
- **Install:** `pip install pokete`

### wego

A terminal weather client written in Go with a plugin architecture. Supports 8 weather backends and 4 display frontends (ASCII art, emoji, markdown, JSON).

- **Language:** Go 1.20+
- **License:** ISC
- **Install:** `go install github.com/schachmat/wego@latest`

## Benchmark Tasks (wego)

| Task | Description | Oracle |
|------|-------------|--------|
| 01 | First-run config initialization | Config file created, non-empty, no crash |
| 02 | Frontend switching (json/markdown/ascii) | Valid output per format, distinct structure |
| 03 | Cache creation and reuse | Cache file exists, mtime preserved on reuse |
| 04 | Offline JSON backend | Local fixture read, valid output, exit 0 |

All tasks have been manually validated and agent-tested. See `wego/benchmarks/wego/` for full task cards, expert traces, and trial results.

## Candidate TUI Projects

| Project | Type | Interaction | Benchmark Fit | Status |
|---------|------|-------------|---------------|--------|
| wego | Weather CLI | Low | Medium | Selected (pilot) |
| lazygit | Git manager | High | Strong | Candidate |
| nnn | File manager | High | Strong | Candidate |
| btop | System monitor | Medium | Medium | Under research |
| k9s | Kubernetes TUI | High | Medium | Under research |
| Helix | Terminal editor | High | Medium | Pending screening |

## Getting Started

```bash
# Clone with benchmark data
git clone git@github.com:Sakurawin/TUI.git
cd TUI

# Run wego with offline backend (no network needed)
cd wego
go run main.go --backend json -- ~/. path/to/benchmarks/wego/fixtures/weather-sample.json

# Run pokete
cd pokete
pip install -e .
pokete
```

## License

Each sub-project retains its original license:
- **pokete:** GPL-3.0
- **wego:** ISC
