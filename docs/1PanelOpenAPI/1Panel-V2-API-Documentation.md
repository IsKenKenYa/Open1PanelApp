# 1Panel V2 API 文档

## 概述

1Panel 是一个开源的 Linux 面板系统，提供了完整的 RESTful API 接口用于系统管理和自动化操作。

### 基本信息

- **版本**: 2.0
- **协议**: Swagger 2.0
- **许可证**: Apache 2.0
- **基础路径**: `/api/v2`
- **主机**: localhost

### 认证方式

API 使用以下两种认证方式：
- **ApiKeyAuth**: API 密钥认证
- **Timestamp**: 时间戳验证

## API 模块分类

### 1. 系统组管理 (System Group)

#### 创建组
- **端点**: `POST /agent/groups`
- **描述**: 创建新的系统组
- **请求体**: `dto.GroupCreate`
- **日志格式**: 创建组 [name][type]

#### 删除组
- **端点**: `POST /agent/groups/del`
- **描述**: 删除指定的系统组
- **请求体**: `dto.OperateByID`
- **日志格式**: 删除组 [type][name]

#### 查询组列表
- **端点**: `POST /agent/groups/search`
- **描述**: 分页查询系统组列表
- **请求体**: `dto.GroupSearch`
- **响应**: `dto.OperateByType[]`

#### 更新组
- **端点**: `POST /agent/groups/update`
- **描述**: 更新系统组信息
- **请求体**: `dto.GroupUpdate`
- **日志格式**: 更新组 [name][type]

### 2. AI 功能 (AI)

#### 域名绑定
- **端点**: `POST /ai/domain/bind`
- **描述**: 绑定 AI 服务域名
- **请求体**: `dto.OllamaBindDomain`

#### 获取绑定域名
- **端点**: `POST /ai/domain/get`
- **描述**: 获取已绑定的域名信息
- **请求体**: `dto.OllamaBindDomainReq`
- **响应**: `dto.OllamaBindDomainRes`

#### GPU/XPU 信息
- **端点**: `GET /ai/gpu/load`
- **描述**: 加载 GPU/XPU 硬件信息

#### Ollama 模型管理

##### 创建模型
- **端点**: `POST /ai/ollama/model`
- **描述**: 创建新的 Ollama 模型
- **请求体**: `dto.OllamaModelName`
- **日志格式**: 添加 Ollama 模型 [name]

##### 关闭模型连接
- **端点**: `POST /ai/ollama/model/close`
- **描述**: 关闭 Ollama 模型连接
- **请求体**: `dto.OllamaModelName`
- **日志格式**: 关闭 Ollama 模型连接 [name]

##### 删除模型
- **端点**: `POST /ai/ollama/model/del`
- **描述**: 删除 Ollama 模型
- **请求体**: `dto.ForceDelete`
- **日志格式**: 删除 Ollama 模型 [names]

##### 加载模型
- **端点**: `POST /ai/ollama/model/load`
- **描述**: 分页查询 Ollama 模型
- **请求体**: `dto.OllamaModelName`
- **响应**: `string`

##### 重新创建模型
- **端点**: `POST /ai/ollama/model/recreate`
- **描述**: 重新创建 Ollama 模型
- **请求体**: `dto.OllamaModelName`
- **日志格式**: 添加 Ollama 模型重试 [name]

##### 查询模型列表
- **端点**: `POST /ai/ollama/model/search`
- **描述**: 分页查询 Ollama 模型列表
- **请求体**: `dto.SearchWithPage`
- **响应**: `dto.PageResult`

##### 同步模型列表
- **端点**: `POST /ai/ollama/model/sync`
- **描述**: 同步 Ollama 模型列表
- **响应**: `dto.OllamaModelDropList[]`
- **日志格式**: 同步 Ollama 模型列表

### 3. 应用管理 (App)

#### 应用查询

##### 按 Key 查询应用
- **端点**: `GET /apps/:key`
- **描述**: 根据应用 key 查询应用信息
- **参数**: key (路径参数)
- **响应**: `response.AppDTO`

##### 检查应用更新
- **端点**: `GET /apps/checkupdate`
- **描述**: 获取应用列表更新信息
- **响应**: `response.AppUpdateRes`

##### 获取应用详情
- **端点**: `GET /apps/detail/:appId/:version/:type`
- **描述**: 根据应用ID查询应用详情
- **参数**: 
  - appId (应用ID)
  - version (应用版本)
  - type (应用类型)
- **响应**: `response.AppDetailDTO`

##### 按ID获取应用详情
- **端点**: `GET /apps/details/:id`
- **描述**: 根据ID获取应用详情
- **参数**: id (应用ID)
- **响应**: `response.AppDetailDTO`

##### 获取忽略的应用
- **端点**: `GET /apps/ignored`
- **描述**: 获取被忽略更新的应用列表
- **响应**: `response.IgnoredApp[]`

##### 应用列表查询
- **端点**: `POST /apps/search`
- **描述**: 分页查询应用列表
- **请求体**: `request.AppSearch`
- **响应**: `response.AppRes`

##### 获取应用服务
- **端点**: `GET /apps/services/:key`
- **描述**: 根据 key 查询应用服务
- **参数**: key (应用key)
- **响应**: `response.AppService[]`

#### 应用安装

##### 安装应用
- **端点**: `POST /apps/install`
- **描述**: 安装新应用
- **请求体**: `request.AppInstallCreate`
- **响应**: `model.AppInstall`
- **日志格式**: 安装应用 [name]

#### 已安装应用管理

##### 检查应用安装状态
- **端点**: `POST /apps/installed/check`
- **描述**: 检查应用是否已安装
- **请求体**: `request.AppInstalledInfo`
- **响应**: `response.AppInstalledCheck`

##### 获取应用配置
- **端点**: `POST /apps/installed/conf`
- **描述**: 根据 key 查询默认配置
- **请求体**: `dto.OperationWithNameAndType`
- **响应**: `string`

##### 更新应用配置
- **端点**: `POST /apps/installed/config/update`
- **描述**: 更新应用配置
- **请求体**: `request.AppConfigUpdate`
- **日志格式**: 应用配置更新 [installID]

##### 获取连接信息
- **端点**: `GET /apps/installed/conninfo/:key`
- **描述**: 根据 key 查询应用密码
- **请求体**: `dto.OperationWithNameAndType`
- **响应**: `response.DatabaseConn`

##### 删除前检查
- **端点**: `GET /apps/installed/delete/check/:appInstallId`
- **描述**: 删除前检查依赖关系
- **参数**: appInstallId (应用安装ID)
- **响应**: `dto.AppResource[]`

##### 忽略应用更新
- **端点**: `POST /apps/installed/ignore`
- **描述**: 忽略应用版本更新
- **请求体**: `request.AppInstalledIgnoreUpgrade`
- **日志格式**: 忽略应用 [installId] 版本升级

