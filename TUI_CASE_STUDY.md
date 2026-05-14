# TUI 评测数据集候选项目调研

本文用于记录所有有待考虑的 TUI 候选项目及其地址，作为数据集构建的项目筛选依据。

当前项目不是要开发一个 TUI 应用，而是要构建一套结构化的 TUI 评测数据集，用于驱动和验证"生成式 TUI"的 Agent 系统。

本文调研来源：

- Ratatui 官网：<https://ratatui.rs/>
- Textual 示例目录：<https://github.com/Textualize/textual/tree/main/examples>
- Ratatui 示例目录：<https://github.com/ratatui/ratatui/tree/main/examples>
- Awesome Ratatui：<https://github.com/ratatui/awesome-ratatui>
- Awesome OpenTUI：<https://github.com/msmps/awesome-opentui>
- Reddit CLI/TUI 精选：<https://www.reddit.com/r/commandline/comments/1jniqsy/essential_clitui_tools_for_developers/>

本文重点不是学习 Ratatui 或 Textual 如何写代码，而是判断这些项目、示例和生态案例是否适合转化为本仓库的数据集资产，包括 `info.json`、`install.md`、`tasks/*.json`、fixture、oracle 和人工验证记录。

## 仓库目标对本文的约束

根据根目录 `README.md`，本仓库的目标是：构建一套结构化的 TUI 评测数据集，用于驱动和验证“生成式 TUI”的 Agent 系统。

整个系统分为三个环节：

| 环节 | 作用 |
| --- | --- |
| 数据集构建 | 收集真实 TUI 项目，编写元信息、安装步骤、自然语言任务和成功判定条件 |
| TUI 生成 Agent | 读取数据集中的任务描述，生成能够完成任务的 TUI 程序 |
| 用户行为 Agent | 模拟真实用户操作生成的 TUI，并根据 oracle 验证可用性 |

因此，本文评价一个候选项目时，主要看它是否能服务数据集构建，而不是看它是否“好看”或“功能多”。适合纳入数据集的 TUI 项目，至少应满足以下条件：

- 能设计明确的自然语言任务。
- 能构造稳定、可重复的前置环境。
- 能定义自动化或半自动化 oracle。
- 安装成本可控，至少能写出 Ubuntu/Debian 可复现安装步骤。
- 与已有项目形成互补，而不是重复覆盖同一类能力。
- 能体现真实 TUI 交互能力，例如导航、选择、输入、搜索、状态理解、面板切换、确认操作等。

## 当前数据集状态

根目录 `README.md` 和 `selected-benchmarks.md` 显示，当前已有或已选项目如下：

| 项目 | 类型 | 交互强度 | 当前状态 | 数据集价值 |
| --- | --- | --- | --- | --- |
| `wego` | 天气查询工具 | low | 已完成 | 适合验证低交互、强配置、强输出、离线 oracle 的流程 |
| `nnn` | 文件管理器 | high | 已完成 | 适合文件系统导航、选择、搜索、文件操作类任务 |
| `lazygit` | Git 管理器 | high | 已完成 | 适合多面板、高交互、Git 状态理解和复杂命令触发 |
| `btop` | 系统监控 | medium | 候选 | 适合只读观察型任务，但 side effect oracle 较弱 |

这说明当前数据集已经覆盖了三类重要样本：低交互 CLI 输出型、高交互文件系统型、高交互 Git 工作流型。下一步新增候选项目时，应优先补充新的评测维度，例如 API 浏览、表格数据浏览、终端仪表盘、表单输入、层级数据浏览、编辑器式交互，而不是重复选择另一个普通文件管理器或另一个 Git TUI。

## 数据集资产要求

每个正式纳入数据集的项目，应最终形成类似以下结构：

```text
datasets/
└── project-name/
    ├── info.json
    ├── install.md
    └── tasks/
        ├── task-01.json
        ├── task-02.json
        └── ...
```

