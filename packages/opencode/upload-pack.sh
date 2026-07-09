#!/bin/bash

# OpenCode 打包上传脚本（一次性上传，只需输入一次密码）

# 服务器配置
SERVER_USER="abat"
SERVER_IP="192.168.180.124"
SERVER_DIR="~/abatlauncher/scripts/abat-opencode-serve"

# 颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================="
echo "OpenCode 打包上传脚本"
echo "目标服务器: ${SERVER_USER}@${SERVER_IP}"
echo "目标目录: ${SERVER_DIR}"
echo "========================================="

# 检查是否在正确的目录
if [ ! -f "Dockerfile" ] || [ ! -f "start.sh" ]; then
    echo -e "${RED}错误: 请在 packages/opencode 目录下运行此脚本${NC}"
    exit 1
fi

# 在当前目录打包
echo -e "\n${GREEN}[1/3] 打包文件...${NC}"
TEMP_DIR="./temp_upload"
mkdir -p ${TEMP_DIR}/opencode

# 复制文件到临时目录
cp Dockerfile ${TEMP_DIR}/opencode/
cp start.sh ${TEMP_DIR}/opencode/

if [ -d "dist" ]; then
    cp -r dist ${TEMP_DIR}/opencode/
else
    echo -e "${RED}警告: dist 目录不存在${NC}"
    echo "请先构建项目: bun run build"
fi

# 打包
cd ${TEMP_DIR}
tar czf opencode.tar.gz opencode/
cd - > /dev/null

echo -e "${GREEN}✓ 打包完成: ${TEMP_DIR}/opencode.tar.gz${NC}"

# 一次性上传并解压（只需输入一次密码）
echo -e "\n${GREEN}[2/3] 上传并解压...${NC}"
scp ${TEMP_DIR}/opencode.tar.gz ${SERVER_USER}@${SERVER_IP}:/tmp/ && \
ssh ${SERVER_USER}@${SERVER_IP} "
    mkdir -p ${SERVER_DIR} && \
    cd ${SERVER_DIR} && \
    tar xzf /tmp/opencode.tar.gz --strip-components=1 && \
    chmod +x start.sh && \
    rm /tmp/opencode.tar.gz && \
    echo '文件已解压到 ${SERVER_DIR}'
"

if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 上传或解压失败${NC}"
    rm -rf ${TEMP_DIR}
    exit 1
fi

# 清理本地临时文件
echo -e "\n${GREEN}[3/3] 清理本地临时文件...${NC}"
rm -rf ${TEMP_DIR}

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}✓ 上传完成！${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "接下来在服务器上执行："
echo "  1. ssh ${SERVER_USER}@${SERVER_IP}"
echo "  2. cd ${SERVER_DIR}"
echo "  3. docker build -t opencode:latest ."
echo "  4. docker run -d --name opencode-server \
  -p 4096:4096 \
  -v /data/abat/ABAT:/workspace:Z \
  -v /data/abat/.opencode:/home/abat/.local/share/opencode:Z \
  -v /data/abat/.config/opencode:/home/abat/.config/opencode:Z \
  -e PORT=4096 \
  -e HOSTNAME=0.0.0.0 \
  opencode:latest "