##### 获取已安装应用列表
- **端点**: `GET /apps/installed/list`
- **描述**: 获取已安装应用列表
- **响应**: `dto.AppInstallInfo[]`

##### 获取应用端口
- **端点**: `POST /apps/installed/loadport`
- **描述**: 根据 key 查询应用端口
- **请求体**: `dto.OperationWithNameAndType`
- **响应**: `integer`

##### 操作已安装应用
- **端点**: `POST /apps/installed/op`
- **描述**: 操作已安装的应用（启动/停止/重启等）
- **请求体**: `request.AppInstalledOperate`
- **日志格式**: [operate] 应用 [appKey][appName]

##### 获取应用参数
- **端点**: `GET /apps/installed/params/:appInstallId`
- **描述**: 根据应用安装ID查询参数
- **参数**: appInstallId (应用安装ID)
- **响应**: `response.AppConfig`

##### 更新应用参数
- **端点**: `POST /apps/installed/params/update`
- **描述**: 修改应用参数
- **请求体**: `request.AppInstalledUpdate`
- **日志格式**: 应用参数修改 [installId]

##### 修改应用端口
- **端点**: `POST /apps/installed/port/change`
- **描述**: 修改应用端口
- **请求体**: `request.PortUpdate`
- **日志格式**: 应用端口修改 [key]-[name] => [port]

##### 分页查询已安装应用
- **端点**: `POST /apps/installed/search`
- **描述**: 分页查询已安装应用
- **请求体**: `request.AppInstalledSearch`
- **响应**: `dto.PageResult`

##### 同步已安装应用
- **端点**: `POST /apps/installed/sync`
- **描述**: 同步已安装应用列表
- **日志格式**: 同步已安装应用列表

##### 获取更新版本
- **端点**: `POST /apps/installed/update/versions`
- **描述**: 根据安装ID查询应用更新版本
- **参数**: appInstallId (应用安装ID)
- **响应**: `dto.AppVersion[]`

#### 应用商店管理

##### 获取应用商店配置
- **端点**: `GET /apps/store/config`
- **描述**: 获取应用商店配置
- **响应**: `response.AppstoreConfig`

##### 更新应用商店配置
- **端点**: `POST /apps/store/update`
- **描述**: 更新应用商店配置
- **请求体**: `request.AppstoreUpdate`

#### 应用同步

##### 同步本地应用列表
- **端点**: `POST /apps/sync/local`
- **描述**: 同步本地应用列表
- **日志格式**: 应用商店同步

##### 同步远程应用列表
- **端点**: `POST /apps/sync/remote`
- **描述**: 同步远程应用列表
- **日志格式**: 应用商店同步

### 4. 备份管理 (Backup Account)

#### 备份账号管理

##### 创建备份账号
- **端点**: `POST /backups`
- **描述**: 创建备份账号
- **请求体**: `dto.BackupOperate`
- **日志格式**: 创建备份账号 [type]

##### 删除备份账号
- **端点**: `POST /backups/del`
- **描述**: 删除备份账号
- **请求体**: `dto.OperateByID`
- **日志格式**: 删除备份账号 [types]

##### 获取本地备份目录
- **端点**: `GET /backups/local`
- **描述**: 获取本地备份目录路径
- **响应**: `string`

##### 获取备份选项
- **端点**: `GET /backups/options`
- **描述**: 加载备份账号选项
- **响应**: `dto.BackupOption[]`

##### 列出存储桶
- **端点**: `POST /buckets`
- **描述**: 列出存储桶
- **请求体**: `dto.ForBuckets`
- **标签**: Backup Account

#### 备份操作

##### 备份系统数据
- **端点**: `POST /backups/backup`
- **描述**: 备份系统数据
- **请求体**: `dto.CommonBackup`
- **日志格式**: 备份 [type] 数据 [name][detailName]

##### 恢复数据
- **端点**: `POST /backups/recover`
- **描述**: 从备份恢复数据
- **请求体**: 待补充

#### 备份记录管理

##### 下载备份记录
- **端点**: `POST /backup/record/download`
- **描述**: 下载备份记录
- **请求体**: `dto.DownloadRecord`
- **响应**: `string`
- **日志格式**: 下载备份记录 [source][fileName]

##### 查询备份记录
- **端点**: `POST /backups/record/search`
- **描述**: 分页查询备份记录
- **请求体**: `dto.RecordSearch`
- **响应**: `dto.PageResult`

##### 按计划任务查询备份记录
- **端点**: `POST /backups/record/search/bycronjob`
- **描述**: 按计划任务分页查询备份记录
- **请求体**: `dto.RecordSearchByCronjob`
- **响应**: `dto.PageResult`

##### 获取备份记录大小
- **端点**: `POST /backups/record/size`
- **描述**: 加载备份记录大小信息
- **请求体**: `dto.SearchForSize`
- **响应**: `dto.RecordFileSize[]`

### 5. 容器管理 (Container)

#### 容器操作

##### 创建容器
- **端点**: `POST /containers`
- **描述**: 创建容器
- **请求体**: `dto.ContainerOperate`
- **标签**: Container

##### 清理容器日志
- **端点**: `POST /containers/clean/log`
- **描述**: 清理容器日志
- **请求体**: `dto.OperationWithName`
- **标签**: Container

##### 通过命令创建容器
- **端点**: `POST /containers/command`
- **描述**: 通过命令创建容器
- **请求体**: `dto.ContainerCreateByCommand`
- **标签**: Container

##### 提交容器
- **端点**: `POST /containers/commit`
- **描述**: 提交容器
- **请求体**: `dto.ContainerCommit`
- **标签**: Container

#### 容器镜像管理

##### 列出所有镜像
- **端点**: `GET /containers/image/all`
- **描述**: 列出所有镜像
- **响应**: `dto.ImageInfo[]`
- **标签**: Container Image

##### 构建镜像
- **端点**: `POST /containers/image/build`
- **描述**: 构建镜像
- **请求体**: `dto.ImageBuild`
- **标签**: Container Image

##### 从路径加载镜像
- **端点**: `POST /containers/image/load`
- **描述**: 从路径加载镜像
- **请求体**: `dto.ImageLoad`
- **标签**: Container Image

##### 拉取镜像
- **端点**: `POST /containers/image/pull`
- **描述**: 拉取镜像
- **请求体**: `dto.ImagePull`
- **标签**: Container Image

##### 推送镜像
- **端点**: `POST /containers/image/push`
- **描述**: 推送镜像
- **请求体**: `dto.ImagePush`
- **标签**: Container Image

### 6. 文件管理 (File)

#### 文件操作

##### 创建文件/文件夹
- **端点**: `POST /files`
- **描述**: 创建文件/文件夹
- **请求体**: `request.FileCreate`
- **标签**: File

##### 批量删除文件/文件夹
- **端点**: `POST /files/batch/del`
- **描述**: 批量删除文件/文件夹
- **请求体**: `request.FileBatchDelete`
- **标签**: File

