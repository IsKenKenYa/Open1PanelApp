# 网站模块 - OpenResty 子模块 API 设计说明

## 端点列表

| 方法 | 路径 | 说明 |
| --- | --- | --- |
| GET | /openresty | 获取OpenResty配置 |
| POST | /openresty/build | 触发构建 |
| POST | /openresty/file | 上传配置文件并更新 |
| GET | /openresty/https | 获取默认HTTPS状态 |
| POST | /openresty/https | 更新默认HTTPS |
| GET | /openresty/modules | 获取模块列表 |
| POST | /openresty/modules/update | 更新模块列表 |
| POST | /openresty/scope | 获取局部配置 |
| GET | /openresty/status | 获取服务状态 |
| POST | /openresty/update | 更新配置 |

## 数据结构

### OpenrestyStatus

字段来源: lib/data/models/openresty_models.dart

- isRunning: bool
- version: string
- nginxVersion: string
- workerProcesses: int
- activeConnections: int
- accepts: int
- handled: int
- requests: int
- reading: int
- writing: int
- waiting: int
- configPath: string
- logPath: string
- errorLogPath: string

### OpenrestyConfig

- serverName: string
- listen: int
- ssl: bool
- sslListen: int
- certificate: string
- certificateKey: string
- root: string
- index: string
- locations: string[]
- upstreams: object
- gzip: bool
- headers: object

### OpenrestyOperation

- operation: string
- options: object

## 请求与响应建议

### GET /openresty

- 响应: OpenrestyConfig

### POST /openresty/update

- 请求: OpenrestyConfig
- 响应: 200/204

### POST /openresty/file

- 请求: multipart/form-data
  - file: 配置文件
- 响应: 200/204

### GET /openresty/https

- 响应: { enabled: bool, certificate: string, certificateKey: string }

### POST /openresty/https

- 请求: { enabled: bool, certificate: string, certificateKey: string }
- 响应: 200/204

### GET /openresty/modules

- 响应: [{ name: string, enabled: bool, version: string }]

### POST /openresty/modules/update

- 请求: { modules: [{ name: string, enabled: bool }] }
- 响应: 200/204

### POST /openresty/scope

- 请求: { scope: string }
- 响应: { scope: string, content: string }

### POST /openresty/build

- 请求: { version: string, modules: string[] }
- 响应: { taskId: string }

### GET /openresty/status

- 响应: OpenrestyStatus

## 兼容性说明

- 当前客户端实现与OpenAPI存在方法差异，需要在实现阶段对齐
