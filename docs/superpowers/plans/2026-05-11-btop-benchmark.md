# btop 基准数据集实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**目标：** 构建 `datasets/btop/` 基准数据集，用受控的系统负载和固定命名进程来评估 `btop` 的监控工作流能力。

**架构：** 使用一个很小的 fixture 层制造可预测的 CPU、内存和进程目标，然后定义一组短任务来验证进程发现、面板导航、过滤以及帮助/退出行为。数据集结构保持与仓库中现有的 `datasets/<project>/info.json`、`install.md` 和 `tasks/*.json` 规范一致。

**技术栈：** JSON 任务定义、Bash fixture 脚本、用于受控负载的 Docker、用于固定屏幕尺寸的 tmux、Git 集成。

---

## 文件结构

```text
datasets/btop/
├── info.json
├── install.md
├── fixtures/
│   ├── README.md
│   ├── setup.sh
│   ├── cleanup.sh
│   └── compose.yaml
└── tasks/
    ├── task-01.json
    ├── task-02.json
    ├── task-03.json
    ├── task-04.json
    └── task-05.json
```

fixture 层必须保持很小，只创建 `btop` 能观察到的、可重复的 CPU、内存和命名进程目标。它不能修改系统配置，也不能依赖宿主机当前负载。

---

### 任务 1：创建数据集骨架和项目元信息

**文件：**
- 新建：`datasets/btop/info.json`
- 新建：`datasets/btop/install.md`
- 新建：`datasets/btop/fixtures/README.md`
- 新建：`datasets/btop/fixtures/setup.sh`
- 新建：`datasets/btop/fixtures/cleanup.sh`
- 新建：`datasets/btop/fixtures/compose.yaml`

- [ ] **步骤 1：先检查现有数据集格式**

在写新文件前，先参考 `datasets/wego/`、`datasets/nnn/` 和 `datasets/lazygit/` 的文件风格。`btop` 的资产也要保持相同的写法：`info.json` 要简洁，`install.md` 要从零开始，`fixtures/` 要能稳定复现。

- [ ] **步骤 2：编写 `info.json`**

```json
{
  "name": "btop",
  "url": "https://github.com/aristocratos/btop",
  "language": "C++",
  "license": "Apache-2.0",
  "description": "终端系统监控工具，提供 CPU、内存、磁盘、网络和进程面板，适合观察系统状态和定位负载问题",
  "category": "system-monitor",
  "interaction_level": "medium",
  "terminal_ui_library": "ftxui",
  "version": "latest",
  "platforms": ["linux", "macos", "bsd", "windows"],
  "dependencies": {
    "required": ["docker", "tmux"],
    "optional": ["git", "curl"]
  },
  "key_features": [
    "多面板系统监控界面",
    "进程浏览与过滤",
    "CPU、内存、磁盘、网络状态查看",
    "帮助页与快捷键驱动交互",
    "适合观察受控负载与命名进程"
  ]
}
```

- [ ] **步骤 3：编写 `install.md`**

```markdown
# btop 安装指南

本文档指导你从零开始在一台全新 Linux 机器上安装并运行 btop。

## 第 1 步：安装运行依赖

```bash
# Ubuntu / Debian
sudo apt-get update
sudo apt-get install -y tmux docker.io git curl

# 验证
tmux -V
docker --version
```

如果 Docker 没有自动启动，手动启动服务：

```bash
sudo systemctl enable --now docker
docker ps
```

## 第 2 步：获取 btop

```bash
git clone https://github.com/aristocratos/btop.git
cd btop
```

## 第 3 步：安装 btop

优先使用仓库提供的构建方式或发行版包。

```bash
# 如果仓库提供构建脚本，按官方文档构建
# 如果系统包可用，也可以直接安装发行版包
```

## 第 4 步：验证安装

```bash
btop --version
```

## 第 5 步：最小运行验证

```bash
btop
```

按 `q` 退出，确认终端恢复正常。
```

- [ ] **步骤 4：编写 `fixtures/README.md`**