| 文件 | 作用 | 调研时需要提前确认的内容 |
| --- | --- | --- |
| `info.json` | 描述项目元信息 | 名称、URL、语言、许可证、类别、交互强度、TUI 库、依赖 |
| `install.md` | 描述可复现安装过程 | 是否能从零安装、是否需要 root、是否需要网络、是否有版本约束 |
| `tasks/*.json` | 描述评测任务 | 任务目标、前置条件、fixture、oracle、negative oracle、hints |
| fixture | 提供稳定环境 | 本地文件、Git 仓库、JSON 数据、配置文件、模拟输入等 |
| oracle | 判定任务是否成功 | 文件存在、文件内容、命令输出、退出码、tmux 截屏等 |

本文后续所有案例都围绕这些资产是否容易构建来评价。

## 候选项目筛选标准

| 维度 | 说明 | 高价值表现 | 低价值表现 |
| --- | --- | --- | --- |
| 任务可设计性 | 是否能写出自然语言任务 | “创建分支并切换”“筛选表格并打开详情” | “看一下界面是否正常” |
| Oracle 稳定性 | 是否能自动判断成功 | 文件内容、命令输出、退出码、结构化 JSON | 只能靠肉眼判断颜色或布局 |
| 环境可复现性 | 是否容易构造前置状态 | 本地 fixture、离线 JSON、临时 Git 仓库 | 依赖真实云服务、账号、API key |
| 交互覆盖度 | 是否能测试 TUI Agent 能力 | 多面板、焦点、快捷键、输入、确认 | 单次命令输出，无持续交互 |
| 安装成本 | 是否能写出稳定安装文档 | 包管理器、源码构建、单二进制 | 编译复杂、依赖重、平台强绑定 |
| 与现有数据集互补 | 是否补充新能力 | API 浏览、表格、图表、层级数据 | 与 `nnn` 或 `lazygit` 高度重复 |

## 核心综合榜单 (Master Lists)

这些仓库是 TUI 界的"百科全书"，包含了绝大多数成熟且流行的项目。

### Awesome Ratatui

项目地址：<https://github.com/ratatui/awesome-ratatui>

特点：专注于使用 Rust 语言中最流行的 TUI 框架 `ratatui` 构建的应用。

科研价值：这里的项目通常代码质量极高、交互非常现代且稳定，非常适合进行基于 Rust 的静态代码分析。

### Awesome OpenTUI

项目地址：<https://github.com/msmps/awesome-opentui>

特点：2026 年较新的榜单，包含了许多**面向 AI Agent** 设计的 TUI（如 `hunk`）和现代组件化 TUI。

科研价值：由于课题涉及 Agent-as-a-User，这个榜单中的"Agent-friendly"工具可以直接作为研究对象或对比标准。

### Reddit CLI/TUI 精选

项目地址：<https://www.reddit.com/r/commandline/comments/1jniqsy/essential_clitui_tools_for_developers/>

特点：由 Reddit 社区用户根据"日常必用"投票选出，实战性极强。

---

## 按领域分类的"种子项目"推荐

为保证 Benchmark 的**多样性（Diversity）**，建议从以下四个领域中各选出 2-3 个代表作：

| 领域 | 顶级推荐 | 理由 |
| --- | --- | --- |
| **版本控制** | `lazygit`, `gitui`, `tig` | 交互极其复杂，包含弹窗、多级菜单、动态列表 |
| **系统监控** | `btop`, `htop`, `k9s` | 涉及大量实时刷新的 UI 元素，考验 Agent 的观测频率 |
| **文件管理** | `yazi`, `ranger`, `superfile` | 典型的三栏布局，包含大量文件系统交互 |
| **开发测试** | `lazydocker`, `atac`, `harlequin` | 功能逻辑性强，容易定义"成功/失败"的 Oracle 信号 |

各项目地址：

