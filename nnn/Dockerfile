FROM debian:bookworm-slim

# 安装编译依赖和运行时工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libncursesw5-dev \
    pkg-config \
    strace \
    gdb \
    procps \
    file \
    vim \
    && rm -rf /var/lib/apt/lists/*

# 复制源码
COPY . /build/nnn
WORKDIR /build/nnn

# 编译 nnn
RUN make clean && make && cp nnn /usr/local/bin/nnn

# 创建测试用户（避免 root 运行 TUI）
RUN useradd -m -s /bin/bash agent
USER agent
WORKDIR /home/agent

# 复制 benchmark fixtures
COPY --chown=agent:agent benchmarks/nnn/fixtures/setup.sh /home/agent/setup.sh

# 初始化测试目录
RUN bash /home/agent/setup.sh

# 默认终端设置
ENV TERM=xterm-256color
ENV EDITOR=vi

# 启动 bash（Agent 可通过 docker exec 交互）
CMD ["/bin/bash"]