##### 批量修改文件权限和用户/组
- **端点**: `POST /files/batch/role`
- **描述**: 批量修改文件权限和用户/组
- **请求体**: `request.FileRoleReq`
- **标签**: File

##### 检查文件是否存在
- **端点**: `POST /files/check`
- **描述**: 检查文件是否存在
- **请求体**: `request.FilePathCheck`
- **标签**: File

##### 分块下载文件
- **端点**: `POST /files/chunkdownload`
- **描述**: 分块下载文件
- **请求体**: `request.FileDownload`
- **标签**: File

### 7. 数据库管理 (Database)

#### MySQL 数据库管理

##### 创建 MySQL 数据库
- **端点**: `POST /databases`
- **描述**: 创建 MySQL 数据库
- **请求体**: `dto.MysqlDBCreate`
- **日志格式**: 创建 mysql 数据库 [name]
- **标签**: Database Mysql

##### 绑定 MySQL 数据库用户
- **端点**: `POST /databases/bind`
- **描述**: 绑定 MySQL 数据库用户
- **请求体**: `dto.BindUser`
- **日志格式**: 绑定 mysql 数据库名 [database] [username]
- **标签**: Database Mysql

##### 更改 MySQL 访问权限
- **端点**: `POST /databases/change/access`
- **描述**: 更改 MySQL 访问权限
- **请求体**: `dto.ChangeDBInfo`
- **日志格式**: 更新数据库 [name] 访问权限
- **标签**: Database Mysql

##### 更改 MySQL 密码
- **端点**: `POST /databases/change/password`
- **描述**: 更改 MySQL 密码
- **请求体**: `dto.ChangeDBInfo`
- **日志格式**: 更新数据库 [name] 密码
- **标签**: Database Mysql

##### 删除 MySQL 数据库
- **端点**: `POST /databases/del`
- **描述**: 删除 MySQL 数据库
- **请求体**: `dto.MysqlDBDelete`
- **日志格式**: 删除 mysql 数据库 [name]
- **标签**: Database Mysql

##### 删除前检查 MySQL 数据库
- **端点**: `POST /databases/del/check`
- **描述**: 删除前检查 MySQL 数据库
- **请求体**: `dto.MysqlDBDeleteCheck`
- **响应**: `string[]`
- **标签**: Database Mysql

##### 更新 MySQL 数据库描述
- **端点**: `POST /databases/description/update`
- **描述**: 更新 MySQL 数据库描述
- **请求体**: `dto.UpdateDescription`
- **日志格式**: mysql 数据库 [name] 描述信息修改 [description]
- **标签**: Database Mysql

##### 从远程加载 MySQL 数据库
- **端点**: `POST /databases/load`
- **描述**: 从远程加载 MySQL 数据库
- **请求体**: `dto.MysqlLoadDB`
- **标签**: Database Mysql

#### 通用数据库管理

##### 加载数据库基础信息
- **端点**: `POST /databases/common/info`
- **描述**: 加载数据库基础信息
- **请求体**: `dto.OperationWithNameAndType`
- **响应**: `dto.DBBaseInfo`
- **标签**: Database Common

##### 加载数据库配置文件
- **端点**: `POST /databases/common/load/file`
- **描述**: 加载数据库配置文件
- **请求体**: `dto.OperationWithNameAndType`
- **响应**: `string`
- **标签**: Database Common

##### 通过上传文件更新配置
- **端点**: `POST /databases/common/update/conf`
- **描述**: 通过上传文件更新配置
- **请求体**: `dto.DBConfUpdateByFile`
- **日志格式**: 更新 [type] 数据库 [database] 配置信息
- **标签**: Database Common

#### 远程数据库管理

##### 创建远程数据库
- **端点**: `POST /databases/db`
- **描述**: 创建远程数据库
- **请求体**: `dto.DatabaseCreate`
- **日志格式**: 创建远程数据库 [name][type]
- **标签**: Database

##### 获取数据库信息
- **端点**: `GET /databases/db/:name`
- **描述**: 获取数据库信息
- **响应**: `dto.DatabaseInfo`
- **标签**: Database

##### 检查数据库连接
- **端点**: `POST /databases/db/check`
- **描述**: 检查数据库连接
- **请求体**: `dto.DatabaseCreate`
- **响应**: `boolean`
- **日志格式**: 检测远程数据库 [name][type] 连接性
- **标签**: Database

##### 删除远程数据库
- **端点**: `POST /databases/db/del`
- **描述**: 删除远程数据库
- **请求体**: `dto.DatabaseDelete`
- **日志格式**: 删除远程数据库 [names]
- **标签**: Database

##### 列出数据库项
- **端点**: `GET /databases/db/item/:type`
- **描述**: 列出数据库项
- **响应**: `dto.DatabaseItem[]`
- **标签**: Database

##### 列出数据库选项
- **端点**: `GET /databases/db/list/:type`
- **描述**: 列出数据库选项
- **响应**: `dto.DatabaseOption[]`
- **标签**: Database

##### 分页查询数据库
- **端点**: `POST /databases/db/search`
- **描述**: 分页查询数据库
- **请求体**: `dto.DatabaseSearch`
- **响应**: `dto.PageResult`
- **标签**: Database

##### 更新数据库
- **端点**: `POST /databases/db/update`
- **描述**: 更新数据库
- **请求体**: `dto.DatabaseUpdate`
- **日志格式**: 更新远程数据库 [name]
- **标签**: Database

### 8. 网站管理 (Website)

#### 网站基本操作

##### 根据ID查询网站
- **端点**: `GET /websites/:id`
- **描述**: 根据ID查询网站
- **参数**: id (路径参数, 整数)
- **响应**: `response.WebsiteDTO`
- **标签**: Website

##### 根据ID查询网站Nginx配置
- **端点**: `GET /websites/:id/config/:type`
- **描述**: 根据ID查询网站Nginx配置
- **参数**: id (路径参数, 整数)
- **响应**: `response.FileInfo`
- **标签**: Website Nginx

#### HTTPS 配置

##### 加载HTTPS配置
- **端点**: `GET /websites/:id/https`
- **描述**: 加载HTTPS配置
- **参数**: id (路径参数, 整数)
- **响应**: `response.WebsiteHTTPS`
- **标签**: Website HTTPS

##### 更新HTTPS配置
- **端点**: `POST /websites/:id/https`
- **描述**: 更新HTTPS配置
- **请求体**: `request.WebsiteHTTPSOp`
- **响应**: `response.WebsiteHTTPS`
- **日志格式**: 更新网站 [domain] https 配置
- **标签**: Website HTTPS

#### ACME 账户管理

##### 创建网站ACME账户
- **端点**: `POST /websites/acme`
- **描述**: 创建网站ACME账户
- **请求体**: `request.WebsiteAcmeAccountCreate`
- **响应**: `response.WebsiteAcmeAccountDTO`
- **标签**: Website Acme