| 项目 | 地址 | 说明 |
| --- | --- | --- |
| `gitui` | <https://github.com/extrawurst/gitui> | Rust 编写的 Git TUI，与 lazygit 互补 |
| `tig` | <https://github.com/jonas/tig> | 经典 ncurses Git 浏览器 |
| `htop` | <https://github.com/htop-dev/htop> | 经典进程查看器 |
| `k9s` | <https://github.com/derailed/k9s> | Kubernetes 集群管理 TUI（重环境） |
| `yazi` | <https://github.com/sxyazi/yazi> | Rust 编写的现代文件管理器 |
| `ranger` | <https://github.com/ranger/ranger> | Python 编写的经典三栏文件管理器 |
| `superfile` | <https://github.com/MHNightCat/superfile> | Go 编写的现代文件管理器 |
| `lazydocker` | <https://github.com/jesseduffield/lazydocker> | Docker 管理 TUI，与 lazygit 同作者 |
| `atac` | <https://github.com/Julien-cpsn/atac> | 终端 API 客户端，类 Postman |
| `harlequin` | <https://github.com/tconbeer/harlequin> | Python SQL IDE for the terminal |

---

## 构建 Benchmark 的筛选策略

1. **交叉对比筛选**：如果在上述三个榜单中都出现的项目（如 `lazygit`, `btop`, `yazi`），说明其**成熟度**和**通用性**极高，应优先选入。
2. **获取"专家轨迹"数据**：许多项目有官方演示视频（`asciinema` 录制）。可下载 `.cast` 文件解析为按键流，作为 **Golden Trace（金标准轨迹）**。
3. **语言多样性**：建议在最终名单中包含 3-4 种不同语言编写的 TUI（如 Go 的 `bubbletea` 系列、Rust 的 `ratatui` 系列、Python 的 `textual` 系列），以论证评测算法具有**跨语言的通用性**。

---

## 从 Ratatui 官网得到的候选方向

Ratatui 官网展示了大量真实 TUI 项目。相比官方 examples，这些真实项目更适合作为数据集候选，因为它们有完整业务目标、真实安装方式和真实用户工作流。

### csvlens

项目地址：<https://github.com/YS-L/csvlens>

类型：CSV 文件查看器。

建议状态：优先候选。

适合纳入原因：

- 与现有 `wego`、`nnn`、`lazygit` 互补，代表结构化表格数据浏览场景。
- Fixture 容易构造，只需要准备固定 CSV 文件。
- Oracle 可以通过选定行列、过滤结果、排序结果或导出结果验证。
- 不依赖网络、账号或外部服务，可复现性强。
- 表格浏览、横向滚动、搜索过滤、列宽处理都能测试用户行为 Agent 的屏幕理解能力。

可设计任务示例：

| 任务 | 前置条件 | Oracle |
| --- | --- | --- |
| 打开指定 CSV 并定位某个城市记录 | 准备 `cities.csv` | tmux 截屏包含目标城市和对应列值 |
| 搜索某个字段值 | 准备含多行数据的 CSV | 截屏或导出结果只包含匹配行 |
| 切换到指定列并查看详情 | 准备宽表 CSV | 截屏包含目标列名和目标单元格 |

风险：如果任务只能靠 tmux 截屏判断，oracle 稳定性会弱于文件系统验证。应优先确认是否支持命令行参数、导出、固定布局或可脚本化输出。

### openapi-tui

项目地址：<https://github.com/zaghaghi/openapi-tui>

类型：OpenAPI 浏览和请求执行 TUI。

建议状态：优先候选，但需要控制环境。

适合纳入原因：

- 代表 API 浏览、接口选择、参数填写、请求执行、响应查看等工作流。
- 与 `lazygit` 的 Git 工作流、`nnn` 的文件工作流互补。
- 可以用本地 OpenAPI spec 和本地 mock server 构造离线 fixture。
- 能测试多面板导航、搜索、表单输入、详情查看和响应解释。

可设计任务示例：

| 任务 | 前置条件 | Oracle |
| --- | --- | --- |
| 打开本地 OpenAPI 文件并定位 `/users` 接口 | 准备 `openapi.yaml` | 截屏包含 `/users` 和接口描述 |
| 执行本地 mock GET 请求 | 启动本地 mock server | server 日志包含请求，响应区包含预期 JSON |
| 修改参数后重新请求 | 本地接口返回参数回显 | 响应内容包含指定参数值 |

风险：如果依赖真实外部 API，会导致不稳定。必须要求离线 spec、本地 mock server 和固定响应。

