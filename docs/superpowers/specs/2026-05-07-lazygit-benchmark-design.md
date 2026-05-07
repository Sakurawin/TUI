# lazygit Benchmark 数据集设计

## 概述

为 lazygit（Git 仓库管理 TUI）构建完整的 benchmark 数据集，包含 8 个任务，覆盖其核心交互能力。

## 目标

- 构建 `datasets/lazygit/` 目录结构，与 nnn/wego 保持一致
- 8 个任务覆盖 lazygit 的主要能力：导航、commit、branch、stash、diff、rebase、cherry-pick、discard
- 混合验证策略：文件系统验证 + tmux 截屏对比

## 目录结构

```
datasets/lazygit/
├── info.json           # 项目元信息
├── install.md          # 安装指南
└── tasks/
    ├── task-01.json    # 提交暂存文件
    ├── task-02.json    # 创建并切换分支
    ├── task-03.json    # 暂存并恢复工作区
    ├── task-04.json    # 查看文件 diff
    ├── task-05.json    # 解决合并冲突
    ├── task-06.json    # 交互式 rebase
    ├── task-07.json    # Cherry-pick 提交
    └── task-08.json    # 丢弃未暂存更改
```

## info.json

```json
{
  "name": "lazygit",
  "url": "https://github.com/jesseduffield/lazygit",
  "language": "Go",
  "license": "MIT",
  "description": "Git 仓库管理 TUI，提供多面板界面管理暂存区、分支、提交历史、stash 等",
  "category": "git-manager",
  "interaction_level": "high",
  "terminal_ui_library": "gocui",
  "version": "latest",
  "platforms": ["linux", "macos", "bsd", "windows"],
  "dependencies": {
    "required": ["go 1.20+", "git"],
    "optional": []
  },
  "key_features": [
    "多面板布局（文件/分支/提交/stash/远程）",
    "vim-style 导航 (h/j/k/l)",
    "交互式 rebase（squash/reword/fixup）",
    "暂存区精细操作（行级 stage/unstage）",
    "合并冲突可视化解决",
    "cherry-pick、bisect 等高级 Git 操作"
  ]
}
```

## install.md 核心步骤

```bash
# Ubuntu / Debian
sudo apt-get update
sudo apt-get install -y golang-go git

# 安装 lazygit
go install github.com/jesseduffield/lazygit@latest

# 确保 PATH 包含 $HOME/go/bin
export PATH=$HOME/go/bin:$PATH

# 验证
lazygit --version
```

## 任务设计

### task-01: 提交暂存文件

- **描述**: 用户在一个 Git 仓库中有两个未跟踪的文件，希望通过 lazygit 将它们暂存并提交，提交消息为 "initial commit"
- **类别**: commit
- **Fixture**: `/tmp/lg-test-01/` — 空 Git 仓库 + 2 个未跟踪文件（README.md, main.go）
- **操作流程**: 进入 lazygit → `Space` 暂存文件 → `c` 提交 → 输入消息 → 确认
- **Oracle (file_content)**: `git log --oneline -1` 包含 "initial commit"，`git status` 无未提交更改
- **Negative Oracle**: 提交消息不匹配，或文件未全部暂存

### task-02: 创建并切换分支

- **描述**: 用户在 main 分支上，希望创建一个名为 feature 的新分支并切换过去
- **类别**: branch
- **Fixture**: `/tmp/lg-test-02/` — 有 1 个 commit 的 Git 仓库
- **操作流程**: `3` 进入分支面板 → `n` 创建新分支 → 输入 "feature" → `Enter`
- **Oracle (command_output)**: `git branch --show-current` 输出 "feature"，`git branch` 包含 "feature"
- **Negative Oracle**: 分支未创建或未切换

### task-03: 暂存并恢复工作区

- **描述**: 用户有未提交的修改，希望通过 stash 暂存，然后恢复这些修改
- **类别**: stash
- **Fixture**: `/tmp/lg-test-03/` — 有 1 个 commit + 1 个已修改文件
- **操作流程**: `4` 进入 stash 面板 → `s` 暂存 → 确认 → `g` 弹出恢复
- **Oracle (command_output)**: `git stash list` 为空（已弹出），`git diff` 显示修改内容已恢复
- **Negative Oracle**: stash 未弹出或工作区内容丢失

### task-04: 查看文件 diff

