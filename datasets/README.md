# TUI Benchmark 数据集

## 数据集架构

```
datasets/
├── README.md              # 本文档
├── <project-name>/        # 每个 TUI 项目一个目录
│   ├── info.json          # 项目元信息
│   ├── install.md         # 安装说明
│   ├── fixtures/          # 测试固件（可选）
│   │   └── setup.sh       # 环境初始化脚本
│   └── tasks/             # 任务列表
│       ├── task-01.json   # 单个任务定义
│       ├── task-02.json
│       └── ...
```

### 目录说明

| 文件 | 用途 |
|------|------|
| `info.json` | 项目基本信息：名称、仓库地址、语言、依赖、核心功能等 |
| `install.md` | 项目的安装步骤和环境要求 |
| `fixtures/` | 测试所需的预置数据、Docker 配置、模拟脚本等 |
| `tasks/` | 任务定义文件，每个文件一个独立任务 |

---

## info.json 字段说明

```json
{
  "name": "项目名称",
  "url": "GitHub 仓库地址",
  "language": "主要编程语言",
  "license": "开源许可证",
  "description": "一句话项目描述",
  "category": "项目类别（如 system-monitor、file-manager、version-control）",
  "interaction_level": "交互复杂度（low / medium / high）",
  "terminal_ui_library": "使用的 TUI 框架",
  "version": "测试的目标版本",
  "platforms": ["支持平台列表"],
  "dependencies": {
    "required": ["必需依赖"],
    "optional": ["可选依赖"]
  },
  "key_features": ["核心功能列表"]
}
```

---

## task.json 字段说明

### 顶层字段

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `id` | string | 是 | 任务唯一编号，格式 `task-XX` |
| `title` | string | 是 | 一句话任务标题 |
| `description` | string | 是 | 自然语言描述，包含用户目标和预期效果 |
| `category` | string | 是 | 任务类别 |
| `preconditions` | object | 是 | 任务执行前的环境准备条件 |
| `oracle` | object | 是 | 判定任务成功的条件 |
| `negative_oracle` | object | 否 | 判定任务失败的条件 |
| `hints` | object | 否 | 给 Agent 的提示信息 |

### description 字段规范

description 应包含两部分：
1. **用户目标**：用户想做什么
2. **预期效果**：操作完成后的最终状态

```
用户想要做 XXX。预期效果：YYY。
```

示例：
```
用户想要浏览一个项目目录，进入其中的 src 子目录，查看里面有哪些源码文件，然后返回上级目录。预期效果：成功进入 src/ 目录看到源码文件列表，返回后 nnn 正常退出。
```

**原则：**
- 目标导向，而非指令导向（描述"要什么"，而非"怎么做"）
- 使用自然语言，不涉及具体按键操作
- 明确前置条件（如"需先创建某文件"）

### preconditions 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `setup_command` | string | 自动化框架执行的 bash 命令（Agent 不可见） |
| `description` | string | 自然语言描述任务开始前应处于的状态 |

示例：
```json
{
  "setup_command": "rm -rf /tmp/lg-test-01 && mkdir -p /tmp/lg-test-01 && cd /tmp/lg-test-01 && git init",
  "description": "存在一个已初始化的 Git 仓库，包含两个未跟踪文件"
}
```

### oracle 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | string | 判定类型：`exit_code` / `file_exists` / `file_content` / `command_output` |
| `check` | string | 自动化验证命令（Agent 不可见） |
| `expected` | string | check 的预期结果（自然语言） |
| `description` | string | 用人话解释 oracle 的含义 |
| `verification_criteria` | string | **给 Agent 看的**自然语言验证标准 |
| `automated_check` | string | 可自动执行的 shell 脚本，输出 PASS/FAIL |
| `automated_expected` | string | automated_check 的预期输出 |

**关键区分：**
- `check` / `automated_check`：包含具体检测命令，**仅供自动化框架使用，Agent 不可见**
- `verification_criteria`：用自然语言描述"什么算成功"，**暴露给 Agent**
- `description`：解释 oracle 的含义，**暴露给 Agent**

