# lazygit Benchmark 数据集实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 lazygit 构建完整的 benchmark 数据集，包含 info.json、install.md 和 8 个任务 JSON 文件

**Architecture:** 遵循 nnn/wego 的数据集结构，每个任务包含自然语言描述、preconditions（fixture 创建）、oracle（验证条件）和 hints

**Tech Stack:** JSON, Bash (setup_command), Git (fixture 仓库)

---

## 文件结构

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

---

### Task 1: 创建目录结构和 info.json

**Files:**
- Create: `datasets/lazygit/info.json`
- Create: `datasets/lazygit/install.md`
- Create: `datasets/lazygit/tasks/` (目录)

- [ ] **Step 1: 创建目录结构**

```bash
mkdir -p /data1/wangyuanhao/TUI/datasets/lazygit/tasks
```

- [ ] **Step 2: 编写 info.json**

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

- [ ] **Step 3: 编写 install.md**

```markdown
# lazygit 安装指南

从零开始在一台全新 Linux 机器上安装并运行 lazygit。

## 第 1 步：安装依赖

```bash
# Ubuntu / Debian
sudo apt-get update
sudo apt-get install -y golang-go git

# 验证
go version && echo "✓ Go 已安装"
git --version && echo "✓ Git 已安装"
```

如果没有 sudo 权限，手动安装 Go：

```bash
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
tar -C $HOME -xzf go1.22.0.linux-amd64.tar.gz
export PATH=$HOME/go/bin:$PATH
echo 'export PATH=$HOME/go/bin:$PATH' >> ~/.bashrc
```

## 第 2 步：安装 lazygit

```bash
go install github.com/jesseduffield/lazygit@latest
```

确保 `$HOME/go/bin` 在 PATH 中：

```bash
export PATH=$HOME/go/bin:$PATH
echo 'export PATH=$HOME/go/bin:$PATH' >> ~/.bashrc
```

## 第 3 步：验证安装

```bash
lazygit --version
```

## 第 4 步：基本使用

```bash
# 在当前目录启动 lazygit
lazygit

# 在指定目录启动
lazygit -p /path/to/repo
```

### 核心键位速查

| 按键 | 功能 |
|------|------|
| `j/k` | 上下移动光标 |
| `h/l` | 面板间切换 |
| `1-5` | 切换到指定面板 |
| `Space` | 暂存/取消暂存文件 |
| `c` | 提交 |
| `n` | 新建分支 |
| `s` | stash |
| `g` | 弹出 stash |
| `e` | 交互式 rebase |
| `d` | 丢弃更改 |
| `?` | 帮助 |
| `q` | 退出 |
```

- [ ] **Step 4: 提交**

```bash
git add datasets/lazygit/
git commit -m "feat: add lazygit dataset structure with info.json and install.md"
```

---

### Task 2: 编写 task-01.json（提交暂存文件）

**Files:**
- Create: `datasets/lazygit/tasks/task-01.json`