```markdown
# btop Fixtures

本目录包含 `btop` 基准所需的确定性工作负载 fixture。

目标是制造稳定的进程名称、CPU 负载和内存压力，让 benchmark 任务不依赖宿主机的随机状态。

fixture 流程如下：

1. `setup.sh` 启动工作负载容器和辅助进程。
2. `tasks/*.json` 默认这些工作负载已经在运行。
3. `cleanup.sh` 停止并移除所有 fixture 资源。

运行任务期间不要手动修改宿主机。
```

- [ ] **步骤 5：编写 `fixtures/setup.sh` 和 `fixtures/cleanup.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail

docker compose -f "$(dirname "$0")/compose.yaml" up -d --build
```

```bash
#!/usr/bin/env bash
set -euo pipefail

docker compose -f "$(dirname "$0")/compose.yaml" down -v
```

- [ ] **步骤 6：编写 `fixtures/compose.yaml`**

```yaml
services:
  cpu-burn:
    image: alpine:3.20
    command: ["sh", "-c", "while true; do sha256sum /dev/zero >/dev/null; done"]
    restart: unless-stopped

  memory-burn:
    image: alpine:3.20
    command: ["sh", "-c", "python3 - <<'PY'\nchunks=[]\nwhile True:\n    chunks.append(bytearray(1024 * 1024))\nPY"]
    restart: unless-stopped

  named-worker:
    image: alpine:3.20
    container_name: btop-named-worker
    command: ["sh", "-c", "while true; do echo 'btop worker alive'; sleep 2; done"]
    restart: unless-stopped
```

`cpu-burn`、`memory-burn` 和 `named-worker` 提供稳定的观察目标。实现时如果发现镜像或 busy-loop 方式需要调整，可以微调实现，但必须保留相同的可观察名称和行为。

- [ ] **步骤 7：做一次结构检查**

确认数据集路径已经创建，且新文件位于预期位置。这里先检查结构正确性，不追求完整 benchmark 成功。

---

### 任务 2：定义进程发现和面板导航任务

**文件：**
- 新建：`datasets/btop/tasks/task-01.json`
- 新建：`datasets/btop/tasks/task-02.json`
- 新建：`datasets/btop/tasks/task-03.json`

- [ ] **步骤 1：编写任务 01，用于定位命名工作进程**

```json
{
  "id": "task-01",
  "title": "定位命名工作进程",
  "description": "用户想在 btop 中找到名为 btop-named-worker 的进程，并确认它正在运行。",
  "category": "process-discovery",
  "preconditions": {
    "setup_command": "bash datasets/btop/fixtures/setup.sh",
    "description": "Docker fixtures are running, including the named worker container"
  },
  "oracle": {
    "type": "command_output",
    "check": "docker ps --format '{{.Names}}' | grep -qx 'btop-named-worker'",
    "expected": "btop-named-worker is listed as running"
  },
  "negative_oracle": {
    "description": "如果命名工作进程没有运行，或者 benchmark 使用了不同的名称，就判定失败。"
  },
  "hints": {
    "key_operations": ["process panel", "search", "filter"],
    "expected_flow": "打开 btop，切换到进程视图，搜索 btop-named-worker，并确认它可见"
  }
}
```

- [ ] **步骤 2：编写任务 02，用于识别 CPU 负载**

```json
{
  "id": "task-02",
  "title": "识别 CPU 压力来源",
  "description": "用户想确认当前系统中哪个受控工作负载正在制造 CPU 压力，并在 btop 中定位它。",
  "category": "resource-observation",
  "preconditions": {
    "setup_command": "bash datasets/btop/fixtures/setup.sh",
    "description": "CPU burn container is running"
  },
  "oracle": {
    "type": "command_output",
    "check": "docker compose -f datasets/btop/fixtures/compose.yaml ps --format json | jq -r '.Name' | grep -qx 'cpu-burn'",
    "expected": "cpu-burn workload is active"
  },
  "negative_oracle": {
    "description": "如果 CPU 负载服务没有运行，就不能验证该任务。"
  },
  "hints": {
    "key_operations": ["CPU panel", "process list", "sort by usage"],
    "expected_flow": "打开 btop，查看 CPU 使用情况，并确认哪个进程或容器在制造负载"
  }
}
```

- [ ] **步骤 3：编写任务 03，用于检查内存压力**

```json
{
  "id": "task-03",
  "title": "查看内存压力面板",
  "description": "用户想在 btop 中确认是否存在固定的内存压力工作负载，并查看其影响。",
  "category": "resource-observation",
  "preconditions": {
    "setup_command": "bash datasets/btop/fixtures/setup.sh",
    "description": "Memory burn container is running"
  },
  "oracle": {
    "type": "command_output",
    "check": "docker compose -f datasets/btop/fixtures/compose.yaml ps --format json | jq -r '.Name' | grep -qx 'memory-burn'",
    "expected": "memory-burn workload is active"
  },
  "negative_oracle": {
    "description": "如果内存工作负载不存在，就判定失败。"
  },
  "hints": {
    "key_operations": ["memory panel", "process panel", "toggle details"],
    "expected_flow": "打开 btop，查看内存使用情况，并确认受控工作负载在进程列表或资源视图中可见"
  }
}
```

- [ ] **步骤 4：检查 JSON 结构**

确认 JSON 文件语法正确，而且所需键都已经写全。任务定义要保持短小和确定性。

---

### 任务 3：补充过滤、帮助和退出恢复任务

**文件：**
- 新建：`datasets/btop/tasks/task-04.json`
- 新建：`datasets/btop/tasks/task-05.json`

- [ ] **步骤 1：编写任务 04，用于过滤进程列表**

```json
{
  "id": "task-04",
  "title": "过滤进程列表",
  "description": "用户想在 btop 的进程列表里只保留目标工作负载相关的条目，以减少噪声。",
  "category": "filtering",
  "preconditions": {
    "setup_command": "bash datasets/btop/fixtures/setup.sh",
    "description": "All fixture containers are running"
  },
  "oracle": {
    "type": "command_output",
    "check": "docker ps --format '{{.Names}}' | sort | tr '\n' ' '",
    "expected": "The fixture names cpu-burn, memory-burn, and btop-named-worker are available for filtering"
  },
  "negative_oracle": {
    "description": "如果 benchmark 环境缺少任意一个 fixture 名称，这个任务就无效。"
  },
  "hints": {
    "key_operations": ["search", "filter", "process panel"],
    "expected_flow": "使用 btop 缩小进程视图范围，直到目标 fixture 进程容易检查为止"
  }
}
```

- [ ] **步骤 2：编写任务 05，用于查看帮助并正常退出**

```json
{
  "id": "task-05",
  "title": "查看帮助并正常退出",
  "description": "用户想查看 btop 的帮助信息，然后退出并恢复终端状态。",
  "category": "help-and-exit",
  "preconditions": {
    "setup_command": "bash datasets/btop/fixtures/setup.sh",
    "description": "btop starts successfully in a tmux pane"
  },
  "oracle": {
    "type": "exit_code",
    "check": "tmux capture-pane -pt btop-benchmark:0.0 | tail -n +1",
    "expected": "退出 btop 后终端返回 shell 提示符"
  },
  "negative_oracle": {
    "description": "如果 raw mode 没有恢复，或者 shell 提示符没有回来，就判定失败。"
  },
  "hints": {
    "key_operations": ["help", "quit"],
    "expected_flow": "先查看帮助，然后干净退出 btop，让终端恢复可用"
  }
}
```

- [ ] **步骤 3：判断是否需要第六个任务**

如果任务 05 之后覆盖已经足够，就停在 5 个任务。如果还需要补一个任务，只能继续添加一个和进程、磁盘或网络相关的任务，而且不能让 benchmark 变得更依赖宿主机状态。

---

### 任务 4：加入验证资产并跑完整体 sanity check

**文件：**
- 新建：`datasets/btop/tasks/README.md`（如果需要补充任务说明）
- 修改：`datasets/btop/install.md`（如果真实测试后安装路径需要更清楚）
- 修改：`datasets/btop/fixtures/setup.sh` 和 `cleanup.sh`（如果初始负载太重或不稳定）

- [ ] **步骤 1：启动 fixture 并确认名字稳定**

运行 fixture setup，然后确认容器名称与任务假设一致：

```bash
bash datasets/btop/fixtures/setup.sh
docker ps --format '{{.Names}}'
```

预期结果：`cpu-burn`、`memory-burn` 和 `btop-named-worker` 都存在。

- [ ] **步骤 2：在固定 tmux 面板中运行 `btop`**

在专门的 tmux 会话里启动 `btop`，并固定 pane 尺寸。确认进程面板和资源面板都能正常渲染。

- [ ] **步骤 3：按 oracle 验证每个任务**

对每个任务文件，都要确认它的 oracle 可以不用人工理解屏幕内容就能检查。如果某个任务仍然只能靠肉眼判断，就要先重写任务。

- [ ] **步骤 4：清理 fixture**

```bash
bash datasets/btop/fixtures/cleanup.sh
docker ps --format '{{.Names}}'
```

预期结果：fixture 容器被移除，环境恢复干净，便于下一个任务继续。

- [ ] **步骤 5：记录必要的计划修正**

如果真实 `btop` 的行为与预期不一致，不要保留隐含偏差；应直接更新数据集文件。

---

## 检查清单

- 数据集只覆盖一个 `btop` 监控工作流族。
- fixture 层是确定性的，并且每次运行后都会清理。
- 每个任务都包含自然语言目标、前置条件、oracle 和负向判定。
- 数据集尽量避免依赖宿主机随机状态。
- 所有文件都符合仓库里已有数据集的风格。

## 实施过程中的待确认问题

1. `btop` 的实际安装路径是否支持在 `install.md` 中写出一个干净的版本检查命令？
2. 当前 Docker 负载容器是否需要比这份草案更轻，避免在慢机器上误判失败？
3. 5 个任务是否已经足够，还是需要第 6 个任务来补充磁盘或网络面板？