### oxker

项目地址：<https://github.com/mrjackwills/oxker>

类型：Docker 容器查看和控制 TUI。

建议状态：第二批候选。

适合纳入原因：

- 代表运维控制台型 TUI，覆盖列表、详情、状态刷新和控制操作。
- 可以测试 Agent 是否理解容器状态、日志面板、启动/停止等操作。
- 与现有 Git 和文件系统任务互补。

可设计任务示例：

| 任务 | 前置条件 | Oracle |
| --- | --- | --- |
| 找到指定容器并查看日志 | 启动本地测试容器 | tmux 截屏包含容器名和日志内容 |
| 停止某个容器 | 启动可停止容器 | `docker inspect` 显示状态为 exited |
| 过滤容器列表 | 多个命名容器 | 截屏只显示或高亮目标容器 |

风险：依赖 Docker daemon，环境成本高于 `csvlens` 和 `openapi-tui`。如果测试机器没有 Docker 权限，安装和验证会复杂。

### binsider

项目地址：<https://github.com/orhun/binsider>

类型：二进制分析 TUI。

建议状态：研究候选。

适合纳入原因：

- 代表专业分析工具，能测试高密度信息阅读和面板导航。
- Fixture 可以通过固定二进制文件构造。
- 与现有项目领域差异明显。

可设计任务示例：

| 任务 | 前置条件 | Oracle |
| --- | --- | --- |
| 打开固定 ELF 文件并定位某段信息 | 准备测试 ELF | 截屏包含目标 section 名称 |
| 查看字符串或符号 | 准备含固定字符串的二进制 | 截屏包含目标字符串 |

风险：任务可能偏观察型，side effect 较少，oracle 可能依赖屏幕文本。适合补充信息理解能力，但不适合作为第一优先级。

### yozefu

项目地址：<https://github.com/MAIF/yozefu>

类型：Kafka 集群探索 TUI。

建议状态：后续候选。

适合纳入原因：

- 代表数据基础设施管理场景。
- 可以测试 topic、partition、message、consumer group 等层级状态理解。

风险：需要 Kafka 环境，fixture 和 oracle 成本较高。除非后续明确需要复杂外部服务型 TUI，否则不建议第一批纳入。

## Ratatui 官方 examples 对数据集的价值

Ratatui examples 本身不是现成数据集候选，因为它们多数是演示 widget 或框架能力，而不是面向终端用户的完整工具。但它们对设计 benchmark 任务类型很有价值，可以帮助我们定义应该覆盖哪些 TUI 能力。

| Ratatui 示例 | 展示能力 | 对数据集设计的启发 |
| --- | --- | --- |
| `table` | 交互式表格 | 适合选择 `csvlens` 这类表格浏览项目 |
| `input-form` | 表单输入 | 适合设计参数填写、配置编辑、搜索输入任务 |
| `popup` | 弹窗确认 | 适合设计删除、丢弃、提交、执行请求等确认任务 |
| `async-github` | 异步 API 数据 | 适合设计远程或 mock API 加载任务，但要控制网络不稳定性 |
| `chart` / `gauge` / `weather` | 图表和指标 | 适合选择监控类 TUI，例如 `btop` 或 Docker/Kafka 控制台 |
| `constraint-explorer` / `flex` | 多区域布局 | 适合评估 Agent 是否理解多面板和焦点切换 |
| `scrollbar` | 长内容滚动 | 适合日志、文档、表格长列表任务 |
| `user-input` | 键盘输入 | 适合所有高交互 TUI 的基础任务设计 |

不建议直接把 Ratatui examples 纳入正式数据集。原因是：

- 它们主要展示框架能力，不是完整用户工具。
- 任务缺少真实业务目标。
- Oracle 多依赖屏幕显示。
- 安装方式依赖 Ratatui workspace，不代表普通用户安装真实 TUI 项目。

更合适的用法是：把 Ratatui examples 当作能力分类参考，例如表格、表单、弹窗、异步、图表、布局。

## Textual examples 对数据集的价值