### negative_oracle 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `check` | string | 反向验证命令（可选） |
| `expected` | string | 预期的失败结果 |
| `description` | string | 自然语言描述什么情况算失败 |

### hints 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `note` | string | 自然语言提示，帮助 Agent 理解操作方向 |
| `observable_behavior` | string | 屏幕上的预期效果描述（无法自动验证时使用） |

**原则：**
- 不暴露具体按键（如 `Space`、`l`、`h`）
- 不暴露操作流程（如 "按 3 进入分支面板 → 按 n 新建")
- 只描述操作方向和注意事项

---

## 任务设计原则

### 1. 目标导向而非指令导向

```
❌ "请运行 help 子命令查看帮助信息"
✅ "用户希望了解该工具支持哪些功能和子命令"
```

### 2. 增加前置条件

```
❌ "编辑一个待办事项"
✅ "存在一个已创建的待办事项（如 'buy groceries'），需要修改其描述"
```

### 3. 隐藏检测指令

```
❌ accept_if: "bash wego version"
✅ verification_criteria: "终端输出包含版本号信息"
```

---

## 项目选取标准

### 选取原则

1. **功能简单、代码量适中**：确保 AI 生成的代码符合预期且易于测试
2. **高认可度**：优先选择官方推荐或知名榜单中的项目
3. **多样性**：覆盖不同领域（文件管理、系统监控、版本控制等）
4. **语言多样性**：包含不同语言实现（Go、Rust、Python 等）

### 推荐项目来源

#### 核心综合榜单

| 榜单 | 特点 | 链接 |
|------|------|------|
| [rothgar/awesome-tuis](https://github.com/rothgar/awesome-tuis) | TUI 界的"百科全书"，包含绝大多数成熟项目 | GitHub |
| [Awesome Ratatui](https://github.com/ratatui/awesome-ratatui) | 专注 Rust ratatui 框架的 TUI 应用 | GitHub |
| [Awesome OpenTUI](https://github.com/msmps/awesome-opentui) | 2026 年新榜单，含面向 AI Agent 的 TUI | GitHub |
| [Essential CLI/TUI Tools](https://www.reddit.com/r/commandline/comments/1jniqsy/essential_clitui_tools_for_developers/) | Reddit 社区投票选出的日常必用工具 | Reddit |

#### 按领域分类推荐

| 领域 | 推荐项目 | 特点 |
|------|----------|------|
| 版本控制 | `lazygit`, `gitui`, `tig` | 交互复杂，含弹窗、多级菜单、动态列表 |
| 系统监控 | `btop`, `htop`, `k9s` | 实时刷新 UI 元素，考验观测频率 |
| 文件管理 | `yazi`, `ranger`, `superfile`, `nnn` | 典型三栏布局，大量文件系统交互 |
| 开发测试 | `lazydocker`, `atac`, `harlequin` | 功能逻辑性强，容易定义成功/失败信号 |
| 天气查询 | `wego` | 简单 CLI，适合入门级任务 |

### 筛选方法

1. **交叉对比**：在多个榜单中都出现的项目（如 `lazygit`、`btop`、`yazi`），成熟度和通用性最高
2. **获取专家轨迹**：许多项目有官方 `asciinema` 演示录制（`.cast` 文件），可解析为按键流作为 Golden Trace
3. **语言多样性**：10 个项目中包含 3-4 种语言（Go / Rust / Python / C++）

---

## 当前数据集状态

| 项目 | 语言 | 类别 | 任务数 | 状态 |
|------|------|------|--------|------|
| wego | Go | 天气查询 | 4 | ✅ 已完成 |
| btop | C++ | 系统监控 | 5 | ✅ 已完成 |
| lazygit | Go | 版本控制 | 8 | ✅ 已完成 |
| nnn | C | 文件管理 | 5 | ✅ 已完成 |

---

## 待扩展项目（建议）

| 项目 | 语言 | 类别 | 优先级 |
|------|------|------|--------|
| yazi | Rust | 文件管理 | 高 |
| gitui | Rust | 版本控制 | 中 |
| lazydocker | Go | 容器管理 | 中 |
| htop | C | 系统监控 | 低 |
| superfile | Go | 文件管理 | 低 |
