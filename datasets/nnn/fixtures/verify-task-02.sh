#!/bin/bash
# 自动化验证 nnn 任务 02：批量选择文件并复制到另一个目录
# 使用 tmux 发送按键给 nnn

set -euo pipefail

echo "=== 开始自动化验证任务 02 ==="

# 重建 fixtures
rm -rf /tmp/nnn-test-02
mkdir -p /tmp/nnn-test-02/{logs,backup}
touch /tmp/nnn-test-02/logs/{app.log,server.log,debug.log,temp.txt,config.ini}
echo "[✓] fixtures 已创建"

# 创建 tmux 会话（不继承 LD_LIBRARY_PATH，避免影响 tmux 自身）
SESSION="nnn-test-02"
tmux kill-session -t "$SESSION" 2>/dev/null || true
env -u LD_LIBRARY_PATH tmux new-session -d -s "$SESSION" -x 80 -y 24

# 在 tmux 中设置 LD_LIBRARY_PATH 并启动 nnn
tmux send-keys -t "$SESSION" "export LD_LIBRARY_PATH=/home/wangyuanhao/miniconda3/lib:/usr/lib/x86_64-linux-gnu && /data1/wangyuanhao/TUI/nnn/nnn /tmp/nnn-test-02" Enter
sleep 2

# 进入 logs/
echo "进入 logs/..."
tmux send-keys -t "$SESSION" "l"
sleep 1

# 开启多选模式
echo "进入多选模式..."
tmux send-keys -t "$SESSION" "m"
sleep 0.5

# 选择 app.log（第 1 个文件）
echo "选择 app.log..."
tmux send-keys -t "$SESSION" Space
sleep 0.5

# 下移跳过 config.ini
tmux send-keys -t "$SESSION" "j"
sleep 0.3

# 下移到 debug.log
tmux send-keys -t "$SESSION" "j"
sleep 0.3
echo "选择 debug.log..."
tmux send-keys -t "$SESSION" Space
sleep 0.5

# 下移到 server.log
tmux send-keys -t "$SESSION" "j"
sleep 0.3
echo "选择 server.log..."
tmux send-keys -t "$SESSION" Space
sleep 0.5

# 复制
echo "复制..."
tmux send-keys -t "$SESSION" "p"
sleep 1

# 返回上级
echo "返回上级..."
tmux send-keys -t "$SESSION" "h"
sleep 1

# 进入 backup/
echo "进入 backup/..."
tmux send-keys -t "$SESSION" "l"
sleep 1

# 粘贴
echo "粘贴..."
tmux send-keys -t "$SESSION" "p"
sleep 1.5

# 退出
echo "退出..."
tmux send-keys -t "$SESSION" "q"
sleep 0.5
tmux send-keys -t "$SESSION" "q"
sleep 1

# 清理
tmux kill-session -t "$SESSION" 2>/dev/null || true

# 验证
echo ""
echo "=== 验证结果 ==="

PASS=0
TOTAL=6

[ -f /tmp/nnn-test-02/backup/app.log ] && PASS=$((PASS+1)) && echo "✓ app.log 存在" || echo "✗ app.log 不存在"
[ -f /tmp/nnn-test-02/backup/server.log ] && PASS=$((PASS+1)) && echo "✓ server.log 存在" || echo "✗ server.log 不存在"
[ -f /tmp/nnn-test-02/backup/debug.log ] && PASS=$((PASS+1)) && echo "✓ debug.log 存在" || echo "✗ debug.log 不存在"
[ ! -f /tmp/nnn-test-02/backup/temp.txt ] && PASS=$((PASS+1)) && echo "✓ temp.txt 不存在" || echo "✗ temp.txt 存在"
[ ! -f /tmp/nnn-test-02/backup/config.ini ] && PASS=$((PASS+1)) && echo "✓ config.ini 不存在" || echo "✗ config.ini 存在"

COUNT=$(ls /tmp/nnn-test-02/backup/ 2>/dev/null | wc -l)
[ "$COUNT" -eq 3 ] && PASS=$((PASS+1)) && echo "✓ 文件数量正确 (3)" || echo "✗ 文件数量错误 ($COUNT)"

echo ""
echo "backup/ 内容:"
ls /tmp/nnn-test-02/backup/ 2>/dev/null || echo "(空)"

if [ "$PASS" -eq "$TOTAL" ]; then
    echo ""
    echo "PASS ($PASS/$TOTAL)"
else
    echo ""
    echo "FAIL ($PASS/$TOTAL)"
fi
