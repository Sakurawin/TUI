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
