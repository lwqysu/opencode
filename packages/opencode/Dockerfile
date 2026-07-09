FROM alpine AS base

# Disable the runtime transpiler cache by default inside Docker containers.
# On ephemeral containers, the cache is not useful
ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

# 安装依赖（使用阿里云镜像源）
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --no-cache libgcc libstdc++ ripgrep git

# 根据架构复制对应的二进制文件
FROM base AS build-amd64
COPY dist/opencode-linux-x64-baseline-musl/bin/opencode /usr/local/bin/opencode

FROM base AS build-arm64
COPY dist/opencode-linux-arm64-musl/bin/opencode /usr/local/bin/opencode

# 服务器使用 x86_64 架构
FROM build-amd64

# 设置用户 UID 和 GID（与 ABAT 项目统一）
ARG USER_UID=10009
ARG USER_GID=10009

# 复制启动脚本
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# 创建日志和运行目录
RUN mkdir -p /var/log/opencode /var/run /workspace

# 创建 abat 用户组和用户（与 ABAT 项目统一）
RUN addgroup -g ${USER_GID} abat && \
    adduser -D -u ${USER_UID} -G abat abat && \
    echo "abat:abat" | chpasswd

# 设置目录权限
RUN chown -R abat:abat /var/log/opencode /var/run /workspace

# 配置 Git
RUN git config --global core.longpaths true && \
    git config --global pull.rebase false && \
    git config --global core.autocrlf false && \
    git config --global core.eol lf && \
    git config --global core.quotepath false

# 验证安装
RUN opencode --version

# 设置环境变量
ENV PORT=4096
ENV HOSTNAME=0.0.0.0

# 切换到 abat 用户
USER abat

# 设置工作目录
WORKDIR /workspace

# 暴露端口
EXPOSE 4096

# 使用启动脚本作为入口点
CMD ["sh", "/usr/local/bin/start.sh"]
