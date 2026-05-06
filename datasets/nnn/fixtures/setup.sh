#!/bin/bash
# nnn 测试 fixtures 初始化脚本
# 作用：每次运行这个脚本，会把 5 个测试任务所需的目录和文件全部重新创建
# 这样每次验证都是从干净状态开始，不会被上次的操作污染

set -euo pipefail

echo "=== nnn 测试 fixtures 初始化 ==="

# 任务 1：导航并查看文件
# 目的：创建一个简单的项目目录，里面有 src/ 子目录
rm -rf /tmp/nnn-test-01
mkdir -p /tmp/nnn-test-01/src
touch /tmp/nnn-test-01/src/main.c /tmp/nnn-test-01/src/utils.c /tmp/nnn-test-01/src/Makefile
touch /tmp/nnn-test-01/README.md
echo "[✓] 任务 01: /tmp/nnn-test-01（含 src/ 子目录和 3 个源码文件）"

# 任务 2：批量选择并复制
# 目的：创建一个含混合文件的目录和一个空的目标目录
rm -rf /tmp/nnn-test-02
mkdir -p /tmp/nnn-test-02/{logs,backup}
touch /tmp/nnn-test-02/logs/{app.log,server.log,debug.log,temp.txt,config.ini}
echo "[✓] 任务 02: /tmp/nnn-test-02（logs/ 含 5 个文件，backup/ 为空）"

# 任务 3：创建目录和文件
# 目的：创建一个空的工作区，让你在里面新建目录和文件
rm -rf /tmp/nnn-test-03
mkdir -p /tmp/nnn-test-03/workspace
echo "[✓] 任务 03: /tmp/nnn-test-03/workspace（空目录）"

# 任务 4：过滤查找
# 目的：创建一个含多种文件类型的目录，用来测试过滤功能
rm -rf /tmp/nnn-test-04
mkdir -p /tmp/nnn-test-04/data
touch /tmp/nnn-test-04/data/{report_2024.csv,report_2025.csv,budget.xlsx,notes.txt,photo.jpg,summary.csv,readme.md}
echo "[✓] 任务 04: /tmp/nnn-test-04/data（含 7 个不同类型的文件）"

# 任务 5：多标签页操作
# 目的：创建两个独立目录，用来测试在目录间复制文件
rm -rf /tmp/nnn-test-05
mkdir -p /tmp/nnn-test-05/{dir_a,dir_b}
echo 'important data' > /tmp/nnn-test-05/dir_a/data.txt
echo 'existing file' > /tmp/nnn-test-05/dir_b/info.txt
echo "[✓] 任务 05: /tmp/nnn-test-05（dir_a 有 data.txt，dir_b 有 info.txt）"

echo ""
echo "=== 全部 fixtures 创建完成 ==="
echo "文件列表："
find /tmp/nnn-test-0* -type f | sort