##### 删除ACME账户
- **端点**: `POST /websites/acme/del`
- **描述**: 删除ACME账户
- **请求体**: `dto.OperateByID`
- **标签**: Website Acme

##### 搜索ACME账户
- **端点**: `POST /websites/acme/search`
- **描述**: 搜索ACME账户
- **请求体**: `dto.SearchWithPage`
- **响应**: `dto.PageResult`
- **标签**: Website Acme

#### CA 证书管理

##### 创建CA证书
- **端点**: `POST /websites/ca`
- **描述**: 创建CA证书
- **请求体**: `request.WebsiteCACreate`
- **响应**: `response.WebsiteCADTO`
- **标签**: Website CA

##### 删除CA证书
- **端点**: `POST /websites/ca/del`
- **描述**: 删除CA证书
- **请求体**: `dto.OperateByID`
- **标签**: Website CA

##### 下载CA证书
- **端点**: `POST /websites/ca/download`
- **描述**: 下载CA证书
- **请求体**: `request.WebsiteResourceReq`
- **标签**: Website CA

##### 获取CA证书
- **端点**: `POST /websites/ca/obtain`
- **描述**: 获取CA证书
- **请求体**: `request.WebsiteCAObtain`
- **响应**: `response.WebsiteCADTO`
- **标签**: Website CA

##### 续订CA证书
- **端点**: `POST /websites/ca/renew`
- **描述**: 续订CA证书
- **请求体**: `request.WebsiteCARenew`
- **响应**: `response.WebsiteCADTO`
- **标签**: Website CA

##### 搜索CA证书
- **端点**: `POST /websites/ca/search`
- **描述**: 搜索CA证书
- **请求体**: `dto.SearchWithPage`
- **响应**: `dto.PageResult`
- **标签**: Website CA

##### 根据ID获取CA证书
- **端点**: `GET /websites/ca/{id}`
- **描述**: 根据ID获取CA证书
- **参数**: id (路径参数)
- **响应**: `response.WebsiteCADTO`
- **标签**: Website CA

#### 网站基本管理

##### 检查网站
- **端点**: `POST /websites/check`
- **描述**: 检查网站
- **请求体**: `request.WebsiteCheck`
- **响应**: `response.WebsiteCheckRes`
- **标签**: Website

##### 获取网站配置
- **端点**: `GET /websites/config`
- **描述**: 获取网站配置
- **响应**: `response.WebsiteConfig`
- **标签**: Website

##### 更新网站配置
- **端点**: `POST /websites/config/update`
- **描述**: 更新网站配置
- **请求体**: `request.WebsiteConfigUpdate`
- **日志格式**: 更新网站配置 [id]
- **标签**: Website

##### 获取网站数据库
- **端点**: `POST /websites/databases`
- **描述**: 获取网站数据库
- **请求体**: `request.WebsiteDatabasesReq`
- **响应**: `response.WebsiteDatabasesRes`
- **标签**: Website

##### 获取默认HTML页面
- **端点**: `GET /websites/default/html/:type`
- **描述**: 获取默认HTML页面
- **参数**: type (路径参数)
- **响应**: `string`
- **标签**: Website

##### 更新默认HTML页面
- **端点**: `POST /websites/default/html/update`
- **描述**: 更新默认HTML页面
- **请求体**: `request.WebsiteDefaultHTMLUpdate`
- **日志格式**: 更新默认页面 [type]
- **标签**: Website

##### 获取默认服务器配置
- **端点**: `GET /websites/default/server`
- **描述**: 获取默认服务器配置
- **响应**: `response.WebsiteDefaultServer`
- **标签**: Website

##### 删除网站
- **端点**: `POST /websites/del`
- **描述**: 删除网站
- **请求体**: `request.WebsiteDelete`
- **日志格式**: 删除网站 [domains]
- **标签**: Website

##### 获取网站目录
- **端点**: `POST /websites/dir`
- **描述**: 获取网站目录
- **请求体**: `request.WebsiteDirReq`
- **响应**: `response.WebsiteDirRes`
- **标签**: Website

##### 获取目录权限
- **端点**: `POST /websites/dir/permission`
- **描述**: 获取目录权限
- **请求体**: `request.WebsiteDirPermissionReq`
- **响应**: `response.WebsiteDirPermissionRes`
- **标签**: Website

##### 更新网站目录
- **端点**: `POST /websites/dir/update`
- **描述**: 更新网站目录
- **请求体**: `request.WebsiteDirUpdate`
- **日志格式**: 更新网站目录 [id]
- **标签**: Website

#### DNS 管理

##### 创建DNS记录
- **端点**: `POST /websites/dns`
- **描述**: 创建DNS记录
- **请求体**: `request.WebsiteDNSCreate`
- **响应**: `response.WebsiteDNSDTO`
- **标签**: Website DNS

##### 删除DNS记录
- **端点**: `POST /websites/dns/del`
- **描述**: 删除DNS记录
- **请求体**: `dto.OperateByID`
- **标签**: Website DNS

##### 搜索DNS记录
- **端点**: `POST /websites/dns/search`
- **描述**: 搜索DNS记录
- **请求体**: `dto.SearchWithPage`
- **响应**: `dto.PageResult`
- **标签**: Website DNS

##### 更新DNS记录
- **端点**: `POST /websites/dns/update`
- **描述**: 更新DNS记录
- **请求体**: `request.WebsiteDNSUpdate`
- **日志格式**: 更新DNS记录 [id]
- **标签**: Website DNS

#### 域名管理

##### 获取域名
- **端点**: `POST /websites/domains`
- **描述**: 获取域名
- **请求体**: `request.WebsiteDomainsReq`
- **响应**: `response.WebsiteDomainsRes`
- **标签**: Website Domain

##### 根据网站ID获取域名
- **端点**: `GET /websites/domains/:websiteId`
- **描述**: 根据网站ID获取域名
- **参数**: websiteId (路径参数)
- **响应**: `response.WebsiteDomainsRes`
- **标签**: Website Domain

##### 删除域名
- **端点**: `POST /websites/domains/del`
- **描述**: 删除域名
- **请求体**: `request.WebsiteDomainsDel`
- **日志格式**: 删除域名 [ids]
- **标签**: Website Domain

##### 更新域名
- **端点**: `POST /websites/domains/update`
- **描述**: 更新域名
- **请求体**: `request.WebsiteDomainsUpdate`
- **日志格式**: 更新域名 [id]
- **标签**: Website Domain

#### 负载均衡

##### 获取负载均衡配置
- **端点**: `POST /websites/lbs`
- **描述**: 获取负载均衡配置
- **请求体**: `request.WebsiteLbsReq`
- **响应**: `response.WebsiteLbsRes`
- **标签**: Website Lb

##### 创建负载均衡
- **端点**: `POST /websites/lbs/create`
- **描述**: 创建负载均衡
- **请求体**: `request.WebsiteLbCreate`
- **日志格式**: 创建负载均衡 [id]
- **标签**: Website Lb

