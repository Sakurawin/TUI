# 已选入 Benchmark 的项目

## 作用

这个文件只记录已经决定纳入 benchmark 池的项目。

它和 `benchmarks/tui-candidates.md` 的区别是：

- `tui-candidates.md` 是候选池，总体偏广
- `selected-benchmarks.md` 是最终入选表，只保留已经做出选择的项目

## 当前入选标准

一个项目要进入这里，至少应满足下面几个条件：

1. 能支撑明确的 benchmark 任务设计。
2. 能定义相对稳定的 oracle。
3. 能在可接受的环境成本下重复运行。
4. 对研究目标有补充价值，而不是和已有项目完全重复。

## 当前已选项目

### 项目：wego

- 项目定位：pilot project + benchmark candidate
- 当前结论：保留
- 主要价值：验证低交互、强配置、强输出任务下的 benchmark 流程是否能跑通
- 已覆盖能力：配置初始化、frontend 切换、缓存行为、离线 JSON backend、agent task execution 基础可靠性
- 明显短板：不能代表复杂全屏、高交互、多面板 TUI
- 当前状态：已建立 benchmark 资产
- 相关目录：`benchmarks/wego/`
- 备注：适合作为第一步，但必须补一个更高交互的 TUI 对照项目

## 下一批优先候选

这些项目目前还没有正式入选，但优先级最高，适合下一步继续筛选：

### 优先候选 1：lazygit

- 推荐原因：本地可运行、环境轻、交互强、任务可设计性高
- 适合作为：高交互 Git 工作流 benchmark
- 当前判断：最适合作为 `wego` 之后的下一项目

### 优先候选 2：nnn

- 推荐原因：文件系统任务容易隔离，oracle 相对容易做
- 适合作为：高交互文件导航与文件操作 benchmark
- 当前判断：如果你想优先要“低环境成本 + 高交互”，它是很强的备选

### 优先候选 3：k9s

- 推荐原因：真实复杂度高，交互价值很强
- 适合作为：复杂运维型 TUI benchmark
- 当前判断：更适合第二阶段，因为环境准备成本高

## 后续维护方式

1. 先在 `benchmarks/tui-candidates.md` 中完成候选调研。
2. 一旦决定纳入 benchmark 池，就把项目补进本文件。
3. 同时为该项目建立自己的目录：`benchmarks/<project-name>/`。
4. 在该目录下继续维护任务卡、fixture、manual validation、expert trace 和 agent trial 结果。
