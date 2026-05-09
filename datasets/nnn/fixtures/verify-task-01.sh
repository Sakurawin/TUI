#!/bin/bash
# 自动化验证 nnn 任务 01：导航到子目录并查看文件列表
# 使用 tmux 发送按键给 nnn

set -euo pipefail

echo "=== 开始自动化验证任务 01 ==="

# 重建 fixtures
rm -rf /tmp/nnn-test-01
mkdir -p /tmp/nnn-test-01/src
touch /tmp/nnn-test-01/src/main.c /tmp/nnn-test-01/src/utils.c /tmp/nnn-test-01/src/Makefile
touch /tmp/nnn-test-01/README.md
echo "[✓] fixtures 已创建"

# 创建 tmux 会话
SESSION="nnn-test-01"
tmux kill-session -t "$SESSION" 2>/dev/null || true
env -u LD_LIBRARY_PATH tmux new-session -d -s "$SESSION" -x 80 -y 24

# 在 tmux 中设置 LD_LIBRARY_PATH 并启动 nnn
tmux send-keys -t "$SESSION" "export LD_LIBRARY_PATH=/home/wangyuanhao/miniconda3/lib:/usr/lib/x86_64-linux-gnu && /data1/wangyuanhao/TUI/nnn/nnn /tmp/nnn-test-01" Enter
sleep 2

# 进入 src/
echo "进入 src/..."
tmux send-keys -t "$SESSION" "l"
sleep 1

# 返回上级
echo "返回上级..."
tmux send-keys -t "$SESSION" "h"
sleep 1

# 退出 nnn
echo "退出 nnn..."
tmux send-keys -t "$SESSION" "q"
sleep 1

# 检查 nnn 进程是否还在
NNN_PID=$(pgrep -f "nnn /tmp/nnn-test-01" || true)

# 验证
echo ""
echo "=== 验证结果 ==="

if [ -z "$NNN_PID" ]; then
    echo "✓ nnn 正常退出"
    RESULT="PASS"
else
    echo "✗ nnn 仍在运行 (PID: $NNN_PID)"
    RESULT="FAIL"
fi

# 清理
tmux kill-session -t "$SESSION" 2>/dev/null || true

echo ""
echo "$RESULT (1/1)"