##### 删除负载均衡
- **端点**: `POST /websites/lbs/delete`
- **描述**: 删除负载均衡
- **请求体**: `request.WebsiteLbDelete`
- **日志格式**: 删除负载均衡 [ids]
- **标签**: Website Lb

##### 获取负载均衡文件
- **端点**: `POST /websites/lbs/file`
- **描述**: 获取负载均衡文件
- **请求体**: `request.WebsiteLbFileReq`
- **响应**: `string`
- **标签**: Website Lb

##### 更新负载均衡
- **端点**: `POST /websites/lbs/update`
- **描述**: 更新负载均衡
- **请求体**: `request.WebsiteLbUpdate`
- **日志格式**: 更新负载均衡 [id]
- **标签**: Website Lb

#### 防盗链

##### 获取防盗链配置
- **端点**: `POST /websites/leech`
- **描述**: 获取防盗链配置
- **请求体**: `request.WebsiteLeechReq`
- **响应**: `response.WebsiteLeechRes`
- **标签**: Website Leech

##### 更新防盗链配置
- **端点**: `POST /websites/leech/update`
- **描述**: 更新防盗链配置
- **请求体**: `request.WebsiteLeechUpdate`
- **日志格式**: 更新防盗链配置 [id]
- **标签**: Website Leech

#### 网站列表

##### 获取网站列表
- **端点**: `GET /websites/list`
- **描述**: 获取网站列表
- **响应**: `response.WebsiteDTO[]`
- **标签**: Website

##### 获取网站日志
- **端点**: `POST /websites/log`
- **描述**: 获取网站日志
- **请求体**: `request.WebsiteLogReq`
- **响应**: `response.WebsiteLogRes`
- **标签**: Website

##### 更新Nginx配置
- **端点**: `POST /websites/nginx/update`
- **描述**: 更新Nginx配置
- **请求体**: `request.WebsiteNginxUpdate`
- **日志格式**: 更新网站 [id] Nginx 配置
- **标签**: Website Nginx

##### 操作网站
- **端点**: `POST /websites/operate`
- **描述**: 操作网站（启动/停止/重启等）
- **请求体**: `request.WebsiteOperate`
- **日志格式**: [operate] 网站 [domain]
- **标签**: Website

##### 获取网站选项
- **端点**: `GET /websites/options`
- **描述**: 获取网站选项
- **响应**: `response.WebsiteOption[]`
- **标签**: Website

##### 获取PHP版本
- **端点**: `GET /websites/php/version`
- **描述**: 获取PHP版本
- **响应**: `string[]`
- **标签**: Website PHP

#### 代理管理

##### 获取代理配置
- **端点**: `POST /websites/proxies`
- **描述**: 获取代理配置
- **请求体**: `request.WebsiteProxiesReq`
- **响应**: `response.WebsiteProxiesRes`
- **标签**: Website Proxy

##### 更新代理配置
- **端点**: `POST /websites/proxies/update`
- **描述**: 更新代理配置
- **请求体**: `request.WebsiteProxiesUpdate`
- **日志格式**: 更新代理配置 [id]
- **标签**: Website Proxy

##### 清除代理缓存
- **端点**: `POST /websites/proxy/clear`
- **描述**: 清除代理缓存
- **请求体**: `request.WebsiteProxyClear`
- **日志格式**: 清除代理缓存 [id]
- **标签**: Website Proxy

##### 获取代理配置文件
- **端点**: `POST /websites/proxy/config`
- **描述**: 获取代理配置文件
- **请求体**: `request.WebsiteProxyConfigReq`
- **响应**: `string`
- **标签**: Website Proxy

##### 根据ID获取代理配置
- **端点**: `GET /websites/proxy/config/{id}`
- **描述**: 根据ID获取代理配置
- **参数**: id (路径参数)
- **响应**: `response.WebsiteProxyConfigDTO`
- **标签**: Website Proxy

##### 获取代理文件
- **端点**: `POST /websites/proxy/file`
- **描述**: 获取代理文件
- **请求体**: `request.WebsiteProxyFileReq`
- **响应**: `string`
- **标签**: Website Proxy

#### 真实IP

##### 获取真实IP配置
- **端点**: `POST /websites/realip`
- **描述**: 获取真实IP配置
- **请求体**: `request.WebsiteRealIPReq`
- **响应**: `response.WebsiteRealIPRes`
- **标签**: Website RealIP

##### 根据ID获取真实IP配置
- **端点**: `GET /websites/realip/config/{id}`
- **描述**: 根据ID获取真实IP配置
- **参数**: id (路径参数)
- **响应**: `response.WebsiteRealIPConfigDTO`
- **标签**: Website RealIP

#### 重定向

##### 获取重定向配置
- **端点**: `POST /websites/redirect`
- **描述**: 获取重定向配置
- **请求体**: `request.WebsiteRedirectReq`
- **响应**: `response.WebsiteRedirectRes`
- **标签**: Website Redirect

##### 获取重定向文件
- **端点**: `POST /websites/redirect/file`
- **描述**: 获取重定向文件
- **请求体**: `request.WebsiteRedirectFileReq`
- **响应**: `string`
- **标签**: Website Redirect

##### 更新重定向配置
- **端点**: `POST /websites/redirect/update`
- **描述**: 更新重定向配置
- **请求体**: `request.WebsiteRedirectUpdate`
- **日志格式**: 更新重定向配置 [id]
- **标签**: Website Redirect

##### 根据ID获取网站资源
- **端点**: `GET /websites/resource/{id}`
- **描述**: 根据ID获取网站资源
- **参数**: id (路径参数)
- **响应**: `response.WebsiteResourceDTO`
- **标签**: Website

#### 重写规则

##### 获取重写规则
- **端点**: `POST /websites/rewrite`
- **描述**: 获取重写规则
- **请求体**: `request.WebsiteRewriteReq`
- **响应**: `response.WebsiteRewriteRes`
- **标签**: Website Rewrite

##### 获取自定义重写规则
- **端点**: `POST /websites/rewrite/custom`
- **描述**: 获取自定义重写规则
- **请求体**: `request.WebsiteRewriteCustomReq`
- **响应**: `response.WebsiteRewriteCustomRes`
- **标签**: Website Rewrite

##### 更新重写规则
- **端点**: `POST /websites/rewrite/update`
- **描述**: 更新重写规则
- **请求体**: `request.WebsiteRewriteUpdate`
- **日志格式**: 更新重写规则 [id]
- **标签**: Website Rewrite

#### 网站搜索

##### 搜索网站
- **端点**: `POST /websites/search`
- **描述**: 分页搜索网站
- **请求体**: `request.WebsiteSearch`
- **响应**: `dto.PageResult`
- **标签**: Website

#### SSL 证书管理

