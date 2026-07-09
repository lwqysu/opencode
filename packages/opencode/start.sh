#!/bin/sh

# OpenCode 容器启动脚本

# 设置默认端口
PORT=${PORT:-4096}
HOSTNAME=${HOSTNAME:-0.0.0.0}

# 导出环境变量
export OPENCODE_PORT=$PORT
export OPENCODE_HOSTNAME=$HOSTNAME

# 切换到工作目录
cd /workspace

# 启动 opencode 服务
echo "Starting OpenCode server on ${HOSTNAME}:${PORT}..."

# 使用 nohup 在后台运行，并自动重启
nohup sh -c "while true; do opencode serve --port ${PORT} --hostname ${HOSTNAME}; sleep 1; done" >> /var/log/opencode/server.log 2>&1 &

# 记录进程ID
echo $! > /var/run/opencode.pid

echo "OpenCode server started (PID: $(cat /var/run/opencode.pid))"
echo "Access at http://${HOSTNAME}:${PORT}"
echo "Logs: /var/log/opencode/server.log"

# 保持容器运行
tail -f /var/log/opencode/server.log