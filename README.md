# TUI 评测数据集

**目标：** 构建一套结构化的 TUI（终端用户界面）评测数据集，用于驱动和验证"生成式 TUI"的 Agent 系统。

## 项目思路

整个系统分为三个环节：

```
┌─────────────┐      ┌──────────────────┐      ┌─────────────────┐
│  数据集构建  │─────▶│  TUI 生成 Agent   │─────▶│  用户行为 Agent  │
│  （本仓库）  │      │  根据需求生成 TUI  │      │  模拟用户测试 TUI │
└─────────────┘      └──────────────────┘      └─────────────────┘
```

1. **数据集（本阶段重点）：** 收集真实 TUI 项目，为每个项目编写完整的元信息、安装步骤、自然语言任务描述和成功判定条件
2. **TUI 生成 Agent：** 读取数据集中的任务描述，生成能够完成这些任务的 TUI 程序
3. **用户行为 Agent：** 模拟真实用户操作生成的 TUI，根据数据集中的判定条件验证其是否可用

## 数据集结构

每个 TUI 项目在数据集中包含以下信息：

```
datasets/
├── project-name/
│   ├── info.json              # 项目元信息（名称、URL、语言、许可证等）
│   ├── install.md             # 完整安装步骤（从零开始，任何机器可复现）
│   └── tasks/
│       ├── task-01.json       # 任务定义（自然语言描述 + 判定条件）
│       ├── task-02.json
│       └── ...
```

### info.json 字段说明

| 字段 | 说明 |
|------|------|
| `name` | 项目名称 |
| `url` | 源码仓库地址 |
| `language` | 编程语言 |
| `license` | 许可证 |
| `description` | 一句话描述项目功能 |
| `category` | 项目类型（文件管理器、编辑器、监控工具等） |
| `interaction_level` | 交互强度（low / medium / high） |
| `terminal_ui_library` | 使用的 TUI 框架/库 |

### install.md 要求

- **从零开始：** 假设机器上没有任何开发工具，第一步就是安装依赖
- **可复现：** 每一步都可以直接复制粘贴执行
- **包含验证命令：** 每个关键步骤后有验证命令确认安装成功
- **覆盖多平台：** 至少包含 Ubuntu/Debian 的安装步骤

### task JSON 字段说明

| 字段 | 说明 |
|------|------|
| `id` | 任务编号 |
| `title` | 任务标题 |
| `description` | 自然语言描述用户想要完成的事情（不涉及具体操作） |
| `category` | 任务类别（导航、文件操作、搜索、配置等） |
| `preconditions` | 执行任务前的环境要求 |
| `oracle` | 成功判定条件 |
| `oracle.type` | 判定类型（file_exists / file_content / exit_code / command_output） |
| `oracle.check` | 具体的检查命令或条件 |
| `oracle.expected` | 预期结果 |
| `negative_oracle` | 反向验证（什么情况下算失败） |
| `hints` | 给 Agent 的提示（可选，如涉及的关键操作） |

## 当前数据集

| 项目 | 类型 | 交互强度 | 任务数 | 状态 |
|------|------|----------|--------|------|
| nnn | 文件管理器 | high | 5 | 完成 |
| wego | 天气查询工具 | low | 4 | 完成 |
| pokete | 终端游戏 | high | - | 待补充 |
| lazygit | Git 管理器 | high | - | 候选 |
| btop | 系统监控 | medium | - | 候选 |

## 研究路线

| 阶段 | 时间节点 | 核心内容 |
|------|----------|----------|
| P1: 基础设施 | 第 1-4 周 | 开发 agent-tui 驱动框架 |
| **P2: 数据集构建** | **第 5-10 周** | **为 ~10 个 TUI 项目编写完整数据集** |
| P3: 实验采集 | 第 11-16 周 | 用数据集驱动 TUI 生成 Agent，用用户行为 Agent 验证 |
| P4: 论文撰写 | 第 17 周起 | 分析数据、撰写论文 |

## 快速开始

```bash
git clone git@github.com:Sakurawin/TUI.git
cd TUI

# 查看某个项目的数据集
cat datasets/nnn/info.json
cat datasets/nnn/install.md
cat datasets/nnn/tasks/task-01.json
```

## 许可证

各子项目保留其原始许可证。数据集文档采用 CC BY 4.0 许可。