##### 创建网站SSL证书
- **端点**: `POST /websites/ssl`
- **描述**: 创建网站SSL证书
- **请求体**: `request.WebsiteSSLCreate`
- **响应**: `request.WebsiteSSLCreate`
- **日志格式**: 创建网站 ssl [primaryDomain]
- **标签**: Website SSL

##### 根据ID获取SSL证书
- **端点**: `GET /websites/ssl/:id`
- **描述**: 根据ID获取SSL证书
- **参数**: id (路径参数, 整数)
- **响应**: `response.WebsiteSSLDTO`
- **标签**: Website SSL

##### 删除SSL证书
- **端点**: `POST /websites/ssl/del`
- **描述**: 删除SSL证书
- **请求体**: `request.WebsiteBatchDelReq`
- **日志格式**: 删除 ssl [domain]
- **标签**: Website SSL

##### 下载SSL证书
- **端点**: `POST /websites/ssl/download`
- **描述**: 下载SSL证书
- **请求体**: `request.WebsiteResourceReq`
- **日志格式**: 下载证书文件 [domain]
- **标签**: Website SSL

##### 申请SSL证书
- **端点**: `POST /websites/ssl/obtain`
- **描述**: 申请SSL证书
- **请求体**: `request.WebsiteSSLApply`
- **日志格式**: 申请证书 [domain]
- **标签**: Website SSL

##### 解析网站SSL
- **端点**: `POST /websites/ssl/resolve`
- **描述**: 解析网站SSL
- **请求体**: `request.WebsiteDNSReq`
- **响应**: `response.WebsiteDNSRes[]`
- **标签**: Website SSL

##### 搜索SSL证书
- **端点**: `POST /websites/ssl/search`
- **描述**: 分页搜索SSL证书
- **请求体**: `request.WebsiteSSLSearch`
- **响应**: `response.WebsiteSSLDTO[]`
- **标签**: Website SSL

##### 更新SSL证书
- **端点**: `POST /websites/ssl/update`
- **描述**: 更新SSL证书
- **请求体**: `request.WebsiteSSLUpdate`
- **日志格式**: 更新SSL证书 [domain]
- **标签**: Website SSL

##### 上传SSL证书
- **端点**: `POST /websites/ssl/upload`
- **描述**: 上传SSL证书
- **请求体**: `request.WebsiteSSLUpload`
- **响应**: `response.WebsiteSSLDTO`
- **标签**: Website SSL

##### 根据网站ID获取SSL证书
- **端点**: `GET /websites/ssl/website/:websiteId`
- **描述**: 根据网站ID获取SSL证书
- **参数**: websiteId (路径参数)
- **响应**: `response.WebsiteSSLDTO[]`
- **标签**: Website SSL

#### 网站更新

##### 更新网站
- **端点**: `POST /websites/update`
- **描述**: 更新网站
- **请求体**: `request.WebsiteUpdate`
- **日志格式**: 更新网站 [id]
- **标签**: Website

## 数据模型

### 通用数据传输对象 (DTO)

#### 分页结果
```json
{
  "total": "总数",
  "items": "数据项列表"
}
```

#### 操作请求
```json
{
  "id": "操作对象ID"
}
```

#### 分页查询
```json
{
  "page": "页码",
  "pageSize": "每页大小",
  "info": "查询条件"
}
```

### 组管理相关

#### 组创建请求
```json
{
  "name": "组名称",
  "type": "组类型"
}
```

#### 组更新请求
```json
{
  "id": "组ID",
  "name": "组名称",
  "type": "组类型"
}
```

### AI 相关

#### Ollama 模型名称
```json
{
  "name": "模型名称"
}
```

#### 强制删除请求
```json
{
  "ids": ["ID列表"],
  "force": "是否强制删除"
}
```

### 应用相关

#### 应用安装创建请求
```json
{
  "name": "应用名称",
  "appId": "应用ID",
  "params": "安装参数"
}
```

#### 应用配置更新请求
```json
{
  "installID": "安装ID",
  "webUI": "Web界面配置"
}
```

### 备份相关

#### 备份操作请求
```json
{
  "type": "备份类型",
  "name": "备份名称"
}
```

#### 通用备份请求
```json
{
  "type": "备份类型",
  "name": "备份名称",
  "detailName": "详细名称"
}
```

#### 应用管理相关模型

##### AppInstallInfo
应用安装信息模型：
- id: 应用ID
- key: 应用键
- name: 应用名称

##### AppConfigVersion
应用配置版本模型：
- name: 名称
- lastModified: 最后修改时间
- downloadUrl: 下载URL
- downloadCallBackUrl: 下载回调URL
- additionalProperties: 额外属性

##### AppDefine
应用定义模型：
- name: 名称
- icon: 图标
- readMe: 说明文档
- lastModified: 最后修改时间
- versions: 版本列表
- additionalProperties: 额外属性

##### AppProperty
应用属性模型：
- key: 键
- Required: 必需项
- architectures: 支持架构
- crossVersionUpdate: 跨版本更新
- description: 描述
- document: 文档
- github: GitHub地址
- gpuSupport: GPU支持
- limit: 限制
- memoryRequired: 内存需求

##### AppList
应用列表模型：
- apps: 应用列表
- lastModified: 最后修改时间
- valid: 是否有效
- violations: 违规项
- additionalProperties: 额外属性

##### AppDTO
应用数据传输对象：
- id: 应用ID
- key: 应用键
- name: 应用名称
- description: 描述
- shortDescEn: 英文简短描述
- shortDescZh: 中文简短描述
- icon: 图标
- type: 类型
- resource: 资源
- status: 状态
- architectures: 支持架构
- github: GitHub地址
- document: 文档
- gpuSupport: GPU支持
- memoryRequired: 内存需求
- limit: 限制
- recommend: 推荐
- required: 必需项
- requiredPanelVersion: 需要的面板版本
- crossVersionUpdate: 跨版本更新
- lastModified: 最后修改时间
- readMe: 说明文档
- installed: 是否已安装
- tags: 标签列表

##### AppConfig
应用配置模型：
- type: 类型
- webUI: Web界面
- containerName: 容器名称
- dockerCompose: Docker Compose配置
- editCompose: 编辑Compose
- pullImage: 拉取镜像
- allowPort: 允许端口
- hostMode: 主机模式
- advanced: 高级选项
- gpuConfig: GPU配置
- memoryLimit: 内存限制
- memoryUnit: 内存单位
- cpuQuota: CPU配额
- params: 参数列表

##### AppParam
应用参数模型：
- key: 键
- label: 标签
- type: 类型
- value: 值
- defaultValue: 默认值
- description: 描述
- required: 是否必需
- options: 选项列表

##### RuntimeDTO
运行时数据传输对象：
- id: 运行时ID
- appID: 应用ID
- appDetailID: 应用详情ID
- name: 名称
- type: 类型
- status: 状态
- image: 镜像
- version: 版本
- path: 路径
- codeDir: 代码目录
- port: 端口
- source: 来源
- resource: 资源
- message: 消息
- containerStatus: 容器状态
- createdAt: 创建时间
- environments: 环境变量列表
- exposedPorts: 暴露端口列表
- volumes: 卷列表
- appParams: 应用参数列表
- params: 参数映射

