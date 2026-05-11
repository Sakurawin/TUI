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
