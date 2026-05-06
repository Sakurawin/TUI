# TUI Candidates Tracker Design

## Goal

Add a single Chinese-language tracker file for non-`wego` TUI benchmark candidates so future project selection is recorded consistently.

## Why This Is Needed

The current benchmark assets are organized per project under `benchmarks/wego/`, but there is no shared place to compare other TUI projects.

Without a common tracker, candidate selection can become scattered across notes and chat history, which makes later benchmark decisions harder to justify.

## Design

- Create one root-level tracker file at `benchmarks/tui-candidates.md`.
- Keep the document in Chinese because the working discussion is in Chinese.
- Use one repeated template per candidate so projects can be compared side by side.
- Keep the structure lightweight and research-oriented rather than product-oriented.

## Required Fields Per Candidate

- 项目名
- 仓库地址
- 项目类型
- 交互强度
- 外部依赖
- 安装与运行难度
- 适合评测的能力
- 不适合评测的能力
- benchmark 适配度
- 当前状态
- 备注

## Status Values

The tracker should support these lightweight states:

- 待初筛
- 调研中
- 候选保留
- 已选入 benchmark 池
- 已淘汰

## Non-Goals

- This file does not replace per-project benchmark folders.
- This file does not store task cards, fixtures, or trial results.
- This file does not force all candidates to have complete data on first entry.