- [ ] **Step 1: 编写 task-01.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 01：提交暂存文件",
    "字段说明": {
      "id": "任务唯一编号，格式 task-XX",
      "title": "一句话任务标题",
      "description": "自然语言描述用户想做什么，不涉及具体按键操作。TUI 生成 Agent 读这段话来理解需求",
      "category": "任务类别",
      "preconditions": "验证前必须满足的环境条件",
      "oracle": "判定任务成功的核心条件",
      "negative_oracle": "判定任务失败的条件",
      "hints": "给 Agent 的提示信息，不是硬约束"
    },
    "oracle 字段说明": {
      "type": "判定类型：exit_code / file_exists / file_content / command_output",
      "check": "Agent 或人工执行的验证命令",
      "expected": "check 的预期结果",
      "description": "用人话解释 oracle 的含义",
      "automated_check": "可自动化执行的 shell 脚本，输出 PASS/FAIL",
      "automated_expected": "automated_check 的预期输出"
    }
  },
  "id": "task-01",
  "title": "提交暂存文件",
  "description": "用户在一个 Git 仓库中有两个未跟踪的文件（README.md 和 main.go），希望通过 lazygit 将它们暂存并提交，提交消息为 \"initial commit\"。",
  "category": "commit",
  "preconditions": {
    "_doc": "验证前先执行 setup_command 创建测试 Git 仓库和未跟踪文件",
    "setup_command": "rm -rf /tmp/lg-test-01 && mkdir -p /tmp/lg-test-01 && cd /tmp/lg-test-01 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo '# Hello' > README.md && echo 'package main' > main.go",
    "description": "存在一个已初始化的 Git 仓库，包含两个未跟踪文件"
  },
  "oracle": {
    "_doc": "检查 git log 包含正确的提交消息，且工作区干净",
    "type": "command_output",
    "check": "cd /tmp/lg-test-01 && git log --oneline -1 && git status --short",
    "expected": "git log 输出包含 'initial commit'，git status 无输出（工作区干净）",
    "description": "文件被正确暂存并提交，提交消息匹配",
    "automated_check": "cd /tmp/lg-test-01 && git log --oneline -1 | grep -q 'initial commit' && [ -z \"$(git status --short)\" ] && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "_doc": "反向验证：提交消息不匹配或文件未全部暂存都算失败",
    "description": "如果提交消息不包含 'initial commit'、或 git status 显示有未提交的更改，则任务失败"
  },
  "hints": {
    "_doc": "提示信息，帮助 Agent 理解如何操作",
    "key_operations": ["Space (暂存文件)", "c (提交)", "q (退出)"],
    "expected_flow": "启动 lazygit → 用 j/k 选中文件 → Space 暂存两个文件 → c 输入提交消息 → 确认 → q 退出"
  }
}
```

- [ ] **Step 2: 验证 fixture 创建**

```bash
rm -rf /tmp/lg-test-01 && mkdir -p /tmp/lg-test-01 && cd /tmp/lg-test-01 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo '# Hello' > README.md && echo 'package main' > main.go
git status
```

Expected: 显示两个未跟踪文件 README.md 和 main.go

- [ ] **Step 3: 提交**

```bash
git add datasets/lazygit/tasks/task-01.json
git commit -m "feat: add lazygit task-01 (commit staged files)"
```

---

### Task 3: 编写 task-02.json（创建并切换分支）

**Files:**
- Create: `datasets/lazygit/tasks/task-02.json`

- [ ] **Step 1: 编写 task-02.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 02：创建并切换分支"
  },
  "id": "task-02",
  "title": "创建并切换分支",
  "description": "用户在 main 分支上，希望创建一个名为 feature 的新分支并切换过去。",
  "category": "branch",
  "preconditions": {
    "_doc": "验证前先执行 setup_command 创建有初始提交的 Git 仓库",
    "setup_command": "rm -rf /tmp/lg-test-02 && mkdir -p /tmp/lg-test-02 && cd /tmp/lg-test-02 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo 'init' > .gitkeep && git add . && git commit -m 'init'",
    "description": "存在一个有初始提交的 Git 仓库，在 main 分支上"
  },
  "oracle": {
    "_doc": "检查当前分支是否为 feature，且分支列表包含 feature",
    "type": "command_output",
    "check": "cd /tmp/lg-test-02 && git branch --show-current",
    "expected": "feature",
    "description": "当前分支为 feature",
    "automated_check": "cd /tmp/lg-test-02 && [ \"$(git branch --show-current)\" = 'feature' ] && git branch | grep -q 'feature' && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "description": "如果当前分支不是 feature、或分支列表中没有 feature，则任务失败"
  },
  "hints": {
    "key_operations": ["3 (切换到分支面板)", "n (新建分支)", "q (退出)"],
    "expected_flow": "启动 lazygit → 按 3 进入分支面板 → 按 n 输入 'feature' → Enter 确认 → q 退出"
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add datasets/lazygit/tasks/task-02.json
git commit -m "feat: add lazygit task-02 (create and switch branch)"
```

---

### Task 4: 编写 task-03.json（暂存并恢复工作区）

**Files:**
- Create: `datasets/lazygit/tasks/task-03.json`

