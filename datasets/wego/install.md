# wego 安装指南

从零开始在一台全新 Linux 机器上安装并运行 wego 终端天气客户端。

## 第 1 步：安装 Go

```bash
# Ubuntu / Debian
sudo apt-get update
sudo apt-get install -y golang-go

# 验证
go version && echo "✓ Go 已安装"
```

如果没有 sudo 权限，手动安装：

```bash
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
tar -C $HOME -xzf go1.22.0.linux-amd64.tar.gz
export PATH=$HOME/go/bin:$PATH
echo 'export PATH=$HOME/go/bin:$PATH' >> ~/.bashrc
go version
```

## 第 2 步：安装 wego

```bash
go install github.com/schachmat/wego@latest
```

确保 `$GOPATH/bin` 或 `$HOME/go/bin` 在 PATH 中：

```bash
export PATH=$HOME/go/bin:$PATH
echo 'export PATH=$HOME/go/bin:$PATH' >> ~/.bashrc
```

## 第 3 步：验证安装

```bash
which wego
wego -h
```

## 第 4 步：首次运行

使用免费的 open-meteo 后端（无需 API key）：

```bash
wego --backend open-meteo -- 2
```

参数 `2` 表示显示 2 天预报。

## 第 5 步：配置默认后端

首次运行后会自动生成配置文件。编辑配置文件设置默认后端：

```bash
# 查看配置文件位置（通常在 ~/.config/wego/wegorc 或 ~/.wegorc）
cat ~/.wegorc

# 手动指定配置文件运行
WEGORC=/tmp/wegorc wego --backend open-meteo -- 2
```

## 离线运行（使用 JSON fixture）

wego 支持 `json` 后端读取本地文件，无需网络：

```bash
wego --backend json --frontend json -- ./path/to/weather-sample.json
```

## 常见问题

### 报错 `command not found: wego`

确认 `$HOME/go/bin` 在 PATH 中：`export PATH=$HOME/go/bin:$PATH`

### 报错 `API key required`

大多数后端需要 API key。免费选项：
- `open-meteo`：无需 key
- `smhi`：无需 key（仅限北欧地区）
- 或使用 `json` 后端读本地文件
