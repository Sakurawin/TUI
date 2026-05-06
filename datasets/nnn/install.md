# nnn 安装指南

本文档指导你从零开始在一台全新 Linux 机器上编译、安装并运行 nnn 终端文件管理器。

## 第 1 步：安装系统依赖

```bash
# Ubuntu / Debian
sudo apt-get update
sudo apt-get install -y build-essential libncursesw5-dev pkg-config git

# 验证
gcc --version && echo "✓ gcc 已安装"
pkg-config --libs ncursesw && echo "✓ ncursesw 已安装"
```

如果系统没有 `sudo` 权限，可以用 conda 安装 ncurses：

```bash
conda install -y ncurses
```

## 第 2 步：获取源码

```bash
git clone https://github.com/jarun/nnn.git
cd nnn
```

## 第 3 步：编译

标准编译：

```bash
make
```

如果没有 sudo 权限（ncurses 安装在 conda 中），需要指定路径：

```bash
make CFLAGS_CURSES="-I$CONDA_PREFIX/include" \
     LDLIBS_CURSES="-L$CONDA_PREFIX/lib -lncursesw -ltinfow"
```

编译选项说明（通过 `make O_XXX=1` 启用）：

| 选项 | 说明 |
|------|------|
| `O_NORL=1` | 禁用 readline（默认已禁用） |
| `O_PCRE2=1` | 启用 PCRE2 正则过滤 |
| `O_NOMOUSE=1` | 禁用鼠标支持 |
| `O_NERD=1` | 启用 Nerd Font 图标 |
| `O_EMOJI=1` | 启用 Emoji 图标 |

## 第 4 步：安装（可选）

```bash
sudo make install
```

或直接使用编译产物：

```bash
cp nnn /usr/local/bin/nnn
```

## 第 5 步：验证安装

```bash
# 检查二进制文件
which nnn || ls -la ./nnn

# 查看帮助
nnn -h

# 快速启动测试（进入当前目录后按 q 退出）
nnn
```

## 第 6 步：基本使用

```bash
# 启动 nnn，指定初始目录
nnn /path/to/start

# 使用 8-color 模式（兼容性更好）
nnn -C

# 使用详情模式启动
nnn -d
```

### 核心键位速查

| 按键 | 功能 |
|------|------|
| `h` / `←` | 返回上级目录 |
| `l` / `→` / `Enter` | 进入目录 / 打开文件 |
| `j` / `↓` | 光标下移 |
| `k` / `↑` | 光标上移 |
| `/` | 即时过滤 |
| `Space` | 选择文件 |
| `m` | 多选模式 |
| `p` | 复制/粘贴 |
| `n` | 新建文件/目录 |
| `d` | 详情模式 |
| `?` | 帮助 |
| `q` | 退出 |

## 常见问题

### 编译报错 `curses.h: No such file or directory`

缺少 ncurses 开发头文件，执行 `sudo apt-get install libncursesw5-dev` 或用 conda 安装。

### 运行时报错 `libtinfow.so.6: cannot open shared object`

运行时找不到 ncurses 动态库，设置 `export LD_LIBRARY_PATH=/path/to/ncurses/lib:$LD_LIBRARY_PATH`。

### 终端显示乱码

确认 `TERM` 环境变量正确：

```bash
export TERM=xterm-256color
```