Textual examples 同样更多是框架示例，而不是完整产品。但它们覆盖了很多对数据集设计有启发的交互模式，尤其是树形数据、代码浏览、Markdown、主题和表单交互。

| Textual 示例 | 展示能力 | 对数据集设计的启发 |
| --- | --- | --- |
| `json_tree.py` | 层级数据展开和折叠 | 适合选择 JSON/YAML 浏览器、配置浏览器、API 响应浏览器 |
| `code_browser.py` | 文件树 + 内容详情 | 可为文件浏览、代码导航、文档浏览类任务提供结构参考 |
| `dictionary.py` | 搜索输入 + 结果展示 | 可为查询式 TUI 设计搜索和结果验证任务 |
| `calculator.py` | 按钮和状态更新 | 可为表单、命令面板、快捷操作任务提供事件模型参考 |
| `markdown.py` | 长文本和文档渲染 | 适合帮助页、说明页、报告阅读类任务 |
| `theme_sandbox.py` | 主题和样式 | 可辅助设计视觉一致性任务，但不宜作为主要 oracle |
| `sidebar.py` / `breakpoints.py` | 侧边栏和响应式布局 | 可帮助评估多区域导航和小窗口适配 |

Textual examples 暗示数据集可以补充以下方向：

- JSON/YAML/TOML 配置浏览器。
- 代码或文档浏览器。
- API 响应查看器。
- 查询式内部工具。
- 表单驱动的配置编辑器。

这些方向和当前已有的 `wego`、`nnn`、`lazygit` 有明显互补性。但如果只使用 Textual 官方 examples 本身，可能仍然存在框架演示多于真实业务的问题。因此建议优先寻找 Textual 生态中的成品 TUI，而不是直接把 examples 纳入正式 benchmark。

## 与当前已有 benchmark 的互补分析

新增项目应优先补齐当前数据集缺口。

| 已有项目 | 已覆盖能力 | 尚未覆盖能力 |
| --- | --- | --- |
| `wego` | 配置、输出格式、缓存、离线 JSON backend | 高交互、多面板、焦点导航 |
| `nnn` | 文件导航、选择、搜索、文件操作 | API、表格数据、业务状态、网络或 mock 服务 |
| `lazygit` | Git 状态、多面板、提交、分支、stash、rebase | 表格数据浏览、非 Git 业务对象、只读监控、表单配置 |

基于这个缺口，下一批候选优先级建议如下：

| 优先级 | 项目 | 主要补充能力 | 推荐理由 |
| --- | --- | --- | --- |
| 1 | `csvlens` | 表格数据浏览、过滤、定位 | 环境轻、fixture 简单、与现有项目互补强 |
| 2 | `openapi-tui` | API 浏览、参数输入、响应查看 | 能补充表单和接口工作流，但需要本地 mock server |
| 3 | `btop` | 只读监控、指标面板、状态定位 | 已在仓库中作为候选，适合补观察型任务 |
| 4 | `oxker` | 运维控制台、状态控制、日志查看 | 交互价值强，但 Docker 环境成本较高 |
| 5 | `binsider` | 专业分析、高密度信息阅读 | 领域互补，但 oracle 多依赖截屏 |
| 6 | `yozefu` | 数据基础设施、多层级状态 | 研究价值高，但 Kafka 环境成本高 |

## 推荐新增项目一：csvlens

项目地址：<https://github.com/YS-L/csvlens>

建议结论：最适合作为下一批数据集项目。

### 选择理由

`csvlens` 的最大优点是 fixture 简单、任务明确、环境成本低。只要准备固定 CSV 文件，就可以构造大量稳定任务。它可以补齐当前数据集缺少的结构化表格数据浏览能力。

它和现有项目的关系如下：

| 对比项目 | 差异 |
| --- | --- |
| `wego` | `wego` 主要是命令输出和配置，`csvlens` 是交互式表格浏览 |
| `nnn` | `nnn` 浏览文件系统，`csvlens` 浏览文件内容中的结构化数据 |
| `lazygit` | `lazygit` 是 Git 工作流，`csvlens` 是数据查询和定位工作流 |

### 建议数据集设计

`info.json` 可记录：

