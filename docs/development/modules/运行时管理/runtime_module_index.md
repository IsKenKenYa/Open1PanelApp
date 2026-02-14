# 运行时管理模块索引

## 模块定位

运行时管理模块是Open1PanelApp的**核心开发环境模块**，负责管理各类编程语言运行时环境（Java、Node.js、Python、Go、PHP、.NET等）的安装、配置、监控和维护。该模块为开发者提供便捷的运行时环境管理能力。

### 核心职责

1. **运行时生命周期管理** - 创建、更新、删除运行时环境
2. **多语言支持** - Java、Node.js、Python、Go、PHP、.NET等主流语言
3. **配置管理** - 运行时参数配置、环境变量管理
4. **状态监控** - 运行时状态同步、健康检查
5. **扩展管理** - PHP扩展安装与管理

## 子模块结构

```
运行时管理/
├── 运行时列表
│   ├── 列表展示
│   ├── 搜索过滤
│   └── 批量操作
├── 运行时详情
│   ├── 基本信息
│   ├── 配置参数
│   └── 状态监控
├── 运行时操作
│   ├── 创建运行时
│   ├── 更新配置
│   ├── 启动/停止/重启
│   └── 删除运行时
├── PHP专项
│   ├── 扩展管理
│   ├── 配置文件编辑
│   └── 状态监控
└── 语言特定功能
    ├── Java (JDK配置)
    ├── Node.js (npm/yarn/pnpm)
    ├── Python (pip/virtualenv)
    ├── Go (GOPATH配置)
    └── .NET (SDK管理)
```

## API端点映射

| API端点 | 方法 | 功能描述 | 实现状态 |
|---------|------|---------|---------|
| `/runtimes` | POST | 创建运行时 | ✅ 已实现 |
| `/runtimes/{id}` | GET | 获取运行时详情 | ✅ 已实现 |
| `/runtimes/del` | POST | 删除运行时 | ✅ 已实现 |
| `/runtimes/operate` | POST | 操作运行时 | ✅ 已实现 |
| `/runtimes/{id}/extensions` | GET | 获取PHP扩展列表 | ✅ 已实现 |
| `/runtimes/php/config/update` | POST | 更新PHP配置 | ✅ 已实现 |
| `/runtimes/{id}/php/config` | GET | 加载PHP配置 | ✅ 已实现 |
| `/runtimes/{id}/php/status` | GET | 获取PHP状态 | ✅ 已实现 |
| `/runtimes/remark/update` | POST | 更新备注 | ✅ 已实现 |
| `/runtimes/search` | POST | 搜索运行时 | ✅ 已实现 |
| `/runtimes/status/sync` | POST | 同步状态 | ✅ 已实现 |
| `/runtimes/update` | POST | 更新运行时 | ✅ 已实现 |

## 现有实现

### API客户端
- [runtime_v2.dart](../../../lib/api/v2/runtime_v2.dart) - 12个API方法

### 数据模型
- [runtime_models.dart](../../../lib/data/models/runtime_models.dart) - 完整模型定义
  - `RuntimeType` - 运行时类型枚举
  - `RuntimeInfo` - 运行时信息
  - `RuntimeCreate` - 创建请求
  - `RuntimeUpdate` - 更新请求
  - `RuntimeSearch` - 搜索请求
  - `RuntimeOperate` - 操作请求
  - `JavaRuntime` - Java运行时
  - `NodeRuntime` - Node.js运行时
  - `PythonRuntime` - Python运行时
  - `GoRuntime` - Go运行时
  - `PHPRuntime` - PHP运行时
  - `RuntimePackage` - 运行时包

## 支持的运行时类型

| 类型 | 标识 | 特有配置 |
|------|------|---------|
| **Java** | java | JDK_HOME, JAVA_HOME, Classpath |
| **Node.js** | node | NODE_HOME, NPM_HOME, 包管理器 |
| **Python** | python | PYTHON_HOME, PIP_HOME, virtualenv |
| **Go** | go | GO_HOME, GOPATH, GOCACHE |
| **PHP** | php | PHP_HOME, php.ini, 扩展目录 |
| **.NET** | dotnet | SDK路径, 运行时版本 |

## 后续规划

### 短期目标（1-2周）
1. 创建运行时列表页面UI
2. 实现运行时详情页面
3. 添加运行时创建/编辑表单
4. 添加单元测试覆盖

### 中期目标（1个月）
1. 完善PHP扩展管理UI
2. 实现配置文件在线编辑器
3. 添加运行时状态监控图表
4. 实现批量操作功能

### 长期目标
1. 支持自定义运行时类型
2. 实现运行时版本切换
3. 添加运行时性能分析
4. 支持运行时集群管理

## 质量指标

| 指标 | 当前状态 | 目标 |
|------|---------|------|
| API实现 | 100% | 100% |
| 数据模型 | 100% | 100% |
| 单元测试 | 0% | ≥80% |
| 文档覆盖 | 0% | 100% |
| UI实现 | 0% | 100% |

---

**文档版本**: 1.0  
**最后更新**: 2026-02-14  
**维护者**: Open1Panel开发团队
