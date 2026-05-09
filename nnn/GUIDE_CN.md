# nnn 中文操作指南

> nnn (n³) 是一个功能齐全的终端文件管理器，体积小巧、配置简单、速度极快。

## 目录

- [简介](#简介)
- [安装](#安装)
- [基本启动](#基本启动)
- [核心快捷键](#核心快捷键)
- [导航操作](#导航操作)
- [文件操作](#文件操作)
- [选择功能](#选择功能)
- [过滤与搜索](#过滤与搜索)
- [排序功能](#排序功能)
- [上下文（标签页）](#上下文标签页)
- [书签功能](#书签功能)
- [会话管理](#会话管理)
- [插件系统](#插件系统)
- [环境变量配置](#环境变量配置)
- [常用场景示例](#常用场景示例)
- [高级技巧](#高级技巧)

---

## 简介

nnn 是一个性能优化、功能丰富的终端文件管理器，具有以下特点：

- **极简**：二进制文件通常只有约 100KB
- **快速**：内存占用通常低于 3.5MB
- **隐私**：不收集用户数据
- **跨平台**：支持 Linux、macOS、BSD、Haiku、Cygwin、WSL
- **可扩展**：支持插件和补丁

---

## 安装

### 从包管理器安装

```bash
# Debian/Ubuntu
sudo apt install nnn

# Arch Linux
sudo pacman -S nnn

# macOS (Homebrew)
brew install nnn

# Fedora
sudo dnf install nnn
```

### 从源码编译

```bash
git clone https://github.com/jarun/nnn.git
cd nnn
make
sudo make install
```

编译时可选依赖：
- `readline`：用于命令行编辑
- `ncurses`：终端处理（通常已安装）
- `libgsf`：支持压缩包内预览

---

## 基本启动

```bash
# 打开当前目录
nnn

# 打开指定目录
nnn /path/to/directory

# 打开指定文件（自动定位到父目录）
nnn /path/to/file.txt

# 以详细模式启动
nnn -d

# 显示隐藏文件
nnn -H

# 用编辑器打开文本文件
nnn -e
```

### 常用启动选项

| 选项 | 说明 |
|------|------|
| `-a` | 自动设置临时 NNN_FIFO |
| `-A` | 禁用唯一匹配时自动进入目录 |
| `-c` | 指定 opener 为 CLI 专用 |
| `-C` | 8 色方案 |
| `-d` | 详细模式（显示文件大小、权限等） |
| `-D` | 目录使用上下文颜色 |
| `-e` | 用 $VISUAL/$EDITOR 打开文本文件 |
| `-E` | 内部编辑使用 $EDITOR |
| `-f` | 使用历史文件 |
| `-g` | 使用正则表达式过滤 |
| `-H` | 显示隐藏文件 |
| `-i` | 在信息栏显示当前文件信息 |
| `-J` | 禁用选择后自动前进 |
| `-n` | 启动时进入 type-to-nav 模式 |
| `-o` | 仅在按 Enter 时打开文件 |
| `-Q` | 多上下文时禁用退出确认 |
| `-r` | 显示 cp/mv 进度 |
| `-R` | 禁用边缘滚动 |
| `-S` | 持久会话 |
| `-t secs` | 空闲超时锁定终端 |
| `-u` | 优先使用选择而非悬浮项 |
| `-U` | 在状态栏显示用户和组名 |
| `-x` | 选择时显示通知、复制路径到剪贴板 |
| `-z` | 使用模糊过滤 |

---

## 核心快捷键

按 `?` 可查看完整快捷键列表。以下是最常用的快捷键：

### 基本导航

| 快捷键 | 功能 |
|--------|------|
| `↑/k` | 上移 |
| `↓/j` | 下移 |
| `←/h` | 返回上级目录 |
| `→/l` | 进入目录/打开文件 |
| `Enter` | 打开文件或进入目录 |
| `q` | 退出当前上下文 |
| `Ctrl+Q` | 完全退出 |

### 快速跳转

| 快捷键 | 功能 |
|--------|------|
| `g/Home` | 跳转到第一个条目 |
| `G/End` | 跳转到最后一个条目 |
| `J` | 跳转到指定编号/偏移 |
| `~` | 跳转到 HOME 目录 |
| `@` | 跳转到启动目录 |
| `-` | 跳转到上次访问的目录 |
| `` ` `` | 跳转到根目录 / |
| `'` | 跳转到第一个非目录文件 |

### 帮助与信息

| 快捷键 | 功能 |
|--------|------|
| `?` | 显示帮助和配置屏幕 |
| `f/Ctrl+F` | 显示文件详细信息 |

---

## 导航操作

### 目录浏览

- **进入目录**：将光标移到目录上，按 `l` 或 `→` 或 `Enter`
- **返回上级**：按 `h` 或 `←` 或 `Backspace`
- **滚动浏览**：使用 `j/k` 或 `↑/↓`，或 `Page Up/Page Down`

### type-to-nav 模式

此模式下，输入字符会自动过滤并进入匹配的目录：

```bash
# 启动时启用
nnn -n

# 运行时切换：在空过滤提示符下按 Ctrl+N
```

### 快速查看

| 快捷键 | 功能 |
|--------|------|
| `d` | 切换详细模式 |
| `.` | 切换显示隐藏文件 |
| `Ctrl+L` | 重绘屏幕 |

---

## 文件操作

### 创建

| 快捷键 | 功能 |
|--------|------|
| `n` | 新建文件或目录 |

**注意**：
- 新建文件：直接输入文件名，如 `myfile.txt`
- 新建目录：以 `/` 结尾，如 `mydir/`
- 支持创建多级目录：`path/to/dir/`

### 重命名

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+R` | 重命名当前文件 |
| `r` | 批量重命名（编辑器模式） |

### 编辑

| 快捷键 | 功能 |
|--------|------|
| `e` | 用编辑器打开文件 |

### 复制/移动/删除

| 快捷键 | 功能 |
|--------|------|
| `p/Ctrl+P` | 从选择缓冲区复制 |
| `v/Ctrl+V` | 从选择缓冲区移动 |
| `w/Ctrl+W` | 复制/移动并重命名 |
| `x/Ctrl+X` | 删除（移到回收站） |
| `X` | 强制删除 (rm -rf) |

### 权限操作

| 快捷键 | 功能 |
|--------|------|
| `*` | 切换可执行权限 |

### 压缩包操作

| 快捷键 | 功能 |
|--------|------|
| `z` | 创建压缩包 |

---

## 选择功能

nnn 支持跨目录、跨上下文选择文件！

### 选择方式

| 快捷键 | 功能 |
|--------|------|
| `Space/+` | 切换选择当前文件 |
| `m` | 切换多选模式 |
| `a` | 选择当前目录所有文件 |
| `A` | 反选当前目录 |
| `E` | 编辑选择列表 |

### 选择操作

1. **单个选择**：光标移到文件上，按 `Space`
2. **范围选择**：按 `m` 进入多选模式，移动光标选择范围
3. **全选**：按 `a` 选择当前目录所有文件

### 选择状态

- 选中的文件前会显示 `+` 标记
- 选择存储在 `~/.config/nnn/.selection` 文件中
- 选择在多个 nnn 实例间共享

### 使用选择

选择文件后，可以：
- `p`：复制到当前位置
- `v`：移动到当前位置
- `x`：删除选中的文件
- `z`：打包成压缩包
- `w`：复制/移动并重命名

---

## 过滤与搜索

### 基本过滤

按 `/` 进入过滤模式，输入字符会实时过滤文件列表：

```
/输入过滤文本
```

### 过滤模式切换

在空过滤提示符下：
- `/`：切换字符串/模糊/正则模式
- `:`：切换大小写敏感

### 过滤模式

1. **字符串模式**（默认）：匹配包含输入文本的文件
2. **模糊模式**（`-z` 启动）：所有字符按顺序出现即可匹配
3. **正则模式**（`-g` 启动）：使用正则表达式匹配

### 过滤快捷键

| 快捷键 | 功能 |
|--------|------|
| `/` | 进入过滤模式 |
| `Esc` | 退出过滤（保留视图） |
| `Ctrl+N` | 切换 type-to-nav 模式 |
| `Ctrl+L` | 清除过滤/应用上次过滤 |

### 正则表达式示例

```bash
# 匹配以特定文本开头的文件
^filename

# 匹配所有 .mkv 文件
\.mkv

# 匹配任意字符（类似模糊搜索）
.*

# 排除包含 nnn 的文件名（需要 PCRE2）
^(?!nnn)
```

### 自动进入目录

当过滤结果唯一且是目录时，nnn 会自动进入该目录。使用 `-A` 选项可禁用此功能。

---

## 排序功能

### 排序切换

| 快捷键 | 功能 |
|--------|------|
| `t` | 排序切换菜单 |
| `Ctrl+T` | 在文件名/大小/时间排序间循环 |

### 排序选项

| 按键 | 排序方式 |
|------|----------|
| `a` | 磁盘使用量（apparent） |
| `d` | 磁盘使用量（实际） |
| `e` | 文件扩展名 |
| `r` | 反转当前排序 |
| `s` | 文件大小 |
| `t` | 时间（默认修改时间） |
| `v` | 版本号排序（数字自然排序） |
| `c` | 清除排序（恢复文件名排序） |

### 时间类型

按 `t` 后再按：
- `a`：访问时间
- `c`：变更时间（元数据）
- `m`：修改时间（默认）

### 反转排序

使用大写字母可反转默认排序顺序：
- `E`：按扩展名降序
- `S`：按大小降序
- `T`：按时间降序

---

## 上下文（标签页）

nnn 支持 8 个独立的上下文（类似标签页），每个可以独立浏览不同目录。

### 上下文操作

| 快捷键 | 功能 |
|--------|------|
| `1-8` | 切换到指定上下文 |
| `Tab` | 循环切换上下文 |
| `Shift+Tab` | 反向循环上下文 |

### 上下文状态

- **当前上下文**：反色显示
- **活跃上下文**：下划线显示
- **非活跃上下文**：普通显示

### 上下文特性

- 新上下文会复制前一个上下文的状态
- 每个上下文可以有自己的颜色（通过 `NNN_COLORS` 配置）
- 每个上下文独立保存过滤状态

### 使用场景

```bash
# 在两个目录间复制文件
1. 在上下文 1 浏览源目录，选择文件，按 p 复制
2. 按 2 切换到上下文 2
3. 浏览目标目录，按 p 粘贴
```

---

## 书签功能

### 书签类型

1. **快捷键书签**：通过 `NNN_BMS` 环境变量设置
2. **符号链接书签**：在 `~/.config/nnn/bookmarks/` 中创建

### 快捷键书签设置

```bash
export NNN_BMS="d:$HOME/Docs;u:/home/user/Cam Uploads;D:$HOME/Downloads/"
```

### 书签操作

| 快捷键 | 功能 |
|--------|------|
| `b` | 打开书签列表 |
| `B` | 创建当前目录的书签 |

### 使用书签

1. 按 `b` 打开书签列表
2. 输入书签键（如 `d`）
3. 按 `Enter` 跳转到书签目录

### 书签与历史

- 进入书签后，原目录设为"上次访问目录"
- 按 `-` 可返回原目录

---

## 会话管理

### 会话操作

| 快捷键 | 功能 |
|--------|------|
| `s` | 管理会话 |

### 会话类型

1. **自动会话**：保存最后工作状态，文件名为 `@`
2. **命名会话**：用户创建的命名会话

### 会话存储

会话文件存储在：
```
${XDG_CONFIG_HOME:-$HOME/.config}/nnn/sessions/
```

### 使用会话

```bash
# 启动时加载会话
nnn -s mysession

# 持久会话模式
nnn -S

# 运行时管理
# 按 s 打开会话菜单
# 可以保存、加载、删除会话
```

### 会话内容

会话保存：
- 所有上下文的状态
- 排序设置
- 过滤状态
- 当前目录

---

## 插件系统

### 安装插件

```bash
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
```

插件安装到：`~/.config/nnn/plugins/`

### 配置插件快捷键

```bash
export NNN_PLUG='f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'
```

### 使用插件

| 快捷键 | 功能 |
|--------|------|
| `;` | 打开插件提示符 |
| `;键` | 运行指定插件 |
| `Alt+键` | 运行指定插件（替代方式） |
| `Enter` | 在插件提示符下浏览并选择插件 |

### 常用插件

| 插件 | 功能 |
|------|------|
| `finder` | 自定义查找命令 |
| `fzopen` | 模糊查找文件 |
| `preview-tui` | 文件预览 |
| `imgview` | 图片查看 |
| `diffs` | 文件对比 |
| `nmount` | 挂载/卸载设备 |
| `nuke` | CLI 文件打开器 |
| `organize` | 按类型自动组织文件 |
| `renamer` | 批量重命名 |

### 运行命令作为插件

```bash
# 使用 ! 前缀
export NNN_PLUG='x:!chmod +x "$nnn";g:!git log'

# 使用 * 后缀跳过确认
export NNN_PLUG='s:!smplayer "$nnn"*'

# 使用 & 后缀运行 GUI 应用
export NNN_PLUG='m:-!&mousepad "$nnn"'

# 使用 | 后缀分页显示输出
export NNN_PLUG='m:-!|mediainfo "$nnn"'
```

### 创建自定义插件

```bash
#!/usr/bin/env sh
# 示例：显示文件的 git 日志
git log -p -- "$1"
```

插件接收参数：
- `$1`：当前悬浮的文件名
- `$2`：工作目录
- `$3`：选择模式输出文件

---

## 环境变量配置

### 基本配置

```bash
# 在 .bashrc 或 .zshrc 中添加

# 二进制选项
export NNN_OPTS="cEnrx"

# 自定义文件打开器
export NNN_OPENER=nuke

# 书签
export NNN_BMS="d:$HOME/Docs;D:$HOME/Downloads"

# 插件
export NNN_PLUG='f:finder;o:fzopen;p:preview-tui'
```

### 颜色配置

```bash
# 8 色方案（每个上下文一个颜色）
export NNN_COLORS='12341234'

# xterm 256 色（十六进制）
export NNN_COLORS='#0a1b2c3d0a1b2c3d'

# 文件类型颜色
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
```

### 高级配置

```bash
# 目录特定排序
export NNN_ORDER='t:/home/user/Downloads;S:/tmp'

# 压缩包扩展名
export NNN_ARCHIVE="\\.(7z|bz2|gz|tar|tgz|zip)$"

# 自定义 sshfs 命令
export NNN_SSHFS='sshfs -o reconnect,idmap=user,cache_timeout=3600'

# rclone 选项
export NNN_RCLONE='rclone mount --read-only --no-checksum'

# 使用回收站而非 rm
export NNN_TRASH=1  # 使用 trash-cli
# export NNN_TRASH=2  # 使用 gio trash

# 自定义选择文件路径
export NNN_SEL='/tmp/.sel'

# FIFO 用于文件预览
export NNN_FIFO='/tmp/nnn.fifo'

# 终端锁定程序
export NNN_LOCKER='cmatrix'

# 退出时 cd 并写入文件
export NNN_TMPFILE='/tmp/.lastd'

# 帮助页面显示程序
export NNN_HELP='fortune'
```

### cd on quit 配置

在 `.bashrc` 中添加：

```bash
n() {
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
```

---

## 常用场景示例

### 场景 1：浏览和查找文件

```bash
# 启动 nnn
nnn

# 使用过滤查找文件
/
输入文件名部分字符

# 切换显示隐藏文件
.

# 查看文件详情
f
```

### 场景 2：批量复制文件

```bash
# 1. 浏览到源目录
# 2. 选择文件
Space        # 选择单个文件
m            # 进入多选模式
j            # 向下移动选择更多
Space        # 选择

# 3. 复制选择
p            # 复制到选择缓冲区

# 4. 浏览到目标目录
# 5. 粘贴
p            # 粘贴
```

### 场景 3：在两个目录间移动文件

```bash
# 1. 上下文 1 浏览源目录
1            # 切换到上下文 1
# 选择文件
Space        # 选择文件
v            # 移动到选择缓冲区

# 2. 切换到上下文 2
2            # 切换到上下文 2
# 浏览到目标目录
v            # 移动到当前位置
```

### 场景 4：创建项目结构

```bash
# 1. 浏览到项目目录
# 2. 创建目录
n
myproject/   # 输入目录名，以 / 结尾
l            # 进入目录

# 3. 创建子目录
n
src/
n
docs/

# 4. 创建文件
l            # 进入 src/
n
main.py      # 输入文件名
```

### 场景 5：使用插件预览文件

```bash
# 1. 配置预览插件
export NNN_PLUG='p:preview-tui'
export NNN_FIFO='/tmp/nnn.fifo'

# 2. 启动 nnn
nnn

# 3. 打开预览
;p           # 运行预览插件

# 4. 浏览文件，右侧会显示预览
```

### 场景 6：批量重命名文件

```bash
# 1. 选择要重命名的文件
a            # 选择所有文件

# 2. 批量重命名
r            # 打开编辑器

# 3. 在编辑器中修改文件名
# 4. 保存退出
```

---

## 高级技巧

### 1. 使用 find 管道

```bash
# 列出大于 1M 的文件
find -maxdepth 1 -size +1M -print0 | nnn

# 列出所有视频文件
find . -maxdepth 1 | file -if- | grep video | awk -F: '{printf "%s%c", $1, 0}' | nnn
```

### 2. 远程文件管理

```bash
# 配置 sshfs
export NNN_SSHFS='sshfs -o reconnect,idmap=user'

# 在 nnn 中按 c 连接远程服务器
c
user@host:/path
```

### 3. 文件选择技巧

```bash
# 跨目录选择
# 1. 在目录 A 选择文件
Space
# 2. 浏览到目录 B，继续选择
Space
# 3. 所有选择的文件都在选择缓冲区中
```

### 4. 使用书签快速导航

```bash
# 设置书签
export NNN_BMS="p:$HOME/projects;w:$HOME/work;d:$HOME/Downloads"

# 使用书签
b            # 打开书签
p            # 跳转到 projects
```

### 5. 自定义文件打开方式

```bash
# 使用 nuke 插件作为 opener
export NNN_OPENER=nuke

# 或者自定义
export NNN_OPENER=/path/to/my/opener
```

### 6. 集成到 Vim

```vim
" 在 .vimrc 中添加
Plug 'mcchrish/nnn.vim'

" 使用 :Nnn 命令打开 nnn
```

### 7. 使用会话保存工作状态

```bash
# 保存当前状态
s            # 打开会话菜单
# 选择保存，输入名称

# 恢复状态
s            # 打开会话菜单
# 选择加载，选择会话名称
```

### 8. 键盘映射自定义

nnn 不支持运行时自定义键绑定，但可以通过补丁修改：

```bash
# 使用 Colemak 键位布局补丁
make O_COLEMAK=1
```

---

## 故障排除

### 问题：文件颜色不显示

```bash
# 确保终端支持 256 色
echo $TERM
# 应该显示 xterm-256color 或类似

# 设置 TERM
export TERM=xterm-256color
```

### 问题：中文文件名显示乱码

```bash
# 确保 locale 设置正确
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

### 问题：插件不工作

```bash
# 检查插件是否有执行权限
chmod +x ~/.config/nnn/plugins/*

# 检查插件路径
echo $NNN_PLUG
```

### 问题：预览不显示

```bash
# 确保设置了 NNN_FIFO
export NNN_FIFO='/tmp/nnn.fifo'

# 确保预览插件正确安装
ls ~/.config/nnn/plugins/preview-tui
```

---

## 参考资源

- [官方 GitHub](https://github.com/jarun/nnn)
- [官方 Wiki](https://github.com/jarun/nnn/wiki)
- [插件仓库](https://github.com/jarun/nnn/tree/master/plugins)
- [补丁框架](https://github.com/jarun/nnn/tree/master/patches)
- [性能基准](https://github.com/jarun/nnn/wiki/Performance)

---

*本指南基于 nnn 源码和官方文档编写，如有疑问请参考官方文档。*