| 字段 | 建议值 |
| --- | --- |
| `category` | `data-viewer` |
| `interaction_level` | `medium` |
| `terminal_ui_library` | 待确认 |
| `description` | 命令行 CSV 文件查看器，支持表格浏览、搜索和过滤 |

`install.md` 应验证：

- 是否可通过包管理器、cargo 或 release binary 安装。
- 是否能在 Ubuntu/Debian 上从零安装。
- 是否能用固定 CSV 文件启动。
- 是否支持 `--help`、版本输出或非交互验证。

建议任务：

| 任务编号 | 任务标题 | 前置条件 | Oracle 类型 |
| --- | --- | --- | --- |
| task-01 | 打开 CSV 并定位指定记录 | 固定 `people.csv` | tmux 截屏包含目标姓名和字段 |
| task-02 | 搜索包含指定关键词的行 | 固定 `tickets.csv` | 截屏只显示或高亮目标记录 |
| task-03 | 查看宽表中的指定列 | 固定宽表 CSV | 截屏包含目标列名和单元格 |
| task-04 | 对指定列排序或移动定位 | 固定数字列 CSV | 截屏显示目标排序结果 |

### 风险控制

- 避免依赖真实大文件，全部使用仓库内 fixture。
- 如果 tmux 截屏内容受终端宽度影响，需要固定 `COLUMNS`、`LINES` 或 tmux pane 尺寸。
- 任务描述应避免指定具体快捷键，快捷键放在 `hints` 中。

## 推荐新增项目二：openapi-tui

项目地址：<https://github.com/zaghaghi/openapi-tui>

建议结论：适合作为 API 工作流 benchmark，但必须离线化。

### 选择理由

`openapi-tui` 能补充当前数据集缺少的接口浏览和请求执行场景。这类任务非常适合评估生成式 TUI 或用户行为 Agent 是否理解资源列表、参数、响应、错误状态这些应用型概念。

### 建议数据集设计

Fixture 应包括：

- 一个固定 OpenAPI 文件，例如 `fixtures/openapi.yaml`。
- 一个本地 mock server，例如监听 `127.0.0.1:18080`。
- 固定响应 JSON，例如 `/users/42` 返回固定用户对象。

建议任务：

| 任务编号 | 任务标题 | 前置条件 | Oracle 类型 |
| --- | --- | --- | --- |
| task-01 | 定位指定 API endpoint | 本地 OpenAPI 文件 | tmux 截屏包含 endpoint 和描述 |
| task-02 | 执行 GET 请求并查看响应 | 本地 mock server | server 日志 + 截屏响应内容 |
| task-03 | 修改路径参数后请求 | mock server 回显参数 | 响应 JSON 包含指定值 |
| task-04 | 查看错误响应 | mock server 返回 404 | 截屏包含状态码和错误 JSON |

### 风险控制

- 不使用真实公网 API。
- 不使用需要认证的接口。
- mock server 必须由 `preconditions.setup_command` 启动，并能在任务结束后清理。
- oracle 不只依赖屏幕，尽量结合 server log 或输出文件。

## 推荐新增项目三：btop

项目地址：<https://github.com/aristocratos/btop>

建议结论：适合作为只读监控型 benchmark，但不应单独代表高交互 TUI。

### 选择理由

`btop` 已在仓库 `README.md` 中列为候选。它代表系统监控类 TUI，可以补充指标面板、状态定位、只读观察任务。它的安装通常不复杂，用户也熟悉此类界面。

### 可设计任务

| 任务 | Oracle |
| --- | --- |
| 找到 CPU 使用率区域 | tmux 截屏包含 CPU 区域和百分比 |
| 查看内存使用情况 | 截屏包含 Mem 或 memory 指标 |
| 切换到进程视图并定位某个进程 | 截屏包含目标进程名 |

### 风险

`btop` 主要是观察型工具，很多任务没有持久 side effect。系统状态还会随机器变化，因此 oracle 多半依赖 tmux 截屏和宽松匹配。它适合补充界面理解能力，不适合作为自动化验证最稳定的项目。

## 推荐新增项目四：oxker