##### TagDTO
标签数据传输对象：
- id: 标签ID
- key: 标签键
- name: 标签名称

#### 文件管理相关模型

##### FileInfo
文件信息模型：
- name: 文件名
- path: 文件路径
- size: 文件大小
- isDir: 是否为目录
- isHidden: 是否为隐藏文件
- isSymlink: 是否为符号链接
- modTime: 修改时间
- mode: 文件权限
- user: 文件所有者
- group: 文件所属组
- mimeType: MIME类型
- content: 文件内容
- items: 子项列表（目录时使用）
- linkPath: 链接路径（符号链接时使用）

##### FileCreate
文件创建请求模型：
- path: 文件路径
- content: 文件内容
- isDir: 是否为目录
- isLink: 是否为链接
- isSymlink: 是否为符号链接
- linkPath: 链接路径
- mode: 权限模式
- sub: 是否递归创建子目录

##### FileCompress
文件压缩请求模型：
- dst: 目标路径
- files: 要压缩的文件列表
- name: 压缩包名称
- type: 压缩类型
- replace: 是否替换已存在的文件
- secret: 压缩密码

##### FileDeCompress
文件解压缩请求模型：
- dst: 目标路径
- path: 压缩包路径
- type: 解压类型
- secret: 解压密码

##### FileBatchDelete
文件批量删除请求模型：
- paths: 要删除的文件路径列表
- isDir: 是否为目录

##### FavoriteCreate
收藏夹创建请求模型：
- path: 文件路径

##### FavoriteDelete
收藏夹删除请求模型：
- id: 收藏夹ID

##### DirSizeReq
目录大小请求模型：
- path: 目录路径

##### FileContentReq
文件内容请求模型：
- path: 文件路径
- isDetail: 是否显示详细信息

#### 系统管理相关模型

##### ClamCreate
Clam扫描规则创建请求模型：
- name: 规则名称
- path: 扫描路径
- infectedDir: 感染文件目录
- infectedStrategy: 感染文件处理策略
- alertCount: 告警次数
- alertTitle: 告警标题
- description: 描述

##### ClamUpdate
Clam扫描规则更新请求模型：
- id: 规则ID
- name: 规则名称
- path: 扫描路径
- infectedDir: 感染文件目录
- infectedStrategy: 感染文件处理策略
- alertCount: 告警次数
- alertTitle: 告警标题
- description: 描述

##### ClamDelete
Clam扫描规则删除请求模型：
- ids: 规则ID列表
- removeInfected: 是否移除感染文件
- removeRecord: 是否移除记录

##### ClamLogReq
Clam日志请求模型：
- clamName: Clam名称
- recordName: 记录名称
- tail: 日志尾部行数

##### ClamLogSearch
Clam日志搜索请求模型：
- clamID: ClamID
- startTime: 开始时间
- endTime: 结束时间
- page: 页码
- pageSize: 每页大小

##### Clean
清理请求模型：
- name: 清理项名称
- size: 清理大小
- treeType: 树类型

##### CleanData
清理数据模型：
- systemClean: 系统清理项
- systemLogClean: 系统日志清理项
- containerClean: 容器清理项
- downloadClean: 下载清理项
- uploadClean: 上传清理项

##### CleanTree
清理树模型：
- id: ID
- name: 名称
- label: 标签
- size: 大小
- type: 类型
- isCheck: 是否选中
- isRecommend: 是否推荐
- children: 子项列表

##### DeviceBaseInfo
设备基础信息模型：
- hostname: 主机名
- localTime: 本地时间
- timeZone: 时区
- user: 用户
- ntp: NTP服务器
- dns: DNS服务器列表
- hosts: 主机列表
- swapMemoryTotal: 交换内存总量
- swapMemoryUsed: 交换内存使用量
- swapMemoryAvailable: 交换内存可用量
- swapDetails: 交换内存详情
- maxSize: 最大大小

##### DiskInfo
磁盘信息模型：
- device: 设备名称
- path: 挂载路径
- type: 文件系统类型
- total: 总容量
- used: 已使用容量
- free: 可用容量
- usedPercent: 使用百分比
- inodesTotal: inode总数
- inodesUsed: 已使用inode数
- inodesFree: 可用inode数
- inodesUsedPercent: inode使用百分比

#### 容器管理相关模型

##### ContainerCreate
容器创建请求模型，包含容器配置信息：
- image: 镜像名称
- name: 容器名称
- cpuShares: CPU份额
- memory: 内存限制
- volumes: 卷配置
- ports: 端口映射
- env: 环境变量
- network: 网络配置
- restartPolicy: 重启策略

##### ContainerOperation
容器操作请求模型：
- names: 容器名称列表
- operation: 操作类型 (up, start, stop, restart, kill, pause, unpause, remove)

##### ContainerStats
容器状态统计模型：
- cpuPercent: CPU使用率
- memory: 内存使用量
- networkRX: 网络接收流量
- networkTX: 网络发送流量
- ioRead: 磁盘读取量
- ioWrite: 磁盘写入量

#### 数据库管理相关模型

##### DatabaseCreate
数据库创建请求模型：
- name: 数据库名称
- type: 数据库类型
- username: 用户名
- password: 密码
- permission: 权限设置
- characterSet: 字符集
- collation: 排序规则

##### DatabaseUpdate
数据库更新请求模型：
- id: 数据库ID
- type: 数据库类型
- username: 用户名
- password: 密码
- version: 版本
- address: 地址
- port: 端口
- ssl: SSL配置
- description: 描述

##### DatabaseSearch
数据库搜索请求模型：
- type: 数据库类型
- info: 搜索信息
- page: 页码
- pageSize: 每页大小
- orderBy: 排序字段
- order: 排序方式

#### 网站管理相关模型

##### WebsiteCreate
网站创建请求模型：
- primaryDomain: 主域名
- alias: 别名
- type: 网站类型
- siteDir: 网站目录
- runtimeID: 运行环境ID
- remark: 备注

##### WebsiteUpdate
网站更新请求模型：
- id: 网站ID
- primaryDomain: 主域名
- remark: 备注
- webSiteGroupID: 网站组ID
- IPV6: 是否启用IPv6
- expireDate: 到期日期

##### WebsiteHTTPSOp
网站HTTPS操作请求模型：
- id: 网站ID
- enable: 是否启用HTTPS
- http3: 是否启用HTTP3
- hsts: 是否启用HSTS
- SSLProtocol: SSL协议配置
- httpsPort: HTTPS端口

##### WebsiteSSLCreate
网站SSL创建请求模型：
- primaryDomain: 主域名
- domains: 域名列表
- type: SSL类型
- acmeAccountId: ACME账户ID
- dnsAccountId: DNS账户ID
- autoRenew: 是否自动续期

