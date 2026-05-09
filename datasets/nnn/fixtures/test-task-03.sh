#!/bin/bash
# 测试任务三：创建目录和文件

set -euo pipefail

# 重建环境
rm -rf /tmp/nnn-test-03
mkdir -p /tmp/nnn-test-03/workspace

echo "=== 测试 nnn 创建目录和文件 ==="
echo "当前目录内容："
ls -la /tmp/nnn-test-03/workspace/

# 创建 tmux 会话
SESSION="nnn-test-03"
tmux kill-session -t "$SESSION" 2>/dev/null || true

# 设置环境变量
export LD_LIBRARY_PATH=/home/wangyuanhao/miniconda3/lib:/usr/lib/x86_64-linux-gnu

# 创建 tmux 会话
env -u LD_LIBRARY_PATH tmux new-session -d -s "$SESSION" -x 80 -y 24

# 在 tmux 中设置环境变量并启动 nnn
tmux send-keys -t "$SESSION" "export LD_LIBRARY_PATH=/home/wangyuanhao/miniconda3/lib:/usr/lib/x86_64-linux-gnu && /data1/wangyuanhao/TUI/nnn/nnn /tmp/nnn-test-03/workspace" Enter
sleep 2

echo ""
echo "=== 步骤 1: 创建 docs/ 目录 ==="
echo "按 n 键..."
tmux send-keys -t "$SESSION" "n"
sleep 1

echo "输入 docs/ ..."
tmux send-keys -t "$SESSION" "docs/"
sleep 1

echo "按 Enter 确认..."
tmux send-keys -t "$SESSION" Enter
sleep 2

echo ""
echo "=== 检查目录是否创建 ==="
ls -la /tmp/nnn-test-03/workspace/

echo ""
echo "=== 步骤 2: 进入 docs/ 目录 ==="
echo "按 l 进入目录..."
tmux send-keys -t "$SESSION" "l"
sleep 1

echo ""
echo "=== 步骤 3: 创建 README.md 文件 ==="
echo "按 n 键..."
tmux send-keys -t "$SESSION" "n"
sleep 1

echo "输入 README.md ..."
tmux send-keys -t "$SESSION" "README.md"
sleep 1

echo "按 Enter 确认..."
tmux send-keys -t "$SESSION" Enter
sleep 2

echo ""
echo "=== 检查文件是否创建 ==="
ls -la /tmp/nnn-test-03/workspace/docs/

echo ""
echo "=== 步骤 4: 编辑文件 ==="
echo "按 e 编辑文件..."
tmux send-keys -t "$SESSION" "e"
sleep 2

echo "输入内容..."
tmux send-keys -t "$SESSION" "i# My Project"
sleep 1

echo "按 Esc 退出插入模式..."
tmux send-keys -t "$SESSION" Escape
sleep 1

echo "输入 :wq 保存退出..."
tmux send-keys -t "$SESSION" ":wq"
sleep 1
tmux send-keys -t "$SESSION" Enter
sleep 2

echo ""
echo "=== 步骤 5: 退出 nnn ==="
echo "按 h 返回上级..."
tmux send-keys -t "$SESSION" "h"
sleep 1

echo "按 h 再返回上级..."
tmux send-keys -t "$SESSION" "h"
sleep 1

echo "按 q 退出..."
tmux send-keys -t "$SESSION" "q"
sleep 1

echo ""
echo "=== 最终验证 ==="
echo "目录结构："
find /tmp/nnn-test-03 -type f -o -type d | sort

echo ""
echo "README.md 内容："
cat /tmp/nnn-test-03/workspace/docs/README.md 2>/dev/null || echo "文件不存在"

# 清理
tmux kill-session -t "$SESSION" 2>/dev/null || true