项目地址：<https://github.com/mrjackwills/oxker>

建议结论：适合作为第二阶段运维控制台 benchmark。

### 选择理由

`oxker` 可以补充容器管理场景，任务具有明确 side effect，例如启动、停止、查看日志。这比纯监控工具更容易定义 oracle。

### 可设计任务

| 任务 | 前置条件 | Oracle |
| --- | --- | --- |
| 查看指定容器日志 | 启动固定测试容器 | 截屏包含固定日志文本 |
| 停止指定容器 | 启动 named container | `docker inspect` 状态为 exited |
| 找到运行中的容器 | 多个容器 | 截屏包含目标容器名和 running 状态 |

### 风险

需要 Docker 环境和权限。相比 `csvlens`，它的环境成本明显更高。建议等基础 benchmark 流程更稳定后再纳入。

## 不建议第一批直接纳入的内容

### Ratatui examples

不建议直接把 Ratatui examples 纳入正式数据集。原因是：

- 它们主要展示框架能力，不是完整用户工具。
- 任务缺少真实业务目标。
- Oracle 多依赖屏幕显示。
- 安装方式依赖 Ratatui workspace，不代表普通用户安装真实 TUI 项目。

更合适的用法是：把 Ratatui examples 当作能力分类参考，例如表格、表单、弹窗、异步、图表、布局。

### Textual examples

不建议直接把 Textual examples 纳入正式数据集。原因类似：

- 它们是框架示例，不是稳定产品。
- 很多任务只能验证 widget 是否显示，而不是验证用户完成真实目标。
- 作为 benchmark 项目时，代表性弱于真实 TUI 应用。

更合适的用法是：把 Textual examples 当作任务形态参考，例如 JSON 树、代码浏览、Markdown、查询式交互、主题和响应式布局。

### 重环境项目

例如 `k9s`、`yozefu` 这类依赖 Kubernetes 或 Kafka 的项目，交互价值很高，但第一批不建议优先做。原因是：

- Fixture 成本高。
- 安装和运行环境重。
- Oracle 容易依赖外部服务状态。
- Agent 失败时很难判断是操作失败、环境失败还是服务状态变化。

它们适合第二阶段或第三阶段作为复杂真实场景补充。

## 建议的下一步工作

结合当前数据集状态，建议按以下顺序推进。

### 第一步：补充候选池记录

在 `tui-candidates.md` 中新增或更新以下项目：

| 项目 | 建议状态 | 原因 |
| --- | --- | --- |
| `csvlens` | 候选保留 | 环境轻、表格数据任务明确、与现有项目互补 |
| `openapi-tui` | 调研中 | API 工作流价值高，但需要验证离线 fixture 方案 |
| `oxker` | 调研中 | 运维控制台价值高，但 Docker 环境成本较高 |
| `binsider` | 待初筛 | 专业分析工具，需确认 oracle 可行性 |
| `yozefu` | 待初筛 | Kafka 环境较重，后续阶段考虑 |

### 第二步：优先立项 csvlens

建议先为 `csvlens` 建立 `datasets/csvlens/`，因为它最符合当前阶段的需求：

- 与已有项目互补。
- Fixture 最容易构造。
- 安装成本相对低。
- 任务可以覆盖表格浏览、搜索、定位、排序等能力。
- 不依赖外部 API 或服务。

初始目录建议：

```text
datasets/csvlens/
├── info.json
├── install.md
├── fixtures/
│   ├── people.csv
│   ├── tickets.csv
│   └── wide-table.csv
└── tasks/
    ├── task-01.json
    ├── task-02.json
    ├── task-03.json
    └── task-04.json
```

### 第三步：再评估 openapi-tui

`openapi-tui` 应在确认以下问题后再正式纳入：

- 是否能完全使用本地 OpenAPI 文件。
- 是否能连接本地 mock server。
- 是否能通过日志、响应文件或 tmux 截屏稳定验证。
- 是否能写出低成本安装步骤。

### 第四步：把 Ratatui/Textual examples 用作能力标签

建议在后续任务设计中引入能力标签，例如：

