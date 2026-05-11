# btop Fixtures

本目录包含 `btop` 基准所需的确定性工作负载 fixture。

目标是制造稳定的进程名称、CPU 负载和内存压力，让 benchmark 任务不依赖宿主机的随机状态。

fixture 流程如下：

1. `setup.sh` 启动工作负载容器和辅助进程。
2. `tasks/*.json` 默认这些工作负载已经在运行。
3. `cleanup.sh` 停止并移除所有 fixture 资源。

运行任务期间不要手动修改宿主机。
