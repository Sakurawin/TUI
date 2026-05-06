# TUI 可用性自动化评测基准库

基于 LLM Agent 的终端用户界面（TUI）可用性自动化评测平台。本仓库是科研项目 **"基于 Agent-as-a-User 的生成式 TUI 可用性自动化评测"** 的基准数据与实验平台（目标会议：ICSE 2027）。

## 研究背景

TUI 在开发者工具生态中至关重要，但其设计和测试高度依赖人工直觉。传统自动化测试只能验证*功能正确性*（能不能用），无法评估*可用性*（好不好用）。随着大语言模型已具备操作终端界面的能力，我们可以通过模拟真实用户行为来系统性地评测 TUI 的可用性。

## 研究路线

| 阶段 | 时间节点 | 核心内容 |
|------|----------|----------|
| P1: 基础设施 | 第 1-4 周 | 开发 `agent-tui` 驱动框架（按键操作、屏幕捕捉、strace 监控） |
| P2: 数据挖掘 | 第 5-10 周 | 原子/复合功能挖掘算法，构建约 10 个 TUI 项目基准库 |
| P3: 实验采集 | 第 11-16 周 | 大规模 Agent 自动测试与可用性数据收集 |
| P4: 论文撰写 | 第 17 周起 | 数据分析、论文撰写与投稿 |

**度量指标：** 按键次数 + 思考时间（K+T）、LLM 认知负荷（Token 长度）、任务成功率。

## 仓库结构

```
.
├── pokete/                     # 基准 TUI：终端宝可梦游戏（Python）
├── wego/                       # 基准 TUI：终端天气查询工具（Go）
│   └── benchmarks/
│       └── wego/
│           ├── tasks/          # 任务定义（配置初始化、前端切换、缓存、离线后端）
│           ├── fixtures/       # 静态测试数据，用于可重复运行
│           └── results/        # 专家轨迹、Agent 试验记录、人工验证结果
├── tui-candidates.md           # 候选 TUI 项目池（lazygit、nnn、btop、k9s、Helix）
└── selected-benchmarks.md      # 已入选基准项目及入选理由
```

## 基准项目

### pokete

基于终端的宝可梦风格游戏，使用 Python 编写。玩家可以探索地图、遭遇野生生物、进行回合制战斗、与 NPC 交互。底层使用 `scrap_engine` 终端渲染库。

- **语言：** Python 3.12+
- **许可证：** GPL-3.0
- **安装：** `pip install pokete`

### wego

基于终端的天气查询客户端，使用 Go 编写，采用插件化架构。支持 8 种天气数据后端和 4 种前端展示模式（ASCII 艺术、Emoji、Markdown、JSON）。

- **语言：** Go 1.20+
- **许可证：** ISC
- **安装：** `go install github.com/schachmat/wego@latest`

## wego 基准任务

| 任务 | 描述 | 验证标准（Oracle） |
|------|------|-------------------|
| 01 | 首次运行配置初始化 | 配置文件已创建、非空、无崩溃 |
| 02 | 前端模式切换（json/markdown/ascii） | 各格式输出合法、结构可区分 |
| 03 | 缓存创建与复用 | 缓存文件存在、复用时修改时间不变 |
| 04 | 离线 JSON 后端 | 读取本地数据文件、输出合法、退出码为 0 |

所有任务均已完成人工验证和 Agent 试验。详见 `wego/benchmarks/wego/` 下的任务卡、专家轨迹和试验记录。

## 候选 TUI 项目

| 项目 | 类型 | 交互强度 | 基准适配度 | 当前状态 |
|------|------|----------|-----------|----------|
| wego | 天气查询工具 | 低 | 中 | 已入选（试点） |
| lazygit | Git 管理器 | 高 | 强 | 候选保留 |
| nnn | 文件管理器 | 高 | 强 | 候选保留 |
| btop | 系统监控 | 中 | 中 | 调研中 |
| k9s | Kubernetes 管理 | 高 | 中 | 调研中 |
| Helix | 终端编辑器 | 高 | 中 | 待初筛 |

## 快速开始

```bash
# 克隆仓库
git clone git@github.com:Sakurawin/TUI.git
cd TUI

# 使用离线后端运行 wego（无需网络）
cd wego
go run main.go --backend json -- ./benchmarks/wego/fixtures/weather-sample.json

# 运行 pokete
cd pokete
pip install -e .
pokete
```

## 许可证

各子项目保留其原始许可证：
- **pokete：** GPL-3.0
- **wego：** ISC