| 标签 | 来源启发 | 含义 |
| --- | --- | --- |
| `table-navigation` | Ratatui `table` | 表格行列导航 |
| `form-input` | Ratatui `input-form`、Textual `dictionary.py` | 输入框、参数、提交 |
| `popup-confirmation` | Ratatui `popup` | 确认或取消操作 |
| `tree-navigation` | Textual `json_tree.py` | 层级数据展开和折叠 |
| `multi-panel-focus` | Ratatui `constraint-explorer`、Textual `code_browser.py` | 多面板焦点切换 |
| `long-content-scroll` | Ratatui `scrollbar`、Textual `markdown.py` | 长内容滚动阅读 |
| `async-data-loading` | Ratatui `async-github` | 外部数据加载、刷新、错误状态 |

这些标签可以加入任务 JSON 的 `category` 或扩展字段中，便于后续统计数据集覆盖范围。

## 最终结论

本文不建议把 Ratatui 或 Textual 官方 examples 直接作为正式数据集项目。它们更适合作为任务能力分类和设计参考。

### 已完成或已有数据集

| 项目 | 状态 | 说明 |
| --- | --- | --- |
| `wego` | 已完成 | 低交互 CLI 输出型 |
| `nnn` | 已完成 | 高交互文件系统型 |
| `lazygit` | 已完成 | 高交互 Git 工作流型 |

### 第一批候选（轻环境、高互补）

| 排名 | 项目 | 地址 | 结论 |
| --- | --- | --- | --- |
| 1 | `csvlens` | <https://github.com/YS-L/csvlens> | 最推荐，表格数据浏览，fixture 简单 |
| 2 | `openapi-tui` | <https://github.com/zaghaghi/openapi-tui> | 推荐，API 浏览和请求执行，需离线化 |
| 3 | `btop` | <https://github.com/aristocratos/btop> | 只读监控型，补充面板理解 |

### 第二批候选（需额外环境）

| 排名 | 项目 | 地址 | 结论 |
| --- | --- | --- | --- |
| 4 | `oxker` | <https://github.com/mrjackwills/oxker> | Docker 控制台，交互价值高但依赖 Docker |
| 5 | `lazydocker` | <https://github.com/jesseduffield/lazydocker> | Docker 管理，与 lazygit 同作者 |
| 6 | `k9s` | <https://github.com/derailed/k9s> | Kubernetes 管理，环境较重 |

### 第三批候选（待调研）

| 排名 | 项目 | 地址 | 结论 |
| --- | --- | --- | --- |
| 7 | `binsider` | <https://github.com/orhun/binsider> | 二进制分析，oracle 需谨慎设计 |
| 8 | `yozefu` | <https://github.com/MAIF/yozefu> | Kafka 探索，环境成本高 |
| 9 | `gitui` | <https://github.com/extrawurst/gitui> | Git TUI，与 lazygit 互补 |
| 10 | `yazi` | <https://github.com/sxyazi/yazi> | 现代文件管理器 |
| 11 | `ranger` | <https://github.com/ranger/ranger> | 经典三栏文件管理器 |
| 12 | `superfile` | <https://github.com/MHNightCat/superfile> | Go 文件管理器 |
| 13 | `tig` | <https://github.com/jonas/tig> | 经典 ncurses Git 浏览器 |
| 14 | `atac` | <https://github.com/Julien-cpsn/atac> | 终端 API 客户端 |
| 15 | `harlequin` | <https://github.com/tconbeer/harlequin> | Python SQL TUI |
| 16 | `htop` | <https://github.com/htop-dev/htop> | 经典进程查看器 |

### 待定项目（来源 Awesome OpenTUI / Awesome Ratatui）

以下项目来自 Awesome OpenTUI 等榜单，需进一步调研：

- `hunk` — 面向 AI Agent 设计的 TUI（Awesome OpenTUI 特有）

最务实的下一步是：先把 `csvlens` 加入候选池并建立 `datasets/csvlens/` 原型，用 3 到 4 个任务验证表格型 TUI benchmark 的可行性。完成后，再推进 `openapi-tui` 的离线 mock server 方案。