##### WebsiteSSLDTO
网站SSL数据传输对象：
- id: SSL证书ID
- primaryDomain: 主域名
- domains: 域名列表
- type: SSL类型
- provider: 提供商
- startDate: 开始日期
- expireDate: 到期日期
- status: 状态
- autoRenew: 是否自动续期
- acmeAccount: ACME账户信息
- dnsAccount: DNS账户信息

##### WebsiteAcmeAccountDTO
网站ACME账户数据传输对象：
- id: 账户ID
- email: 邮箱
- keyType: 密钥类型
- type: 账户类型
- url: 账户URL
- eabKid: EAB KID
- eabHmacKey: EAB HMAC密钥

##### WebsiteCADTO
网站CA证书数据传输对象：
- id: CA证书ID
- commonName: 通用名称
- organization: 组织
- city: 城市
- country: 国家
- province: 省份

##### WebsiteDTO
网站数据传输对象：
- id: 网站ID
- primaryDomain: 主域名
- alias: 别名
- type: 网站类型
- siteDir: 网站目录
- status: 状态
- runtimeID: 运行环境ID
- runtimeName: 运行环境名称
- webSiteSSL: SSL证书信息
- protocol: 协议
- proxy: 代理配置
- rewrite: 重写规则
- remark: 备注

##### WebsiteOption
网站选项模型：
- id: 网站ID
- primaryDomain: 主域名
- alias: 别名

##### WebsiteHTTPS
网站HTTPS配置模型：
- enable: 是否启用HTTPS
- http3: 是否启用HTTP3
- hsts: 是否启用HSTS
- hstsIncludeSubDomains: 是否包含子域名
- SSLProtocol: SSL协议配置
- httpsPort: HTTPS端口
- httpsPorts: HTTPS端口列表
- algorithm: 算法
- SSL: SSL证书信息

##### WebsiteRealIP
网站真实IP配置模型：
- websiteID: 网站ID
- open: 是否开启
- ipFrom: IP来源
- ipHeader: IP头
- ipOther: 其他IP配置

## 错误处理

API 遵循标准的 HTTP 状态码：
- `200`: 请求成功
- `400`: 请求参数错误
- `401`: 认证失败
- `403`: 权限不足
- `404`: 资源不存在
- `500`: 服务器内部错误

## 使用示例

### 认证
所有 API 请求都需要包含认证信息：
```http
Authorization: Bearer <your-api-key>
Timestamp: <current-timestamp>
```

### 创建系统组
```http
POST /api/v2/agent/groups
Content-Type: application/json

{
  "name": "web-servers",
  "type": "server"
}
```

### 安装应用
```http
POST /api/v2/apps/install
Content-Type: application/json

{
  "name": "nginx",
  "appId": 1,
  "params": {
    "port": 80,
    "domain": "example.com"
  }
}
```

### 备份数据
```http
POST /api/v2/backups/backup
Content-Type: application/json

{
  "type": "mysql",
  "name": "database-backup",
  "detailName": "daily-backup"
}
```

## 注意事项

1. **认证**: 所有 API 请求都需要有效的 API 密钥和时间戳
2. **日志记录**: 大部分操作都会记录操作日志，包含中英文格式
3. **分页**: 列表查询接口支持分页，使用标准的分页参数
4. **错误处理**: 请根据 HTTP 状态码和响应内容处理错误情况
5. **版本兼容**: 当前文档基于 API v2.0 版本

## 更新日志

- **v2.0**: 初始版本，包含完整的系统管理功能
- **v2.1**: 新增容器管理功能，支持容器的创建、操作和监控
- **v2.2**: 新增文件管理功能，支持文件的上传、下载、压缩和解压缩
- **v2.3**: 新增数据库管理功能，支持多种数据库类型的创建和管理
- **v2.4**: 新增网站管理功能，支持网站的创建、配置和SSL证书管理
- **v2.5**: 新增应用管理功能，支持应用的安装、配置和运行时管理

## 常见问题

### 1. 如何获取API密钥？
API密钥可以通过系统管理界面生成，每个密钥都有特定的权限和有效期。

### 2. 如何处理分页查询？
所有支持分页的查询接口都使用以下标准参数：
- `page`: 页码，从1开始
- `pageSize`: 每页大小，通常为10、20或50

### 3. 如何处理文件上传？
文件上传需要使用multipart/form-data格式，具体请参考各个文件上传接口的文档。

### 4. 如何处理大文件操作？
对于大文件操作，建议使用异步接口，并通过轮询获取操作状态。

### 5. 如何处理并发请求？
系统支持并发请求，但请注意合理控制并发数量，避免对系统性能造成影响。

## 最佳实践

### 1. 错误处理
```javascript
try {
  const response = await fetch('/api/v2/endpoint', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`,
      'Timestamp': Date.now().toString()
    },
    body: JSON.stringify(data)
  });
  
  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message || 'Request failed');
  }
  
  const result = await response.json();
  // 处理成功响应
} catch (error) {
  // 处理错误
  console.error('API request failed:', error);
}
```

### 2. 分页查询
```javascript
async function fetchPaginatedData(endpoint, params = {}) {
  const defaultParams = {
    page: 1,
    pageSize: 20,
    order: 'ascending',
    orderBy: 'createdAt'
  };
  
  const queryParams = { ...defaultParams, ...params };
  const queryString = new URLSearchParams(queryParams).toString();
  
  const response = await fetch(`/api/v2/${endpoint}?${queryString}`, {
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Timestamp': Date.now().toString()
    }
  });
  
  return response.json();
}
```

### 3. 文件上传
```javascript
async function uploadFile(file, path) {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('path', path);
  
  const response = await fetch('/api/v2/files/upload', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Timestamp': Date.now().toString()
    },
    body: formData
  });
  
  return response.json();
}
```

### 4. 异步操作处理
```javascript
async function handleAsyncOperation(endpoint, data) {
  // 启动异步操作
  const startResponse = await fetch(`/api/v2/${endpoint}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`,
      'Timestamp': Date.now().toString()
    },
    body: JSON.stringify(data)
  });
  
  const startResult = await startResponse.json();
  const taskId = startResult.taskId;
  
  // 轮询任务状态
  let status;
  do {
    await new Promise(resolve => setTimeout(resolve, 1000));
    const statusResponse = await fetch(`/api/v2/tasks/${taskId}/status`, {
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Timestamp': Date.now().toString()
      }
    });
    
    status = await statusResponse.json();
  } while (status.status === 'running');
  
  return status;
}
```

## 联系支持

如果您在使用API时遇到问题，请通过以下方式获取支持：

1. **文档**: 查阅本文档和相关的API参考
2. **社区**: 加入我们的开发者社区，与其他开发者交流
3. **工单**: 提交技术支持工单，获取专业支持
4. **邮件**: 发送邮件至support@example.com

## 许可证

本API文档遵循MIT许可证，详情请参阅LICENSE文件。