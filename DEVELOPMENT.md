# OpenCode 开发文档

## 项目信息

### GitHub 仓库地址

- **主仓库（上游）**: [https://github.com/anomalyco/opencode](https://github.com/anomalyco/opencode)
- **Fork 仓库**: [https://github.com/lwqysu/opencode](https://github.com/lwqysu/opencode)

### 官方文档

- **官方文档**: [https://opencode.ai/docs](https://opencode.ai/docs)
- **官方网站**: [https://opencode.ai](https://opencode.ai)
- **中文 README**: [README.zh.md](./README.zh.md)

---

## 项目结构

OpenCode 是一个 Monorepo 项目，使用 Bun 作为包管理器和运行时。

### 核心包目录

```
packages/
├── opencode/          # 后端核心服务（Bun + Effect）
├── app/               # 前端应用（Vite + Solid.js）
├── core/              # 核心共享库
├── sdk/               # SDK 工具包
├── server/            # 服务器基础库
├── protocol/          # 协议定义
├── schema/            # 数据模式
└── ...
```

### 主要文件说明

#### 后端服务 (packages/opencode/)

- **Dockerfile**: 容器化配置，基于 Alpine Linux
- **start.sh**: 容器启动脚本
- **src/index.ts**: 服务入口文件
- **src/server/**: 服务器核心代码
  - **server.ts**: HTTP 服务器主文件
  - **routes/**: API 路由定义
    - **instance/httpapi/api.ts**: API 路由总汇
    - **instance/httpapi/groups/**: API 分组
      - **control.ts**: 控制相关 API
      - **session.ts**: 会话管理 API
      - **workspace.ts**: 工作区 API
      - **project.ts**: 项目管理 API
      - **file.ts**: 文件操作 API
      - **pty.ts**: 终端(PTY) API
      - **mcp.ts**: MCP 协议 API
      - **permission.ts**: 权限管理 API
      - **provider.ts**: 提供者管理 API
      - **config.ts**: 配置管理 API
      - **experimental.ts**: 实验性功能 API
      - **instance.ts**: 实例管理 API
      - **question.ts**: 问题交互 API

#### 前端应用 (packages/app/)

- **src/index.ts**: 前端入口
- **vite.js**: Vite 配置
- **.env**: 环境配置文件
  ```env
  VITE_OPENCODE_SERVER_HOST=192.168.180.124
  VITE_OPENCODE_SERVER_PORT=4096
  ```

---

## OpenCode 服务接口 API 文档

### 基础信息

- **服务地址**: `http://192.168.180.124:4096`
- **协议**: HTTP/WebSocket
- **数据格式**: JSON
- **架构**: Effect-based HTTP API
- **OpenAPI 文档**: `http://192.168.180.124:4096/doc`
- **API 版本**: 1.0.0
- **端点总数**: 162+

### 在线 API 文档

OpenCode 服务提供了完整的 **OpenAPI 3.1** 规范文档：

#### 访问方式

1. **浏览器访问**（推荐使用 Swagger UI 或其他 OpenAPI 工具）:
   ```
   http://192.168.180.124:4096/doc
   ```

2. **命令行获取**:
   ```bash
   # 获取完整 API 文档 (JSON 格式)
   curl http://192.168.180.124:4096/doc > opencode-api.json
   
   # 查看所有 API 端点
   curl -s http://192.168.180.124:4096/doc | jq -r '.paths | keys'
   
   # 查看特定端点详情
   curl -s http://192.168.180.124:4096/doc | jq '.paths["/api/session"]'
   ```

3. **使用在线 Swagger Editor 查看**:
   - 访问 [Swagger Editor](https://editor.swagger.io/)
   - 将 `http://192.168.180.124:4096/doc` 的内容粘贴进去
   - 即可获得可交互的 API 文档界面

### 主要 API 端点分类

OpenCode 提供了 **162+ 个 API 端点**，主要分为以下类别：

#### 1. 核心 API (`/api/*`)

##### 会话管理 (Session)
- `POST /api/session` - 创建新会话
- `GET /api/session` - 获取会话列表
- `GET /api/session/active` - 获取活跃会话
- `GET /api/session/{sessionID}` - 获取会话详情
- `DELETE /api/session/{sessionID}` - 删除会话
- `POST /api/session/{sessionID}/message` - 发送消息

##### 工作区管理 (Workspace)
- `GET /api/workspace` - 获取工作区信息
- `POST /api/workspace` - 创建/更新工作区
- `GET /api/workspace/file` - 列出文件
- `GET /api/workspace/git/*` - Git 操作

##### 文件系统 (FileSystem)
- `GET /api/fs/list` - 列出目录
- `GET /api/fs/read/*` - 读取文件内容
- `POST /api/fs/find` - 搜索文件
- `POST /api/fs/write/*` - 写入文件
- `DELETE /api/fs/delete/*` - 删除文件

##### 终端 (PTY)
- `POST /api/pty` - 创建终端
- `GET /api/pty/{ptyID}` - 获取终端信息
- `WebSocket /api/pty/{ptyID}/connect` - 连接终端
- `DELETE /api/pty/{ptyID}` - 关闭终端

##### AI 提供者 (Provider)
- `GET /api/provider` - 获取提供者列表
- `POST /api/provider` - 添加提供者
- `GET /api/provider/{providerID}` - 获取提供者详情
- `PUT /api/provider/{providerID}` - 更新提供者
- `DELETE /api/provider/{providerID}` - 删除提供者

##### 模型管理 (Model)
- `GET /api/model` - 获取可用模型列表
- `GET /api/model/{modelID}` - 获取模型详情

##### 权限管理 (Permission)
- `POST /api/permission/request` - 请求权限
- `GET /api/permission/saved` - 获取已保存权限
- `DELETE /api/permission/saved/{id}` - 删除权限

##### 配置管理 (Config)
- `GET /config` - 获取配置
- `PUT /config` - 更新配置

##### MCP 集成 (Model Context Protocol)
- `GET /api/mcp/server` - 获取 MCP 服务器列表
- `POST /api/mcp/server` - 添加 MCP 服务器
- `GET /api/mcp/server/{serverID}` - 获取服务器详情
- `DELETE /api/mcp/server/{serverID}` - 删除服务器

##### 集成管理 (Integration)
- `GET /api/integration` - 获取集成列表
- `POST /api/integration` - 创建集成
- `GET /api/integration/{integrationID}` - 获取集成详情
- `POST /api/integration/{integrationID}/connect/oauth` - OAuth 连接

#### 2. 认证 API (`/auth/*`)

- `PUT /auth/{providerID}` - 设置认证凭据
- `DELETE /auth/{providerID}` - 删除认证凭据

#### 3. Agent API (`/agent`, `/api/agent`)

- `POST /agent` - 创建 Agent
- `POST /api/agent` - Agent 操作

#### 4. 事件流 (Events)

- `WebSocket /api/event` - 实时事件流
- 服务器推送事件（会话更新、文件变更等）

#### 5. 健康检查

```bash
GET /api/health
响应: {"healthy": true}
```

#### 6. 前端应用

```bash
GET /
响应: HTML 页面（OpenCode Web UI）
```

### API 调用示例

#### 1. 检查服务健康状态

```bash
curl http://192.168.180.124:4096/api/health
```

响应：
```json
{"healthy": true}
```

#### 2. 获取完整 API 文档

```bash
# 保存为 JSON 文件
curl http://192.168.180.124:4096/doc -o opencode-api.json

# 查看 API 概要信息
curl -s http://192.168.180.124:4096/doc | jq '.info'

# 列出所有端点
curl -s http://192.168.180.124:4096/doc | jq -r '.paths | keys[]'

# 查看特定端点的详细信息
curl -s http://192.168.180.124:4096/doc | jq '.paths["/api/session"]'
```

#### 3. 会话管理示例

```bash
# 创建新会话
curl -X POST http://192.168.180.124:4096/api/session \
  -H "Content-Type: application/json" \
  -d '{
    "workspaceID": "your-workspace-id",
    "agentID": "build"
  }'

# 获取所有会话
curl http://192.168.180.124:4096/api/session

# 向会话发送消息
curl -X POST http://192.168.180.124:4096/api/session/{sessionID}/message \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Hello, OpenCode!"
  }'
```

#### 4. 文件系统操作示例

```bash
# 列出目录内容
curl "http://192.168.180.124:4096/api/fs/list?path=/workspace"

# 读取文件内容
curl "http://192.168.180.124:4096/api/fs/read/path/to/file.txt"

# 搜索文件
curl -X POST http://192.168.180.124:4096/api/fs/find \
  -H "Content-Type: application/json" \
  -d '{
    "pattern": "*.ts",
    "directory": "/workspace"
  }'
```

#### 5. 访问 Web 界面

在浏览器中打开：
```
http://192.168.180.124:4096
```

#### 6. WebSocket 连接示例

WebSocket 端点用于实时通信：

```javascript
// 连接到事件流
const ws = new WebSocket('ws://192.168.180.124:4096/api/event');

ws.onopen = () => {
  console.log('WebSocket 已连接');
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('收到事件:', data);
};

ws.onerror = (error) => {
  console.error('WebSocket 错误:', error);
};

ws.onclose = () => {
  console.log('WebSocket 已关闭');
};
```

```javascript
// 连接到终端
const ptyWs = new WebSocket('ws://192.168.180.124:4096/api/pty/{ptyID}/connect');

ptyWs.onmessage = (event) => {
  // 接收终端输出
  console.log('终端输出:', event.data);
};

// 向终端发送命令
ptyWs.send(JSON.stringify({
  type: 'input',
  data: 'ls -la\n'
}));
```

### API 认证

部分 API 端点需要认证：

- 使用 `Authorization` 中间件
- 支持 Token 认证
- 会话级别的权限控制

### 错误处理

API 使用标准 HTTP 状态码和统一的错误响应格式：

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "错误描述",
    "details": {}
  }
}
```

---

## 开发环境搭建

### 前置要求

- **Bun**: >= 1.0.0
- **Node.js**: >= 18.0.0 (可选，主要使用 Bun)
- **Git**: 最新版本
- **Docker**: 用于容器化部署

### 安装依赖

```bash
# 克隆仓库
git clone git@github.com:lwqysu/opencode.git
cd opencode

# 安装 Bun（如果尚未安装）
curl -fsSL https://bun.sh/install | bash

# 安装项目依赖
bun install
```

---

## 运行项目

### 1. 运行后端服务（OpenCode 核心）

```bash
# 进入后端目录
cd packages/opencode

# 开发模式运行
bun run dev

# 或使用生产构建
bun run build
./bin/opencode
```

**默认配置：**
- 端口: `4096`
- 主机: `0.0.0.0`
- 工作目录: `/workspace`（容器）或当前目录（本地）

### 2. 运行前端应用

```bash
# 进入前端目录
cd packages/app

# 启动开发服务器
bun run dev

# 或使用 Vite 启动
bun run start
```

**前端开发服务器：**
- 默认端口: `5173`
- 后端连接配置在 `.env` 文件中

### 3. 同时运行前后端

可以使用两个终端窗口分别运行前端和后端，或者配置工作流脚本：

```bash
# 终端 1: 后端
cd packages/opencode && bun run dev

# 终端 2: 前端
cd packages/app && bun run dev
```

### 4. Docker 容器运行

#### 构建镜像

```bash
# 在项目根目录
cd packages/opencode

# 构建 Docker 镜像
docker build -t opencode:latest .
```

#### 运行容器

```bash
docker run -d \
  --name opencode-server \
  -p 4096:4096 \
  -v $(pwd)/workspace:/workspace \
  -e PORT=4096 \
  -e HOSTNAME=0.0.0.0 \
  opencode:latest
```

#### 查看容器日志

```bash
docker logs -f opencode-server
```

#### 停止容器

```bash
docker stop opencode-server
docker rm opencode-server
```

---

## 测试

### 运行单元测试

```bash
# 后端测试
cd packages/opencode
bun test

# 前端测试
cd packages/app
bun test
```

### 运行 E2E 测试

```bash
cd packages/app
bun run test:e2e
```

### HTTP API 测试

```bash
cd packages/opencode
bun run test:httpapi
```

---

## 调试

### 后端调试

使用 Bun 的内置调试器：

```bash
cd packages/opencode
bun --inspect run src/index.ts
```

然后在 Chrome 浏览器中打开 `chrome://inspect`。

### 前端调试

1. 启动开发服务器：`bun run dev`
2. 在浏览器中打开 `http://localhost:5173`
3. 使用浏览器的开发者工具进行调试

### 查看日志

```bash
# 本地开发日志在终端直接输出

# Docker 容器日志
docker logs -f opencode-server

# 或进入容器查看
docker exec -it opencode-server sh
cat /var/log/opencode/app.log
```

---

## 常见问题

### 1. 端口冲突

如果 4096 端口被占用，可以修改：

**本地开发：**
```bash
export PORT=8080
bun run dev
```

**Docker：**
```bash
docker run -p 8080:4096 ...
```

### 2. 依赖安装失败

```bash
# 清理缓存
rm -rf node_modules
rm bun.lockb

# 重新安装
bun install
```

### 3. 前端无法连接后端

检查 `packages/app/.env` 文件中的配置：
```env
VITE_OPENCODE_SERVER_HOST=localhost  # 改为实际的后端地址
VITE_OPENCODE_SERVER_PORT=4096       # 确保端口正确
```

### 4. Git 配置问题

容器中已预配置 Git，本地开发需确保：
```bash
git config --global core.longpaths true
git config --global pull.rebase false
git config --global core.autocrlf false
```

---

## 贡献指南

1. Fork 项目到你的 GitHub
2. 创建特性分支: `git checkout -b feature/your-feature`
3. 提交更改: `git commit -m 'Add some feature'`
4. 推送到分支: `git push origin feature/your-feature`
5. 提交 Pull Request

详细信息请参阅 [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 相关资源

- **Discord 社区**: [https://opencode.ai/discord](https://opencode.ai/discord)
- **飞书群**: [加入飞书](https://applink.feishu.cn/client/chat/chatter/add_by_link?link_token=52ao9352-5623-4fa0-b7dd-3407c392c1af&qr_code=true)
- **Twitter/X**: [@opencode](https://x.com/opencode)
- **npm 包**: [opencode-ai](https://www.npmjs.com/package/opencode-ai)

---

## 许可证

MIT License - 详见 [LICENSE](./LICENSE) 文件

---

**最后更新**: 2026年7月9日