- **描述**: 用户修改了一个文件，希望在 lazygit 中查看 diff 了解具体变更
- **类别**: diff
- **Fixture**: `/tmp/lg-test-04/` — 有 1 个 commit + 1 个已修改文件（含多行修改）
- **操作流程**: 选中文件 → `Enter` 查看 diff → 确认显示正确
- **Oracle (command_output)**: tmux capture-pane 截屏包含 diff 内容（含 `+` 和 `-` 行）
- **Negative Oracle**: 截屏为空或不包含 diff 标记

### task-05: 解决合并冲突

- **描述**: 两个分支修改了同一文件的同一区域导致冲突，用户通过 lazygit 选择解决方案
- **类别**: conflict
- **Fixture**: `/tmp/lg-test-05/` — 两个分支（main, feature）修改同一文件，预先执行 merge 触发冲突
- **操作流程**: 合并后出现冲突面板 → 选择冲突文件 → 选择解决方案（如保留 theirs）→ 标记为已解决
- **Oracle (file_content)**: 冲突文件不包含冲突标记（`<<<<<<<`, `=======`, `>>>>>>>`），内容为预期值
- **Negative Oracle**: 文件仍含冲突标记

### task-06: 交互式 rebase

- **描述**: 用户有 3 个连续 commit，希望将后两个 squash 成一个
- **类别**: rebase
- **Fixture**: `/tmp/lg-test-06/` — 3 个连续 commit 的仓库
- **操作流程**: 选中第一个 commit → `e` 进入 rebase 编辑 → 选择 squash → 保留消息
- **Oracle (command_output)**: `git log --oneline | wc -l` 输出 2（从 3 个减少到 2 个）
- **Negative Oracle**: commit 数量未减少或 rebase 中途失败

### task-07: Cherry-pick 提交

- **描述**: 用户在 feature 分支有一个 commit，希望 cherry-pick 到 main 分支
- **类别**: cherry-pick
- **Fixture**: `/tmp/lg-test-07/` — main 和 feature 两个分支，feature 有 1 个独有的 commit
- **操作流程**: 切换到 feature 分支 → 选中 commit → `C` 复制 → 切换到 main → `V` 粘贴
- **Oracle (command_output)**: `git log main --oneline` 包含 cherry-pick 的 commit 内容
- **Negative Oracle**: main 分支不包含目标 commit

### task-08: 丢弃未暂存更改

- **描述**: 用户有未暂存的修改文件，希望丢弃所有更改恢复到上次提交的状态
- **类别**: discard
- **Fixture**: `/tmp/lg-test-08/` — 有 1 个 commit + 1 个已修改文件
- **操作流程**: 选中文件 → `d` → 确认丢弃
- **Oracle (command_output)**: `git status` 输出 "nothing to commit, working tree clean"
- **Negative Oracle**: 文件仍包含未提交的修改

## 验证策略

| 验证方式 | 适用任务 | 说明 |
|----------|----------|------|
| 文件系统验证 | 01/02/03/05/06/07/08 | 通过 `git log`、`git branch`、`git stash list`、文件内容等验证 |
| tmux 截屏验证 | 04 | 通过 `tmux capture-pane` 截取屏幕内容，检查是否包含预期的 diff 标记 |

## Fixture 策略

每个任务的 `preconditions.setup_command` 创建独立的临时 Git 仓库（如 `/tmp/lg-test-01/`），任务间完全隔离。

复杂场景需要在 setup 中预先创建多个 commit 和分支：

| 任务 | Fixture 复杂度 | 预创建内容 |
|------|---------------|-----------|
| 01 | 低 | 空仓库 + 2 个未跟踪文件 |
| 02 | 低 | 1 个 commit |
| 03 | 中 | 1 个 commit + 工作区修改 |
| 04 | 中 | 1 个 commit + 工作区修改（多行） |
| 05 | 高 | 2 个分支 + 冲突状态 |
| 06 | 高 | 3 个连续 commit |
| 07 | 高 | 2 个分支 + 各自的 commit |
| 08 | 中 | 1 个 commit + 工作区修改 |

## 实施计划

1. 创建 `datasets/lazygit/` 目录结构
2. 编写 `info.json` 和 `install.md`
3. 逐个编写 8 个 task JSON 文件
4. 在本地安装 lazygit 并手动验证每个任务
5. 编写自动化验证脚本（参考 nnn 的 verify-task-01.sh 模式）
6. 更新 `selected-benchmarks.md` 将 lazygit 标记为已选入