- [ ] **Step 1: 编写 task-03.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 03：暂存并恢复工作区"
  },
  "id": "task-03",
  "title": "暂存并恢复工作区",
  "description": "用户有未提交的修改，希望通过 stash 暂存这些修改，然后恢复回来。",
  "category": "stash",
  "preconditions": {
    "_doc": "创建有初始提交和工作区修改的 Git 仓库",
    "setup_command": "rm -rf /tmp/lg-test-03 && mkdir -p /tmp/lg-test-03 && cd /tmp/lg-test-03 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo 'original' > data.txt && git add . && git commit -m 'init' && echo 'modified' >> data.txt",
    "description": "存在一个有初始提交的 Git 仓库，工作区有未提交的修改"
  },
  "oracle": {
    "_doc": "检查 stash 已清空（已弹出），且工作区文件包含修改内容",
    "type": "command_output",
    "check": "cd /tmp/lg-test-03 && git stash list && cat data.txt",
    "expected": "stash list 为空，data.txt 包含 'modified' 行",
    "description": "stash 已弹出，工作区修改已恢复",
    "automated_check": "cd /tmp/lg-test-03 && [ -z \"$(git stash list)\" ] && grep -q 'modified' data.txt && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "description": "如果 stash 未清空、或工作区修改丢失，则任务失败"
  },
  "hints": {
    "key_operations": ["4 (切换到 stash 面板)", "s (stash)", "g (弹出 stash)", "q (退出)"],
    "expected_flow": "启动 lazygit → 按 4 进入 stash 面板 → 按 s 暂存 → 确认 → 按 g 弹出 → 确认 → q 退出"
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add datasets/lazygit/tasks/task-03.json
git commit -m "feat: add lazygit task-03 (stash and restore)"
```

---

### Task 5: 编写 task-04.json（查看文件 diff）

**Files:**
- Create: `datasets/lazygit/tasks/task-04.json`

- [ ] **Step 1: 编写 task-04.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 04：查看文件 diff"
  },
  "id": "task-04",
  "title": "查看文件 diff",
  "description": "用户修改了一个文件，希望在 lazygit 中查看 diff 了解具体变更内容。",
  "category": "diff",
  "preconditions": {
    "_doc": "创建有初始提交和多行修改的 Git 仓库",
    "setup_command": "rm -rf /tmp/lg-test-04 && mkdir -p /tmp/lg-test-04 && cd /tmp/lg-test-04 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && printf 'line1\\nline2\\nline3\\n' > file.txt && git add . && git commit -m 'init' && printf 'line1\\nmodified line2\\nline3\\nnew line4\\n' > file.txt",
    "description": "存在一个有初始提交的 Git 仓库，工作区文件有多行修改"
  },
  "oracle": {
    "_doc": "通过 tmux 截屏检查 diff 内容是否显示在屏幕上",
    "type": "command_output",
    "check": "tmux capture-pane -t lg-test-04 -p 2>/dev/null | grep -c '[+-]'",
    "expected": "截屏中包含 diff 标记（+ 和 - 行），计数大于 0",
    "description": "lazygit 的 diff 面板正确显示了文件变更",
    "automated_check": "DIFF_COUNT=$(tmux capture-pane -t lg-test-04 -p 2>/dev/null | grep -c '[+-]' || echo 0) && [ \"$DIFF_COUNT\" -gt 0 ] && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "description": "如果截屏为空或不包含 diff 标记，则任务失败"
  },
  "hints": {
    "key_operations": ["Enter (查看 diff)", "q (退出)"],
    "expected_flow": "启动 lazygit → 选中修改的文件 → Enter 查看 diff → 确认显示 +/- 行 → q 退出"
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add datasets/lazygit/tasks/task-04.json
git commit -m "feat: add lazygit task-04 (view diff)"
```

---

### Task 6: 编写 task-05.json（解决合并冲突）

**Files:**
- Create: `datasets/lazygit/tasks/task-05.json`

- [ ] **Step 1: 编写 task-05.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 05：解决合并冲突"
  },
  "id": "task-05",
  "title": "解决合并冲突",
  "description": "两个分支修改了同一文件的同一区域导致冲突，用户通过 lazygit 选择解决方案。",
  "category": "conflict",
  "preconditions": {
    "_doc": "创建有两个分支且合并会产生冲突的 Git 仓库",
    "setup_command": "rm -rf /tmp/lg-test-05 && mkdir -p /tmp/lg-test-05 && cd /tmp/lg-test-05 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo 'base content' > conflict.txt && git add . && git commit -m 'base' && git checkout -b feature && echo 'feature version' > conflict.txt && git add . && git commit -m 'feature change' && git checkout main && echo 'main version' > conflict.txt && git add . && git commit -m 'main change' && git merge feature || true",
    "description": "存在一个有合并冲突的 Git 仓库，conflict.txt 文件包含冲突标记"
  },
  "oracle": {
    "_doc": "检查冲突标记已消除，文件内容为预期值",
    "type": "file_content",
    "check": "cat /tmp/lg-test-05/conflict.txt",
    "expected": "文件内容不包含冲突标记（<<<<<<< / ======= / >>>>>>>），且内容为 'main version' 或 'feature version'",
    "description": "冲突已解决，文件内容为有效值",
    "automated_check": "cd /tmp/lg-test-05 && ! grep -q '<<<<<<<' conflict.txt && ! grep -q '>>>>>>>' conflict.txt && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "description": "如果文件仍包含冲突标记，则任务失败"
  },
  "hints": {
    "key_operations": ["↓ (选中冲突文件)", "Space (选择解决方案)", "m (标记为已解决)", "q (退出)"],
    "expected_flow": "启动 lazygit → 选中冲突文件 → 选择解决方案（如保留 theirs）→ 标记为已解决 → q 退出"
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add datasets/lazygit/tasks/task-05.json
git commit -m "feat: add lazygit task-05 (resolve merge conflict)"
```

---

### Task 7: 编写 task-06.json（交互式 rebase）

**Files:**
- Create: `datasets/lazygit/tasks/task-06.json`

- [ ] **Step 1: 编写 task-06.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 06：交互式 rebase"
  },
  "id": "task-06",
  "title": "交互式 rebase",
  "description": "用户有 3 个连续 commit，希望将后两个 squash 成一个。",
  "category": "rebase",
  "preconditions": {
    "_doc": "创建有 3 个连续 commit 的 Git 仓库",
    "setup_command": "rm -rf /tmp/lg-test-06 && mkdir -p /tmp/lg-test-06 && cd /tmp/lg-test-06 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo 'a' > f.txt && git add . && git commit -m 'commit A' && echo 'b' >> f.txt && git add . && git commit -m 'commit B' && echo 'c' >> f.txt && git add . && git commit -m 'commit C'",
    "description": "存在一个有 3 个连续 commit 的 Git 仓库"
  },
  "oracle": {
    "_doc": "检查 commit 数量从 3 减少到 2",
    "type": "command_output",
    "check": "cd /tmp/lg-test-06 && git log --oneline | wc -l",
    "expected": "2",
    "description": "rebase 后 commit 数量为 2（后两个 squash 成一个）",
    "automated_check": "cd /tmp/lg-test-06 && [ \"$(git log --oneline | wc -l)\" -eq 2 ] && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "description": "如果 commit 数量未减少、或 rebase 中途失败，则任务失败"
  },
  "hints": {
    "key_operations": ["↓ (选中目标 commit)", "e (进入 rebase 编辑)", "s (squash)", "q (退出)"],
    "expected_flow": "启动 lazygit → 选中第一个 commit → 按 e 编辑 → 选择 squash → 保留消息 → q 退出"
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add datasets/lazygit/tasks/task-06.json
git commit -m "feat: add lazygit task-06 (interactive rebase)"
```

---

### Task 8: 编写 task-07.json（Cherry-pick 提交）

**Files:**
- Create: `datasets/lazygit/tasks/task-07.json`

- [ ] **Step 1: 编写 task-07.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 07：Cherry-pick 提交"
  },
  "id": "task-07",
  "title": "Cherry-pick 提交",
  "description": "用户在 feature 分支有一个 commit，希望 cherry-pick 到 main 分支。",
  "category": "cherry-pick",
  "preconditions": {
    "_doc": "创建有两个分支的 Git 仓库，feature 有独有的 commit",
    "setup_command": "rm -rf /tmp/lg-test-07 && mkdir -p /tmp/lg-test-07 && cd /tmp/lg-test-07 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo 'base' > f.txt && git add . && git commit -m 'base' && git checkout -b feature && echo 'feature work' >> f.txt && git add . && git commit -m 'feature commit' && git checkout main",
    "description": "存在一个有两个分支的 Git 仓库，feature 分支有独有的 commit"
  },
  "oracle": {
    "_doc": "检查 main 分支的 git log 包含 feature commit 的内容",
    "type": "command_output",
    "check": "cd /tmp/lg-test-07 && git log main --oneline",
    "expected": "main 分支的 log 包含 'feature commit'",
    "description": "cherry-pick 成功，main 分支包含目标 commit",
    "automated_check": "cd /tmp/lg-test-07 && git log main --oneline | grep -q 'feature commit' && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "description": "如果 main 分支不包含目标 commit，则任务失败"
  },
  "hints": {
    "key_operations": ["3 (分支面板)", "↓ (选中 commit)", "C (复制)", "V (粘贴)", "q (退出)"],
    "expected_flow": "启动 lazygit → 切换到 feature 分支 → 选中 commit → C 复制 → 切换到 main → V 粘贴 → q 退出"
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add datasets/lazygit/tasks/task-07.json
git commit -m "feat: add lazygit task-07 (cherry-pick)"
```

---

### Task 9: 编写 task-08.json（丢弃未暂存更改）

**Files:**
- Create: `datasets/lazygit/tasks/task-08.json`

- [ ] **Step 1: 编写 task-08.json**

```json
{
  "_doc": {
    "说明": "lazygit 任务 08：丢弃未暂存更改"
  },
  "id": "task-08",
  "title": "丢弃未暂存更改",
  "description": "用户有未暂存的修改文件，希望丢弃所有更改恢复到上次提交的状态。",
  "category": "discard",
  "preconditions": {
    "_doc": "创建有初始提交和工作区修改的 Git 仓库",
    "setup_command": "rm -rf /tmp/lg-test-08 && mkdir -p /tmp/lg-test-08 && cd /tmp/lg-test-08 && git init && git config user.email 'test@test.com' && git config user.name 'Test' && echo 'original content' > data.txt && git add . && git commit -m 'init' && echo 'dirty changes' >> data.txt",
    "description": "存在一个有初始提交的 Git 仓库，工作区有未暂存的修改"
  },
  "oracle": {
    "_doc": "检查 git status 干净，文件内容恢复到原始状态",
    "type": "command_output",
    "check": "cd /tmp/lg-test-08 && git status --short && cat data.txt",
    "expected": "git status 无输出（工作区干净），data.txt 内容为 'original content'",
    "description": "工作区干净，文件恢复到上次提交的状态",
    "automated_check": "cd /tmp/lg-test-08 && [ -z \"$(git status --short)\" ] && grep -q 'original content' data.txt && ! grep -q 'dirty changes' data.txt && echo PASS || echo FAIL",
    "automated_expected": "PASS"
  },
  "negative_oracle": {
    "description": "如果工作区仍包含未提交的修改，则任务失败"
  },
  "hints": {
    "key_operations": ["↓ (选中文件)", "d (丢弃更改)", "q (退出)"],
    "expected_flow": "启动 lazygit → 选中修改的文件 → 按 d → 确认丢弃 → q 退出"
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add datasets/lazygit/tasks/task-08.json
git commit -m "feat: add lazygit task-08 (discard changes)"
```

---

### Task 10: 更新 selected-benchmarks.md

**Files:**
- Modify: `selected-benchmarks.md`

- [ ] **Step 1: 更新 selected-benchmarks.md**

在文件末尾的"下一批优先候选"部分，将 lazygit 从"优先候选 1"移到"当前已选项目"部分：

```markdown
### 项目：lazygit

- 项目定位：高交互 Git 工作流 benchmark
- 当前结论：已选入
- 主要价值：验证高交互、多面板、复杂 Git 操作场景下的 benchmark 流程
- 已覆盖能力：多面板导航、commit、branch、stash、diff、rebase、cherry-pick、discard
- 明显短板：需要本地 Git 仓库作为 fixture
- 当前状态：已建立 benchmark 资产
- 相关目录：`datasets/lazygit/`
- 备注：作为 nnn 之后的第二个高交互 TUI benchmark
```

- [ ] **Step 2: 提交**

```bash
git add selected-benchmarks.md
git commit -m "docs: mark lazygit as selected benchmark"
```

---

## 验证清单

完成所有任务后，运行以下验证：

- [ ] `datasets/lazygit/info.json` 存在且格式正确
- [ ] `datasets/lazygit/install.md` 存在且步骤完整
- [ ] `datasets/lazygit/tasks/task-01.json` 到 `task-08.json` 全部存在
- [ ] 所有 JSON 文件格式正确（`python3 -m json.tool` 验证）
- [ ] 所有 `setup_command` 可以成功执行
- [ ] 所有 `automated_check` 脚本可以运行

```bash
# 验证 JSON 格式
for f in datasets/lazygit/tasks/task-*.json; do python3 -m json.tool "$f" > /dev/null && echo "✓ $f" || echo "✗ $f"; done

# 验证 info.json
python3 -m json.tool datasets/lazygit/info.json > /dev/null && echo "✓ info.json" || echo "✗ info.json"
```
