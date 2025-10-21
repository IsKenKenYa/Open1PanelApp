---
title: 1PanelV2
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers: []
includes: []
search: true
code_clipboard: true
highlight_theme: darkula
headingLevel: 2
generator: "@tarslib/widdershins v4.0.30"

---

# 1PanelV2

开源Linux面板

Base URLs:

# Authentication

# Default

## POST /containers/download/log

POST /containers/download/log

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load container limits

GET /containers/limit

> 返回示例

> 200 Response

```
{"cpu":0,"memory":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.ResourceLimit](#schemadto.resourcelimit)|

## GET Load container stats

GET /containers/list/stats

> 返回示例

> 200 Response

```
[{"containerID":"string","cpuPercent":0,"cpuTotalUsage":0,"memoryCache":0,"memoryLimit":0,"memoryPercent":0,"memoryUsage":0,"percpuUsage":0,"systemUsage":0}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.ContainerListStats](#schemadto.containerliststats)]|false|none||none|
|» containerID|string|false|none||none|
|» cpuPercent|number|false|none||none|
|» cpuTotalUsage|integer|false|none||none|
|» memoryCache|integer|false|none||none|
|» memoryLimit|integer|false|none||none|
|» memoryPercent|number|false|none||none|
|» memoryUsage|integer|false|none||none|
|» percpuUsage|integer|false|none||none|
|» systemUsage|integer|false|none||none|

## GET Get website proxy cache config

GET /websites/proxy/config/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |id|

> 返回示例

> 200 Response

```
{"cacheExpire":0,"cacheExpireUnit":"string","cacheLimit":0,"cacheLimitUnit":"string","open":true,"shareCache":0,"shareCacheUnit":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxProxyCache](#schemaresponse.nginxproxycache)|

# System Group

## POST Create group

POST /agent/groups

> Body 请求参数

```json
{
  "id": 0,
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GroupCreate](#schemadto.groupcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete group

POST /agent/groups/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List groups

POST /agent/groups/search

> Body 请求参数

```json
{
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GroupSearch](#schemadto.groupsearch)| 是 |none|

> 返回示例

> 200 Response

```
[{"type":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.OperateByType](#schemadto.operatebytype)]|false|none||none|
|» type|string|false|none||none|

## POST Update group

POST /agent/groups/update

> Body 请求参数

```json
{
  "id": 0,
  "isDefault": true,
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GroupUpdate](#schemadto.groupupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create group

POST /core/groups

> Body 请求参数

```json
{
  "id": 0,
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GroupCreate](#schemadto.groupcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete group

POST /core/groups/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List groups

POST /core/groups/search

> Body 请求参数

```json
{
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GroupSearch](#schemadto.groupsearch)| 是 |none|

> 返回示例

> 200 Response

```
[{"type":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.OperateByType](#schemadto.operatebytype)]|false|none||none|
|» type|string|false|none||none|

## POST Update group

POST /core/groups/update

> Body 请求参数

```json
{
  "id": 0,
  "isDefault": true,
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GroupUpdate](#schemadto.groupupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# AI

## POST Bind domain

POST /ai/domain/bind

> Body 请求参数

```json
{
  "appInstallID": 0,
  "domain": "string",
  "ipList": "string",
  "sslID": 0,
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OllamaBindDomain](#schemadto.ollamabinddomain)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get bind domain

POST /ai/domain/get

> Body 请求参数

```json
{
  "appInstallID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OllamaBindDomainReq](#schemadto.ollamabinddomainreq)| 是 |none|

> 返回示例

> 200 Response

```
{"acmeAccountID":0,"allowIPs":["string"],"connUrl":"string","domain":"string","sslID":0,"websiteID":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.OllamaBindDomainRes](#schemadto.ollamabinddomainres)|

## GET Load gpu / xpu info

GET /ai/gpu/load

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create Ollama model

POST /ai/ollama/model

> Body 请求参数

```json
{
  "name": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OllamaModelName](#schemadto.ollamamodelname)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Close Ollama model conn

POST /ai/ollama/model/close

> Body 请求参数

```json
{
  "name": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OllamaModelName](#schemadto.ollamamodelname)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete Ollama model

POST /ai/ollama/model/del

> Body 请求参数

```json
{
  "forceDelete": true,
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ForceDelete](#schemadto.forcedelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page Ollama models

POST /ai/ollama/model/load

> Body 请求参数

```json
{
  "name": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OllamaModelName](#schemadto.ollamamodelname)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Rereate Ollama model

POST /ai/ollama/model/recreate

> Body 请求参数

```json
{
  "name": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OllamaModelName](#schemadto.ollamamodelname)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page Ollama models

POST /ai/ollama/model/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Sync Ollama model list

POST /ai/ollama/model/sync

> 返回示例

> 200 Response

```
[{"id":0,"name":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.OllamaModelDropList](#schemadto.ollamamodeldroplist)]|false|none||none|
|» id|integer|false|none||none|
|» name|string|false|none||none|

# App

## GET Search app by key

GET /apps/{key}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|key|path|string| 是 |app key|

> 返回示例

> 200 Response

```
{"architectures":"string","createdAt":"string","crossVersionUpdate":true,"description":"string","document":"string","github":"string","gpuSupport":true,"icon":"string","id":0,"installed":true,"key":"string","lastModified":0,"limit":0,"memoryRequired":0,"name":"string","readMe":"string","recommend":0,"required":"string","requiredPanelVersion":0,"resource":"string","shortDescEn":"string","shortDescZh":"string","status":"string","tags":[{"id":0,"key":"string","name":"string"}],"type":"string","updatedAt":"string","versions":["string"],"website":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppDTO](#schemaresponse.appdto)|

## GET Get app list update

GET /apps/checkupdate

> 返回示例

> 200 Response

```
{"appList":{"additionalProperties":{"tags":[{"key":"string","locales":{},"name":"string","sort":0}],"version":"string"},"apps":[{"additionalProperties":{"Required":[null],"architectures":[null],"crossVersionUpdate":true,"description":{},"document":"string","github":"string","gpuSupport":true,"key":"string","limit":0,"memoryRequired":0,"name":"string","recommend":0,"shortDescEn":"string","shortDescZh":"string","tags":[null],"type":"string","version":0,"website":"string"},"icon":"string","lastModified":0,"name":"string","readMe":"string","versions":[{"additionalProperties":null,"downloadCallBackUrl":null,"downloadUrl":null,"lastModified":null,"name":null}]}],"lastModified":0,"valid":true,"violations":["string"]},"appStoreLastModified":0,"canUpdate":true,"isSyncing":true}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppUpdateRes](#schemaresponse.appupdateres)|

## GET Search app detail by appid

GET /apps/detail/{appId}/{version}/{type}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|appId|path|integer| 是 |app id|
|version|path|string| 是 |app 版本|
|type|path|string| 是 |none|

> 返回示例

> 200 Response

```
{"appId":0,"architectures":"string","createdAt":"string","dockerCompose":"string","downloadCallBackUrl":"string","downloadUrl":"string","enable":true,"gpuSupport":true,"hostMode":true,"id":0,"ignoreUpgrade":true,"image":"string","lastModified":0,"lastVersion":"string","memoryRequired":0,"params":null,"status":"string","update":true,"updatedAt":"string","version":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppDetailDTO](#schemaresponse.appdetaildto)|

## GET Get app detail by id

GET /apps/details/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|appId|path|integer| 是 |id|
|id|path|string| 是 |none|

> 返回示例

> 200 Response

```
{"appId":0,"architectures":"string","createdAt":"string","dockerCompose":"string","downloadCallBackUrl":"string","downloadUrl":"string","enable":true,"gpuSupport":true,"hostMode":true,"id":0,"ignoreUpgrade":true,"image":"string","lastModified":0,"lastVersion":"string","memoryRequired":0,"params":null,"status":"string","update":true,"updatedAt":"string","version":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppDetailDTO](#schemaresponse.appdetaildto)|

## GET Get Ignore App

GET /apps/ignored

> 返回示例

> 200 Response

```
[{"detailID":0,"icon":"string","name":"string","version":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.IgnoredApp](#schemaresponse.ignoredapp)]|false|none||none|
|» detailID|integer|false|none||none|
|» icon|string|false|none||none|
|» name|string|false|none||none|
|» version|string|false|none||none|

## POST Install app

POST /apps/install

> Body 请求参数

```json
{
  "advanced": true,
  "allowPort": true,
  "appDetailId": 0,
  "containerName": "string",
  "cpuQuota": 0,
  "dockerCompose": "string",
  "editCompose": true,
  "gpuConfig": true,
  "hostMode": true,
  "memoryLimit": 0,
  "memoryUnit": "string",
  "name": "string",
  "params": {},
  "pullImage": true,
  "services": {
    "property1": "string",
    "property2": "string"
  },
  "taskID": "string",
  "type": "string",
  "webUI": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppInstallCreate](#schemarequest.appinstallcreate)| 是 |none|

> 返回示例

> 200 Response

```
{"app":{"architectures":"string","createdAt":"string","crossVersionUpdate":true,"description":"string","document":"string","github":"string","gpuSupport":true,"icon":"string","id":0,"key":"string","lastModified":0,"limit":0,"memoryRequired":0,"name":"string","readMe":"string","recommend":0,"required":"string","requiredPanelVersion":0,"resource":"string","shortDescEn":"string","shortDescZh":"string","status":"string","tags":["string"],"type":"string","updatedAt":"string","website":"string"},"appDetailId":0,"appId":0,"containerName":"string","createdAt":"string","description":"string","dockerCompose":"string","env":"string","httpPort":0,"httpsPort":0,"id":0,"message":"string","name":"string","param":"string","serviceName":"string","status":"string","updatedAt":"string","version":"string","webUI":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[model.AppInstall](#schemamodel.appinstall)|

## POST Check app installed

POST /apps/installed/check

> Body 请求参数

```json
{
  "key": "string",
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppInstalledInfo](#schemarequest.appinstalledinfo)| 是 |none|

> 返回示例

> 200 Response

```
{"app":"string","appInstallId":0,"containerName":"string","createdAt":"string","httpPort":0,"httpsPort":0,"installPath":"string","isExist":true,"lastBackupAt":"string","name":"string","status":"string","version":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppInstalledCheck](#schemaresponse.appinstalledcheck)|

## POST Search default config by key

POST /apps/installed/conf

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Update app config

POST /apps/installed/config/update

> Body 请求参数

```json
{
  "installID": 0,
  "webUI": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppConfigUpdate](#schemarequest.appconfigupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Search app password by key

GET /apps/installed/conninfo/{key}

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|key|path|string| 是 |none|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
{"containerName":"string","password":"string","port":0,"serviceName":"string","status":"string","username":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.DatabaseConn](#schemaresponse.databaseconn)|

## GET Check before delete

GET /apps/installed/delete/check/{appInstallId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|appInstallId|path|integer| 是 |App install id|

> 返回示例

> 200 Response

```
[{"name":"string","type":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.AppResource](#schemadto.appresource)]|false|none||none|
|» name|string|false|none||none|
|» type|string|false|none||none|

## POST ignore App Update

POST /apps/installed/ignore

> Body 请求参数

```json
{
  "detailID": 0,
  "operate": "cancel"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppInstalledIgnoreUpgrade](#schemarequest.appinstalledignoreupgrade)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET List app installed

GET /apps/installed/list

> 返回示例

> 200 Response

```
[{"id":0,"key":"string","name":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.AppInstallInfo](#schemadto.appinstallinfo)]|false|none||none|
|» id|integer|false|none||none|
|» key|string|false|none||none|
|» name|string|false|none||none|

## POST Search app port by key

POST /apps/installed/loadport

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
0
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|integer|

## POST Operate installed app

POST /apps/installed/op

> Body 请求参数

```json
{
  "backup": true,
  "backupId": 0,
  "deleteBackup": true,
  "deleteDB": true,
  "deleteImage": true,
  "detailId": 0,
  "dockerCompose": "string",
  "forceDelete": true,
  "installId": 0,
  "operate": "string",
  "pullImage": true,
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppInstalledOperate](#schemarequest.appinstalledoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Search params by appInstallId

GET /apps/installed/params/{appInstallId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|appInstallId|path|string| 是 |request|

> 返回示例

> 200 Response

```
{"advanced":true,"allowPort":true,"containerName":"string","cpuQuota":0,"dockerCompose":"string","editCompose":true,"gpuConfig":true,"hostMode":true,"memoryLimit":0,"memoryUnit":"string","params":[{"edit":true,"key":"string","labelEn":"string","labelZh":"string","multiple":true,"required":true,"rule":"string","showValue":"string","type":"string","value":null,"values":null}],"pullImage":true,"type":"string","webUI":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppConfig](#schemaresponse.appconfig)|

## POST Change app params

POST /apps/installed/params/update

> Body 请求参数

```json
{
  "advanced": true,
  "allowPort": true,
  "containerName": "string",
  "cpuQuota": 0,
  "dockerCompose": "string",
  "editCompose": true,
  "gpuConfig": true,
  "hostMode": true,
  "installId": 0,
  "memoryLimit": 0,
  "memoryUnit": "string",
  "params": {},
  "pullImage": true,
  "type": "string",
  "webUI": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppInstalledUpdate](#schemarequest.appinstalledupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change app port

POST /apps/installed/port/change

> Body 请求参数

```json
{
  "key": "string",
  "name": "string",
  "port": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PortUpdate](#schemarequest.portupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page app installed

POST /apps/installed/search

> Body 请求参数

```json
{
  "all": true,
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "sync": true,
  "tags": [
    "string"
  ],
  "type": "string",
  "unused": true,
  "update": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppInstalledSearch](#schemarequest.appinstalledsearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Sync app installed

POST /apps/installed/sync

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Search app update version by install id

POST /apps/installed/update/versions

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|appInstallId|path|integer| 是 |request|

> 返回示例

> 200 Response

```
[{"detailId":0,"dockerCompose":"string","version":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.AppVersion](#schemadto.appversion)]|false|none||none|
|» detailId|integer|false|none||none|
|» dockerCompose|string|false|none||none|
|» version|string|false|none||none|

## POST List apps

POST /apps/search

> Body 请求参数

```json
{
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "recommend": true,
  "resource": "string",
  "showCurrentArch": true,
  "tags": [
    "string"
  ],
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppSearch](#schemarequest.appsearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":[{"description":"string","github":"string","gpuSupport":true,"icon":"string","id":0,"installed":true,"key":"string","limit":0,"name":"string","recommend":0,"resource":"string","status":"string","tags":[{"id":0,"key":"string","name":"string"}],"type":"string","versions":["string"],"website":"string"}],"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppRes](#schemaresponse.appres)|

## GET Search app service by key

GET /apps/services/{key}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|key|path|string| 是 |request|

> 返回示例

> 200 Response

```
[{"config":null,"from":"string","label":"string","status":"string","value":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.AppService](#schemaresponse.appservice)]|false|none||none|
|» config|any|false|none||none|
|» from|string|false|none||none|
|» label|string|false|none||none|
|» status|string|false|none||none|
|» value|string|false|none||none|

## GET Get appstore config

GET /apps/store/config

> 返回示例

> 200 Response

```
{"defaultDomain":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.AppstoreConfig](#schemaresponse.appstoreconfig)|

## POST Update appstore config

POST /apps/store/update

> Body 请求参数

```json
{
  "defaultDomain": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.AppstoreUpdate](#schemarequest.appstoreupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Sync local  app list

POST /apps/sync/local

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Sync remote app list

POST /apps/sync/remote

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Backup Account

## POST Download backup record

POST /backup/record/download

> Body 请求参数

```json
{
  "downloadAccountID": 0,
  "fileDir": "string",
  "fileName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DownloadRecord](#schemadto.downloadrecord)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Create backup account

POST /backups

> Body 请求参数

```json
{
  "accessKey": "string",
  "backupPath": "string",
  "bucket": "string",
  "credential": "string",
  "id": 0,
  "isPublic": true,
  "name": "string",
  "rememberAuth": true,
  "type": "string",
  "vars": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BackupOperate](#schemadto.backupoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Backup system data

POST /backups/backup

> Body 请求参数

```json
{
  "detailName": "string",
  "fileName": "string",
  "name": "string",
  "secret": "string",
  "taskID": "string",
  "type": "app"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CommonBackup](#schemadto.commonbackup)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete backup account

POST /backups/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET get local backup dir

GET /backups/local

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## GET Load backup account options

GET /backups/options

> 返回示例

> 200 Response

```
[{"id":0,"isPublic":true,"name":"string","type":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.BackupOption](#schemadto.backupoption)]|false|none||none|
|» id|integer|false|none||none|
|» isPublic|boolean|false|none||none|
|» name|string|false|none||none|
|» type|string|false|none||none|

## POST Page backup records

POST /backups/record/search

> Body 请求参数

```json
{
  "detailName": "string",
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.RecordSearch](#schemadto.recordsearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Page backup records by cronjob

POST /backups/record/search/bycronjob

> Body 请求参数

```json
{
  "cronjobID": 0,
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.RecordSearchByCronjob](#schemadto.recordsearchbycronjob)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Load backup record size

POST /backups/record/size

> Body 请求参数

```json
{
  "cronjobID": 0,
  "detailName": "string",
  "info": "string",
  "name": "string",
  "order": "string",
  "orderBy": "string",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchForSize](#schemadto.searchforsize)| 是 |none|

> 返回示例

> 200 Response

```
[{"id":0,"name":"string","size":0}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.RecordFileSize](#schemadto.recordfilesize)]|false|none||none|
|» id|integer|false|none||none|
|» name|string|false|none||none|
|» size|integer|false|none||none|

## POST Recover system data

POST /backups/recover

> Body 请求参数

```json
{
  "backupRecordID": 0,
  "detailName": "string",
  "downloadAccountID": 0,
  "file": "string",
  "name": "string",
  "secret": "string",
  "taskID": "string",
  "type": "app"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CommonRecover](#schemadto.commonrecover)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Recover system data by upload

POST /backups/recover/byupload

> Body 请求参数

```json
{
  "backupRecordID": 0,
  "detailName": "string",
  "downloadAccountID": 0,
  "file": "string",
  "name": "string",
  "secret": "string",
  "taskID": "string",
  "type": "app"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CommonRecover](#schemadto.commonrecover)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Refresh token

POST /backups/refresh/token

> Body 请求参数

```json
{
  "accessKey": "string",
  "backupPath": "string",
  "bucket": "string",
  "credential": "string",
  "id": 0,
  "isPublic": true,
  "name": "string",
  "rememberAuth": true,
  "type": "string",
  "vars": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BackupOperate](#schemadto.backupoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Search backup accounts with page

POST /backups/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchPageWithType](#schemadto.searchpagewithtype)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List files from backup accounts

POST /backups/search/files

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update backup account

POST /backups/update

> Body 请求参数

```json
{
  "accessKey": "string",
  "backupPath": "string",
  "bucket": "string",
  "credential": "string",
  "id": 0,
  "isPublic": true,
  "name": "string",
  "rememberAuth": true,
  "type": "string",
  "vars": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BackupOperate](#schemadto.backupoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List buckets

POST /buckets

> Body 请求参数

```json
{
  "accessKey": "string",
  "credential": "string",
  "type": "string",
  "vars": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ForBuckets](#schemadto.forbuckets)| 是 |none|

> 返回示例

> 200 Response

```
[{}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Create backup account

POST /core/backups

> Body 请求参数

```json
{
  "accessKey": "string",
  "backupPath": "string",
  "bucket": "string",
  "credential": "string",
  "id": 0,
  "isPublic": true,
  "name": "string",
  "rememberAuth": true,
  "type": "string",
  "vars": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BackupOperate](#schemadto.backupoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List buckets

POST /core/backups/buckets

> Body 请求参数

```json
{
  "accessKey": "string",
  "credential": "string",
  "type": "string",
  "vars": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ForBuckets](#schemadto.forbuckets)| 是 |none|

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## GET Load backup account base info

GET /core/backups/client/{clientType}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|clientType|path|string| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Delete backup account

POST /core/backups/del

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Refresh token

POST /core/backups/refresh/token

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update backup account

POST /core/backups/update

> Body 请求参数

```json
{
  "accessKey": "string",
  "backupPath": "string",
  "bucket": "string",
  "credential": "string",
  "id": 0,
  "isPublic": true,
  "name": "string",
  "rememberAuth": true,
  "type": "string",
  "vars": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BackupOperate](#schemadto.backupoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete backup record

POST /record/del

> Body 请求参数

```json
{
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchDeleteReq](#schemadto.batchdeletereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Container

## POST Create container

POST /containers

> Body 请求参数

```json
{
  "autoRemove": true,
  "cmd": [
    "string"
  ],
  "containerID": "string",
  "cpuShares": 0,
  "dns": [
    "string"
  ],
  "domainName": "string",
  "entrypoint": [
    "string"
  ],
  "env": [
    "string"
  ],
  "exposedPorts": [
    {
      "containerPort": "string",
      "hostIP": "string",
      "hostPort": "string",
      "protocol": "string"
    }
  ],
  "forcePull": true,
  "hostname": "string",
  "image": "string",
  "ipv4": "string",
  "ipv6": "string",
  "labels": [
    "string"
  ],
  "macAddr": "string",
  "memory": 0,
  "name": "string",
  "nanoCPUs": 0,
  "network": "string",
  "openStdin": true,
  "privileged": true,
  "publishAllPorts": true,
  "restartPolicy": "string",
  "taskID": "string",
  "tty": true,
  "user": "string",
  "volumes": [
    {
      "containerDir": "string",
      "mode": "string",
      "sourceDir": "string",
      "type": "string"
    }
  ],
  "workingDir": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerOperate](#schemadto.containeroperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Clean container log

POST /containers/clean/log

> Body 请求参数

```json
{
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithName](#schemadto.operationwithname)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create container by command

POST /containers/command

> Body 请求参数

```json
{
  "command": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerCreateByCommand](#schemadto.containercreatebycommand)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Commit Container

POST /containers/commit

> Body 请求参数

```json
{
  "author": "string",
  "comment": "string",
  "containerID": "string",
  "containerName": "string",
  "newImageName": "string",
  "pause": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerCommit](#schemadto.containercommit)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load container info

POST /containers/info

> Body 请求参数

```json
{
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithName](#schemadto.operationwithname)| 是 |none|

> 返回示例

> 200 Response

```
{"autoRemove":true,"cmd":["string"],"containerID":"string","cpuShares":0,"dns":["string"],"domainName":"string","entrypoint":["string"],"env":["string"],"exposedPorts":[{"containerPort":"string","hostIP":"string","hostPort":"string","protocol":"string"}],"forcePull":true,"hostname":"string","image":"string","ipv4":"string","ipv6":"string","labels":["string"],"macAddr":"string","memory":0,"name":"string","nanoCPUs":0,"network":"string","openStdin":true,"privileged":true,"publishAllPorts":true,"restartPolicy":"string","taskID":"string","tty":true,"user":"string","volumes":[{"containerDir":"string","mode":"string","sourceDir":"string","type":"string"}],"workingDir":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.ContainerOperate](#schemadto.containeroperate)|

## POST Container inspect

POST /containers/inspect

> Body 请求参数

```json
{
  "id": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.InspectReq](#schemadto.inspectreq)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST List containers

POST /containers/list

> 返回示例

> 200 Response

```json
[
  "string"
]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Operate Container

POST /containers/operate

> Body 请求参数

```json
{
  "names": [
    "string"
  ],
  "operation": "up"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerOperation](#schemadto.containeroperation)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Clean container

POST /containers/prune

> Body 请求参数

```json
{
  "pruneType": "container",
  "withTagAll": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerPrune](#schemadto.containerprune)| 是 |none|

> 返回示例

> 200 Response

```
{"deletedNumber":0,"spaceReclaimed":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.ContainerPruneReport](#schemadto.containerprunereport)|

## POST Rename Container

POST /containers/rename

> Body 请求参数

```json
{
  "name": "string",
  "newName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerRename](#schemadto.containerrename)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page containers

POST /containers/search

> Body 请求参数

```json
{
  "excludeAppStore": true,
  "filters": "string",
  "name": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0,
  "state": "all"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageContainer](#schemadto.pagecontainer)| 是 |none|

> 返回示例

> 200 Response

```json
{
  "items": null,
  "total": 0
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Container logs

POST /containers/search/log

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|container|query|string| 否 |容器名称|
|since|query|string| 否 |时间筛选|
|follow|query|string| 否 |是否追踪|
|tail|query|string| 否 |显示行号|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Container stats

GET /containers/stats/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |容器id|

> 返回示例

> 200 Response

```
{"cache":0,"cpuPercent":0,"ioRead":0,"ioWrite":0,"memory":0,"networkRX":0,"networkTX":0,"shotTime":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.ContainerStats](#schemadto.containerstats)|

## GET Load containers status

GET /containers/status

> 返回示例

> 200 Response

```json
{
  "all": 0,
  "composeCount": 0,
  "composeTemplateCount": 0,
  "containerCount": 0,
  "created": 0,
  "dead": 0,
  "exited": 0,
  "imageCount": 0,
  "imageSize": 0,
  "networkCount": 0,
  "paused": 0,
  "removing": 0,
  "repoCount": 0,
  "restarting": 0,
  "running": 0,
  "volumeCount": 0
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.ContainerStatus](#schemadto.containerstatus)|

## POST Update container

POST /containers/update

> Body 请求参数

```json
{
  "autoRemove": true,
  "cmd": [
    "string"
  ],
  "containerID": "string",
  "cpuShares": 0,
  "dns": [
    "string"
  ],
  "domainName": "string",
  "entrypoint": [
    "string"
  ],
  "env": [
    "string"
  ],
  "exposedPorts": [
    {
      "containerPort": "string",
      "hostIP": "string",
      "hostPort": "string",
      "protocol": "string"
    }
  ],
  "forcePull": true,
  "hostname": "string",
  "image": "string",
  "ipv4": "string",
  "ipv6": "string",
  "labels": [
    "string"
  ],
  "macAddr": "string",
  "memory": 0,
  "name": "string",
  "nanoCPUs": 0,
  "network": "string",
  "openStdin": true,
  "privileged": true,
  "publishAllPorts": true,
  "restartPolicy": "string",
  "taskID": "string",
  "tty": true,
  "user": "string",
  "volumes": [
    {
      "containerDir": "string",
      "mode": "string",
      "sourceDir": "string",
      "type": "string"
    }
  ],
  "workingDir": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerOperate](#schemadto.containeroperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Upgrade container

POST /containers/upgrade

> Body 请求参数

```json
{
  "forcePull": true,
  "image": "string",
  "name": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ContainerUpgrade](#schemadto.containerupgrade)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Container Compose

## POST Create compose

POST /containers/compose

> Body 请求参数

```json
{
  "env": [
    "string"
  ],
  "file": "string",
  "from": "edit",
  "name": "string",
  "path": "string",
  "taskID": "string",
  "template": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ComposeCreate](#schemadto.composecreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Operate compose

POST /containers/compose/operate

> Body 请求参数

```json
{
  "name": "string",
  "operation": "up",
  "path": "string",
  "withFile": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ComposeOperation](#schemadto.composeoperation)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page composes

POST /containers/compose/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Test compose

POST /containers/compose/test

> Body 请求参数

```json
{
  "env": [
    "string"
  ],
  "file": "string",
  "from": "edit",
  "name": "string",
  "path": "string",
  "taskID": "string",
  "template": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ComposeCreate](#schemadto.composecreate)| 是 |none|

> 返回示例

> 200 Response

```
true
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|boolean|

## POST Update compose

POST /containers/compose/update

> Body 请求参数

```json
{
  "content": "string",
  "env": [
    "string"
  ],
  "name": "string",
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ComposeUpdate](#schemadto.composeupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Container Docker

## GET Load docker daemon.json

GET /containers/daemonjson

> 返回示例

> 200 Response

```json
{
  "cgroupDriver": "string",
  "experimental": true,
  "fixedCidrV6": "string",
  "insecureRegistries": [
    "string"
  ],
  "ip6Tables": true,
  "iptables": true,
  "ipv6": true,
  "isActive": true,
  "isExist": true,
  "isSwarm": true,
  "liveRestore": true,
  "logMaxFile": "string",
  "logMaxSize": "string",
  "registryMirrors": [
    "string"
  ],
  "version": "string"
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.DaemonJsonConf](#schemadto.daemonjsonconf)|

## GET Load docker daemon.json

GET /containers/daemonjson/file

> 返回示例

> 200 Response

```json
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Update docker daemon.json

POST /containers/daemonjson/update

> Body 请求参数

```json
{
  "key": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SettingUpdate](#schemadto.settingupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update docker daemon.json by upload file

POST /containers/daemonjson/update/byfile

> Body 请求参数

```json
{
  "file": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DaemonJsonUpdateByFile](#schemadto.daemonjsonupdatebyfile)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Operate docker

POST /containers/docker/operate

> Body 请求参数

```json
{
  "operation": "start"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DockerOperation](#schemadto.dockeroperation)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load docker status

GET /containers/docker/status

> 返回示例

> 200 Response

```json
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Update docker daemon.json ipv6 option

POST /containers/ipv6option/update

> Body 请求参数

```json
{
  "logMaxFile": "string",
  "logMaxSize": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.LogOption](#schemadto.logoption)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update docker daemon.json log option

POST /containers/logoption/update

> Body 请求参数

```json
{
  "logMaxFile": "string",
  "logMaxSize": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.LogOption](#schemadto.logoption)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Container Image

## GET load images options

GET /containers/image

> 返回示例

> 200 Response

```json
[
  {
    "option": "string"
  }
]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.Options](#schemadto.options)]|false|none||none|
|» option|string|false|none||none|

## GET List all images

GET /containers/image/all

> 返回示例

> 200 Response

```json
[
  {
    "createdAt": "string",
    "id": "string",
    "isUsed": true,
    "size": "string",
    "tags": [
      "string"
    ]
  }
]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.ImageInfo](#schemadto.imageinfo)]|false|none||none|
|» createdAt|string|false|none||none|
|» id|string|false|none||none|
|» isUsed|boolean|false|none||none|
|» size|string|false|none||none|
|» tags|[string]|false|none||none|

## POST Build image

POST /containers/image/build

> Body 请求参数

```json
{
  "dockerfile": "string",
  "from": "string",
  "name": "string",
  "tags": [
    "string"
  ],
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImageBuild](#schemadto.imagebuild)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Load image

POST /containers/image/load

> Body 请求参数

```json
{
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImageLoad](#schemadto.imageload)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Pull image

POST /containers/image/pull

> Body 请求参数

```json
{
  "imageName": "string",
  "repoID": 0,
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImagePull](#schemadto.imagepull)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Push image

POST /containers/image/push

> Body 请求参数

```json
{
  "name": "string",
  "repoID": 0,
  "tagName": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImagePush](#schemadto.imagepush)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete image

POST /containers/image/remove

> Body 请求参数

```json
{
  "force": true,
  "names": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchDelete](#schemadto.batchdelete)| 是 |none|

> 返回示例

> 200 Response

```
{"deletedNumber":0,"spaceReclaimed":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.ContainerPruneReport](#schemadto.containerprunereport)|

## POST Save image

POST /containers/image/save

> Body 请求参数

```json
{
  "name": "string",
  "path": "string",
  "tagName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImageSave](#schemadto.imagesave)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page images

POST /containers/image/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```json
{
  "items": null,
  "total": 0
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Tag image

POST /containers/image/tag

> Body 请求参数

```json
{
  "sourceID": "string",
  "targetName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImageTag](#schemadto.imagetag)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Container Network

## GET List networks

GET /containers/network

> 返回示例

> 200 Response

```json
[
  {
    "option": "string"
  }
]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.Options](#schemadto.options)]|false|none||none|
|» option|string|false|none||none|

## POST Create network

POST /containers/network

> Body 请求参数

```json
{
  "auxAddress": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "auxAddressV6": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "driver": "string",
  "gateway": "string",
  "gatewayV6": "string",
  "ipRange": "string",
  "ipRangeV6": "string",
  "ipv4": true,
  "ipv6": true,
  "labels": [
    "string"
  ],
  "name": "string",
  "options": [
    "string"
  ],
  "subnet": "string",
  "subnetV6": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.NetworkCreate](#schemadto.networkcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete network

POST /containers/network/del

> Body 请求参数

```json
{
  "force": true,
  "names": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchDelete](#schemadto.batchdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page networks

POST /containers/network/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```json
{
  "items": null,
  "total": 0
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

# Container Image-repo

## GET List image repos

GET /containers/repo

> 返回示例

> 200 Response

```json
[
  {
    "downloadUrl": "string",
    "id": 0,
    "name": "string"
  }
]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.ImageRepoOption](#schemadto.imagerepooption)]|false|none||none|
|» downloadUrl|string|false|none||none|
|» id|integer|false|none||none|
|» name|string|false|none||none|

## POST Create image repo

POST /containers/repo

> Body 请求参数

```json
{
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImageRepoDelete](#schemadto.imagerepodelete)| 是 |none|

> 返回示例

> 200 Response

```json
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Delete image repo

POST /containers/repo/del

> Body 请求参数

```json
{
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImageRepoDelete](#schemadto.imagerepodelete)| 是 |none|

> 返回示例

> 200 Response

```json
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Page image repos

POST /containers/repo/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```json
{
  "items": null,
  "total": 0
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## GET Load repo status

GET /containers/repo/status

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```json
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update image repo

POST /containers/repo/update

> Body 请求参数

```json
{
  "auth": true,
  "downloadUrl": "string",
  "id": 0,
  "password": "string",
  "protocol": "string",
  "username": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ImageRepoUpdate](#schemadto.imagerepoupdate)| 是 |none|

> 返回示例

> 200 Response

```json
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

# Container Compose-template

## GET List compose templates

GET /containers/template

> 返回示例

> 200 Response

```json
[
  {
    "content": "string",
    "createdAt": "string",
    "description": "string",
    "id": 0,
    "name": "string"
  }
]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.ComposeTemplateInfo](#schemadto.composetemplateinfo)]|false|none||none|
|» content|string|false|none||none|
|» createdAt|string|false|none||none|
|» description|string|false|none||none|
|» id|integer|false|none||none|
|» name|string|false|none||none|

## POST Create compose template

POST /containers/template

> Body 请求参数

```json
{
  "content": "string",
  "description": "string",
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ComposeTemplateCreate](#schemadto.composetemplatecreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete compose template

POST /containers/template/del

> Body 请求参数

```json
{
  "force": true,
  "names": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchDelete](#schemadto.batchdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page compose templates

POST /containers/template/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```json
{
  "items": null,
  "total": 0
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update compose template

POST /containers/template/update

> Body 请求参数

```json
{
  "content": "string",
  "description": "string",
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ComposeTemplateUpdate](#schemadto.composetemplateupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Container Volume

## GET List volumes

GET /containers/volume

> 返回示例

> 200 Response

```json
[
  {
    "option": "string"
  }
]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.Options](#schemadto.options)]|false|none||none|
|» option|string|false|none||none|

## POST Create volume

POST /containers/volume

> Body 请求参数

```json
{
  "driver": "string",
  "labels": [
    "string"
  ],
  "name": "string",
  "options": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.VolumeCreate](#schemadto.volumecreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete volume

POST /containers/volume/del

> Body 请求参数

```json
{
  "force": true,
  "names": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchDelete](#schemadto.batchdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page volumes

POST /containers/volume/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```json
{
  "items": null,
  "total": 0
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

# App Launcher

## POST Update app Launcher

POST /core/app/launcher/show

> Body 请求参数

```json
{
  "key": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SettingUpdate](#schemadto.settingupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Auth

## GET Load captcha

GET /core/auth/captcha

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST User login

POST /core/auth/login

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|EntranceCode|header|string| 是 |安全入口 base64 加密串|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST User logout

POST /core/auth/logout

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST User login with mfa

POST /core/auth/mfalogin

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

### 返回头部 Header

|Status|Header|Type|Format|Description|
|---|---|---|---|---|
|200|EntranceCode|string||安全入口|

## GET Get Setting For Login

GET /core/auth/setting

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

# Command

## POST Create command

POST /core/commands

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET List commands

GET /core/commands/command

> Body 请求参数

```json
{
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByType](#schemadto.operatebytype)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Delete command

POST /core/commands/del

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page commands

POST /core/commands/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## GET Tree commands

GET /core/commands/tree

> Body 请求参数

```json
{
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByType](#schemadto.operatebytype)| 是 |none|

> 返回示例

> 200 Response

```
null
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Array|

## POST Update command

POST /core/commands/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Host

## POST Create host

POST /core/hosts

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Delete host

POST /core/hosts/del

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get host info

POST /core/hosts/info

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Page host

POST /core/hosts/search

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Test host conn by host id

POST /core/hosts/test/byid/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|

> 返回示例

> 200 Response

```
true
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|boolean|

## POST Test host conn by info

POST /core/hosts/test/byinfo

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
true
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|boolean|

## POST Load host tree

POST /core/hosts/tree

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
[{}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update host

POST /core/hosts/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update host group

POST /core/hosts/update/group

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Logs

## POST Clean operation logs

POST /core/logs/clean

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Page login logs

POST /core/logs/login

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Page operation logs

POST /core/logs/operation

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Load system logs

POST /logs/system

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## GET Load system log files

GET /logs/system/files

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

# System Setting

## POST Update system bind info

POST /core/settings/bind/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Reset system password expired

POST /core/settings/expired/handle

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load system address

GET /core/settings/interface

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update system setting

POST /core/settings/menu/update

> Body 请求参数

```json
{
  "key": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SettingUpdate](#schemadto.settingupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load mfa info

POST /core/settings/mfa

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Bind mfa

POST /core/settings/mfa/bind

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update system password

POST /core/settings/password/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update system port

POST /core/settings/port/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update proxy setting

POST /core/settings/proxy/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Upgrade

POST /core/settings/rollback

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load system setting info

POST /core/settings/search

> 返回示例

> 200 Response

```
{"appStoreLastModified":"string","appStoreSyncStatus":"string","appStoreVersion":"string","defaultNetwork":"string","dockerSockPath":"string","fileRecycleBin":"string","lastCleanData":"string","lastCleanSize":"string","lastCleanTime":"string","localTime":"string","monitorInterval":"string","monitorStatus":"string","monitorStoreDays":"string","ntpSite":"string","snapshotIgnore":"string","systemVersion":"string","timeZone":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.SettingInfo](#schemadto.settinginfo)|

## GET Load system available status

GET /core/settings/search/available

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Download system cert

POST /core/settings/ssl/download

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load system cert info

GET /core/settings/ssl/info

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update system ssl

POST /core/settings/ssl/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load system terminal setting info

POST /core/settings/terminal/search

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update system terminal setting

POST /core/settings/terminal/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update system setting

POST /core/settings/update

> Body 请求参数

```json
{
  "key": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SettingUpdate](#schemadto.settingupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load release notes by version

GET /core/settings/upgrade

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Upgrade

POST /core/settings/upgrade

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST generate api key

POST /settings/api/config/generate/key

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Update api config

POST /settings/api/config/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load local backup dir

GET /settings/basedir

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Load system setting info

POST /settings/search

> 返回示例

> 200 Response

```
{"appStoreLastModified":"string","appStoreSyncStatus":"string","appStoreVersion":"string","defaultNetwork":"string","dockerSockPath":"string","fileRecycleBin":"string","lastCleanData":"string","lastCleanSize":"string","lastCleanTime":"string","localTime":"string","monitorInterval":"string","monitorStatus":"string","monitorStoreDays":"string","ntpSite":"string","snapshotIgnore":"string","systemVersion":"string","timeZone":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.SettingInfo](#schemadto.settinginfo)|

## GET Load system available status

GET /settings/search/available

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create system snapshot

POST /settings/snapshot

> Body 请求参数

```json
{
  "appData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "backupData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "description": "string",
  "downloadAccountID": 0,
  "id": 0,
  "interruptStep": "string",
  "name": "string",
  "panelData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "secret": "string",
  "sourceAccountIDs": "string",
  "taskID": "string",
  "withLoginLog": true,
  "withMonitorData": true,
  "withOperationLog": true,
  "withSystemLog": true,
  "withTaskLog": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SnapshotCreate](#schemadto.snapshotcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete system backup

POST /settings/snapshot/del

> Body 请求参数

```json
{
  "deleteWithFile": true,
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SnapshotBatchDelete](#schemadto.snapshotbatchdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update snapshot description

POST /settings/snapshot/description/update

> Body 请求参数

```json
{
  "description": "string",
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.UpdateDescription](#schemadto.updatedescription)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Import system snapshot

POST /settings/snapshot/import

> Body 请求参数

```json
{
  "backupAccountID": 0,
  "description": "string",
  "names": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SnapshotImport](#schemadto.snapshotimport)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load system snapshot data

GET /settings/snapshot/load

> 返回示例

> 200 Response

```
{"appData":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isDisable":true,"key":"string","label":"string","name":"string","path":"string","relationItemID":"string","size":0}],"id":"string","isCheck":true,"isDisable":true,"key":"string","label":"string","name":"string","path":"string","relationItemID":"string","size":0}],"backupData":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isDisable":true,"key":"string","label":"string","name":"string","path":"string","relationItemID":"string","size":0}],"id":"string","isCheck":true,"isDisable":true,"key":"string","label":"string","name":"string","path":"string","relationItemID":"string","size":0}],"panelData":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isDisable":true,"key":"string","label":"string","name":"string","path":"string","relationItemID":"string","size":0}],"id":"string","isCheck":true,"isDisable":true,"key":"string","label":"string","name":"string","path":"string","relationItemID":"string","size":0}],"withLoginLog":true,"withMonitorData":true,"withOperationLog":true,"withSystemLog":true,"withTaskLog":true}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.SnapshotData](#schemadto.snapshotdata)|

## POST Recover system backup

POST /settings/snapshot/recover

> Body 请求参数

```json
{
  "id": 0,
  "isNew": true,
  "reDownload": true,
  "secret": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SnapshotRecover](#schemadto.snapshotrecover)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Recreate system snapshot

POST /settings/snapshot/recrete

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Rollback system backup

POST /settings/snapshot/rollback

> Body 请求参数

```json
{
  "id": 0,
  "isNew": true,
  "reDownload": true,
  "secret": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SnapshotRecover](#schemadto.snapshotrecover)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page system snapshot

POST /settings/snapshot/search

> Body 请求参数

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageSnapshot](#schemadto.pagesnapshot)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update system setting

POST /settings/update

> Body 请求参数

```json
{
  "key": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SettingUpdate](#schemadto.settingupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Cronjob

## POST Create cronjob

POST /cronjobs

> Body 请求参数

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "appID": "string",
  "command": "string",
  "containerName": "string",
  "dbName": "string",
  "dbType": "string",
  "downloadAccountID": 0,
  "exclusionRules": "string",
  "executor": "string",
  "isDir": true,
  "name": "string",
  "retainCopies": 1,
  "script": "string",
  "scriptMode": "string",
  "secret": "string",
  "sourceAccountIDs": "string",
  "sourceDir": "string",
  "spec": "string",
  "specCustom": true,
  "type": "string",
  "url": "string",
  "user": "string",
  "website": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CronjobCreate](#schemadto.cronjobcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete cronjob

POST /cronjobs/del

> Body 请求参数

```json
{
  "cleanData": true,
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CronjobBatchDelete](#schemadto.cronjobbatchdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Download cronjob records

POST /cronjobs/download

> Body 请求参数

```json
{
  "backupAccountID": 0,
  "recordID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CronjobDownload](#schemadto.cronjobdownload)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Handle cronjob once

POST /cronjobs/handle

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load cronjob spec time

POST /cronjobs/next

> Body 请求参数

```json
{
  "spec": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CronjobSpec](#schemadto.cronjobspec)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Clean job records

POST /cronjobs/records/clean

> Body 请求参数

```json
{
  "cleanData": true,
  "cronjobID": 0,
  "isDelete": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CronjobClean](#schemadto.cronjobclean)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load Cronjob record log

POST /cronjobs/records/log

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Page cronjobs

POST /cronjobs/search

> Body 请求参数

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageCronjob](#schemadto.pagecronjob)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Page job records

POST /cronjobs/search/records

> Body 请求参数

```json
{
  "cronjobID": 0,
  "endTime": "string",
  "page": 0,
  "pageSize": 0,
  "startTime": "string",
  "status": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchRecord](#schemadto.searchrecord)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update cronjob status

POST /cronjobs/status

> Body 请求参数

```json
{
  "id": 0,
  "status": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CronjobUpdateStatus](#schemadto.cronjobupdatestatus)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update cronjob

POST /cronjobs/update

> Body 请求参数

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "appID": "string",
  "command": "string",
  "containerName": "string",
  "dbName": "string",
  "dbType": "string",
  "downloadAccountID": 0,
  "exclusionRules": "string",
  "executor": "string",
  "id": 0,
  "isDir": true,
  "name": "string",
  "retainCopies": 1,
  "script": "string",
  "scriptMode": "string",
  "secret": "string",
  "sourceAccountIDs": "string",
  "sourceDir": "string",
  "spec": "string",
  "specCustom": true,
  "type": "string",
  "url": "string",
  "user": "string",
  "website": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.CronjobUpdate](#schemadto.cronjobupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Dashboard

## GET Load app launcher

GET /dashboard/app/launcher

> 返回示例

> 200 Response

```
null
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Array|

## POST Load app launcher options

POST /dashboard/app/launcher/option

> Body 请求参数

```json
{
  "filter": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchByFilter](#schemadto.searchbyfilter)| 是 |none|

> 返回示例

> 200 Response

```
null
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Array|

## GET Load dashboard base info

GET /dashboard/base/{ioOption}/{netOption}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|ioOption|path|string| 是 |request|
|netOption|path|string| 是 |request|

> 返回示例

> 200 Response

```
{"appInstalledNumber":0,"cpuCores":0,"cpuLogicalCores":0,"cpuModelName":"string","cronjobNumber":0,"currentInfo":{"cpuPercent":[0],"cpuTotal":0,"cpuUsed":0,"cpuUsedPercent":0,"diskData":[{"device":"string","free":0,"inodesFree":0,"inodesTotal":0,"inodesUsed":0,"inodesUsedPercent":0,"path":"string","total":0,"type":"string","used":0,"usedPercent":0}],"gpuData":[{"fanSpeed":"string","gpuUtil":"string","index":0,"maxPowerLimit":"string","memTotal":"string","memUsed":"string","memoryUsage":"string","performanceState":"string","powerDraw":"string","powerUsage":"string","productName":"string","temperature":"string"}],"ioCount":0,"ioReadBytes":0,"ioReadTime":0,"ioWriteBytes":0,"ioWriteTime":0,"load1":0,"load15":0,"load5":0,"loadUsagePercent":0,"memoryAvailable":0,"memoryTotal":0,"memoryUsed":0,"memoryUsedPercent":0,"netBytesRecv":0,"netBytesSent":0,"procs":0,"shotTime":"string","swapMemoryAvailable":0,"swapMemoryTotal":0,"swapMemoryUsed":0,"swapMemoryUsedPercent":0,"timeSinceUptime":"string","uptime":0,"xpuData":[{"deviceID":0,"deviceName":"string","memory":"string","memoryUsed":"string","memoryUtil":"string","power":"string","temperature":"string"}]},"databaseNumber":0,"hostname":"string","ipV4Addr":"string","kernelArch":"string","kernelVersion":"string","os":"string","platform":"string","platformFamily":"string","platformVersion":"string","systemProxy":"string","virtualizationSystem":"string","websiteNumber":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.DashboardBase](#schemadto.dashboardbase)|

## GET Load os info

GET /dashboard/base/os

> 返回示例

> 200 Response

```
{"diskSize":0,"kernelArch":"string","kernelVersion":"string","os":"string","platform":"string","platformFamily":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.OsInfo](#schemadto.osinfo)|

## GET Load dashboard current info

GET /dashboard/current/{ioOption}/{netOption}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|ioOption|path|string| 是 |request|
|netOption|path|string| 是 |request|

> 返回示例

> 200 Response

```
{"cpuPercent":[0],"cpuTotal":0,"cpuUsed":0,"cpuUsedPercent":0,"diskData":[{"device":"string","free":0,"inodesFree":0,"inodesTotal":0,"inodesUsed":0,"inodesUsedPercent":0,"path":"string","total":0,"type":"string","used":0,"usedPercent":0}],"gpuData":[{"fanSpeed":"string","gpuUtil":"string","index":0,"maxPowerLimit":"string","memTotal":"string","memUsed":"string","memoryUsage":"string","performanceState":"string","powerDraw":"string","powerUsage":"string","productName":"string","temperature":"string"}],"ioCount":0,"ioReadBytes":0,"ioReadTime":0,"ioWriteBytes":0,"ioWriteTime":0,"load1":0,"load15":0,"load5":0,"loadUsagePercent":0,"memoryAvailable":0,"memoryTotal":0,"memoryUsed":0,"memoryUsedPercent":0,"netBytesRecv":0,"netBytesSent":0,"procs":0,"shotTime":"string","swapMemoryAvailable":0,"swapMemoryTotal":0,"swapMemoryUsed":0,"swapMemoryUsedPercent":0,"timeSinceUptime":"string","uptime":0,"xpuData":[{"deviceID":0,"deviceName":"string","memory":"string","memoryUsed":"string","memoryUtil":"string","power":"string","temperature":"string"}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.DashboardCurrent](#schemadto.dashboardcurrent)|

## GET Load dashboard current info for node

GET /dashboard/current/node

> 返回示例

> 200 Response

```
{"cpuTotal":0,"cpuUsed":0,"cpuUsedPercent":0,"load1":0,"load15":0,"load5":0,"loadUsagePercent":0,"memoryAvailable":0,"memoryTotal":0,"memoryUsed":0,"memoryUsedPercent":0,"swapMemoryAvailable":0,"swapMemoryTotal":0,"swapMemoryUsed":0,"swapMemoryUsedPercent":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.NodeCurrent](#schemadto.nodecurrent)|

## POST System restart

POST /dashboard/system/restart/{operation}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|operation|path|string| 是 |request|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Database Mysql

## POST Create mysql database

POST /databases

> Body 请求参数

```json
{
  "database": "string",
  "description": "string",
  "format": "utf8mb4",
  "from": "local",
  "name": "string",
  "password": "string",
  "permission": "string",
  "username": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MysqlDBCreate](#schemadto.mysqldbcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Bind user of mysql database

POST /databases/bind

> Body 请求参数

```json
{
  "database": "string",
  "db": "string",
  "password": "string",
  "permission": "string",
  "username": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BindUser](#schemadto.binduser)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change mysql access

POST /databases/change/access

> Body 请求参数

```json
{
  "database": "string",
  "from": "local",
  "id": 0,
  "type": "mysql",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ChangeDBInfo](#schemadto.changedbinfo)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change mysql password

POST /databases/change/password

> Body 请求参数

```json
{
  "database": "string",
  "from": "local",
  "id": 0,
  "type": "mysql",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ChangeDBInfo](#schemadto.changedbinfo)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete mysql database

POST /databases/del

> Body 请求参数

```json
{
  "database": "string",
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0,
  "type": "mysql"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MysqlDBDelete](#schemadto.mysqldbdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Check before delete mysql database

POST /databases/del/check

> Body 请求参数

```json
{
  "database": "string",
  "id": 0,
  "type": "mysql"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MysqlDBDeleteCheck](#schemadto.mysqldbdeletecheck)| 是 |none|

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update mysql database description

POST /databases/description/update

> Body 请求参数

```json
{
  "description": "string",
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.UpdateDescription](#schemadto.updatedescription)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load mysql database from remote

POST /databases/load

> Body 请求参数

```json
{
  "database": "string",
  "from": "local",
  "type": "mysql"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MysqlLoadDB](#schemadto.mysqlloaddb)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET List mysql database names

GET /databases/options

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageInfo](#schemadto.pageinfo)| 是 |none|

> 返回示例

> 200 Response

```
[{"database":"string","from":"string","id":0,"name":"string","type":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.MysqlOption](#schemadto.mysqloption)]|false|none||none|
|» database|string|false|none||none|
|» from|string|false|none||none|
|» id|integer|false|none||none|
|» name|string|false|none||none|
|» type|string|false|none||none|

## POST Load mysql remote access

POST /databases/remote

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
true
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|boolean|

## POST Page mysql databases

POST /databases/search

> Body 请求参数

```json
{
  "database": "string",
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MysqlDBSearch](#schemadto.mysqldbsearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Load mysql status info

POST /databases/status

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
{"Aborted_clients":"string","Aborted_connects":"string","Bytes_received":"string","Bytes_sent":"string","Com_commit":"string","Com_rollback":"string","Connections":"string","Created_tmp_disk_tables":"string","Created_tmp_tables":"string","File":"string","Innodb_buffer_pool_pages_dirty":"string","Innodb_buffer_pool_read_requests":"string","Innodb_buffer_pool_reads":"string","Key_read_requests":"string","Key_reads":"string","Key_write_requests":"string","Key_writes":"string","Max_used_connections":"string","Open_tables":"string","Opened_files":"string","Opened_tables":"string","Position":"string","Qcache_hits":"string","Qcache_inserts":"string","Questions":"string","Run":"string","Select_full_join":"string","Select_range_check":"string","Sort_merge_passes":"string","Table_locks_waited":"string","Threads_cached":"string","Threads_connected":"string","Threads_created":"string","Threads_running":"string","Uptime":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.MysqlStatus](#schemadto.mysqlstatus)|

## POST Load mysql variables info

POST /databases/variables

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
{"binlog_cache_size":"string","innodb_buffer_pool_size":"string","innodb_log_buffer_size":"string","join_buffer_size":"string","key_buffer_size":"string","long_query_time":"string","max_connections":"string","max_heap_table_size":"string","query_cache_size":"string","query_cache_type":"string","read_buffer_size":"string","read_rnd_buffer_size":"string","slow_query_log":"string","sort_buffer_size":"string","table_open_cache":"string","thread_cache_size":"string","thread_stack":"string","tmp_table_size":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.MysqlVariables](#schemadto.mysqlvariables)|

## POST Update mysql variables

POST /databases/variables/update

> Body 请求参数

```json
{
  "database": "string",
  "type": "mysql",
  "variables": [
    {
      "param": "string",
      "value": null
    }
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MysqlVariablesUpdate](#schemadto.mysqlvariablesupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Database Common

## POST Load base info

POST /databases/common/info

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
{"containerName":"string","name":"string","port":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.DBBaseInfo](#schemadto.dbbaseinfo)|

## POST Load Database conf

POST /databases/common/load/file

> Body 请求参数

```json
{
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithNameAndType](#schemadto.operationwithnameandtype)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Update conf by upload file

POST /databases/common/update/conf

> Body 请求参数

```json
{
  "database": "string",
  "file": "string",
  "type": "mysql"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DBConfUpdateByFile](#schemadto.dbconfupdatebyfile)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Database

## POST Create database

POST /databases/db

> Body 请求参数

```json
{
  "address": "string",
  "clientCert": "string",
  "clientKey": "string",
  "description": "string",
  "from": "local",
  "name": "string",
  "password": "string",
  "port": 0,
  "rootCert": "string",
  "skipVerify": true,
  "ssl": true,
  "type": "string",
  "username": "string",
  "version": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DatabaseCreate](#schemadto.databasecreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get databases

GET /databases/db/{name}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|name|path|string| 是 |none|

> 返回示例

> 200 Response

```
{"address":"string","clientCert":"string","clientKey":"string","createdAt":"string","description":"string","from":"string","id":0,"name":"string","password":"string","port":0,"rootCert":"string","skipVerify":true,"ssl":true,"type":"string","username":"string","version":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.DatabaseInfo](#schemadto.databaseinfo)|

## POST Check database

POST /databases/db/check

> Body 请求参数

```json
{
  "address": "string",
  "clientCert": "string",
  "clientKey": "string",
  "description": "string",
  "from": "local",
  "name": "string",
  "password": "string",
  "port": 0,
  "rootCert": "string",
  "skipVerify": true,
  "ssl": true,
  "type": "string",
  "username": "string",
  "version": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DatabaseCreate](#schemadto.databasecreate)| 是 |none|

> 返回示例

> 200 Response

```
true
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|boolean|

## POST Delete database

POST /databases/db/del

> Body 请求参数

```json
{
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DatabaseDelete](#schemadto.databasedelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET List databases

GET /databases/db/item/{type}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|type|path|string| 是 |none|

> 返回示例

> 200 Response

```
[{"database":"string","from":"string","id":0,"name":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.DatabaseItem](#schemadto.databaseitem)]|false|none||none|
|» database|string|false|none||none|
|» from|string|false|none||none|
|» id|integer|false|none||none|
|» name|string|false|none||none|

## GET List databases

GET /databases/db/list/{type}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|type|path|string| 是 |none|

> 返回示例

> 200 Response

```
[{"address":"string","database":"string","from":"string","id":0,"type":"string","version":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.DatabaseOption](#schemadto.databaseoption)]|false|none||none|
|» address|string|false|none||none|
|» database|string|false|none||none|
|» from|string|false|none||none|
|» id|integer|false|none||none|
|» type|string|false|none||none|
|» version|string|false|none||none|

## POST Page databases

POST /databases/db/search

> Body 请求参数

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DatabaseSearch](#schemadto.databasesearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update database

POST /databases/db/update

> Body 请求参数

```json
{
  "address": "string",
  "clientCert": "string",
  "clientKey": "string",
  "description": "string",
  "id": 0,
  "password": "string",
  "port": 0,
  "rootCert": "string",
  "skipVerify": true,
  "ssl": true,
  "type": "string",
  "username": "string",
  "version": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.DatabaseUpdate](#schemadto.databaseupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Check before delete remote database

POST /db/remote/del/check

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

# Database PostgreSQL

## POST Create postgresql database

POST /databases/pg

> Body 请求参数

```json
{
  "database": "string",
  "description": "string",
  "format": "string",
  "from": "local",
  "name": "string",
  "password": "string",
  "superUser": true,
  "username": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PostgresqlDBCreate](#schemadto.postgresqldbcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load postgresql database from remote

POST /databases/pg/{database}/load

> Body 请求参数

```json
{
  "database": "string",
  "from": "local",
  "type": "postgresql"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|database|path|string| 是 |none|
|body|body|[dto.PostgresqlLoadDB](#schemadto.postgresqlloaddb)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Bind postgresql user

POST /databases/pg/bind

> Body 请求参数

```json
{
  "database": "string",
  "name": "string",
  "password": "string",
  "superUser": true,
  "username": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PostgresqlBindUser](#schemadto.postgresqlbinduser)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete postgresql database

POST /databases/pg/del

> Body 请求参数

```json
{
  "database": "string",
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0,
  "type": "postgresql"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PostgresqlDBDelete](#schemadto.postgresqldbdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Check before delete postgresql database

POST /databases/pg/del/check

> Body 请求参数

```json
{
  "database": "string",
  "id": 0,
  "type": "postgresql"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PostgresqlDBDeleteCheck](#schemadto.postgresqldbdeletecheck)| 是 |none|

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update postgresql database description

POST /databases/pg/description

> Body 请求参数

```json
{
  "description": "string",
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.UpdateDescription](#schemadto.updatedescription)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change postgresql password

POST /databases/pg/password

> Body 请求参数

```json
{
  "database": "string",
  "from": "local",
  "id": 0,
  "type": "mysql",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ChangeDBInfo](#schemadto.changedbinfo)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change postgresql privileges

POST /databases/pg/privileges

> Body 请求参数

```json
{
  "database": "string",
  "from": "local",
  "id": 0,
  "type": "mysql",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ChangeDBInfo](#schemadto.changedbinfo)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page postgresql databases

POST /databases/pg/search

> Body 请求参数

```json
{
  "database": "string",
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PostgresqlDBSearch](#schemadto.postgresqldbsearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

# Database Redis

## POST Load redis conf

POST /databases/redis/conf

> Body 请求参数

```json
{
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithName](#schemadto.operationwithname)| 是 |none|

> 返回示例

> 200 Response

```
{"containerName":"string","database":"string","maxclients":"string","maxmemory":"string","name":"string","port":0,"requirepass":"string","timeout":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.RedisConf](#schemadto.redisconf)|

## POST Update redis conf

POST /databases/redis/conf/update

> Body 请求参数

```json
{
  "database": "string",
  "maxclients": "string",
  "maxmemory": "string",
  "timeout": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.RedisConfUpdate](#schemadto.redisconfupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Install redis-cli

POST /databases/redis/install/cli

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change redis password

POST /databases/redis/password

> Body 请求参数

```json
{
  "database": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ChangeRedisPass](#schemadto.changeredispass)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load redis persistence conf

POST /databases/redis/persistence/conf

> Body 请求参数

```json
{
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithName](#schemadto.operationwithname)| 是 |none|

> 返回示例

> 200 Response

```
{"appendfsync":"string","appendonly":"string","database":"string","save":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.RedisPersistence](#schemadto.redispersistence)|

## POST Update redis persistence conf

POST /databases/redis/persistence/update

> Body 请求参数

```json
{
  "appendfsync": "string",
  "appendonly": "string",
  "database": "string",
  "save": "string",
  "type": "aof"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.RedisConfPersistenceUpdate](#schemadto.redisconfpersistenceupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load redis status info

POST /databases/redis/status

> Body 请求参数

```json
{
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithName](#schemadto.operationwithname)| 是 |none|

> 返回示例

> 200 Response

```
{"connected_clients":"string","database":"string","instantaneous_ops_per_sec":"string","keyspace_hits":"string","keyspace_misses":"string","latest_fork_usec":"string","mem_fragmentation_ratio":"string","tcp_port":"string","total_commands_processed":"string","total_connections_received":"string","uptime_in_days":"string","used_memory":"string","used_memory_peak":"string","used_memory_rss":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.RedisStatus](#schemadto.redisstatus)|

# File

## POST Create file

POST /files

> Body 请求参数

```json
{
  "content": "string",
  "isDir": true,
  "isLink": true,
  "isSymlink": true,
  "linkPath": "string",
  "mode": 0,
  "path": "string",
  "sub": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileCreate](#schemarequest.filecreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Batch delete file

POST /files/batch/del

> Body 请求参数

```json
{
  "isDir": true,
  "paths": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileBatchDelete](#schemarequest.filebatchdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Batch change file mode and owner

POST /files/batch/role

> Body 请求参数

```json
{
  "group": "string",
  "mode": 0,
  "paths": [
    "string"
  ],
  "sub": true,
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileRoleReq](#schemarequest.filerolereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Check file exist

POST /files/check

> Body 请求参数

```json
{
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FilePathCheck](#schemarequest.filepathcheck)| 是 |none|

> 返回示例

> 200 Response

```
true
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|boolean|

## POST Chunk Download file

POST /files/chunkdownload

> Body 请求参数

```json
{
  "compress": true,
  "name": "string",
  "paths": [
    "string"
  ],
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileDownload](#schemarequest.filedownload)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST ChunkUpload file

POST /files/chunkupload

> Body 请求参数

```yaml
file: ""

```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» file|body|string(binary)| 是 |request|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Compress file

POST /files/compress

> Body 请求参数

```json
{
  "dst": "string",
  "files": [
    "string"
  ],
  "name": "string",
  "replace": true,
  "secret": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileCompress](#schemarequest.filecompress)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load file content

POST /files/content

> Body 请求参数

```json
{
  "isDetail": true,
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileContentReq](#schemarequest.filecontentreq)| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.FileInfo](#schemaresponse.fileinfo)|

## POST Decompress file

POST /files/decompress

> Body 请求参数

```json
{
  "dst": "string",
  "path": "string",
  "secret": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileDeCompress](#schemarequest.filedecompress)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete file

POST /files/del

> Body 请求参数

```json
{
  "forceDelete": true,
  "isDir": true,
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileDelete](#schemarequest.filedelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Download file

GET /files/download

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create favorite

POST /files/favorite

> Body 请求参数

```json
{
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FavoriteCreate](#schemarequest.favoritecreate)| 是 |none|

> 返回示例

> 200 Response

```
{"createdAt":"string","id":0,"isDir":true,"isTxt":true,"name":"string","path":"string","type":"string","updatedAt":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[model.Favorite](#schemamodel.favorite)|

## POST Delete favorite

POST /files/favorite/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FavoriteDelete](#schemarequest.favoritedelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List favorites

POST /files/favorite/search

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageInfo](#schemadto.pageinfo)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Change file mode

POST /files/mode

> Body 请求参数

```json
{
  "content": "string",
  "isDir": true,
  "isLink": true,
  "isSymlink": true,
  "linkPath": "string",
  "mode": 0,
  "path": "string",
  "sub": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileCreate](#schemarequest.filecreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Move file

POST /files/move

> Body 请求参数

```json
{
  "cover": true,
  "name": "string",
  "newPath": "string",
  "oldPaths": [
    "string"
  ],
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileMove](#schemarequest.filemove)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change file owner

POST /files/owner

> Body 请求参数

```json
{
  "group": "string",
  "path": "string",
  "sub": true,
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileRoleUpdate](#schemarequest.fileroleupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Read file by Line

POST /files/read

> Body 请求参数

```json
{
  "ID": 0,
  "latest": true,
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "resourceID": 0,
  "taskID": "string",
  "taskOperate": "string",
  "taskType": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileReadByLineReq](#schemarequest.filereadbylinereq)| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string","end":true,"lines":["string"],"path":"string","total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.FileLineContent](#schemaresponse.filelinecontent)|

## POST Clear RecycleBin files

POST /files/recycle/clear

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Reduce RecycleBin files

POST /files/recycle/reduce

> Body 请求参数

```json
{
  "from": "string",
  "name": "string",
  "rName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.RecycleBinReduce](#schemarequest.recyclebinreduce)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List RecycleBin files

POST /files/recycle/search

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageInfo](#schemadto.pageinfo)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## GET Get RecycleBin status

GET /files/recycle/status

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Change file name

POST /files/rename

> Body 请求参数

```json
{
  "newName": "string",
  "oldName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileRename](#schemarequest.filerename)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update file content

POST /files/save

> Body 请求参数

```json
{
  "content": "string",
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileEdit](#schemarequest.fileedit)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List files

POST /files/search

> Body 请求参数

```json
{
  "containSub": true,
  "dir": true,
  "expand": true,
  "isDetail": true,
  "page": 0,
  "pageSize": 0,
  "path": "string",
  "search": "string",
  "showHidden": true,
  "sortBy": "string",
  "sortOrder": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileOption](#schemarequest.fileoption)| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.FileInfo](#schemaresponse.fileinfo)|

## POST Load file size

POST /files/size

> Body 请求参数

```json
{
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.DirSizeReq](#schemarequest.dirsizereq)| 是 |none|

> 返回示例

> 200 Response

```
{"size":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.DirSizeRes](#schemaresponse.dirsizeres)|

## POST Load files tree

POST /files/tree

> Body 请求参数

```json
{
  "containSub": true,
  "dir": true,
  "expand": true,
  "isDetail": true,
  "page": 0,
  "pageSize": 0,
  "path": "string",
  "search": "string",
  "showHidden": true,
  "sortBy": "string",
  "sortOrder": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileOption](#schemarequest.fileoption)| 是 |none|

> 返回示例

> 200 Response

```
[{"children":[{"children":[{"children":[null],"extension":"string","id":"string","isDir":true,"name":"string","path":"string"}],"extension":"string","id":"string","isDir":true,"name":"string","path":"string"}],"extension":"string","id":"string","isDir":true,"name":"string","path":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.FileTree](#schemaresponse.filetree)]|false|none||none|
|» children|[[response.FileTree](#schemaresponse.filetree)]|false|none||none|
|»» children|[[response.FileTree](#schemaresponse.filetree)]|false|none||none|
|»» extension|string|false|none||none|
|»» id|string|false|none||none|
|»» isDir|boolean|false|none||none|
|»» name|string|false|none||none|
|»» path|string|false|none||none|
|» extension|string|false|none||none|
|» id|string|false|none||none|
|» isDir|boolean|false|none||none|
|» name|string|false|none||none|
|» path|string|false|none||none|

## POST Upload file

POST /files/upload

> Body 请求参数

```yaml
file: ""

```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» file|body|string(binary)| 是 |request|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page file

POST /files/upload/search

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0,
  "path": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.SearchUploadWithPage](#schemarequest.searchuploadwithpage)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Wget file

POST /files/wget

> Body 请求参数

```json
{
  "ignoreCertificate": true,
  "name": "string",
  "path": "string",
  "url": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FileWget](#schemarequest.filewget)| 是 |none|

> 返回示例

> 200 Response

```
{"key":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.FileWgetRes](#schemaresponse.filewgetres)|

# SSH

## POST Update host SSH setting by file

POST /host/conffile/update

> Body 请求参数

```json
{
  "file": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SSHConf](#schemadto.sshconf)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load host SSH conf

GET /host/ssh/conf

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Generate host SSH secret

POST /host/ssh/generate

> Body 请求参数

```json
{
  "encryptionMode": "rsa",
  "password": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GenerateSSH](#schemadto.generatessh)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load host SSH logs

POST /host/ssh/log

> Body 请求参数

```json
{
  "Status": "Success",
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchSSHLog](#schemadto.searchsshlog)| 是 |none|

> 返回示例

> 200 Response

```
{"failedCount":0,"logs":[{"address":"string","area":"string","authMode":"string","date":"string","dateStr":"string","message":"string","port":"string","status":"string","user":"string"}],"successfulCount":0,"totalCount":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.SSHLog](#schemadto.sshlog)|

## POST Operate SSH

POST /host/ssh/operate

> Body 请求参数

```json
{
  "operation": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Operate](#schemadto.operate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load host SSH setting info

POST /host/ssh/search

> 返回示例

> 200 Response

```
{"autoStart":true,"isActive":true,"isExist":true,"listenAddress":"string","message":"string","passwordAuthentication":"string","permitRootLogin":"string","port":"string","pubkeyAuthentication":"string","useDNS":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.SSHInfo](#schemadto.sshinfo)|

## POST Load host SSH secret

POST /host/ssh/secret

> Body 请求参数

```json
{
  "encryptionMode": "rsa"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.GenerateLoad](#schemadto.generateload)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Update host SSH setting

POST /host/ssh/update

> Body 请求参数

```json
{
  "key": "string",
  "newValue": "string",
  "oldValue": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SSHUpdate](#schemadto.sshupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Host tool

## POST Get tool status

POST /host/tool

> Body 请求参数

```json
{
  "operate": "status",
  "type": "supervisord"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.HostToolReq](#schemarequest.hosttoolreq)| 是 |none|

> 返回示例

> 200 Response

```
{"config":null,"type":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.HostToolRes](#schemaresponse.hosttoolres)|

## POST Get tool config

POST /host/tool/config

> Body 请求参数

```json
{
  "content": "string",
  "operate": "get",
  "type": "supervisord"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.HostToolConfig](#schemarequest.hosttoolconfig)| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.HostToolConfig](#schemaresponse.hosttoolconfig)|

## POST Create Host tool Config

POST /host/tool/create

> Body 请求参数

```json
{
  "configPath": "string",
  "serviceName": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.HostToolCreate](#schemarequest.hosttoolcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get tool logs

POST /host/tool/log

> Body 请求参数

```json
{
  "type": "supervisord"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.HostToolLogReq](#schemarequest.hosttoollogreq)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Operate tool

POST /host/tool/operate

> Body 请求参数

```json
{
  "operate": "status",
  "type": "supervisord"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.HostToolReq](#schemarequest.hosttoolreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get Supervisor process config

GET /host/tool/supervisor/process

> 返回示例

> 200 Response

```
{"command":"string","dir":"string","msg":"string","name":"string","numprocs":"string","status":[{"PID":"string","msg":"string","name":"string","status":"string","uptime":"string"}],"user":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.SupervisorProcessConfig](#schemaresponse.supervisorprocessconfig)|

## POST Create Supervisor process

POST /host/tool/supervisor/process

> Body 请求参数

```json
{
  "command": "string",
  "dir": "string",
  "name": "string",
  "numprocs": "string",
  "operate": "string",
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.SupervisorProcessConfig](#schemarequest.supervisorprocessconfig)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get Supervisor process config file

POST /host/tool/supervisor/process/file

> Body 请求参数

```json
{
  "content": "string",
  "file": "out.log",
  "name": "string",
  "operate": "get"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.SupervisorProcessFileReq](#schemarequest.supervisorprocessfilereq)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

# Firewall

## GET Load firewall base info

GET /hosts/firewall/base

> 返回示例

> 200 Response

```
{"isActive":true,"isExist":true,"name":"string","pingStatus":"string","version":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.FirewallBaseInfo](#schemadto.firewallbaseinfo)|

## POST Create group

POST /hosts/firewall/batch

> Body 请求参数

```json
{
  "rules": [
    {
      "address": "string",
      "description": "string",
      "operation": "add",
      "port": "string",
      "protocol": "tcp",
      "strategy": "accept"
    }
  ],
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchRuleOperate](#schemadto.batchruleoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create group

POST /hosts/firewall/forward

> Body 请求参数

```json
{
  "forceDelete": true,
  "rules": [
    {
      "num": "string",
      "operation": "add",
      "port": "string",
      "protocol": "tcp",
      "targetIP": "string",
      "targetPort": "string"
    }
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ForwardRuleOperate](#schemadto.forwardruleoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create group

POST /hosts/firewall/ip

> Body 请求参数

```json
{
  "address": "string",
  "description": "string",
  "operation": "add",
  "strategy": "accept"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.AddrRuleOperate](#schemadto.addrruleoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Operate firewall

POST /hosts/firewall/operate

> Body 请求参数

```json
{
  "operation": "start"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.FirewallOperation](#schemadto.firewalloperation)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create group

POST /hosts/firewall/port

> Body 请求参数

```json
{
  "address": "string",
  "description": "string",
  "operation": "add",
  "port": "string",
  "protocol": "tcp",
  "strategy": "accept"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PortRuleOperate](#schemadto.portruleoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page firewall rules

POST /hosts/firewall/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0,
  "status": "string",
  "strategy": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.RuleSearch](#schemadto.rulesearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Create group

POST /hosts/firewall/update/addr

> Body 请求参数

```json
{
  "newRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "strategy": "accept"
  },
  "oldRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "strategy": "accept"
  }
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.AddrRuleUpdate](#schemadto.addrruleupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update rule description

POST /hosts/firewall/update/description

> Body 请求参数

```json
{
  "address": "string",
  "description": "string",
  "port": "string",
  "protocol": "string",
  "strategy": "accept",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.UpdateFirewallDescription](#schemadto.updatefirewalldescription)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create group

POST /hosts/firewall/update/port

> Body 请求参数

```json
{
  "newRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "port": "string",
    "protocol": "tcp",
    "strategy": "accept"
  },
  "oldRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "port": "string",
    "protocol": "tcp",
    "strategy": "accept"
  }
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PortRuleUpdate](#schemadto.portruleupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Monitor

## POST Clean monitor data

POST /hosts/monitor/clean

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load monitor data

POST /hosts/monitor/search

> Body 请求参数

```json
{
  "endTime": "string",
  "info": "string",
  "param": "all",
  "startTime": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MonitorSearch](#schemadto.monitorsearch)| 是 |none|

> 返回示例

> 200 Response

```
[{"date":["string"],"param":"cpu","value":[null]}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.MonitorData](#schemadto.monitordata)]|false|none||none|
|» date|[string]|false|none||none|
|» param|string|true|none||none|
|» value|[any]|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|param|cpu|
|param|memory|
|param|load|
|param|io|
|param|network|

## GET Load monitor setting

GET /hosts/monitor/setting

> 返回示例

> 200 Response

```
{"defaultNetwork":"string","monitorInterval":"string","monitorStatus":"string","monitorStoreDays":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.MonitorSetting](#schemadto.monitorsetting)|

## POST Update monitor setting

POST /hosts/monitor/setting/update

> Body 请求参数

```json
{
  "key": "MonitorStatus",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.MonitorSettingUpdate](#schemadto.monitorsettingupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Website

## GET Delete runtime

GET /installed/delete/check/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|string| 是 |none|

> 返回示例

> 200 Response

```
[{"name":"string","type":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.AppResource](#schemadto.appresource)]|false|none||none|
|» name|string|false|none||none|
|» type|string|false|none||none|

## POST Delete runtime

POST /runtimes/del

> Body 请求参数

```json
{
  "forceDelete": true,
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.RuntimeDelete](#schemarequest.runtimedelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Create website

POST /websites

> Body 请求参数

```json
{
  "IPV6": true,
  "alias": "string",
  "appID": 0,
  "appInstall": {
    "advanced": true,
    "allowPort": true,
    "appDetailID": 0,
    "containerName": "string",
    "cpuQuota": 0,
    "dockerCompose": "string",
    "editCompose": true,
    "gpuConfig": true,
    "hostMode": true,
    "memoryLimit": 0,
    "memoryUnit": "string",
    "name": "string",
    "params": {},
    "pullImage": true,
    "type": "string",
    "webUI": "string"
  },
  "appInstallID": 0,
  "appType": "new",
  "createDb": true,
  "dbFormat": "string",
  "dbHost": "string",
  "dbName": "string",
  "dbPassword": "string",
  "dbUser": "string",
  "domains": [
    {
      "domain": "string",
      "port": 0,
      "ssl": true
    }
  ],
  "enableSSL": true,
  "ftpPassword": "string",
  "ftpUser": "string",
  "parentWebsiteID": 0,
  "port": 0,
  "proxy": "string",
  "proxyType": "string",
  "remark": "string",
  "runtimeID": 0,
  "taskID": "string",
  "type": "string",
  "webSiteGroupID": 0,
  "websiteSSLID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCreate](#schemarequest.websitecreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Search website by id

GET /websites/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|

> 返回示例

> 200 Response

```
{"IPV6":true,"accessLog":true,"accessLogPath":"string","alias":"string","appInstallId":0,"appName":"string","createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":"string","domain":"string","id":0,"port":0,"ssl":true,"updatedAt":"string","websiteId":0}],"errorLog":true,"errorLogPath":"string","expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"runtimeName":"string","runtimeType":"string","siteDir":"string","sitePath":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":true,"accessLog":true,"alias":"string","appInstallId":0,"createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":null,"domain":null,"id":null,"port":null,"ssl":null,"updatedAt":null,"websiteId":null}],"errorLog":true,"expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"siteDir":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[null]},"webSiteSSLId":0}]},"webSiteSSLId":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteDTO](#schemaresponse.websitedto)|

## POST Get AuthBasic conf

POST /websites/auths

> Body 请求参数

```json
{
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxAuthReq](#schemarequest.nginxauthreq)| 是 |none|

> 返回示例

> 200 Response

```
{"enable":true,"items":[{"remark":"string","username":"string"}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxAuthRes](#schemaresponse.nginxauthres)|

## POST Get AuthBasic conf

POST /websites/auths/path

> Body 请求参数

```json
{
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxAuthReq](#schemarequest.nginxauthreq)| 是 |none|

> 返回示例

> 200 Response

```
{"name":"string","path":"string","remark":"string","username":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxPathAuthRes](#schemaresponse.nginxpathauthres)|

## POST Get AuthBasic conf

POST /websites/auths/path/update

> Body 请求参数

```json
{
  "name": "string",
  "operate": "string",
  "password": "string",
  "path": "string",
  "remark": "string",
  "username": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxPathAuthUpdate](#schemarequest.nginxpathauthupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get AuthBasic conf

POST /websites/auths/update

> Body 请求参数

```json
{
  "operate": "string",
  "password": "string",
  "remark": "string",
  "username": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxAuthUpdate](#schemarequest.nginxauthupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Check before create website

POST /websites/check

> Body 请求参数

```json
{
  "InstallIds": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteInstallCheckReq](#schemarequest.websiteinstallcheckreq)| 是 |none|

> 返回示例

> 200 Response

```
[{"appName":"string","name":"string","status":"string","version":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.WebsitePreInstallCheck](#schemaresponse.websitepreinstallcheck)]|false|none||none|
|» appName|string|false|none||none|
|» name|string|false|none||none|
|» status|string|false|none||none|
|» version|string|false|none||none|

## GET Get databases

GET /websites/databases

> 返回示例

> 200 Response

```
{"id":0,"name":"string","type":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.Database](#schemaresponse.database)|

## POST Change website database

POST /websites/databases

> Body 请求参数

```json
{
  "databaseID": 0,
  "databaseType": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.ChangeDatabase](#schemarequest.changedatabase)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get default html

GET /websites/default/html/{type}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|type|path|string| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteHtmlRes](#schemaresponse.websitehtmlres)|

## POST Update default html

POST /websites/default/html/update

> Body 请求参数

```json
{
  "content": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteHtmlUpdate](#schemarequest.websitehtmlupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Change default server

POST /websites/default/server

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDefaultUpdate](#schemarequest.websitedefaultupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete website

POST /websites/del

> Body 请求参数

```json
{
  "deleteApp": true,
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDelete](#schemarequest.websitedelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get website dir

POST /websites/dir

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCommonReq](#schemarequest.websitecommonreq)| 是 |none|

> 返回示例

> 200 Response

```
{"dirs":["string"],"msg":"string","user":"string","userGroup":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteDirConfig](#schemaresponse.websitedirconfig)|

## POST Update Site Dir permission

POST /websites/dir/permission

> Body 请求参数

```json
{
  "group": "string",
  "id": 0,
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteUpdateDirPermission](#schemarequest.websiteupdatedirpermission)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update Site Dir

POST /websites/dir/update

> Body 请求参数

```json
{
  "id": 0,
  "siteDir": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteUpdateDir](#schemarequest.websiteupdatedir)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get website upstreams

GET /websites/lbs

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCommonReq](#schemarequest.websitecommonreq)| 是 |none|

> 返回示例

> 200 Response

```
[{"algorithm":"string","content":"string","name":"string","servers":[{"failTimeout":"string","flag":"string","maxConns":0,"maxFails":0,"server":"string","weight":0}]}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[dto.NginxUpstream](#schemadto.nginxupstream)]|false|none||none|
|» algorithm|string|false|none||none|
|» content|string|false|none||none|
|» name|string|false|none||none|
|» servers|[[dto.NginxUpstreamServer](#schemadto.nginxupstreamserver)]|false|none||none|
|»» failTimeout|string|false|none||none|
|»» flag|string|false|none||none|
|»» maxConns|integer|false|none||none|
|»» maxFails|integer|false|none||none|
|»» server|string|false|none||none|
|»» weight|integer|false|none||none|

## POST Create website upstream

POST /websites/lbs/create

> Body 请求参数

```json
{
  "algorithm": "string",
  "name": "string",
  "servers": [
    {
      "failTimeout": "string",
      "flag": "string",
      "maxConns": 0,
      "maxFails": 0,
      "server": "string",
      "weight": 0
    }
  ],
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteLBCreate](#schemarequest.websitelbcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete website upstream

POST /websites/lbs/delete

> Body 请求参数

```json
{
  "name": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteLBDelete](#schemarequest.websitelbdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update website upstream file

POST /websites/lbs/file

> Body 请求参数

```json
{
  "content": "string",
  "name": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteLBUpdateFile](#schemarequest.websitelbupdatefile)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update website upstream

POST /websites/lbs/update

> Body 请求参数

```json
{
  "algorithm": "string",
  "name": "string",
  "servers": [
    {
      "failTimeout": "string",
      "flag": "string",
      "maxConns": 0,
      "maxFails": 0,
      "server": "string",
      "weight": 0
    }
  ],
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteLBUpdate](#schemarequest.websitelbupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get AntiLeech conf

POST /websites/leech

> Body 请求参数

```json
{
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxCommonReq](#schemarequest.nginxcommonreq)| 是 |none|

> 返回示例

> 200 Response

```
{"blocked":true,"cache":true,"cacheTime":0,"cacheUint":"string","enable":true,"extends":"string","logEnable":true,"noneRef":true,"return":"string","serverNames":["string"]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxAntiLeechRes](#schemaresponse.nginxantileechres)|

## POST Update AntiLeech

POST /websites/leech/update

> Body 请求参数

```json
{
  "blocked": true,
  "cache": true,
  "cacheTime": 0,
  "cacheUint": "string",
  "enable": true,
  "extends": "string",
  "logEnable": true,
  "noneRef": true,
  "return": "string",
  "serverNames": [
    "string"
  ],
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxAntiLeechUpdate](#schemarequest.nginxantileechupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET List websites

GET /websites/list

> 返回示例

> 200 Response

```
[{"IPV6":true,"accessLog":true,"accessLogPath":"string","alias":"string","appInstallId":0,"appName":"string","createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":"string","domain":"string","id":0,"port":0,"ssl":true,"updatedAt":"string","websiteId":0}],"errorLog":true,"errorLogPath":"string","expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"runtimeName":"string","runtimeType":"string","siteDir":"string","sitePath":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":true,"accessLog":true,"alias":"string","appInstallId":0,"createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{}],"errorLog":true,"expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"siteDir":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":null,"acmeAccountId":null,"autoRenew":null,"caId":null,"certURL":null,"createdAt":null,"description":null,"dir":null,"disableCNAME":null,"dnsAccount":null,"dnsAccountId":null,"domains":null,"execShell":null,"expireDate":null,"id":null,"keyType":null,"message":null,"nameserver1":null,"nameserver2":null,"organization":null,"pem":null,"primaryDomain":null,"privateKey":null,"provider":null,"pushDir":null,"shell":null,"skipDNS":null,"startDate":null,"status":null,"type":null,"updatedAt":null,"websites":null},"webSiteSSLId":0}]},"webSiteSSLId":0}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.WebsiteDTO](#schemaresponse.websitedto)]|false|none||none|
|» IPV6|boolean|false|none||none|
|» accessLog|boolean|false|none||none|
|» accessLogPath|string|false|none||none|
|» alias|string|false|none||none|
|» appInstallId|integer|false|none||none|
|» appName|string|false|none||none|
|» createdAt|string|false|none||none|
|» dbID|integer|false|none||none|
|» dbType|string|false|none||none|
|» defaultServer|boolean|false|none||none|
|» domains|[[model.WebsiteDomain](#schemamodel.websitedomain)]|false|none||none|
|»» createdAt|string|false|none||none|
|»» domain|string|false|none||none|
|»» id|integer|false|none||none|
|»» port|integer|false|none||none|
|»» ssl|boolean|false|none||none|
|»» updatedAt|string|false|none||none|
|»» websiteId|integer|false|none||none|
|» errorLog|boolean|false|none||none|
|» errorLogPath|string|false|none||none|
|» expireDate|string|false|none||none|
|» ftpId|integer|false|none||none|
|» group|string|false|none||none|
|» httpConfig|string|false|none||none|
|» id|integer|false|none||none|
|» parentWebsiteID|integer|false|none||none|
|» primaryDomain|string|false|none||none|
|» protocol|string|false|none||none|
|» proxy|string|false|none||none|
|» proxyType|string|false|none||none|
|» remark|string|false|none||none|
|» rewrite|string|false|none||none|
|» runtimeID|integer|false|none||none|
|» runtimeName|string|false|none||none|
|» runtimeType|string|false|none||none|
|» siteDir|string|false|none||none|
|» sitePath|string|false|none||none|
|» status|string|false|none||none|
|» type|string|false|none||none|
|» updatedAt|string|false|none||none|
|» user|string|false|none||none|
|» webSiteGroupId|integer|false|none||none|
|» webSiteSSL|[model.WebsiteSSL](#schemamodel.websitessl)|false|none||none|
|»» acmeAccount|[model.WebsiteAcmeAccount](#schemamodel.websiteacmeaccount)|false|none||none|
|»»» createdAt|string|false|none||none|
|»»» eabHmacKey|string|false|none||none|
|»»» eabKid|string|false|none||none|
|»»» email|string|false|none||none|
|»»» id|integer|false|none||none|
|»»» keyType|string|false|none||none|
|»»» type|string|false|none||none|
|»»» updatedAt|string|false|none||none|
|»»» url|string|false|none||none|
|»» acmeAccountId|integer|false|none||none|
|»» autoRenew|boolean|false|none||none|
|»» caId|integer|false|none||none|
|»» certURL|string|false|none||none|
|»» createdAt|string|false|none||none|
|»» description|string|false|none||none|
|»» dir|string|false|none||none|
|»» disableCNAME|boolean|false|none||none|
|»» dnsAccount|[model.WebsiteDnsAccount](#schemamodel.websitednsaccount)|false|none||none|
|»»» createdAt|string|false|none||none|
|»»» id|integer|false|none||none|
|»»» name|string|false|none||none|
|»»» type|string|false|none||none|
|»»» updatedAt|string|false|none||none|
|»» dnsAccountId|integer|false|none||none|
|»» domains|string|false|none||none|
|»» execShell|boolean|false|none||none|
|»» expireDate|string|false|none||none|
|»» id|integer|false|none||none|
|»» keyType|string|false|none||none|
|»» message|string|false|none||none|
|»» nameserver1|string|false|none||none|
|»» nameserver2|string|false|none||none|
|»» organization|string|false|none||none|
|»» pem|string|false|none||none|
|»» primaryDomain|string|false|none||none|
|»» privateKey|string|false|none||none|
|»» provider|string|false|none||none|
|»» pushDir|boolean|false|none||none|
|»» shell|string|false|none||none|
|»» skipDNS|boolean|false|none||none|
|»» startDate|string|false|none||none|
|»» status|string|false|none||none|
|»» type|string|false|none||none|
|»» updatedAt|string|false|none||none|
|»» websites|[[model.Website](#schemamodel.website)]|false|none||none|
|»»» IPV6|boolean|false|none||none|
|»»» accessLog|boolean|false|none||none|
|»»» alias|string|false|none||none|
|»»» appInstallId|integer|false|none||none|
|»»» createdAt|string|false|none||none|
|»»» dbID|integer|false|none||none|
|»»» dbType|string|false|none||none|
|»»» defaultServer|boolean|false|none||none|
|»»» domains|[[model.WebsiteDomain](#schemamodel.websitedomain)]|false|none||none|
|»»»» createdAt|string|false|none||none|
|»»»» domain|string|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» port|integer|false|none||none|
|»»»» ssl|boolean|false|none||none|
|»»»» updatedAt|string|false|none||none|
|»»»» websiteId|integer|false|none||none|
|»»» errorLog|boolean|false|none||none|
|»»» expireDate|string|false|none||none|
|»»» ftpId|integer|false|none||none|
|»»» group|string|false|none||none|
|»»» httpConfig|string|false|none||none|
|»»» id|integer|false|none||none|
|»»» parentWebsiteID|integer|false|none||none|
|»»» primaryDomain|string|false|none||none|
|»»» protocol|string|false|none||none|
|»»» proxy|string|false|none||none|
|»»» proxyType|string|false|none||none|
|»»» remark|string|false|none||none|
|»»» rewrite|string|false|none||none|
|»»» runtimeID|integer|false|none||none|
|»»» siteDir|string|false|none||none|
|»»» status|string|false|none||none|
|»»» type|string|false|none||none|
|»»» updatedAt|string|false|none||none|
|»»» user|string|false|none||none|
|»»» webSiteGroupId|integer|false|none||none|
|»»» webSiteSSL|[model.WebsiteSSL](#schemamodel.websitessl)|false|none||none|
|»»»» acmeAccount|[model.WebsiteAcmeAccount](#schemamodel.websiteacmeaccount)|false|none||none|
|»»»» acmeAccountId|integer|false|none||none|
|»»»» autoRenew|boolean|false|none||none|
|»»»» caId|integer|false|none||none|
|»»»» certURL|string|false|none||none|
|»»»» createdAt|string|false|none||none|
|»»»» description|string|false|none||none|
|»»»» dir|string|false|none||none|
|»»»» disableCNAME|boolean|false|none||none|
|»»»» dnsAccount|[model.WebsiteDnsAccount](#schemamodel.websitednsaccount)|false|none||none|
|»»»» dnsAccountId|integer|false|none||none|
|»»»» domains|string|false|none||none|
|»»»» execShell|boolean|false|none||none|
|»»»» expireDate|string|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» keyType|string|false|none||none|
|»»»» message|string|false|none||none|
|»»»» nameserver1|string|false|none||none|
|»»»» nameserver2|string|false|none||none|
|»»»» organization|string|false|none||none|
|»»»» pem|string|false|none||none|
|»»»» primaryDomain|string|false|none||none|
|»»»» privateKey|string|false|none||none|
|»»»» provider|string|false|none||none|
|»»»» pushDir|boolean|false|none||none|
|»»»» shell|string|false|none||none|
|»»»» skipDNS|boolean|false|none||none|
|»»»» startDate|string|false|none||none|
|»»»» status|string|false|none||none|
|»»»» type|string|false|none||none|
|»»»» updatedAt|string|false|none||none|
|»»»» websites|[[model.Website](#schemamodel.website)]|false|none||none|
|»»» webSiteSSLId|integer|false|none||none|
|» webSiteSSLId|integer|false|none||none|

## POST Operate website log

POST /websites/log

> Body 请求参数

```json
{
  "id": 0,
  "logType": "string",
  "operate": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteLogReq](#schemarequest.websitelogreq)| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string","enable":true,"end":true,"path":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteLog](#schemaresponse.websitelog)|

## POST Operate website

POST /websites/operate

> Body 请求参数

```json
{
  "id": 0,
  "operate": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteOp](#schemarequest.websiteop)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List website names

POST /websites/options

> 返回示例

> 200 Response

```
[{"alias":"string","id":0,"primaryDomain":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.WebsiteOption](#schemaresponse.websiteoption)]|false|none||none|
|» alias|string|false|none||none|
|» id|integer|false|none||none|
|» primaryDomain|string|false|none||none|

## POST Get proxy conf

POST /websites/proxies

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteProxyReq](#schemarequest.websiteproxyreq)| 是 |none|

> 返回示例

> 200 Response

```
[{"cache":true,"cacheTime":0,"cacheUnit":"string","content":"string","enable":true,"filePath":"string","id":0,"match":"string","modifier":"string","name":"string","operate":"string","proxyHost":"string","proxyPass":"string","proxySSLName":"string","replaces":{"property1":"string","property2":"string"},"sni":true}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[request.WebsiteProxyConfig](#schemarequest.websiteproxyconfig)]|false|none||none|
|» cache|boolean|false|none||none|
|» cacheTime|integer|false|none||none|
|» cacheUnit|string|false|none||none|
|» content|string|false|none||none|
|» enable|boolean|false|none||none|
|» filePath|string|false|none||none|
|» id|integer|true|none||none|
|» match|string|true|none||none|
|» modifier|string|false|none||none|
|» name|string|true|none||none|
|» operate|string|true|none||none|
|» proxyHost|string|true|none||none|
|» proxyPass|string|true|none||none|
|» proxySSLName|string|false|none||none|
|» replaces|object|false|none||none|
|»» **additionalProperties**|string|false|none||none|
|» sni|boolean|false|none||none|

## POST Update proxy conf

POST /websites/proxies/update

> Body 请求参数

```json
{
  "cache": true,
  "cacheTime": 0,
  "cacheUnit": "string",
  "content": "string",
  "enable": true,
  "filePath": "string",
  "id": 0,
  "match": "string",
  "modifier": "string",
  "name": "string",
  "operate": "string",
  "proxyHost": "string",
  "proxyPass": "string",
  "proxySSLName": "string",
  "replaces": {
    "property1": "string",
    "property2": "string"
  },
  "sni": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteProxyConfig](#schemarequest.websiteproxyconfig)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Clear Website proxy cache

POST /websites/proxy/clear

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST update website proxy cache config

POST /websites/proxy/config

> Body 请求参数

```json
{
  "cacheExpire": 0,
  "cacheExpireUnit": "string",
  "cacheLimit": 0,
  "cacheLimitUnit": "string",
  "open": true,
  "shareCache": 0,
  "shareCacheUnit": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxProxyCacheUpdate](#schemarequest.nginxproxycacheupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update proxy file

POST /websites/proxy/file

> Body 请求参数

```json
{
  "content": "string",
  "name": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxProxyUpdate](#schemarequest.nginxproxyupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Set Real IP

POST /websites/realip

> Body 请求参数

```json
{
  "ipFrom": "string",
  "ipHeader": "string",
  "ipOther": "string",
  "open": true,
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteRealIP](#schemarequest.websiterealip)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get Real IP Config

GET /websites/realip/config/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |id|

> 返回示例

> 200 Response

```
{"ipFrom":"string","ipHeader":"string","ipOther":"string","open":true,"websiteID":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteRealIP](#schemaresponse.websiterealip)|

## POST Get redirect conf

POST /websites/redirect

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteProxyReq](#schemarequest.websiteproxyreq)| 是 |none|

> 返回示例

> 200 Response

```
[{"content":"string","domains":["string"],"enable":true,"filePath":"string","keepPath":true,"name":"string","path":"string","redirect":"string","redirectRoot":true,"target":"string","type":"string","websiteID":0}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.NginxRedirectConfig](#schemaresponse.nginxredirectconfig)]|false|none||none|
|» content|string|false|none||none|
|» domains|[string]|false|none||none|
|» enable|boolean|false|none||none|
|» filePath|string|false|none||none|
|» keepPath|boolean|false|none||none|
|» name|string|false|none||none|
|» path|string|false|none||none|
|» redirect|string|false|none||none|
|» redirectRoot|boolean|false|none||none|
|» target|string|false|none||none|
|» type|string|false|none||none|
|» websiteID|integer|false|none||none|

## POST Update redirect file

POST /websites/redirect/file

> Body 请求参数

```json
{
  "content": "string",
  "name": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxRedirectUpdate](#schemarequest.nginxredirectupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update redirect conf

POST /websites/redirect/update

> Body 请求参数

```json
{
  "domains": [
    "string"
  ],
  "enable": true,
  "keepPath": true,
  "name": "string",
  "operate": "string",
  "path": "string",
  "redirect": "string",
  "redirectRoot": true,
  "target": "string",
  "type": "string",
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxRedirectReq](#schemarequest.nginxredirectreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get website resource

GET /websites/resource/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |id|

> 返回示例

> 200 Response

```
{"detail":null,"name":"string","resourceID":0,"type":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.Resource](#schemaresponse.resource)|

## POST Get rewrite conf

POST /websites/rewrite

> Body 请求参数

```json
{
  "name": "string",
  "websiteId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxRewriteReq](#schemarequest.nginxrewritereq)| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxRewriteRes](#schemaresponse.nginxrewriteres)|

## GET List custom rewrite

GET /websites/rewrite/custom

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Operate custom rewrite

POST /websites/rewrite/custom

> Body 请求参数

```json
{
  "content": "string",
  "name": "string",
  "operate": "create"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.CustomRewriteOperate](#schemarequest.customrewriteoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update rewrite conf

POST /websites/rewrite/update

> Body 请求参数

```json
{
  "content": "string",
  "name": "string",
  "websiteId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxRewriteUpdate](#schemarequest.nginxrewriteupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page websites

POST /websites/search

> Body 请求参数

```json
{
  "name": "string",
  "order": "null",
  "orderBy": "primary_domain",
  "page": 0,
  "pageSize": 0,
  "websiteGroupId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteSearch](#schemarequest.websitesearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update website

POST /websites/update

> Body 请求参数

```json
{
  "IPV6": true,
  "expireDate": "string",
  "id": 0,
  "primaryDomain": "string",
  "remark": "string",
  "webSiteGroupID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteUpdate](#schemarequest.websiteupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# TaskLog

## GET Get the number of executing tasks

GET /logs/tasks/executing/count

> 返回示例

> 200 Response

```
0
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|integer|

## POST Page task logs

POST /logs/tasks/search

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0,
  "status": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchTaskLogReq](#schemadto.searchtasklogreq)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

# OpenResty

## GET Load OpenResty conf

GET /openresty

> 返回示例

> 200 Response

```
{"content":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxFile](#schemaresponse.nginxfile)|

## POST Build OpenResty

POST /openresty/build

> Body 请求参数

```json
{
  "mirror": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxBuildReq](#schemarequest.nginxbuildreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update OpenResty conf by upload file

POST /openresty/file

> Body 请求参数

```json
{
  "backup": true,
  "content": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxConfigFileUpdate](#schemarequest.nginxconfigfileupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update OpenResty module

POST /openresty/module/update

> Body 请求参数

```json
{
  "enable": true,
  "name": "string",
  "operate": "create",
  "packages": "string",
  "params": "string",
  "script": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxModuleUpdate](#schemarequest.nginxmoduleupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get OpenResty modules

GET /openresty/modules

> 返回示例

> 200 Response

```
{"mirror":"string","modules":[{"enable":true,"name":"string","packages":"string","params":"string","script":"string"}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxBuildConfig](#schemaresponse.nginxbuildconfig)|

## POST Load partial OpenResty conf

POST /openresty/scope

> Body 请求参数

```json
{
  "scope": "index",
  "websiteId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxScopeReq](#schemarequest.nginxscopereq)| 是 |none|

> 返回示例

> 200 Response

```
[{"name":"string","params":["string"]}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.NginxParam](#schemaresponse.nginxparam)]|false|none||none|
|» name|string|false|none||none|
|» params|[string]|false|none||none|

## GET Load OpenResty status info

GET /openresty/status

> 返回示例

> 200 Response

```
{"accepts":0,"active":0,"handled":0,"reading":0,"requests":0,"waiting":0,"writing":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.NginxStatus](#schemaresponse.nginxstatus)|

## POST Update OpenResty conf

POST /openresty/update

> Body 请求参数

```json
{
  "operate": "add",
  "params": null,
  "scope": "index",
  "websiteId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxConfigUpdate](#schemarequest.nginxconfigupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Process

## POST Stop Process

POST /process/stop

> Body 请求参数

```json
{
  "PID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.ProcessReq](#schemarequest.processreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Runtime

## POST Create runtime

POST /runtimes

> Body 请求参数

```json
{
  "appDetailId": 0,
  "clean": true,
  "codeDir": "string",
  "environments": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "exposedPorts": [
    {
      "containerPort": 0,
      "hostIP": "string",
      "hostPort": 0
    }
  ],
  "image": "string",
  "install": true,
  "name": "string",
  "params": {},
  "resource": "string",
  "source": "string",
  "type": "string",
  "version": "string",
  "volumes": [
    {
      "source": "string",
      "target": "string"
    }
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.RuntimeCreate](#schemarequest.runtimecreate)| 是 |none|

> 返回示例

> 200 Response

```
{"appDetailID":0,"codeDir":"string","containerName":"string","createdAt":"string","dockerCompose":"string","env":"string","id":0,"image":"string","message":"string","name":"string","params":"string","port":"string","resource":"string","status":"string","type":"string","updatedAt":"string","version":"string","workDir":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[model.Runtime](#schemamodel.runtime)|

## GET Get runtime

GET /runtimes/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|string| 是 |request|

> 返回示例

> 200 Response

```
{"appDetailID":0,"appID":0,"appParams":[{"edit":true,"key":"string","labelEn":"string","labelZh":"string","multiple":true,"required":true,"rule":"string","showValue":"string","type":"string","value":null,"values":null}],"codeDir":"string","containerStatus":"string","createdAt":"string","environments":[{"key":"string","value":"string"}],"exposedPorts":[{"containerPort":0,"hostIP":"string","hostPort":0}],"id":0,"image":"string","message":"string","name":"string","params":{},"path":"string","port":"string","resource":"string","source":"string","status":"string","type":"string","version":"string","volumes":[{"source":"string","target":"string"}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.RuntimeDTO](#schemaresponse.runtimedto)|

## POST Get Node modules

POST /runtimes/node/modules

> Body 请求参数

```json
{
  "ID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NodeModuleReq](#schemarequest.nodemodulereq)| 是 |none|

> 返回示例

> 200 Response

```
[{"description":"string","license":"string","name":"string","version":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.NodeModule](#schemaresponse.nodemodule)]|false|none||none|
|» description|string|false|none||none|
|» license|string|false|none||none|
|» name|string|false|none||none|
|» version|string|false|none||none|

## POST Operate Node modules

POST /runtimes/node/modules/operate

> Body 请求参数

```json
{
  "ID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NodeModuleReq](#schemarequest.nodemodulereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get Node package scripts

POST /runtimes/node/package

> Body 请求参数

```json
{
  "codeDir": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NodePackageReq](#schemarequest.nodepackagereq)| 是 |none|

> 返回示例

> 200 Response

```
[{"name":"string","script":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.PackageScripts](#schemaresponse.packagescripts)]|false|none||none|
|» name|string|false|none||none|
|» script|string|false|none||none|

## POST Operate runtime

POST /runtimes/operate

> Body 请求参数

```json
{
  "ID": 0,
  "operate": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.RuntimeOperate](#schemarequest.runtimeoperate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get php runtime extension

GET /runtimes/php/{id}/extensions

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|string| 是 |request|

> 返回示例

> 200 Response

```
{"extensions":["string"],"supportExtensions":[{"check":"string","description":"string","file":"string","installed":true,"name":"string","versions":["string"]}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.PHPExtensionRes](#schemaresponse.phpextensionres)|

## POST Update runtime php conf

POST /runtimes/php/config

> Body 请求参数

```json
{
  "disableFunctions": [
    "string"
  ],
  "id": 0,
  "params": {
    "property1": "string",
    "property2": "string"
  },
  "scope": "string",
  "uploadMaxSize": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPConfigUpdate](#schemarequest.phpconfigupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load php runtime conf

GET /runtimes/php/config/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|

> 返回示例

> 200 Response

```
{"disableFunctions":["string"],"params":{"property1":"string","property2":"string"},"uploadMaxSize":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.PHPConfig](#schemaresponse.phpconfig)|

## POST Install php extension

POST /runtimes/php/extensions/install

> Body 请求参数

```json
{
  "ID": 0,
  "name": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPExtensionInstallReq](#schemarequest.phpextensioninstallreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST UnInstall php extension

POST /runtimes/php/extensions/uninstall

> Body 请求参数

```json
{
  "ID": 0,
  "name": "string",
  "taskID": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPExtensionInstallReq](#schemarequest.phpextensioninstallreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Get php conf file

POST /runtimes/php/file

> Body 请求参数

```json
{
  "id": 0,
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPFileReq](#schemarequest.phpfilereq)| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.FileInfo](#schemaresponse.fileinfo)|

## POST Update fpm config

POST /runtimes/php/fpm/config

> Body 请求参数

```json
{
  "id": 0,
  "params": {}
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.FPMConfig](#schemarequest.fpmconfig)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Get fpm config

GET /runtimes/php/fpm/config/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|

> 返回示例

> 200 Response

```
{"id":0,"params":{}}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[request.FPMConfig](#schemarequest.fpmconfig)|

## POST Update php conf file

POST /runtimes/php/update

> Body 请求参数

```json
{
  "content": "string",
  "id": 0,
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPFileUpdate](#schemarequest.phpfileupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST List runtimes

POST /runtimes/search

> Body 请求参数

```json
{
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "status": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.RuntimeSearch](#schemarequest.runtimesearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## GET Get supervisor process

GET /runtimes/supervisor/process/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|

> 返回示例

> 200 Response

```
[{"command":"string","dir":"string","msg":"string","name":"string","numprocs":"string","status":[{"PID":"string","msg":"string","name":"string","status":"string","uptime":"string"}],"user":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.SupervisorProcessConfig](#schemaresponse.supervisorprocessconfig)]|false|none||none|
|» command|string|false|none||none|
|» dir|string|false|none||none|
|» msg|string|false|none||none|
|» name|string|false|none||none|
|» numprocs|string|false|none||none|
|» status|[[response.ProcessStatus](#schemaresponse.processstatus)]|false|none||none|
|»» PID|string|false|none||none|
|»» msg|string|false|none||none|
|»» name|string|false|none||none|
|»» status|string|false|none||none|
|»» uptime|string|false|none||none|
|» user|string|false|none||none|

## POST Operate supervisor process file

POST /runtimes/supervisor/process/file/operate

> Body 请求参数

```json
{
  "content": "string",
  "file": "out.log",
  "id": 0,
  "name": "string",
  "operate": "get"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPSupervisorProcessFileReq](#schemarequest.phpsupervisorprocessfilereq)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Operate supervisor process

POST /runtimes/supervisor/process/operate

> Body 请求参数

```json
{
  "command": "string",
  "dir": "string",
  "id": 0,
  "name": "string",
  "numprocs": "string",
  "operate": "string",
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPSupervisorProcessConfig](#schemarequest.phpsupervisorprocessconfig)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Sync runtime status

POST /runtimes/sync

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update runtime

POST /runtimes/update

> Body 请求参数

```json
{
  "clean": true,
  "codeDir": "string",
  "environments": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "exposedPorts": [
    {
      "containerPort": 0,
      "hostIP": "string",
      "hostPort": 0
    }
  ],
  "id": 0,
  "image": "string",
  "install": true,
  "name": "string",
  "params": {},
  "rebuild": true,
  "source": "string",
  "version": "string",
  "volumes": [
    {
      "source": "string",
      "target": "string"
    }
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.RuntimeUpdate](#schemarequest.runtimeupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# PHP Extensions

## POST Create Extensions

POST /runtimes/php/extensions

> Body 请求参数

```json
{
  "extensions": "string",
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPExtensionsCreate](#schemarequest.phpextensionscreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete Extensions

POST /runtimes/php/extensions/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPExtensionsDelete](#schemarequest.phpextensionsdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page Extensions

POST /runtimes/php/extensions/search

> Body 请求参数

```json
{
  "all": true,
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPExtensionsSearch](#schemarequest.phpextensionssearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update Extensions

POST /runtimes/php/extensions/update

> Body 请求参数

```json
{
  "extensions": "string",
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.PHPExtensionsUpdate](#schemarequest.phpextensionsupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# ScriptLibrary

## POST Add script

POST /script

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete script

POST /script/del

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page script

POST /script/search

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update script

POST /script/update

> Body 请求参数

```json
{}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Clam

## POST Create clam

POST /toolbox/clam

> Body 请求参数

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "description": "string",
  "infectedDir": "string",
  "infectedStrategy": "string",
  "name": "string",
  "path": "string",
  "spec": "string",
  "status": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ClamCreate](#schemadto.clamcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load clam base info

GET /toolbox/clam/base

> 返回示例

> 200 Response

```
{"freshIsActive":true,"freshIsExist":true,"freshVersion":"string","isActive":true,"isExist":true,"version":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.ClamBaseInfo](#schemadto.clambaseinfo)|

## POST Delete clam

POST /toolbox/clam/del

> Body 请求参数

```json
{
  "ids": [
    0
  ],
  "removeInfected": true,
  "removeRecord": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ClamDelete](#schemadto.clamdelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load clam file

POST /toolbox/clam/file/search

> Body 请求参数

```json
{
  "name": "string",
  "tail": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ClamFileReq](#schemadto.clamfilereq)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Update clam file

POST /toolbox/clam/file/update

> Body 请求参数

```json
{
  "file": "string",
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.UpdateByNameAndFile](#schemadto.updatebynameandfile)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Handle clam scan

POST /toolbox/clam/handle

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Operate Clam

POST /toolbox/clam/operate

> Body 请求参数

```json
{
  "operation": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Operate](#schemadto.operate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Clean clam record

POST /toolbox/clam/record/clean

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperateByID](#schemadto.operatebyid)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load clam record detail

POST /toolbox/clam/record/log

> Body 请求参数

```json
{
  "clamName": "string",
  "recordName": "string",
  "tail": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ClamLogReq](#schemadto.clamlogreq)| 是 |none|

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Page clam record

POST /toolbox/clam/record/search

> Body 请求参数

```json
{
  "clamID": 0,
  "endTime": "string",
  "page": 0,
  "pageSize": 0,
  "startTime": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ClamLogSearch](#schemadto.clamlogsearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Page clam

POST /toolbox/clam/search

> Body 请求参数

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchClamWithPage](#schemadto.searchclamwithpage)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update clam status

POST /toolbox/clam/status/update

> Body 请求参数

```json
{
  "id": 0,
  "status": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ClamUpdateStatus](#schemadto.clamupdatestatus)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update clam

POST /toolbox/clam/update

> Body 请求参数

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "description": "string",
  "id": 0,
  "infectedDir": "string",
  "infectedStrategy": "string",
  "name": "string",
  "path": "string",
  "spec": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ClamUpdate](#schemadto.clamupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Device

## POST Clean system

POST /toolbox/clean

> Body 请求参数

```json
[
  {
    "name": "string",
    "size": 0,
    "treeType": "string"
  }
]
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Clean](#schemadto.clean)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load device base info

POST /toolbox/device/base

> 返回示例

> 200 Response

```
{"dns":["string"],"hostname":"string","hosts":[{"host":"string","ip":"string"}],"localTime":"string","maxSize":0,"ntp":"string","swapDetails":[{"isNew":true,"path":"string","size":0,"used":"string"}],"swapMemoryAvailable":0,"swapMemoryTotal":0,"swapMemoryUsed":0,"timeZone":"string","user":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.DeviceBaseInfo](#schemadto.devicebaseinfo)|

## POST Check device DNS conf

POST /toolbox/device/check/dns

> Body 请求参数

```json
{
  "key": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SettingUpdate](#schemadto.settingupdate)| 是 |none|

> 返回示例

> 200 Response

```
true
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|boolean|

## POST load conf

POST /toolbox/device/conf

> Body 请求参数

```json
{
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.OperationWithName](#schemadto.operationwithname)| 是 |none|

> 返回示例

> 200 Response

```
["string"]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

## POST Update device conf by file

POST /toolbox/device/update/byconf

> Body 请求参数

```json
{
  "file": "string",
  "name": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.UpdateByNameAndFile](#schemadto.updatebynameandfile)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update device

POST /toolbox/device/update/conf

> Body 请求参数

```json
{
  "key": "string",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SettingUpdate](#schemadto.settingupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update device hosts

POST /toolbox/device/update/host

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update device passwd

POST /toolbox/device/update/passwd

> Body 请求参数

```json
{
  "passwd": "string",
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.ChangePasswd](#schemadto.changepasswd)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update device swap

POST /toolbox/device/update/swap

> Body 请求参数

```json
{
  "isNew": true,
  "path": "string",
  "size": 0,
  "used": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SwapHelper](#schemadto.swaphelper)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load user list

GET /toolbox/device/users

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET list time zone options

GET /toolbox/device/zone/options

> 返回示例

> 200 Response

```
null
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Array|

## POST Scan system

POST /toolbox/scan

> 返回示例

> 200 Response

```
{"containerClean":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"downloadClean":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"systemClean":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"systemLogClean":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"uploadClean":[{"children":[{"children":[{}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}],"id":"string","isCheck":true,"isRecommend":true,"label":"string","name":"string","size":0,"type":"string"}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.CleanData](#schemadto.cleandata)|

# Fail2ban

## GET Load fail2ban base info

GET /toolbox/fail2ban/base

> 返回示例

> 200 Response

```
{"banAction":"string","banTime":"string","findTime":"string","isActive":true,"isEnable":true,"isExist":true,"logPath":"string","maxRetry":0,"port":0,"version":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.Fail2BanBaseInfo](#schemadto.fail2banbaseinfo)|

## GET Load fail2ban conf

GET /toolbox/fail2ban/load/conf

> 返回示例

> 200 Response

```
"string"
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|string|

## POST Operate fail2ban

POST /toolbox/fail2ban/operate

> Body 请求参数

```json
{
  "operation": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Operate](#schemadto.operate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Operate sshd of fail2ban

POST /toolbox/fail2ban/operate/sshd

> Body 请求参数

```json
{
  "operation": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Operate](#schemadto.operate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page fail2ban ip list

POST /toolbox/fail2ban/search

> Body 请求参数

```json
{
  "status": "banned"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Fail2BanSearch](#schemadto.fail2bansearch)| 是 |none|

> 返回示例

> 200 Response

```
null
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Array|

## POST Update fail2ban conf

POST /toolbox/fail2ban/update

> Body 请求参数

```json
{
  "key": "port",
  "value": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Fail2BanUpdate](#schemadto.fail2banupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update fail2ban conf by file

POST /toolbox/fail2ban/update/byconf

> Body 请求参数

```json
{
  "file": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.UpdateByFile](#schemadto.updatebyfile)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# FTP

## POST Create FTP user

POST /toolbox/ftp

> Body 请求参数

```json
{
  "description": "string",
  "password": "string",
  "path": "string",
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.FtpCreate](#schemadto.ftpcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Load FTP base info

GET /toolbox/ftp/base

> 返回示例

> 200 Response

```
{"isActive":true,"isExist":true}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.FtpBaseInfo](#schemadto.ftpbaseinfo)|

## POST Delete FTP user

POST /toolbox/ftp/del

> Body 请求参数

```json
{
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchDeleteReq](#schemadto.batchdeletereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Load FTP operation log

POST /toolbox/ftp/log/search

> Body 请求参数

```json
{
  "operation": "string",
  "page": 0,
  "pageSize": 0,
  "user": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.FtpLogSearch](#schemadto.ftplogsearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Operate FTP

POST /toolbox/ftp/operate

> Body 请求参数

```json
{
  "operation": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.Operate](#schemadto.operate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page FTP user

POST /toolbox/ftp/search

> Body 请求参数

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.SearchWithPage](#schemadto.searchwithpage)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Sync FTP user

POST /toolbox/ftp/sync

> Body 请求参数

```json
{
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.BatchDeleteReq](#schemadto.batchdeletereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update FTP user

POST /toolbox/ftp/update

> Body 请求参数

```json
{
  "description": "string",
  "id": 0,
  "password": "string",
  "path": "string",
  "status": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.FtpUpdate](#schemadto.ftpupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Website Nginx

## GET Search website nginx by id

GET /websites/{id}/config/{type}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|
|type|path|string| 是 |none|

> 返回示例

> 200 Response

```
{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{"content":"string","extension":"string","favoriteID":0,"gid":"string","group":"string","isDetail":true,"isDir":true,"isHidden":true,"isSymlink":true,"itemTotal":0,"items":[{}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}],"linkPath":"string","mimeType":"string","modTime":"string","mode":"string","name":"string","path":"string","size":0,"type":"string","uid":"string","updateTime":"string","user":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.FileInfo](#schemaresponse.fileinfo)|

## POST Load nginx conf

POST /websites/config

> Body 请求参数

```json
{
  "scope": "index",
  "websiteId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxScopeReq](#schemarequest.nginxscopereq)| 是 |none|

> 返回示例

> 200 Response

```
{"enable":true,"params":[{"name":"string","params":["string"]}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteNginxConfig](#schemaresponse.websitenginxconfig)|

## POST Update nginx conf

POST /websites/config/update

> Body 请求参数

```json
{
  "operate": "add",
  "params": null,
  "scope": "index",
  "websiteId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.NginxConfigUpdate](#schemarequest.nginxconfigupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update website nginx conf

POST /websites/nginx/update

> Body 请求参数

```json
{
  "content": "string",
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteNginxUpdate](#schemarequest.websitenginxupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Website HTTPS

## GET Load https conf

GET /websites/{id}/https

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|

> 返回示例

> 200 Response

```
{"SSL":{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":true,"accessLog":true,"alias":"string","appInstallId":0,"createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":null,"domain":null,"id":null,"port":null,"ssl":null,"updatedAt":null,"websiteId":null}],"errorLog":true,"expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"siteDir":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[null]},"webSiteSSLId":0}]},"SSLProtocol":["string"],"algorithm":"string","enable":true,"hsts":true,"hstsIncludeSubDomains":true,"http3":true,"httpConfig":"string","httpsPort":"string","httpsPorts":[0]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteHTTPS](#schemaresponse.websitehttps)|

## POST Update https conf

POST /websites/{id}/https

> Body 请求参数

```json
{
  "SSLProtocol": [
    "string"
  ],
  "algorithm": "string",
  "certificate": "string",
  "certificatePath": "string",
  "enable": true,
  "hsts": true,
  "hstsIncludeSubDomains": true,
  "http3": true,
  "httpConfig": "HTTPSOnly",
  "httpsPorts": [
    0
  ],
  "importType": "string",
  "privateKey": "string",
  "privateKeyPath": "string",
  "type": "existed",
  "websiteId": 0,
  "websiteSSLId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|string| 是 |none|
|body|body|[request.WebsiteHTTPSOp](#schemarequest.websitehttpsop)| 是 |none|

> 返回示例

> 200 Response

```
{"SSL":{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":true,"accessLog":true,"alias":"string","appInstallId":0,"createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":null,"domain":null,"id":null,"port":null,"ssl":null,"updatedAt":null,"websiteId":null}],"errorLog":true,"expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"siteDir":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[null]},"webSiteSSLId":0}]},"SSLProtocol":["string"],"algorithm":"string","enable":true,"hsts":true,"hstsIncludeSubDomains":true,"http3":true,"httpConfig":"string","httpsPort":"string","httpsPorts":[0]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteHTTPS](#schemaresponse.websitehttps)|

# Website Acme

## POST Create website acme account

POST /websites/acme

> Body 请求参数

```json
{
  "eabHmacKey": "string",
  "eabKid": "string",
  "email": "string",
  "keyType": "P256",
  "type": "letsencrypt"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteAcmeAccountCreate](#schemarequest.websiteacmeaccountcreate)| 是 |none|

> 返回示例

> 200 Response

```
{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteAcmeAccountDTO](#schemaresponse.websiteacmeaccountdto)|

## POST Delete website acme account

POST /websites/acme/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteResourceReq](#schemarequest.websiteresourcereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page website acme accounts

POST /websites/acme/search

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageInfo](#schemadto.pageinfo)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

# Website CA

## POST Create website ca

POST /websites/ca

> Body 请求参数

```json
{
  "city": "string",
  "commonName": "string",
  "country": "string",
  "keyType": "P256",
  "name": "string",
  "organization": "string",
  "organizationUint": "string",
  "province": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCACreate](#schemarequest.websitecacreate)| 是 |none|

> 返回示例

> 200 Response

```
{"city":"string","commonName":"string","country":"string","keyType":"P256","name":"string","organization":"string","organizationUint":"string","province":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[request.WebsiteCACreate](#schemarequest.websitecacreate)|

## POST Delete website ca

POST /websites/ca/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCommonReq](#schemarequest.websitecommonreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Download CA file

POST /websites/ca/download

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteResourceReq](#schemarequest.websiteresourcereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Obtain SSL

POST /websites/ca/obtain

> Body 请求参数

```json
{
  "autoRenew": true,
  "description": "string",
  "dir": "string",
  "domains": "string",
  "execShell": true,
  "id": 0,
  "keyType": "P256",
  "pushDir": true,
  "renew": true,
  "shell": "string",
  "sslID": 0,
  "time": 0,
  "unit": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCAObtain](#schemarequest.websitecaobtain)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Obtain SSL

POST /websites/ca/renew

> Body 请求参数

```json
{
  "autoRenew": true,
  "description": "string",
  "dir": "string",
  "domains": "string",
  "execShell": true,
  "id": 0,
  "keyType": "P256",
  "pushDir": true,
  "renew": true,
  "shell": "string",
  "sslID": 0,
  "time": 0,
  "unit": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCAObtain](#schemarequest.websitecaobtain)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page website ca

POST /websites/ca/search

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteCASearch](#schemarequest.websitecasearch)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## GET Get website ca

GET /websites/ca/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |id|

> 返回示例

> 200 Response

```
{"city":"string","commonName":"string","country":"string","createdAt":"string","csr":"string","id":0,"keyType":"string","name":"string","organization":"string","organizationUint":"string","privateKey":"string","province":"string","updatedAt":"string"}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteCADTO](#schemaresponse.websitecadto)|

# Website DNS

## POST Create website dns account

POST /websites/dns

> Body 请求参数

```json
{
  "authorization": {
    "property1": "string",
    "property2": "string"
  },
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDnsAccountCreate](#schemarequest.websitednsaccountcreate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Delete website dns account

POST /websites/dns/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteResourceReq](#schemarequest.websiteresourcereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Page website dns accounts

POST /websites/dns/search

> Body 请求参数

```json
{
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[dto.PageInfo](#schemadto.pageinfo)| 是 |none|

> 返回示例

> 200 Response

```
{"items":null,"total":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[dto.PageResult](#schemadto.pageresult)|

## POST Update website dns account

POST /websites/dns/update

> Body 请求参数

```json
{
  "authorization": {
    "property1": "string",
    "property2": "string"
  },
  "id": 0,
  "name": "string",
  "type": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDnsAccountUpdate](#schemarequest.websitednsaccountupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Website Domain

## POST Create website domain

POST /websites/domains

> Body 请求参数

```json
{
  "domains": [
    {
      "domain": "string",
      "port": 0,
      "ssl": true
    }
  ],
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDomainCreate](#schemarequest.websitedomaincreate)| 是 |none|

> 返回示例

> 200 Response

```
{"createdAt":"string","domain":"string","id":0,"port":0,"ssl":true,"updatedAt":"string","websiteId":0}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[model.WebsiteDomain](#schemamodel.websitedomain)|

## GET Search website domains by websiteId

GET /websites/domains/{websiteId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|websiteId|path|integer| 是 |request|

> 返回示例

> 200 Response

```
[{"createdAt":"string","domain":"string","id":0,"port":0,"ssl":true,"updatedAt":"string","websiteId":0}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[model.WebsiteDomain](#schemamodel.websitedomain)]|false|none||none|
|» createdAt|string|false|none||none|
|» domain|string|false|none||none|
|» id|integer|false|none||none|
|» port|integer|false|none||none|
|» ssl|boolean|false|none||none|
|» updatedAt|string|false|none||none|
|» websiteId|integer|false|none||none|

## POST Delete website domain

POST /websites/domains/del

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDomainDelete](#schemarequest.websitedomaindelete)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Update website domain

POST /websites/domains/update

> Body 请求参数

```json
{
  "id": 0,
  "ssl": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDomainUpdate](#schemarequest.websitedomainupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Website PHP

## POST Update php version

POST /websites/php/version

> Body 请求参数

```json
{
  "runtimeID": 0,
  "websiteID": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsitePHPVersionReq](#schemarequest.websitephpversionreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

# Website SSL

## POST Create website ssl

POST /websites/ssl

> Body 请求参数

```json
{
  "acmeAccountId": 0,
  "apply": true,
  "autoRenew": true,
  "description": "string",
  "dir": "string",
  "disableCNAME": true,
  "dnsAccountId": 0,
  "execShell": true,
  "id": 0,
  "keyType": "string",
  "nameserver1": "string",
  "nameserver2": "string",
  "otherDomains": "string",
  "primaryDomain": "string",
  "provider": "string",
  "pushDir": true,
  "shell": "string",
  "skipDNS": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteSSLCreate](#schemarequest.websitesslcreate)| 是 |none|

> 返回示例

> 200 Response

```
{"acmeAccountId":0,"apply":true,"autoRenew":true,"description":"string","dir":"string","disableCNAME":true,"dnsAccountId":0,"execShell":true,"id":0,"keyType":"string","nameserver1":"string","nameserver2":"string","otherDomains":"string","primaryDomain":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[request.WebsiteSSLCreate](#schemarequest.websitesslcreate)|

## GET Search website ssl by id

GET /websites/ssl/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |request|

> 返回示例

> 200 Response

```
{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","logPath":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":true,"accessLog":true,"alias":"string","appInstallId":0,"createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":"string","domain":"string","id":0,"port":0,"ssl":true,"updatedAt":"string","websiteId":0}],"errorLog":true,"expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"siteDir":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":null,"accessLog":null,"alias":null,"appInstallId":null,"createdAt":null,"dbID":null,"dbType":null,"defaultServer":null,"domains":null,"errorLog":null,"expireDate":null,"ftpId":null,"group":null,"httpConfig":null,"id":null,"parentWebsiteID":null,"primaryDomain":null,"protocol":null,"proxy":null,"proxyType":null,"remark":null,"rewrite":null,"runtimeID":null,"siteDir":null,"status":null,"type":null,"updatedAt":null,"user":null,"webSiteGroupId":null,"webSiteSSL":null,"webSiteSSLId":null}]},"webSiteSSLId":0}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteSSLDTO](#schemaresponse.websitessldto)|

## POST Delete website ssl

POST /websites/ssl/del

> Body 请求参数

```json
{
  "ids": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteBatchDelReq](#schemarequest.websitebatchdelreq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Download SSL  file

POST /websites/ssl/download

> Body 请求参数

```json
{
  "id": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteResourceReq](#schemarequest.websiteresourcereq)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Apply  ssl

POST /websites/ssl/obtain

> Body 请求参数

```json
{
  "ID": 0,
  "disableLog": true,
  "nameservers": [
    "string"
  ],
  "skipDNSCheck": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteSSLApply](#schemarequest.websitesslapply)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Resolve website ssl

POST /websites/ssl/resolve

> Body 请求参数

```json
{
  "acmeAccountId": 0,
  "domains": [
    "string"
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteDNSReq](#schemarequest.websitednsreq)| 是 |none|

> 返回示例

> 200 Response

```
[{"domain":"string","err":"string","resolve":"string","value":"string"}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.WebsiteDNSRes](#schemaresponse.websitednsres)]|false|none||none|
|» domain|string|false|none||none|
|» err|string|false|none||none|
|» resolve|string|false|none||none|
|» value|string|false|none||none|

## POST Page website ssl

POST /websites/ssl/search

> Body 请求参数

```json
{
  "acmeAccountID": "string",
  "page": 0,
  "pageSize": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteSSLSearch](#schemarequest.websitesslsearch)| 是 |none|

> 返回示例

> 200 Response

```
[{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","logPath":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":true,"accessLog":true,"alias":"string","appInstallId":0,"createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":"string","domain":"string","id":0,"port":0,"ssl":true,"updatedAt":"string","websiteId":0}],"errorLog":true,"expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"siteDir":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{"createdAt":null,"eabHmacKey":null,"eabKid":null,"email":null,"id":null,"keyType":null,"type":null,"updatedAt":null,"url":null},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":null,"id":null,"name":null,"type":null,"updatedAt":null},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{}]},"webSiteSSLId":0}]}]
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|[[response.WebsiteSSLDTO](#schemaresponse.websitessldto)]|false|none||none|
|» acmeAccount|[model.WebsiteAcmeAccount](#schemamodel.websiteacmeaccount)|false|none||none|
|»» createdAt|string|false|none||none|
|»» eabHmacKey|string|false|none||none|
|»» eabKid|string|false|none||none|
|»» email|string|false|none||none|
|»» id|integer|false|none||none|
|»» keyType|string|false|none||none|
|»» type|string|false|none||none|
|»» updatedAt|string|false|none||none|
|»» url|string|false|none||none|
|» acmeAccountId|integer|false|none||none|
|» autoRenew|boolean|false|none||none|
|» caId|integer|false|none||none|
|» certURL|string|false|none||none|
|» createdAt|string|false|none||none|
|» description|string|false|none||none|
|» dir|string|false|none||none|
|» disableCNAME|boolean|false|none||none|
|» dnsAccount|[model.WebsiteDnsAccount](#schemamodel.websitednsaccount)|false|none||none|
|»» createdAt|string|false|none||none|
|»» id|integer|false|none||none|
|»» name|string|false|none||none|
|»» type|string|false|none||none|
|»» updatedAt|string|false|none||none|
|» dnsAccountId|integer|false|none||none|
|» domains|string|false|none||none|
|» execShell|boolean|false|none||none|
|» expireDate|string|false|none||none|
|» id|integer|false|none||none|
|» keyType|string|false|none||none|
|» logPath|string|false|none||none|
|» message|string|false|none||none|
|» nameserver1|string|false|none||none|
|» nameserver2|string|false|none||none|
|» organization|string|false|none||none|
|» pem|string|false|none||none|
|» primaryDomain|string|false|none||none|
|» privateKey|string|false|none||none|
|» provider|string|false|none||none|
|» pushDir|boolean|false|none||none|
|» shell|string|false|none||none|
|» skipDNS|boolean|false|none||none|
|» startDate|string|false|none||none|
|» status|string|false|none||none|
|» type|string|false|none||none|
|» updatedAt|string|false|none||none|
|» websites|[[model.Website](#schemamodel.website)]|false|none||none|
|»» IPV6|boolean|false|none||none|
|»» accessLog|boolean|false|none||none|
|»» alias|string|false|none||none|
|»» appInstallId|integer|false|none||none|
|»» createdAt|string|false|none||none|
|»» dbID|integer|false|none||none|
|»» dbType|string|false|none||none|
|»» defaultServer|boolean|false|none||none|
|»» domains|[[model.WebsiteDomain](#schemamodel.websitedomain)]|false|none||none|
|»»» createdAt|string|false|none||none|
|»»» domain|string|false|none||none|
|»»» id|integer|false|none||none|
|»»» port|integer|false|none||none|
|»»» ssl|boolean|false|none||none|
|»»» updatedAt|string|false|none||none|
|»»» websiteId|integer|false|none||none|
|»» errorLog|boolean|false|none||none|
|»» expireDate|string|false|none||none|
|»» ftpId|integer|false|none||none|
|»» group|string|false|none||none|
|»» httpConfig|string|false|none||none|
|»» id|integer|false|none||none|
|»» parentWebsiteID|integer|false|none||none|
|»» primaryDomain|string|false|none||none|
|»» protocol|string|false|none||none|
|»» proxy|string|false|none||none|
|»» proxyType|string|false|none||none|
|»» remark|string|false|none||none|
|»» rewrite|string|false|none||none|
|»» runtimeID|integer|false|none||none|
|»» siteDir|string|false|none||none|
|»» status|string|false|none||none|
|»» type|string|false|none||none|
|»» updatedAt|string|false|none||none|
|»» user|string|false|none||none|
|»» webSiteGroupId|integer|false|none||none|
|»» webSiteSSL|[model.WebsiteSSL](#schemamodel.websitessl)|false|none||none|
|»»» acmeAccount|[model.WebsiteAcmeAccount](#schemamodel.websiteacmeaccount)|false|none||none|
|»»»» createdAt|string|false|none||none|
|»»»» eabHmacKey|string|false|none||none|
|»»»» eabKid|string|false|none||none|
|»»»» email|string|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» keyType|string|false|none||none|
|»»»» type|string|false|none||none|
|»»»» updatedAt|string|false|none||none|
|»»»» url|string|false|none||none|
|»»» acmeAccountId|integer|false|none||none|
|»»» autoRenew|boolean|false|none||none|
|»»» caId|integer|false|none||none|
|»»» certURL|string|false|none||none|
|»»» createdAt|string|false|none||none|
|»»» description|string|false|none||none|
|»»» dir|string|false|none||none|
|»»» disableCNAME|boolean|false|none||none|
|»»» dnsAccount|[model.WebsiteDnsAccount](#schemamodel.websitednsaccount)|false|none||none|
|»»»» createdAt|string|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|false|none||none|
|»»»» type|string|false|none||none|
|»»»» updatedAt|string|false|none||none|
|»»» dnsAccountId|integer|false|none||none|
|»»» domains|string|false|none||none|
|»»» execShell|boolean|false|none||none|
|»»» expireDate|string|false|none||none|
|»»» id|integer|false|none||none|
|»»» keyType|string|false|none||none|
|»»» message|string|false|none||none|
|»»» nameserver1|string|false|none||none|
|»»» nameserver2|string|false|none||none|
|»»» organization|string|false|none||none|
|»»» pem|string|false|none||none|
|»»» primaryDomain|string|false|none||none|
|»»» privateKey|string|false|none||none|
|»»» provider|string|false|none||none|
|»»» pushDir|boolean|false|none||none|
|»»» shell|string|false|none||none|
|»»» skipDNS|boolean|false|none||none|
|»»» startDate|string|false|none||none|
|»»» status|string|false|none||none|
|»»» type|string|false|none||none|
|»»» updatedAt|string|false|none||none|
|»»» websites|[[model.Website](#schemamodel.website)]|false|none||none|
|»»»» IPV6|boolean|false|none||none|
|»»»» accessLog|boolean|false|none||none|
|»»»» alias|string|false|none||none|
|»»»» appInstallId|integer|false|none||none|
|»»»» createdAt|string|false|none||none|
|»»»» dbID|integer|false|none||none|
|»»»» dbType|string|false|none||none|
|»»»» defaultServer|boolean|false|none||none|
|»»»» domains|[[model.WebsiteDomain](#schemamodel.websitedomain)]|false|none||none|
|»»»» errorLog|boolean|false|none||none|
|»»»» expireDate|string|false|none||none|
|»»»» ftpId|integer|false|none||none|
|»»»» group|string|false|none||none|
|»»»» httpConfig|string|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» parentWebsiteID|integer|false|none||none|
|»»»» primaryDomain|string|false|none||none|
|»»»» protocol|string|false|none||none|
|»»»» proxy|string|false|none||none|
|»»»» proxyType|string|false|none||none|
|»»»» remark|string|false|none||none|
|»»»» rewrite|string|false|none||none|
|»»»» runtimeID|integer|false|none||none|
|»»»» siteDir|string|false|none||none|
|»»»» status|string|false|none||none|
|»»»» type|string|false|none||none|
|»»»» updatedAt|string|false|none||none|
|»»»» user|string|false|none||none|
|»»»» webSiteGroupId|integer|false|none||none|
|»»»» webSiteSSL|[model.WebsiteSSL](#schemamodel.websitessl)|false|none||none|
|»»»» webSiteSSLId|integer|false|none||none|
|»» webSiteSSLId|integer|false|none||none|

## POST Update ssl

POST /websites/ssl/update

> Body 请求参数

```json
{
  "acmeAccountId": 0,
  "apply": true,
  "autoRenew": true,
  "description": "string",
  "dir": "string",
  "disableCNAME": true,
  "dnsAccountId": 0,
  "execShell": true,
  "id": 0,
  "keyType": "string",
  "nameserver1": "string",
  "nameserver2": "string",
  "otherDomains": "string",
  "primaryDomain": "string",
  "provider": "string",
  "pushDir": true,
  "shell": "string",
  "skipDNS": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteSSLUpdate](#schemarequest.websitesslupdate)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## POST Upload ssl

POST /websites/ssl/upload

> Body 请求参数

```json
{
  "certificate": "string",
  "certificatePath": "string",
  "description": "string",
  "privateKey": "string",
  "privateKeyPath": "string",
  "sslID": 0,
  "type": "paste"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|[request.WebsiteSSLUpload](#schemarequest.websitesslupload)| 是 |none|

> 返回示例

> 200 Response

```
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET Search website ssl by website id

GET /websites/ssl/website/{websiteId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|websiteId|path|integer| 是 |request|

> 返回示例

> 200 Response

```
{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","logPath":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":true,"accessLog":true,"alias":"string","appInstallId":0,"createdAt":"string","dbID":0,"dbType":"string","defaultServer":true,"domains":[{"createdAt":"string","domain":"string","id":0,"port":0,"ssl":true,"updatedAt":"string","websiteId":0}],"errorLog":true,"expireDate":"string","ftpId":0,"group":"string","httpConfig":"string","id":0,"parentWebsiteID":0,"primaryDomain":"string","protocol":"string","proxy":"string","proxyType":"string","remark":"string","rewrite":"string","runtimeID":0,"siteDir":"string","status":"string","type":"string","updatedAt":"string","user":"string","webSiteGroupId":0,"webSiteSSL":{"acmeAccount":{"createdAt":"string","eabHmacKey":"string","eabKid":"string","email":"string","id":0,"keyType":"string","type":"string","updatedAt":"string","url":"string"},"acmeAccountId":0,"autoRenew":true,"caId":0,"certURL":"string","createdAt":"string","description":"string","dir":"string","disableCNAME":true,"dnsAccount":{"createdAt":"string","id":0,"name":"string","type":"string","updatedAt":"string"},"dnsAccountId":0,"domains":"string","execShell":true,"expireDate":"string","id":0,"keyType":"string","message":"string","nameserver1":"string","nameserver2":"string","organization":"string","pem":"string","primaryDomain":"string","privateKey":"string","provider":"string","pushDir":true,"shell":"string","skipDNS":true,"startDate":"string","status":"string","type":"string","updatedAt":"string","websites":[{"IPV6":null,"accessLog":null,"alias":null,"appInstallId":null,"createdAt":null,"dbID":null,"dbType":null,"defaultServer":null,"domains":null,"errorLog":null,"expireDate":null,"ftpId":null,"group":null,"httpConfig":null,"id":null,"parentWebsiteID":null,"primaryDomain":null,"protocol":null,"proxy":null,"proxyType":null,"remark":null,"rewrite":null,"runtimeID":null,"siteDir":null,"status":null,"type":null,"updatedAt":null,"user":null,"webSiteGroupId":null,"webSiteSSL":null,"webSiteSSLId":null}]},"webSiteSSLId":0}]}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|OK|[response.WebsiteSSLDTO](#schemaresponse.websitessldto)|

# 数据模型

<h2 id="tocS_dto.AddrRuleOperate">dto.AddrRuleOperate</h2>

<a id="schemadto.addrruleoperate"></a>
<a id="schema_dto.AddrRuleOperate"></a>
<a id="tocSdto.addrruleoperate"></a>
<a id="tocsdto.addrruleoperate"></a>

```json
{
  "address": "string",
  "description": "string",
  "operation": "add",
  "strategy": "accept"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|true|none||none|
|description|string|false|none||none|
|operation|string|true|none||none|
|strategy|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operation|add|
|operation|remove|
|strategy|accept|
|strategy|drop|

<h2 id="tocS_dto.AddrRuleUpdate">dto.AddrRuleUpdate</h2>

<a id="schemadto.addrruleupdate"></a>
<a id="schema_dto.AddrRuleUpdate"></a>
<a id="tocSdto.addrruleupdate"></a>
<a id="tocsdto.addrruleupdate"></a>

```json
{
  "newRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "strategy": "accept"
  },
  "oldRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "strategy": "accept"
  }
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|newRule|[dto.AddrRuleOperate](#schemadto.addrruleoperate)|false|none||none|
|oldRule|[dto.AddrRuleOperate](#schemadto.addrruleoperate)|false|none||none|

<h2 id="tocS_dto.AppConfigVersion">dto.AppConfigVersion</h2>

<a id="schemadto.appconfigversion"></a>
<a id="schema_dto.AppConfigVersion"></a>
<a id="tocSdto.appconfigversion"></a>
<a id="tocsdto.appconfigversion"></a>

```json
{
  "additionalProperties": null,
  "downloadCallBackUrl": "string",
  "downloadUrl": "string",
  "lastModified": 0,
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|additionalProperties|any|false|none||none|
|downloadCallBackUrl|string|false|none||none|
|downloadUrl|string|false|none||none|
|lastModified|integer|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_dto.AppDefine">dto.AppDefine</h2>

<a id="schemadto.appdefine"></a>
<a id="schema_dto.AppDefine"></a>
<a id="tocSdto.appdefine"></a>
<a id="tocsdto.appdefine"></a>

```json
{
  "additionalProperties": {
    "Required": [
      "string"
    ],
    "architectures": [
      "string"
    ],
    "crossVersionUpdate": true,
    "description": {
      "en": "string",
      "ja": "string",
      "ms": "string",
      "pt-br": "string",
      "ru": "string",
      "zh": "string",
      "zh-hant": "string"
    },
    "document": "string",
    "github": "string",
    "gpuSupport": true,
    "key": "string",
    "limit": 0,
    "memoryRequired": 0,
    "name": "string",
    "recommend": 0,
    "shortDescEn": "string",
    "shortDescZh": "string",
    "tags": [
      "string"
    ],
    "type": "string",
    "version": 0,
    "website": "string"
  },
  "icon": "string",
  "lastModified": 0,
  "name": "string",
  "readMe": "string",
  "versions": [
    {
      "additionalProperties": null,
      "downloadCallBackUrl": "string",
      "downloadUrl": "string",
      "lastModified": 0,
      "name": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|additionalProperties|[dto.AppProperty](#schemadto.appproperty)|false|none||none|
|icon|string|false|none||none|
|lastModified|integer|false|none||none|
|name|string|false|none||none|
|readMe|string|false|none||none|
|versions|[[dto.AppConfigVersion](#schemadto.appconfigversion)]|false|none||none|

<h2 id="tocS_dto.AppInstallInfo">dto.AppInstallInfo</h2>

<a id="schemadto.appinstallinfo"></a>
<a id="schema_dto.AppInstallInfo"></a>
<a id="tocSdto.appinstallinfo"></a>
<a id="tocsdto.appinstallinfo"></a>

```json
{
  "id": 0,
  "key": "string",
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|key|string|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_dto.AppList">dto.AppList</h2>

<a id="schemadto.applist"></a>
<a id="schema_dto.AppList"></a>
<a id="tocSdto.applist"></a>
<a id="tocsdto.applist"></a>

```json
{
  "additionalProperties": {
    "tags": [
      {
        "key": "string",
        "locales": {
          "en": "string",
          "ja": "string",
          "ms": "string",
          "pt-br": "string",
          "ru": "string",
          "zh": "string",
          "zh-hant": "string"
        },
        "name": "string",
        "sort": 0
      }
    ],
    "version": "string"
  },
  "apps": [
    {
      "additionalProperties": {
        "Required": [
          "string"
        ],
        "architectures": [
          "string"
        ],
        "crossVersionUpdate": true,
        "description": {
          "en": "string",
          "ja": "string",
          "ms": "string",
          "pt-br": "string",
          "ru": "string",
          "zh": "string",
          "zh-hant": "string"
        },
        "document": "string",
        "github": "string",
        "gpuSupport": true,
        "key": "string",
        "limit": 0,
        "memoryRequired": 0,
        "name": "string",
        "recommend": 0,
        "shortDescEn": "string",
        "shortDescZh": "string",
        "tags": [
          "string"
        ],
        "type": "string",
        "version": 0,
        "website": "string"
      },
      "icon": "string",
      "lastModified": 0,
      "name": "string",
      "readMe": "string",
      "versions": [
        {
          "additionalProperties": null,
          "downloadCallBackUrl": "string",
          "downloadUrl": "string",
          "lastModified": 0,
          "name": "string"
        }
      ]
    }
  ],
  "lastModified": 0,
  "valid": true,
  "violations": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|additionalProperties|[dto.ExtraProperties](#schemadto.extraproperties)|false|none||none|
|apps|[[dto.AppDefine](#schemadto.appdefine)]|false|none||none|
|lastModified|integer|false|none||none|
|valid|boolean|false|none||none|
|violations|[string]|false|none||none|

<h2 id="tocS_dto.AppProperty">dto.AppProperty</h2>

<a id="schemadto.appproperty"></a>
<a id="schema_dto.AppProperty"></a>
<a id="tocSdto.appproperty"></a>
<a id="tocsdto.appproperty"></a>

```json
{
  "Required": [
    "string"
  ],
  "architectures": [
    "string"
  ],
  "crossVersionUpdate": true,
  "description": {
    "en": "string",
    "ja": "string",
    "ms": "string",
    "pt-br": "string",
    "ru": "string",
    "zh": "string",
    "zh-hant": "string"
  },
  "document": "string",
  "github": "string",
  "gpuSupport": true,
  "key": "string",
  "limit": 0,
  "memoryRequired": 0,
  "name": "string",
  "recommend": 0,
  "shortDescEn": "string",
  "shortDescZh": "string",
  "tags": [
    "string"
  ],
  "type": "string",
  "version": 0,
  "website": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|Required|[string]|false|none||none|
|architectures|[string]|false|none||none|
|crossVersionUpdate|boolean|false|none||none|
|description|[dto.Locale](#schemadto.locale)|false|none||none|
|document|string|false|none||none|
|github|string|false|none||none|
|gpuSupport|boolean|false|none||none|
|key|string|false|none||none|
|limit|integer|false|none||none|
|memoryRequired|integer|false|none||none|
|name|string|false|none||none|
|recommend|integer|false|none||none|
|shortDescEn|string|false|none||none|
|shortDescZh|string|false|none||none|
|tags|[string]|false|none||none|
|type|string|false|none||none|
|version|number|false|none||none|
|website|string|false|none||none|

<h2 id="tocS_dto.AppResource">dto.AppResource</h2>

<a id="schemadto.appresource"></a>
<a id="schema_dto.AppResource"></a>
<a id="tocSdto.appresource"></a>
<a id="tocsdto.appresource"></a>

```json
{
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_dto.AppVersion">dto.AppVersion</h2>

<a id="schemadto.appversion"></a>
<a id="schema_dto.AppVersion"></a>
<a id="tocSdto.appversion"></a>
<a id="tocsdto.appversion"></a>

```json
{
  "detailId": 0,
  "dockerCompose": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|detailId|integer|false|none||none|
|dockerCompose|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.BackupOperate">dto.BackupOperate</h2>

<a id="schemadto.backupoperate"></a>
<a id="schema_dto.BackupOperate"></a>
<a id="tocSdto.backupoperate"></a>
<a id="tocsdto.backupoperate"></a>

```json
{
  "accessKey": "string",
  "backupPath": "string",
  "bucket": "string",
  "credential": "string",
  "id": 0,
  "isPublic": true,
  "name": "string",
  "rememberAuth": true,
  "type": "string",
  "vars": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|accessKey|string|false|none||none|
|backupPath|string|false|none||none|
|bucket|string|false|none||none|
|credential|string|false|none||none|
|id|integer|false|none||none|
|isPublic|boolean|false|none||none|
|name|string|false|none||none|
|rememberAuth|boolean|false|none||none|
|type|string|true|none||none|
|vars|string|true|none||none|

<h2 id="tocS_dto.BackupOption">dto.BackupOption</h2>

<a id="schemadto.backupoption"></a>
<a id="schema_dto.BackupOption"></a>
<a id="tocSdto.backupoption"></a>
<a id="tocsdto.backupoption"></a>

```json
{
  "id": 0,
  "isPublic": true,
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|isPublic|boolean|false|none||none|
|name|string|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_dto.BatchDelete">dto.BatchDelete</h2>

<a id="schemadto.batchdelete"></a>
<a id="schema_dto.BatchDelete"></a>
<a id="tocSdto.batchdelete"></a>
<a id="tocsdto.batchdelete"></a>

```json
{
  "force": true,
  "names": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|force|boolean|false|none||none|
|names|[string]|true|none||none|

<h2 id="tocS_dto.BatchDeleteReq">dto.BatchDeleteReq</h2>

<a id="schemadto.batchdeletereq"></a>
<a id="schema_dto.BatchDeleteReq"></a>
<a id="tocSdto.batchdeletereq"></a>
<a id="tocsdto.batchdeletereq"></a>

```json
{
  "ids": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ids|[integer]|true|none||none|

<h2 id="tocS_dto.BatchRuleOperate">dto.BatchRuleOperate</h2>

<a id="schemadto.batchruleoperate"></a>
<a id="schema_dto.BatchRuleOperate"></a>
<a id="tocSdto.batchruleoperate"></a>
<a id="tocsdto.batchruleoperate"></a>

```json
{
  "rules": [
    {
      "address": "string",
      "description": "string",
      "operation": "add",
      "port": "string",
      "protocol": "tcp",
      "strategy": "accept"
    }
  ],
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|rules|[[dto.PortRuleOperate](#schemadto.portruleoperate)]|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.BindUser">dto.BindUser</h2>

<a id="schemadto.binduser"></a>
<a id="schema_dto.BindUser"></a>
<a id="tocSdto.binduser"></a>
<a id="tocsdto.binduser"></a>

```json
{
  "database": "string",
  "db": "string",
  "password": "string",
  "permission": "string",
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|db|string|true|none||none|
|password|string|true|none||none|
|permission|string|true|none||none|
|username|string|true|none||none|

<h2 id="tocS_dto.ChangeDBInfo">dto.ChangeDBInfo</h2>

<a id="schemadto.changedbinfo"></a>
<a id="schema_dto.ChangeDBInfo"></a>
<a id="tocSdto.changedbinfo"></a>
<a id="tocsdto.changedbinfo"></a>

```json
{
  "database": "string",
  "from": "local",
  "id": 0,
  "type": "mysql",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|from|string|true|none||none|
|id|integer|false|none||none|
|type|string|true|none||none|
|value|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|from|local|
|from|remote|
|type|mysql|
|type|mariadb|
|type|postgresql|

<h2 id="tocS_dto.ChangePasswd">dto.ChangePasswd</h2>

<a id="schemadto.changepasswd"></a>
<a id="schema_dto.ChangePasswd"></a>
<a id="tocSdto.changepasswd"></a>
<a id="tocsdto.changepasswd"></a>

```json
{
  "passwd": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|passwd|string|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_dto.ChangeRedisPass">dto.ChangeRedisPass</h2>

<a id="schemadto.changeredispass"></a>
<a id="schema_dto.ChangeRedisPass"></a>
<a id="tocSdto.changeredispass"></a>
<a id="tocsdto.changeredispass"></a>

```json
{
  "database": "string",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|value|string|false|none||none|

<h2 id="tocS_dto.ClamBaseInfo">dto.ClamBaseInfo</h2>

<a id="schemadto.clambaseinfo"></a>
<a id="schema_dto.ClamBaseInfo"></a>
<a id="tocSdto.clambaseinfo"></a>
<a id="tocsdto.clambaseinfo"></a>

```json
{
  "freshIsActive": true,
  "freshIsExist": true,
  "freshVersion": "string",
  "isActive": true,
  "isExist": true,
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|freshIsActive|boolean|false|none||none|
|freshIsExist|boolean|false|none||none|
|freshVersion|string|false|none||none|
|isActive|boolean|false|none||none|
|isExist|boolean|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.ClamCreate">dto.ClamCreate</h2>

<a id="schemadto.clamcreate"></a>
<a id="schema_dto.ClamCreate"></a>
<a id="tocSdto.clamcreate"></a>
<a id="tocsdto.clamcreate"></a>

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "description": "string",
  "infectedDir": "string",
  "infectedStrategy": "string",
  "name": "string",
  "path": "string",
  "spec": "string",
  "status": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|alertCount|integer|false|none||none|
|alertTitle|string|false|none||none|
|description|string|false|none||none|
|infectedDir|string|false|none||none|
|infectedStrategy|string|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|spec|string|false|none||none|
|status|string|false|none||none|

<h2 id="tocS_dto.ClamDelete">dto.ClamDelete</h2>

<a id="schemadto.clamdelete"></a>
<a id="schema_dto.ClamDelete"></a>
<a id="tocSdto.clamdelete"></a>
<a id="tocsdto.clamdelete"></a>

```json
{
  "ids": [
    0
  ],
  "removeInfected": true,
  "removeRecord": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ids|[integer]|true|none||none|
|removeInfected|boolean|false|none||none|
|removeRecord|boolean|false|none||none|

<h2 id="tocS_dto.ClamFileReq">dto.ClamFileReq</h2>

<a id="schemadto.clamfilereq"></a>
<a id="schema_dto.ClamFileReq"></a>
<a id="tocSdto.clamfilereq"></a>
<a id="tocsdto.clamfilereq"></a>

```json
{
  "name": "string",
  "tail": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|
|tail|string|false|none||none|

<h2 id="tocS_dto.ClamLogReq">dto.ClamLogReq</h2>

<a id="schemadto.clamlogreq"></a>
<a id="schema_dto.ClamLogReq"></a>
<a id="tocSdto.clamlogreq"></a>
<a id="tocsdto.clamlogreq"></a>

```json
{
  "clamName": "string",
  "recordName": "string",
  "tail": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|clamName|string|false|none||none|
|recordName|string|false|none||none|
|tail|string|false|none||none|

<h2 id="tocS_dto.ClamLogSearch">dto.ClamLogSearch</h2>

<a id="schemadto.clamlogsearch"></a>
<a id="schema_dto.ClamLogSearch"></a>
<a id="tocSdto.clamlogsearch"></a>
<a id="tocsdto.clamlogsearch"></a>

```json
{
  "clamID": 0,
  "endTime": "string",
  "page": 0,
  "pageSize": 0,
  "startTime": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|clamID|integer|false|none||none|
|endTime|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|startTime|string|false|none||none|

<h2 id="tocS_dto.ClamUpdate">dto.ClamUpdate</h2>

<a id="schemadto.clamupdate"></a>
<a id="schema_dto.ClamUpdate"></a>
<a id="tocSdto.clamupdate"></a>
<a id="tocsdto.clamupdate"></a>

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "description": "string",
  "id": 0,
  "infectedDir": "string",
  "infectedStrategy": "string",
  "name": "string",
  "path": "string",
  "spec": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|alertCount|integer|false|none||none|
|alertTitle|string|false|none||none|
|description|string|false|none||none|
|id|integer|false|none||none|
|infectedDir|string|false|none||none|
|infectedStrategy|string|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|spec|string|false|none||none|

<h2 id="tocS_dto.ClamUpdateStatus">dto.ClamUpdateStatus</h2>

<a id="schemadto.clamupdatestatus"></a>
<a id="schema_dto.ClamUpdateStatus"></a>
<a id="tocSdto.clamupdatestatus"></a>
<a id="tocsdto.clamupdatestatus"></a>

```json
{
  "id": 0,
  "status": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|status|string|false|none||none|

<h2 id="tocS_dto.Clean">dto.Clean</h2>

<a id="schemadto.clean"></a>
<a id="schema_dto.Clean"></a>
<a id="tocSdto.clean"></a>
<a id="tocsdto.clean"></a>

```json
{
  "name": "string",
  "size": 0,
  "treeType": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|size|integer|false|none||none|
|treeType|string|false|none||none|

<h2 id="tocS_dto.CleanData">dto.CleanData</h2>

<a id="schemadto.cleandata"></a>
<a id="schema_dto.CleanData"></a>
<a id="tocSdto.cleandata"></a>
<a id="tocsdto.cleandata"></a>

```json
{
  "containerClean": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isRecommend": true,
          "label": "string",
          "name": "string",
          "size": 0,
          "type": "string"
        }
      ],
      "id": "string",
      "isCheck": true,
      "isRecommend": true,
      "label": "string",
      "name": "string",
      "size": 0,
      "type": "string"
    }
  ],
  "downloadClean": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isRecommend": true,
          "label": "string",
          "name": "string",
          "size": 0,
          "type": "string"
        }
      ],
      "id": "string",
      "isCheck": true,
      "isRecommend": true,
      "label": "string",
      "name": "string",
      "size": 0,
      "type": "string"
    }
  ],
  "systemClean": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isRecommend": true,
          "label": "string",
          "name": "string",
          "size": 0,
          "type": "string"
        }
      ],
      "id": "string",
      "isCheck": true,
      "isRecommend": true,
      "label": "string",
      "name": "string",
      "size": 0,
      "type": "string"
    }
  ],
  "systemLogClean": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isRecommend": true,
          "label": "string",
          "name": "string",
          "size": 0,
          "type": "string"
        }
      ],
      "id": "string",
      "isCheck": true,
      "isRecommend": true,
      "label": "string",
      "name": "string",
      "size": 0,
      "type": "string"
    }
  ],
  "uploadClean": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isRecommend": true,
          "label": "string",
          "name": "string",
          "size": 0,
          "type": "string"
        }
      ],
      "id": "string",
      "isCheck": true,
      "isRecommend": true,
      "label": "string",
      "name": "string",
      "size": 0,
      "type": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerClean|[[dto.CleanTree](#schemadto.cleantree)]|false|none||none|
|downloadClean|[[dto.CleanTree](#schemadto.cleantree)]|false|none||none|
|systemClean|[[dto.CleanTree](#schemadto.cleantree)]|false|none||none|
|systemLogClean|[[dto.CleanTree](#schemadto.cleantree)]|false|none||none|
|uploadClean|[[dto.CleanTree](#schemadto.cleantree)]|false|none||none|

<h2 id="tocS_dto.CleanTree">dto.CleanTree</h2>

<a id="schemadto.cleantree"></a>
<a id="schema_dto.CleanTree"></a>
<a id="tocSdto.cleantree"></a>
<a id="tocsdto.cleantree"></a>

```json
{
  "children": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isRecommend": true,
          "label": "string",
          "name": "string",
          "size": 0,
          "type": "string"
        }
      ],
      "id": "string",
      "isCheck": true,
      "isRecommend": true,
      "label": "string",
      "name": "string",
      "size": 0,
      "type": "string"
    }
  ],
  "id": "string",
  "isCheck": true,
  "isRecommend": true,
  "label": "string",
  "name": "string",
  "size": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|children|[[dto.CleanTree](#schemadto.cleantree)]|false|none||none|
|id|string|false|none||none|
|isCheck|boolean|false|none||none|
|isRecommend|boolean|false|none||none|
|label|string|false|none||none|
|name|string|false|none||none|
|size|integer|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_dto.CommonBackup">dto.CommonBackup</h2>

<a id="schemadto.commonbackup"></a>
<a id="schema_dto.CommonBackup"></a>
<a id="tocSdto.commonbackup"></a>
<a id="tocsdto.commonbackup"></a>

```json
{
  "detailName": "string",
  "fileName": "string",
  "name": "string",
  "secret": "string",
  "taskID": "string",
  "type": "app"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|detailName|string|false|none||none|
|fileName|string|false|none||none|
|name|string|false|none||none|
|secret|string|false|none||none|
|taskID|string|false|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|app|
|type|mysql|
|type|mariadb|
|type|redis|
|type|website|
|type|postgresql|

<h2 id="tocS_dto.CommonRecover">dto.CommonRecover</h2>

<a id="schemadto.commonrecover"></a>
<a id="schema_dto.CommonRecover"></a>
<a id="tocSdto.commonrecover"></a>
<a id="tocsdto.commonrecover"></a>

```json
{
  "backupRecordID": 0,
  "detailName": "string",
  "downloadAccountID": 0,
  "file": "string",
  "name": "string",
  "secret": "string",
  "taskID": "string",
  "type": "app"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|backupRecordID|integer|false|none||none|
|detailName|string|false|none||none|
|downloadAccountID|integer|true|none||none|
|file|string|false|none||none|
|name|string|false|none||none|
|secret|string|false|none||none|
|taskID|string|false|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|app|
|type|mysql|
|type|mariadb|
|type|redis|
|type|website|
|type|postgresql|

<h2 id="tocS_dto.ComposeCreate">dto.ComposeCreate</h2>

<a id="schemadto.composecreate"></a>
<a id="schema_dto.ComposeCreate"></a>
<a id="tocSdto.composecreate"></a>
<a id="tocsdto.composecreate"></a>

```json
{
  "env": [
    "string"
  ],
  "file": "string",
  "from": "edit",
  "name": "string",
  "path": "string",
  "taskID": "string",
  "template": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|env|[string]|false|none||none|
|file|string|false|none||none|
|from|string|true|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|taskID|string|false|none||none|
|template|integer|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|from|edit|
|from|path|
|from|template|

<h2 id="tocS_dto.ComposeOperation">dto.ComposeOperation</h2>

<a id="schemadto.composeoperation"></a>
<a id="schema_dto.ComposeOperation"></a>
<a id="tocSdto.composeoperation"></a>
<a id="tocsdto.composeoperation"></a>

```json
{
  "name": "string",
  "operation": "up",
  "path": "string",
  "withFile": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|
|operation|string|true|none||none|
|path|string|false|none||none|
|withFile|boolean|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|operation|up|
|operation|start|
|operation|stop|
|operation|down|
|operation|delete|

<h2 id="tocS_dto.ComposeTemplateCreate">dto.ComposeTemplateCreate</h2>

<a id="schemadto.composetemplatecreate"></a>
<a id="schema_dto.ComposeTemplateCreate"></a>
<a id="tocSdto.composetemplatecreate"></a>
<a id="tocsdto.composetemplatecreate"></a>

```json
{
  "content": "string",
  "description": "string",
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|description|string|false|none||none|
|name|string|true|none||none|

<h2 id="tocS_dto.ComposeTemplateInfo">dto.ComposeTemplateInfo</h2>

<a id="schemadto.composetemplateinfo"></a>
<a id="schema_dto.ComposeTemplateInfo"></a>
<a id="tocSdto.composetemplateinfo"></a>
<a id="tocsdto.composetemplateinfo"></a>

```json
{
  "content": "string",
  "createdAt": "string",
  "description": "string",
  "id": 0,
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|createdAt|string|false|none||none|
|description|string|false|none||none|
|id|integer|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_dto.ComposeTemplateUpdate">dto.ComposeTemplateUpdate</h2>

<a id="schemadto.composetemplateupdate"></a>
<a id="schema_dto.ComposeTemplateUpdate"></a>
<a id="tocSdto.composetemplateupdate"></a>
<a id="tocsdto.composetemplateupdate"></a>

```json
{
  "content": "string",
  "description": "string",
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|description|string|false|none||none|
|id|integer|false|none||none|

<h2 id="tocS_dto.ComposeUpdate">dto.ComposeUpdate</h2>

<a id="schemadto.composeupdate"></a>
<a id="schema_dto.ComposeUpdate"></a>
<a id="tocSdto.composeupdate"></a>
<a id="tocsdto.composeupdate"></a>

```json
{
  "content": "string",
  "env": [
    "string"
  ],
  "name": "string",
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|true|none||none|
|env|[string]|false|none||none|
|name|string|true|none||none|
|path|string|true|none||none|

<h2 id="tocS_dto.ContainerCommit">dto.ContainerCommit</h2>

<a id="schemadto.containercommit"></a>
<a id="schema_dto.ContainerCommit"></a>
<a id="tocSdto.containercommit"></a>
<a id="tocsdto.containercommit"></a>

```json
{
  "author": "string",
  "comment": "string",
  "containerID": "string",
  "containerName": "string",
  "newImageName": "string",
  "pause": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|author|string|false|none||none|
|comment|string|false|none||none|
|containerID|string|true|none||none|
|containerName|string|false|none||none|
|newImageName|string|false|none||none|
|pause|boolean|false|none||none|

<h2 id="tocS_dto.ContainerCreateByCommand">dto.ContainerCreateByCommand</h2>

<a id="schemadto.containercreatebycommand"></a>
<a id="schema_dto.ContainerCreateByCommand"></a>
<a id="tocSdto.containercreatebycommand"></a>
<a id="tocsdto.containercreatebycommand"></a>

```json
{
  "command": "string",
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|command|string|false|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_dto.ContainerListStats">dto.ContainerListStats</h2>

<a id="schemadto.containerliststats"></a>
<a id="schema_dto.ContainerListStats"></a>
<a id="tocSdto.containerliststats"></a>
<a id="tocsdto.containerliststats"></a>

```json
{
  "containerID": "string",
  "cpuPercent": 0,
  "cpuTotalUsage": 0,
  "memoryCache": 0,
  "memoryLimit": 0,
  "memoryPercent": 0,
  "memoryUsage": 0,
  "percpuUsage": 0,
  "systemUsage": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerID|string|false|none||none|
|cpuPercent|number|false|none||none|
|cpuTotalUsage|integer|false|none||none|
|memoryCache|integer|false|none||none|
|memoryLimit|integer|false|none||none|
|memoryPercent|number|false|none||none|
|memoryUsage|integer|false|none||none|
|percpuUsage|integer|false|none||none|
|systemUsage|integer|false|none||none|

<h2 id="tocS_dto.ContainerOperate">dto.ContainerOperate</h2>

<a id="schemadto.containeroperate"></a>
<a id="schema_dto.ContainerOperate"></a>
<a id="tocSdto.containeroperate"></a>
<a id="tocsdto.containeroperate"></a>

```json
{
  "autoRemove": true,
  "cmd": [
    "string"
  ],
  "containerID": "string",
  "cpuShares": 0,
  "dns": [
    "string"
  ],
  "domainName": "string",
  "entrypoint": [
    "string"
  ],
  "env": [
    "string"
  ],
  "exposedPorts": [
    {
      "containerPort": "string",
      "hostIP": "string",
      "hostPort": "string",
      "protocol": "string"
    }
  ],
  "forcePull": true,
  "hostname": "string",
  "image": "string",
  "ipv4": "string",
  "ipv6": "string",
  "labels": [
    "string"
  ],
  "macAddr": "string",
  "memory": 0,
  "name": "string",
  "nanoCPUs": 0,
  "network": "string",
  "openStdin": true,
  "privileged": true,
  "publishAllPorts": true,
  "restartPolicy": "string",
  "taskID": "string",
  "tty": true,
  "user": "string",
  "volumes": [
    {
      "containerDir": "string",
      "mode": "string",
      "sourceDir": "string",
      "type": "string"
    }
  ],
  "workingDir": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|autoRemove|boolean|false|none||none|
|cmd|[string]|false|none||none|
|containerID|string|false|none||none|
|cpuShares|integer|false|none||none|
|dns|[string]|false|none||none|
|domainName|string|false|none||none|
|entrypoint|[string]|false|none||none|
|env|[string]|false|none||none|
|exposedPorts|[[dto.PortHelper](#schemadto.porthelper)]|false|none||none|
|forcePull|boolean|false|none||none|
|hostname|string|false|none||none|
|image|string|true|none||none|
|ipv4|string|false|none||none|
|ipv6|string|false|none||none|
|labels|[string]|false|none||none|
|macAddr|string|false|none||none|
|memory|number|false|none||none|
|name|string|true|none||none|
|nanoCPUs|number|false|none||none|
|network|string|false|none||none|
|openStdin|boolean|false|none||none|
|privileged|boolean|false|none||none|
|publishAllPorts|boolean|false|none||none|
|restartPolicy|string|false|none||none|
|taskID|string|false|none||none|
|tty|boolean|false|none||none|
|user|string|false|none||none|
|volumes|[[dto.VolumeHelper](#schemadto.volumehelper)]|false|none||none|
|workingDir|string|false|none||none|

<h2 id="tocS_dto.ContainerOperation">dto.ContainerOperation</h2>

<a id="schemadto.containeroperation"></a>
<a id="schema_dto.ContainerOperation"></a>
<a id="tocSdto.containeroperation"></a>
<a id="tocsdto.containeroperation"></a>

```json
{
  "names": [
    "string"
  ],
  "operation": "up"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|names|[string]|true|none||none|
|operation|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operation|up|
|operation|start|
|operation|stop|
|operation|restart|
|operation|kill|
|operation|pause|
|operation|unpause|
|operation|remove|

<h2 id="tocS_dto.ContainerPrune">dto.ContainerPrune</h2>

<a id="schemadto.containerprune"></a>
<a id="schema_dto.ContainerPrune"></a>
<a id="tocSdto.containerprune"></a>
<a id="tocsdto.containerprune"></a>

```json
{
  "pruneType": "container",
  "withTagAll": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|pruneType|string|true|none||none|
|withTagAll|boolean|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|pruneType|container|
|pruneType|image|
|pruneType|volume|
|pruneType|network|
|pruneType|buildcache|

<h2 id="tocS_dto.ContainerPruneReport">dto.ContainerPruneReport</h2>

<a id="schemadto.containerprunereport"></a>
<a id="schema_dto.ContainerPruneReport"></a>
<a id="tocSdto.containerprunereport"></a>
<a id="tocsdto.containerprunereport"></a>

```json
{
  "deletedNumber": 0,
  "spaceReclaimed": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|deletedNumber|integer|false|none||none|
|spaceReclaimed|integer|false|none||none|

<h2 id="tocS_dto.ContainerRename">dto.ContainerRename</h2>

<a id="schemadto.containerrename"></a>
<a id="schema_dto.ContainerRename"></a>
<a id="tocSdto.containerrename"></a>
<a id="tocsdto.containerrename"></a>

```json
{
  "name": "string",
  "newName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|
|newName|string|true|none||none|

<h2 id="tocS_dto.ContainerStats">dto.ContainerStats</h2>

<a id="schemadto.containerstats"></a>
<a id="schema_dto.ContainerStats"></a>
<a id="tocSdto.containerstats"></a>
<a id="tocsdto.containerstats"></a>

```json
{
  "cache": 0,
  "cpuPercent": 0,
  "ioRead": 0,
  "ioWrite": 0,
  "memory": 0,
  "networkRX": 0,
  "networkTX": 0,
  "shotTime": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cache|number|false|none||none|
|cpuPercent|number|false|none||none|
|ioRead|number|false|none||none|
|ioWrite|number|false|none||none|
|memory|number|false|none||none|
|networkRX|number|false|none||none|
|networkTX|number|false|none||none|
|shotTime|string|false|none||none|

<h2 id="tocS_dto.ContainerStatus">dto.ContainerStatus</h2>

<a id="schemadto.containerstatus"></a>
<a id="schema_dto.ContainerStatus"></a>
<a id="tocSdto.containerstatus"></a>
<a id="tocsdto.containerstatus"></a>

```json
{
  "all": 0,
  "composeCount": 0,
  "composeTemplateCount": 0,
  "containerCount": 0,
  "created": 0,
  "dead": 0,
  "exited": 0,
  "imageCount": 0,
  "imageSize": 0,
  "networkCount": 0,
  "paused": 0,
  "removing": 0,
  "repoCount": 0,
  "restarting": 0,
  "running": 0,
  "volumeCount": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|all|integer|false|none||none|
|composeCount|integer|false|none||none|
|composeTemplateCount|integer|false|none||none|
|containerCount|integer|false|none||none|
|created|integer|false|none||none|
|dead|integer|false|none||none|
|exited|integer|false|none||none|
|imageCount|integer|false|none||none|
|imageSize|integer|false|none||none|
|networkCount|integer|false|none||none|
|paused|integer|false|none||none|
|removing|integer|false|none||none|
|repoCount|integer|false|none||none|
|restarting|integer|false|none||none|
|running|integer|false|none||none|
|volumeCount|integer|false|none||none|

<h2 id="tocS_dto.ContainerUpgrade">dto.ContainerUpgrade</h2>

<a id="schemadto.containerupgrade"></a>
<a id="schema_dto.ContainerUpgrade"></a>
<a id="tocSdto.containerupgrade"></a>
<a id="tocsdto.containerupgrade"></a>

```json
{
  "forcePull": true,
  "image": "string",
  "name": "string",
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|forcePull|boolean|false|none||none|
|image|string|true|none||none|
|name|string|true|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_dto.CronjobBatchDelete">dto.CronjobBatchDelete</h2>

<a id="schemadto.cronjobbatchdelete"></a>
<a id="schema_dto.CronjobBatchDelete"></a>
<a id="tocSdto.cronjobbatchdelete"></a>
<a id="tocsdto.cronjobbatchdelete"></a>

```json
{
  "cleanData": true,
  "ids": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cleanData|boolean|false|none||none|
|ids|[integer]|true|none||none|

<h2 id="tocS_dto.CronjobClean">dto.CronjobClean</h2>

<a id="schemadto.cronjobclean"></a>
<a id="schema_dto.CronjobClean"></a>
<a id="tocSdto.cronjobclean"></a>
<a id="tocsdto.cronjobclean"></a>

```json
{
  "cleanData": true,
  "cronjobID": 0,
  "isDelete": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cleanData|boolean|false|none||none|
|cronjobID|integer|true|none||none|
|isDelete|boolean|false|none||none|

<h2 id="tocS_dto.CronjobCreate">dto.CronjobCreate</h2>

<a id="schemadto.cronjobcreate"></a>
<a id="schema_dto.CronjobCreate"></a>
<a id="tocSdto.cronjobcreate"></a>
<a id="tocsdto.cronjobcreate"></a>

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "appID": "string",
  "command": "string",
  "containerName": "string",
  "dbName": "string",
  "dbType": "string",
  "downloadAccountID": 0,
  "exclusionRules": "string",
  "executor": "string",
  "isDir": true,
  "name": "string",
  "retainCopies": 1,
  "script": "string",
  "scriptMode": "string",
  "secret": "string",
  "sourceAccountIDs": "string",
  "sourceDir": "string",
  "spec": "string",
  "specCustom": true,
  "type": "string",
  "url": "string",
  "user": "string",
  "website": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|alertCount|integer|false|none||none|
|alertTitle|string|false|none||none|
|appID|string|false|none||none|
|command|string|false|none||none|
|containerName|string|false|none||none|
|dbName|string|false|none||none|
|dbType|string|false|none||none|
|downloadAccountID|integer|false|none||none|
|exclusionRules|string|false|none||none|
|executor|string|false|none||none|
|isDir|boolean|false|none||none|
|name|string|true|none||none|
|retainCopies|integer|false|none||none|
|script|string|false|none||none|
|scriptMode|string|false|none||none|
|secret|string|false|none||none|
|sourceAccountIDs|string|false|none||none|
|sourceDir|string|false|none||none|
|spec|string|true|none||none|
|specCustom|boolean|false|none||none|
|type|string|true|none||none|
|url|string|false|none||none|
|user|string|false|none||none|
|website|string|false|none||none|

<h2 id="tocS_dto.CronjobDownload">dto.CronjobDownload</h2>

<a id="schemadto.cronjobdownload"></a>
<a id="schema_dto.CronjobDownload"></a>
<a id="tocSdto.cronjobdownload"></a>
<a id="tocsdto.cronjobdownload"></a>

```json
{
  "backupAccountID": 0,
  "recordID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|backupAccountID|integer|true|none||none|
|recordID|integer|true|none||none|

<h2 id="tocS_dto.CronjobSpec">dto.CronjobSpec</h2>

<a id="schemadto.cronjobspec"></a>
<a id="schema_dto.CronjobSpec"></a>
<a id="tocSdto.cronjobspec"></a>
<a id="tocsdto.cronjobspec"></a>

```json
{
  "spec": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|spec|string|true|none||none|

<h2 id="tocS_dto.CronjobUpdate">dto.CronjobUpdate</h2>

<a id="schemadto.cronjobupdate"></a>
<a id="schema_dto.CronjobUpdate"></a>
<a id="tocSdto.cronjobupdate"></a>
<a id="tocsdto.cronjobupdate"></a>

```json
{
  "alertCount": 0,
  "alertTitle": "string",
  "appID": "string",
  "command": "string",
  "containerName": "string",
  "dbName": "string",
  "dbType": "string",
  "downloadAccountID": 0,
  "exclusionRules": "string",
  "executor": "string",
  "id": 0,
  "isDir": true,
  "name": "string",
  "retainCopies": 1,
  "script": "string",
  "scriptMode": "string",
  "secret": "string",
  "sourceAccountIDs": "string",
  "sourceDir": "string",
  "spec": "string",
  "specCustom": true,
  "type": "string",
  "url": "string",
  "user": "string",
  "website": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|alertCount|integer|false|none||none|
|alertTitle|string|false|none||none|
|appID|string|false|none||none|
|command|string|false|none||none|
|containerName|string|false|none||none|
|dbName|string|false|none||none|
|dbType|string|false|none||none|
|downloadAccountID|integer|false|none||none|
|exclusionRules|string|false|none||none|
|executor|string|false|none||none|
|id|integer|true|none||none|
|isDir|boolean|false|none||none|
|name|string|true|none||none|
|retainCopies|integer|false|none||none|
|script|string|false|none||none|
|scriptMode|string|false|none||none|
|secret|string|false|none||none|
|sourceAccountIDs|string|false|none||none|
|sourceDir|string|false|none||none|
|spec|string|true|none||none|
|specCustom|boolean|false|none||none|
|type|string|true|none||none|
|url|string|false|none||none|
|user|string|false|none||none|
|website|string|false|none||none|

<h2 id="tocS_dto.CronjobUpdateStatus">dto.CronjobUpdateStatus</h2>

<a id="schemadto.cronjobupdatestatus"></a>
<a id="schema_dto.CronjobUpdateStatus"></a>
<a id="tocSdto.cronjobupdatestatus"></a>
<a id="tocsdto.cronjobupdatestatus"></a>

```json
{
  "id": 0,
  "status": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|status|string|true|none||none|

<h2 id="tocS_dto.DBBaseInfo">dto.DBBaseInfo</h2>

<a id="schemadto.dbbaseinfo"></a>
<a id="schema_dto.DBBaseInfo"></a>
<a id="tocSdto.dbbaseinfo"></a>
<a id="tocsdto.dbbaseinfo"></a>

```json
{
  "containerName": "string",
  "name": "string",
  "port": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerName|string|false|none||none|
|name|string|false|none||none|
|port|integer|false|none||none|

<h2 id="tocS_dto.DBConfUpdateByFile">dto.DBConfUpdateByFile</h2>

<a id="schemadto.dbconfupdatebyfile"></a>
<a id="schema_dto.DBConfUpdateByFile"></a>
<a id="tocSdto.dbconfupdatebyfile"></a>
<a id="tocsdto.dbconfupdatebyfile"></a>

```json
{
  "database": "string",
  "file": "string",
  "type": "mysql"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|file|string|false|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|mysql|
|type|mariadb|
|type|postgresql|
|type|redis|

<h2 id="tocS_dto.DaemonJsonConf">dto.DaemonJsonConf</h2>

<a id="schemadto.daemonjsonconf"></a>
<a id="schema_dto.DaemonJsonConf"></a>
<a id="tocSdto.daemonjsonconf"></a>
<a id="tocsdto.daemonjsonconf"></a>

```json
{
  "cgroupDriver": "string",
  "experimental": true,
  "fixedCidrV6": "string",
  "insecureRegistries": [
    "string"
  ],
  "ip6Tables": true,
  "iptables": true,
  "ipv6": true,
  "isActive": true,
  "isExist": true,
  "isSwarm": true,
  "liveRestore": true,
  "logMaxFile": "string",
  "logMaxSize": "string",
  "registryMirrors": [
    "string"
  ],
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cgroupDriver|string|false|none||none|
|experimental|boolean|false|none||none|
|fixedCidrV6|string|false|none||none|
|insecureRegistries|[string]|false|none||none|
|ip6Tables|boolean|false|none||none|
|iptables|boolean|false|none||none|
|ipv6|boolean|false|none||none|
|isActive|boolean|false|none||none|
|isExist|boolean|false|none||none|
|isSwarm|boolean|false|none||none|
|liveRestore|boolean|false|none||none|
|logMaxFile|string|false|none||none|
|logMaxSize|string|false|none||none|
|registryMirrors|[string]|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.DaemonJsonUpdateByFile">dto.DaemonJsonUpdateByFile</h2>

<a id="schemadto.daemonjsonupdatebyfile"></a>
<a id="schema_dto.DaemonJsonUpdateByFile"></a>
<a id="tocSdto.daemonjsonupdatebyfile"></a>
<a id="tocsdto.daemonjsonupdatebyfile"></a>

```json
{
  "file": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|file|string|false|none||none|

<h2 id="tocS_dto.DashboardBase">dto.DashboardBase</h2>

<a id="schemadto.dashboardbase"></a>
<a id="schema_dto.DashboardBase"></a>
<a id="tocSdto.dashboardbase"></a>
<a id="tocsdto.dashboardbase"></a>

```json
{
  "appInstalledNumber": 0,
  "cpuCores": 0,
  "cpuLogicalCores": 0,
  "cpuModelName": "string",
  "cronjobNumber": 0,
  "currentInfo": {
    "cpuPercent": [
      0
    ],
    "cpuTotal": 0,
    "cpuUsed": 0,
    "cpuUsedPercent": 0,
    "diskData": [
      {
        "device": "string",
        "free": 0,
        "inodesFree": 0,
        "inodesTotal": 0,
        "inodesUsed": 0,
        "inodesUsedPercent": 0,
        "path": "string",
        "total": 0,
        "type": "string",
        "used": 0,
        "usedPercent": 0
      }
    ],
    "gpuData": [
      {
        "fanSpeed": "string",
        "gpuUtil": "string",
        "index": 0,
        "maxPowerLimit": "string",
        "memTotal": "string",
        "memUsed": "string",
        "memoryUsage": "string",
        "performanceState": "string",
        "powerDraw": "string",
        "powerUsage": "string",
        "productName": "string",
        "temperature": "string"
      }
    ],
    "ioCount": 0,
    "ioReadBytes": 0,
    "ioReadTime": 0,
    "ioWriteBytes": 0,
    "ioWriteTime": 0,
    "load1": 0,
    "load15": 0,
    "load5": 0,
    "loadUsagePercent": 0,
    "memoryAvailable": 0,
    "memoryTotal": 0,
    "memoryUsed": 0,
    "memoryUsedPercent": 0,
    "netBytesRecv": 0,
    "netBytesSent": 0,
    "procs": 0,
    "shotTime": "string",
    "swapMemoryAvailable": 0,
    "swapMemoryTotal": 0,
    "swapMemoryUsed": 0,
    "swapMemoryUsedPercent": 0,
    "timeSinceUptime": "string",
    "uptime": 0,
    "xpuData": [
      {
        "deviceID": 0,
        "deviceName": "string",
        "memory": "string",
        "memoryUsed": "string",
        "memoryUtil": "string",
        "power": "string",
        "temperature": "string"
      }
    ]
  },
  "databaseNumber": 0,
  "hostname": "string",
  "ipV4Addr": "string",
  "kernelArch": "string",
  "kernelVersion": "string",
  "os": "string",
  "platform": "string",
  "platformFamily": "string",
  "platformVersion": "string",
  "systemProxy": "string",
  "virtualizationSystem": "string",
  "websiteNumber": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appInstalledNumber|integer|false|none||none|
|cpuCores|integer|false|none||none|
|cpuLogicalCores|integer|false|none||none|
|cpuModelName|string|false|none||none|
|cronjobNumber|integer|false|none||none|
|currentInfo|[dto.DashboardCurrent](#schemadto.dashboardcurrent)|false|none||none|
|databaseNumber|integer|false|none||none|
|hostname|string|false|none||none|
|ipV4Addr|string|false|none||none|
|kernelArch|string|false|none||none|
|kernelVersion|string|false|none||none|
|os|string|false|none||none|
|platform|string|false|none||none|
|platformFamily|string|false|none||none|
|platformVersion|string|false|none||none|
|systemProxy|string|false|none||none|
|virtualizationSystem|string|false|none||none|
|websiteNumber|integer|false|none||none|

<h2 id="tocS_dto.DashboardCurrent">dto.DashboardCurrent</h2>

<a id="schemadto.dashboardcurrent"></a>
<a id="schema_dto.DashboardCurrent"></a>
<a id="tocSdto.dashboardcurrent"></a>
<a id="tocsdto.dashboardcurrent"></a>

```json
{
  "cpuPercent": [
    0
  ],
  "cpuTotal": 0,
  "cpuUsed": 0,
  "cpuUsedPercent": 0,
  "diskData": [
    {
      "device": "string",
      "free": 0,
      "inodesFree": 0,
      "inodesTotal": 0,
      "inodesUsed": 0,
      "inodesUsedPercent": 0,
      "path": "string",
      "total": 0,
      "type": "string",
      "used": 0,
      "usedPercent": 0
    }
  ],
  "gpuData": [
    {
      "fanSpeed": "string",
      "gpuUtil": "string",
      "index": 0,
      "maxPowerLimit": "string",
      "memTotal": "string",
      "memUsed": "string",
      "memoryUsage": "string",
      "performanceState": "string",
      "powerDraw": "string",
      "powerUsage": "string",
      "productName": "string",
      "temperature": "string"
    }
  ],
  "ioCount": 0,
  "ioReadBytes": 0,
  "ioReadTime": 0,
  "ioWriteBytes": 0,
  "ioWriteTime": 0,
  "load1": 0,
  "load15": 0,
  "load5": 0,
  "loadUsagePercent": 0,
  "memoryAvailable": 0,
  "memoryTotal": 0,
  "memoryUsed": 0,
  "memoryUsedPercent": 0,
  "netBytesRecv": 0,
  "netBytesSent": 0,
  "procs": 0,
  "shotTime": "string",
  "swapMemoryAvailable": 0,
  "swapMemoryTotal": 0,
  "swapMemoryUsed": 0,
  "swapMemoryUsedPercent": 0,
  "timeSinceUptime": "string",
  "uptime": 0,
  "xpuData": [
    {
      "deviceID": 0,
      "deviceName": "string",
      "memory": "string",
      "memoryUsed": "string",
      "memoryUtil": "string",
      "power": "string",
      "temperature": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cpuPercent|[number]|false|none||none|
|cpuTotal|integer|false|none||none|
|cpuUsed|number|false|none||none|
|cpuUsedPercent|number|false|none||none|
|diskData|[[dto.DiskInfo](#schemadto.diskinfo)]|false|none||none|
|gpuData|[[dto.GPUInfo](#schemadto.gpuinfo)]|false|none||none|
|ioCount|integer|false|none||none|
|ioReadBytes|integer|false|none||none|
|ioReadTime|integer|false|none||none|
|ioWriteBytes|integer|false|none||none|
|ioWriteTime|integer|false|none||none|
|load1|number|false|none||none|
|load15|number|false|none||none|
|load5|number|false|none||none|
|loadUsagePercent|number|false|none||none|
|memoryAvailable|integer|false|none||none|
|memoryTotal|integer|false|none||none|
|memoryUsed|integer|false|none||none|
|memoryUsedPercent|number|false|none||none|
|netBytesRecv|integer|false|none||none|
|netBytesSent|integer|false|none||none|
|procs|integer|false|none||none|
|shotTime|string|false|none||none|
|swapMemoryAvailable|integer|false|none||none|
|swapMemoryTotal|integer|false|none||none|
|swapMemoryUsed|integer|false|none||none|
|swapMemoryUsedPercent|number|false|none||none|
|timeSinceUptime|string|false|none||none|
|uptime|integer|false|none||none|
|xpuData|[[dto.XPUInfo](#schemadto.xpuinfo)]|false|none||none|

<h2 id="tocS_dto.DataTree">dto.DataTree</h2>

<a id="schemadto.datatree"></a>
<a id="schema_dto.DataTree"></a>
<a id="tocSdto.datatree"></a>
<a id="tocsdto.datatree"></a>

```json
{
  "children": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "id": "string",
  "isCheck": true,
  "isDisable": true,
  "key": "string",
  "label": "string",
  "name": "string",
  "path": "string",
  "relationItemID": "string",
  "size": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|children|[[dto.DataTree](#schemadto.datatree)]|false|none||none|
|id|string|false|none||none|
|isCheck|boolean|false|none||none|
|isDisable|boolean|false|none||none|
|key|string|false|none||none|
|label|string|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|relationItemID|string|false|none||none|
|size|integer|false|none||none|

<h2 id="tocS_dto.DatabaseCreate">dto.DatabaseCreate</h2>

<a id="schemadto.databasecreate"></a>
<a id="schema_dto.DatabaseCreate"></a>
<a id="tocSdto.databasecreate"></a>
<a id="tocsdto.databasecreate"></a>

```json
{
  "address": "string",
  "clientCert": "string",
  "clientKey": "string",
  "description": "string",
  "from": "local",
  "name": "string",
  "password": "string",
  "port": 0,
  "rootCert": "string",
  "skipVerify": true,
  "ssl": true,
  "type": "string",
  "username": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|false|none||none|
|clientCert|string|false|none||none|
|clientKey|string|false|none||none|
|description|string|false|none||none|
|from|string|true|none||none|
|name|string|true|none||none|
|password|string|false|none||none|
|port|integer|false|none||none|
|rootCert|string|false|none||none|
|skipVerify|boolean|false|none||none|
|ssl|boolean|false|none||none|
|type|string|true|none||none|
|username|string|true|none||none|
|version|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|from|local|
|from|remote|

<h2 id="tocS_dto.DatabaseDelete">dto.DatabaseDelete</h2>

<a id="schemadto.databasedelete"></a>
<a id="schema_dto.DatabaseDelete"></a>
<a id="tocSdto.databasedelete"></a>
<a id="tocsdto.databasedelete"></a>

```json
{
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|deleteBackup|boolean|false|none||none|
|forceDelete|boolean|false|none||none|
|id|integer|true|none||none|

<h2 id="tocS_dto.DatabaseInfo">dto.DatabaseInfo</h2>

<a id="schemadto.databaseinfo"></a>
<a id="schema_dto.DatabaseInfo"></a>
<a id="tocSdto.databaseinfo"></a>
<a id="tocsdto.databaseinfo"></a>

```json
{
  "address": "string",
  "clientCert": "string",
  "clientKey": "string",
  "createdAt": "string",
  "description": "string",
  "from": "string",
  "id": 0,
  "name": "string",
  "password": "string",
  "port": 0,
  "rootCert": "string",
  "skipVerify": true,
  "ssl": true,
  "type": "string",
  "username": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|false|none||none|
|clientCert|string|false|none||none|
|clientKey|string|false|none||none|
|createdAt|string|false|none||none|
|description|string|false|none||none|
|from|string|false|none||none|
|id|integer|false|none||none|
|name|string|false|none||none|
|password|string|false|none||none|
|port|integer|false|none||none|
|rootCert|string|false|none||none|
|skipVerify|boolean|false|none||none|
|ssl|boolean|false|none||none|
|type|string|false|none||none|
|username|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.DatabaseItem">dto.DatabaseItem</h2>

<a id="schemadto.databaseitem"></a>
<a id="schema_dto.DatabaseItem"></a>
<a id="tocSdto.databaseitem"></a>
<a id="tocsdto.databaseitem"></a>

```json
{
  "database": "string",
  "from": "string",
  "id": 0,
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|false|none||none|
|from|string|false|none||none|
|id|integer|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_dto.DatabaseOption">dto.DatabaseOption</h2>

<a id="schemadto.databaseoption"></a>
<a id="schema_dto.DatabaseOption"></a>
<a id="tocSdto.databaseoption"></a>
<a id="tocsdto.databaseoption"></a>

```json
{
  "address": "string",
  "database": "string",
  "from": "string",
  "id": 0,
  "type": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|false|none||none|
|database|string|false|none||none|
|from|string|false|none||none|
|id|integer|false|none||none|
|type|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.DatabaseSearch">dto.DatabaseSearch</h2>

<a id="schemadto.databasesearch"></a>
<a id="schema_dto.DatabaseSearch"></a>
<a id="tocSdto.databasesearch"></a>
<a id="tocsdto.databasesearch"></a>

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|info|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|type|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|name|
|orderBy|createdAt|

<h2 id="tocS_dto.DatabaseUpdate">dto.DatabaseUpdate</h2>

<a id="schemadto.databaseupdate"></a>
<a id="schema_dto.DatabaseUpdate"></a>
<a id="tocSdto.databaseupdate"></a>
<a id="tocsdto.databaseupdate"></a>

```json
{
  "address": "string",
  "clientCert": "string",
  "clientKey": "string",
  "description": "string",
  "id": 0,
  "password": "string",
  "port": 0,
  "rootCert": "string",
  "skipVerify": true,
  "ssl": true,
  "type": "string",
  "username": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|false|none||none|
|clientCert|string|false|none||none|
|clientKey|string|false|none||none|
|description|string|false|none||none|
|id|integer|false|none||none|
|password|string|false|none||none|
|port|integer|false|none||none|
|rootCert|string|false|none||none|
|skipVerify|boolean|false|none||none|
|ssl|boolean|false|none||none|
|type|string|true|none||none|
|username|string|true|none||none|
|version|string|true|none||none|

<h2 id="tocS_dto.DeviceBaseInfo">dto.DeviceBaseInfo</h2>

<a id="schemadto.devicebaseinfo"></a>
<a id="schema_dto.DeviceBaseInfo"></a>
<a id="tocSdto.devicebaseinfo"></a>
<a id="tocsdto.devicebaseinfo"></a>

```json
{
  "dns": [
    "string"
  ],
  "hostname": "string",
  "hosts": [
    {
      "host": "string",
      "ip": "string"
    }
  ],
  "localTime": "string",
  "maxSize": 0,
  "ntp": "string",
  "swapDetails": [
    {
      "isNew": true,
      "path": "string",
      "size": 0,
      "used": "string"
    }
  ],
  "swapMemoryAvailable": 0,
  "swapMemoryTotal": 0,
  "swapMemoryUsed": 0,
  "timeZone": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|dns|[string]|false|none||none|
|hostname|string|false|none||none|
|hosts|[[dto.HostHelper](#schemadto.hosthelper)]|false|none||none|
|localTime|string|false|none||none|
|maxSize|integer|false|none||none|
|ntp|string|false|none||none|
|swapDetails|[[dto.SwapHelper](#schemadto.swaphelper)]|false|none||none|
|swapMemoryAvailable|integer|false|none||none|
|swapMemoryTotal|integer|false|none||none|
|swapMemoryUsed|integer|false|none||none|
|timeZone|string|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_dto.DiskInfo">dto.DiskInfo</h2>

<a id="schemadto.diskinfo"></a>
<a id="schema_dto.DiskInfo"></a>
<a id="tocSdto.diskinfo"></a>
<a id="tocsdto.diskinfo"></a>

```json
{
  "device": "string",
  "free": 0,
  "inodesFree": 0,
  "inodesTotal": 0,
  "inodesUsed": 0,
  "inodesUsedPercent": 0,
  "path": "string",
  "total": 0,
  "type": "string",
  "used": 0,
  "usedPercent": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|device|string|false|none||none|
|free|integer|false|none||none|
|inodesFree|integer|false|none||none|
|inodesTotal|integer|false|none||none|
|inodesUsed|integer|false|none||none|
|inodesUsedPercent|number|false|none||none|
|path|string|false|none||none|
|total|integer|false|none||none|
|type|string|false|none||none|
|used|integer|false|none||none|
|usedPercent|number|false|none||none|

<h2 id="tocS_dto.DockerOperation">dto.DockerOperation</h2>

<a id="schemadto.dockeroperation"></a>
<a id="schema_dto.DockerOperation"></a>
<a id="tocSdto.dockeroperation"></a>
<a id="tocsdto.dockeroperation"></a>

```json
{
  "operation": "start"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|operation|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operation|start|
|operation|restart|
|operation|stop|

<h2 id="tocS_dto.DownloadRecord">dto.DownloadRecord</h2>

<a id="schemadto.downloadrecord"></a>
<a id="schema_dto.DownloadRecord"></a>
<a id="tocSdto.downloadrecord"></a>
<a id="tocsdto.downloadrecord"></a>

```json
{
  "downloadAccountID": 0,
  "fileDir": "string",
  "fileName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|downloadAccountID|integer|true|none||none|
|fileDir|string|true|none||none|
|fileName|string|true|none||none|

<h2 id="tocS_dto.ExtraProperties">dto.ExtraProperties</h2>

<a id="schemadto.extraproperties"></a>
<a id="schema_dto.ExtraProperties"></a>
<a id="tocSdto.extraproperties"></a>
<a id="tocsdto.extraproperties"></a>

```json
{
  "tags": [
    {
      "key": "string",
      "locales": {
        "en": "string",
        "ja": "string",
        "ms": "string",
        "pt-br": "string",
        "ru": "string",
        "zh": "string",
        "zh-hant": "string"
      },
      "name": "string",
      "sort": 0
    }
  ],
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|tags|[[dto.Tag](#schemadto.tag)]|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.Fail2BanBaseInfo">dto.Fail2BanBaseInfo</h2>

<a id="schemadto.fail2banbaseinfo"></a>
<a id="schema_dto.Fail2BanBaseInfo"></a>
<a id="tocSdto.fail2banbaseinfo"></a>
<a id="tocsdto.fail2banbaseinfo"></a>

```json
{
  "banAction": "string",
  "banTime": "string",
  "findTime": "string",
  "isActive": true,
  "isEnable": true,
  "isExist": true,
  "logPath": "string",
  "maxRetry": 0,
  "port": 0,
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|banAction|string|false|none||none|
|banTime|string|false|none||none|
|findTime|string|false|none||none|
|isActive|boolean|false|none||none|
|isEnable|boolean|false|none||none|
|isExist|boolean|false|none||none|
|logPath|string|false|none||none|
|maxRetry|integer|false|none||none|
|port|integer|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.Fail2BanSearch">dto.Fail2BanSearch</h2>

<a id="schemadto.fail2bansearch"></a>
<a id="schema_dto.Fail2BanSearch"></a>
<a id="tocSdto.fail2bansearch"></a>
<a id="tocsdto.fail2bansearch"></a>

```json
{
  "status": "banned"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|status|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|status|banned|
|status|ignore|

<h2 id="tocS_dto.Fail2BanUpdate">dto.Fail2BanUpdate</h2>

<a id="schemadto.fail2banupdate"></a>
<a id="schema_dto.Fail2BanUpdate"></a>
<a id="tocSdto.fail2banupdate"></a>
<a id="tocsdto.fail2banupdate"></a>

```json
{
  "key": "port",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|true|none||none|
|value|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|key|port|
|key|bantime|
|key|findtime|
|key|maxretry|
|key|banaction|
|key|logpath|
|key|port|

<h2 id="tocS_dto.FirewallBaseInfo">dto.FirewallBaseInfo</h2>

<a id="schemadto.firewallbaseinfo"></a>
<a id="schema_dto.FirewallBaseInfo"></a>
<a id="tocSdto.firewallbaseinfo"></a>
<a id="tocsdto.firewallbaseinfo"></a>

```json
{
  "isActive": true,
  "isExist": true,
  "name": "string",
  "pingStatus": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|isActive|boolean|false|none||none|
|isExist|boolean|false|none||none|
|name|string|false|none||none|
|pingStatus|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_dto.FirewallOperation">dto.FirewallOperation</h2>

<a id="schemadto.firewalloperation"></a>
<a id="schema_dto.FirewallOperation"></a>
<a id="tocSdto.firewalloperation"></a>
<a id="tocsdto.firewalloperation"></a>

```json
{
  "operation": "start"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|operation|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operation|start|
|operation|stop|
|operation|restart|
|operation|disablePing|
|operation|enablePing|

<h2 id="tocS_dto.ForBuckets">dto.ForBuckets</h2>

<a id="schemadto.forbuckets"></a>
<a id="schema_dto.ForBuckets"></a>
<a id="tocSdto.forbuckets"></a>
<a id="tocsdto.forbuckets"></a>

```json
{
  "accessKey": "string",
  "credential": "string",
  "type": "string",
  "vars": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|accessKey|string|false|none||none|
|credential|string|true|none||none|
|type|string|true|none||none|
|vars|string|true|none||none|

<h2 id="tocS_dto.ForceDelete">dto.ForceDelete</h2>

<a id="schemadto.forcedelete"></a>
<a id="schema_dto.ForceDelete"></a>
<a id="tocSdto.forcedelete"></a>
<a id="tocsdto.forcedelete"></a>

```json
{
  "forceDelete": true,
  "ids": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|forceDelete|boolean|false|none||none|
|ids|[integer]|false|none||none|

<h2 id="tocS_dto.ForwardRuleOperate">dto.ForwardRuleOperate</h2>

<a id="schemadto.forwardruleoperate"></a>
<a id="schema_dto.ForwardRuleOperate"></a>
<a id="tocSdto.forwardruleoperate"></a>
<a id="tocsdto.forwardruleoperate"></a>

```json
{
  "forceDelete": true,
  "rules": [
    {
      "num": "string",
      "operation": "add",
      "port": "string",
      "protocol": "tcp",
      "targetIP": "string",
      "targetPort": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|forceDelete|boolean|false|none||none|
|rules|[object]|false|none||none|
|» num|string|false|none||none|
|» operation|string|true|none||none|
|» port|string|true|none||none|
|» protocol|string|true|none||none|
|» targetIP|string|false|none||none|
|» targetPort|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operation|add|
|operation|remove|
|protocol|tcp|
|protocol|udp|
|protocol|tcp/udp|

<h2 id="tocS_dto.FtpBaseInfo">dto.FtpBaseInfo</h2>

<a id="schemadto.ftpbaseinfo"></a>
<a id="schema_dto.FtpBaseInfo"></a>
<a id="tocSdto.ftpbaseinfo"></a>
<a id="tocsdto.ftpbaseinfo"></a>

```json
{
  "isActive": true,
  "isExist": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|isActive|boolean|false|none||none|
|isExist|boolean|false|none||none|

<h2 id="tocS_dto.FtpCreate">dto.FtpCreate</h2>

<a id="schemadto.ftpcreate"></a>
<a id="schema_dto.FtpCreate"></a>
<a id="tocSdto.ftpcreate"></a>
<a id="tocsdto.ftpcreate"></a>

```json
{
  "description": "string",
  "password": "string",
  "path": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|description|string|false|none||none|
|password|string|true|none||none|
|path|string|true|none||none|
|user|string|true|none||none|

<h2 id="tocS_dto.FtpLogSearch">dto.FtpLogSearch</h2>

<a id="schemadto.ftplogsearch"></a>
<a id="schema_dto.FtpLogSearch"></a>
<a id="tocSdto.ftplogsearch"></a>
<a id="tocsdto.ftplogsearch"></a>

```json
{
  "operation": "string",
  "page": 0,
  "pageSize": 0,
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|operation|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|user|string|false|none||none|

<h2 id="tocS_dto.FtpUpdate">dto.FtpUpdate</h2>

<a id="schemadto.ftpupdate"></a>
<a id="schema_dto.FtpUpdate"></a>
<a id="tocSdto.ftpupdate"></a>
<a id="tocsdto.ftpupdate"></a>

```json
{
  "description": "string",
  "id": 0,
  "password": "string",
  "path": "string",
  "status": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|description|string|false|none||none|
|id|integer|false|none||none|
|password|string|true|none||none|
|path|string|true|none||none|
|status|string|false|none||none|

<h2 id="tocS_dto.GPUInfo">dto.GPUInfo</h2>

<a id="schemadto.gpuinfo"></a>
<a id="schema_dto.GPUInfo"></a>
<a id="tocSdto.gpuinfo"></a>
<a id="tocsdto.gpuinfo"></a>

```json
{
  "fanSpeed": "string",
  "gpuUtil": "string",
  "index": 0,
  "maxPowerLimit": "string",
  "memTotal": "string",
  "memUsed": "string",
  "memoryUsage": "string",
  "performanceState": "string",
  "powerDraw": "string",
  "powerUsage": "string",
  "productName": "string",
  "temperature": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|fanSpeed|string|false|none||none|
|gpuUtil|string|false|none||none|
|index|integer|false|none||none|
|maxPowerLimit|string|false|none||none|
|memTotal|string|false|none||none|
|memUsed|string|false|none||none|
|memoryUsage|string|false|none||none|
|performanceState|string|false|none||none|
|powerDraw|string|false|none||none|
|powerUsage|string|false|none||none|
|productName|string|false|none||none|
|temperature|string|false|none||none|

<h2 id="tocS_dto.GenerateLoad">dto.GenerateLoad</h2>

<a id="schemadto.generateload"></a>
<a id="schema_dto.GenerateLoad"></a>
<a id="tocSdto.generateload"></a>
<a id="tocsdto.generateload"></a>

```json
{
  "encryptionMode": "rsa"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|encryptionMode|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|encryptionMode|rsa|
|encryptionMode|ed25519|
|encryptionMode|ecdsa|
|encryptionMode|dsa|

<h2 id="tocS_dto.GenerateSSH">dto.GenerateSSH</h2>

<a id="schemadto.generatessh"></a>
<a id="schema_dto.GenerateSSH"></a>
<a id="tocSdto.generatessh"></a>
<a id="tocsdto.generatessh"></a>

```json
{
  "encryptionMode": "rsa",
  "password": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|encryptionMode|string|true|none||none|
|password|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|encryptionMode|rsa|
|encryptionMode|ed25519|
|encryptionMode|ecdsa|
|encryptionMode|dsa|

<h2 id="tocS_dto.GroupCreate">dto.GroupCreate</h2>

<a id="schemadto.groupcreate"></a>
<a id="schema_dto.GroupCreate"></a>
<a id="tocSdto.groupcreate"></a>
<a id="tocsdto.groupcreate"></a>

```json
{
  "id": 0,
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|name|string|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.GroupSearch">dto.GroupSearch</h2>

<a id="schemadto.groupsearch"></a>
<a id="schema_dto.GroupSearch"></a>
<a id="tocSdto.groupsearch"></a>
<a id="tocsdto.groupsearch"></a>

```json
{
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|type|string|true|none||none|

<h2 id="tocS_dto.GroupUpdate">dto.GroupUpdate</h2>

<a id="schemadto.groupupdate"></a>
<a id="schema_dto.GroupUpdate"></a>
<a id="tocSdto.groupupdate"></a>
<a id="tocsdto.groupupdate"></a>

```json
{
  "id": 0,
  "isDefault": true,
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|isDefault|boolean|false|none||none|
|name|string|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.HostHelper">dto.HostHelper</h2>

<a id="schemadto.hosthelper"></a>
<a id="schema_dto.HostHelper"></a>
<a id="tocSdto.hosthelper"></a>
<a id="tocsdto.hosthelper"></a>

```json
{
  "host": "string",
  "ip": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|host|string|false|none||none|
|ip|string|false|none||none|

<h2 id="tocS_dto.ImageBuild">dto.ImageBuild</h2>

<a id="schemadto.imagebuild"></a>
<a id="schema_dto.ImageBuild"></a>
<a id="tocSdto.imagebuild"></a>
<a id="tocsdto.imagebuild"></a>

```json
{
  "dockerfile": "string",
  "from": "string",
  "name": "string",
  "tags": [
    "string"
  ],
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|dockerfile|string|true|none||none|
|from|string|true|none||none|
|name|string|true|none||none|
|tags|[string]|false|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_dto.ImageInfo">dto.ImageInfo</h2>

<a id="schemadto.imageinfo"></a>
<a id="schema_dto.ImageInfo"></a>
<a id="tocSdto.imageinfo"></a>
<a id="tocsdto.imageinfo"></a>

```json
{
  "createdAt": "string",
  "id": "string",
  "isUsed": true,
  "size": "string",
  "tags": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|createdAt|string|false|none||none|
|id|string|false|none||none|
|isUsed|boolean|false|none||none|
|size|string|false|none||none|
|tags|[string]|false|none||none|

<h2 id="tocS_dto.ImageLoad">dto.ImageLoad</h2>

<a id="schemadto.imageload"></a>
<a id="schema_dto.ImageLoad"></a>
<a id="tocSdto.imageload"></a>
<a id="tocsdto.imageload"></a>

```json
{
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|path|string|true|none||none|

<h2 id="tocS_dto.ImagePull">dto.ImagePull</h2>

<a id="schemadto.imagepull"></a>
<a id="schema_dto.ImagePull"></a>
<a id="tocSdto.imagepull"></a>
<a id="tocsdto.imagepull"></a>

```json
{
  "imageName": "string",
  "repoID": 0,
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|imageName|string|true|none||none|
|repoID|integer|false|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_dto.ImagePush">dto.ImagePush</h2>

<a id="schemadto.imagepush"></a>
<a id="schema_dto.ImagePush"></a>
<a id="tocSdto.imagepush"></a>
<a id="tocsdto.imagepush"></a>

```json
{
  "name": "string",
  "repoID": 0,
  "tagName": "string",
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|
|repoID|integer|true|none||none|
|tagName|string|true|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_dto.ImageRepoDelete">dto.ImageRepoDelete</h2>

<a id="schemadto.imagerepodelete"></a>
<a id="schema_dto.ImageRepoDelete"></a>
<a id="tocSdto.imagerepodelete"></a>
<a id="tocsdto.imagerepodelete"></a>

```json
{
  "ids": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ids|[integer]|true|none||none|

<h2 id="tocS_dto.ImageRepoOption">dto.ImageRepoOption</h2>

<a id="schemadto.imagerepooption"></a>
<a id="schema_dto.ImageRepoOption"></a>
<a id="tocSdto.imagerepooption"></a>
<a id="tocsdto.imagerepooption"></a>

```json
{
  "downloadUrl": "string",
  "id": 0,
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|downloadUrl|string|false|none||none|
|id|integer|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_dto.ImageRepoUpdate">dto.ImageRepoUpdate</h2>

<a id="schemadto.imagerepoupdate"></a>
<a id="schema_dto.ImageRepoUpdate"></a>
<a id="tocSdto.imagerepoupdate"></a>
<a id="tocsdto.imagerepoupdate"></a>

```json
{
  "auth": true,
  "downloadUrl": "string",
  "id": 0,
  "password": "string",
  "protocol": "string",
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|auth|boolean|false|none||none|
|downloadUrl|string|false|none||none|
|id|integer|false|none||none|
|password|string|false|none||none|
|protocol|string|false|none||none|
|username|string|false|none||none|

<h2 id="tocS_dto.ImageSave">dto.ImageSave</h2>

<a id="schemadto.imagesave"></a>
<a id="schema_dto.ImageSave"></a>
<a id="tocSdto.imagesave"></a>
<a id="tocsdto.imagesave"></a>

```json
{
  "name": "string",
  "path": "string",
  "tagName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|
|path|string|true|none||none|
|tagName|string|true|none||none|

<h2 id="tocS_dto.ImageTag">dto.ImageTag</h2>

<a id="schemadto.imagetag"></a>
<a id="schema_dto.ImageTag"></a>
<a id="tocSdto.imagetag"></a>
<a id="tocsdto.imagetag"></a>

```json
{
  "sourceID": "string",
  "targetName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|sourceID|string|true|none||none|
|targetName|string|true|none||none|

<h2 id="tocS_dto.InspectReq">dto.InspectReq</h2>

<a id="schemadto.inspectreq"></a>
<a id="schema_dto.InspectReq"></a>
<a id="tocSdto.inspectreq"></a>
<a id="tocsdto.inspectreq"></a>

```json
{
  "id": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|string|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.Locale">dto.Locale</h2>

<a id="schemadto.locale"></a>
<a id="schema_dto.Locale"></a>
<a id="tocSdto.locale"></a>
<a id="tocsdto.locale"></a>

```json
{
  "en": "string",
  "ja": "string",
  "ms": "string",
  "pt-br": "string",
  "ru": "string",
  "zh": "string",
  "zh-hant": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|en|string|false|none||none|
|ja|string|false|none||none|
|ms|string|false|none||none|
|pt-br|string|false|none||none|
|ru|string|false|none||none|
|zh|string|false|none||none|
|zh-hant|string|false|none||none|

<h2 id="tocS_dto.LogOption">dto.LogOption</h2>

<a id="schemadto.logoption"></a>
<a id="schema_dto.LogOption"></a>
<a id="tocSdto.logoption"></a>
<a id="tocsdto.logoption"></a>

```json
{
  "logMaxFile": "string",
  "logMaxSize": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|logMaxFile|string|false|none||none|
|logMaxSize|string|false|none||none|

<h2 id="tocS_dto.MonitorData">dto.MonitorData</h2>

<a id="schemadto.monitordata"></a>
<a id="schema_dto.MonitorData"></a>
<a id="tocSdto.monitordata"></a>
<a id="tocsdto.monitordata"></a>

```json
{
  "date": [
    "string"
  ],
  "param": "cpu",
  "value": [
    null
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|date|[string]|false|none||none|
|param|string|true|none||none|
|value|[any]|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|param|cpu|
|param|memory|
|param|load|
|param|io|
|param|network|

<h2 id="tocS_dto.MonitorSearch">dto.MonitorSearch</h2>

<a id="schemadto.monitorsearch"></a>
<a id="schema_dto.MonitorSearch"></a>
<a id="tocSdto.monitorsearch"></a>
<a id="tocsdto.monitorsearch"></a>

```json
{
  "endTime": "string",
  "info": "string",
  "param": "all",
  "startTime": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|endTime|string|false|none||none|
|info|string|false|none||none|
|param|string|true|none||none|
|startTime|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|param|all|
|param|cpu|
|param|memory|
|param|load|
|param|io|
|param|network|

<h2 id="tocS_dto.MonitorSetting">dto.MonitorSetting</h2>

<a id="schemadto.monitorsetting"></a>
<a id="schema_dto.MonitorSetting"></a>
<a id="tocSdto.monitorsetting"></a>
<a id="tocsdto.monitorsetting"></a>

```json
{
  "defaultNetwork": "string",
  "monitorInterval": "string",
  "monitorStatus": "string",
  "monitorStoreDays": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|defaultNetwork|string|false|none||none|
|monitorInterval|string|false|none||none|
|monitorStatus|string|false|none||none|
|monitorStoreDays|string|false|none||none|

<h2 id="tocS_dto.MonitorSettingUpdate">dto.MonitorSettingUpdate</h2>

<a id="schemadto.monitorsettingupdate"></a>
<a id="schema_dto.MonitorSettingUpdate"></a>
<a id="tocSdto.monitorsettingupdate"></a>
<a id="tocsdto.monitorsettingupdate"></a>

```json
{
  "key": "MonitorStatus",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|true|none||none|
|value|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|key|MonitorStatus|
|key|MonitorStoreDays|
|key|MonitorInterval|
|key|DefaultNetwork|

<h2 id="tocS_dto.MysqlDBCreate">dto.MysqlDBCreate</h2>

<a id="schemadto.mysqldbcreate"></a>
<a id="schema_dto.MysqlDBCreate"></a>
<a id="tocSdto.mysqldbcreate"></a>
<a id="tocsdto.mysqldbcreate"></a>

```json
{
  "database": "string",
  "description": "string",
  "format": "utf8mb4",
  "from": "local",
  "name": "string",
  "password": "string",
  "permission": "string",
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|description|string|false|none||none|
|format|string|true|none||none|
|from|string|true|none||none|
|name|string|true|none||none|
|password|string|true|none||none|
|permission|string|true|none||none|
|username|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|format|utf8mb4|
|format|utf8|
|format|gbk|
|format|big5|
|from|local|
|from|remote|

<h2 id="tocS_dto.MysqlDBDelete">dto.MysqlDBDelete</h2>

<a id="schemadto.mysqldbdelete"></a>
<a id="schema_dto.MysqlDBDelete"></a>
<a id="tocSdto.mysqldbdelete"></a>
<a id="tocsdto.mysqldbdelete"></a>

```json
{
  "database": "string",
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0,
  "type": "mysql"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|deleteBackup|boolean|false|none||none|
|forceDelete|boolean|false|none||none|
|id|integer|true|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|mysql|
|type|mariadb|

<h2 id="tocS_dto.MysqlDBDeleteCheck">dto.MysqlDBDeleteCheck</h2>

<a id="schemadto.mysqldbdeletecheck"></a>
<a id="schema_dto.MysqlDBDeleteCheck"></a>
<a id="tocSdto.mysqldbdeletecheck"></a>
<a id="tocsdto.mysqldbdeletecheck"></a>

```json
{
  "database": "string",
  "id": 0,
  "type": "mysql"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|id|integer|true|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|mysql|
|type|mariadb|

<h2 id="tocS_dto.MysqlDBSearch">dto.MysqlDBSearch</h2>

<a id="schemadto.mysqldbsearch"></a>
<a id="schema_dto.MysqlDBSearch"></a>
<a id="tocSdto.mysqldbsearch"></a>
<a id="tocsdto.mysqldbsearch"></a>

```json
{
  "database": "string",
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|info|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|name|
|orderBy|createdAt|

<h2 id="tocS_dto.MysqlLoadDB">dto.MysqlLoadDB</h2>

<a id="schemadto.mysqlloaddb"></a>
<a id="schema_dto.MysqlLoadDB"></a>
<a id="tocSdto.mysqlloaddb"></a>
<a id="tocsdto.mysqlloaddb"></a>

```json
{
  "database": "string",
  "from": "local",
  "type": "mysql"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|from|string|true|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|from|local|
|from|remote|
|type|mysql|
|type|mariadb|

<h2 id="tocS_dto.MysqlOption">dto.MysqlOption</h2>

<a id="schemadto.mysqloption"></a>
<a id="schema_dto.MysqlOption"></a>
<a id="tocSdto.mysqloption"></a>
<a id="tocsdto.mysqloption"></a>

```json
{
  "database": "string",
  "from": "string",
  "id": 0,
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|false|none||none|
|from|string|false|none||none|
|id|integer|false|none||none|
|name|string|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_dto.MysqlStatus">dto.MysqlStatus</h2>

<a id="schemadto.mysqlstatus"></a>
<a id="schema_dto.MysqlStatus"></a>
<a id="tocSdto.mysqlstatus"></a>
<a id="tocsdto.mysqlstatus"></a>

```json
{
  "Aborted_clients": "string",
  "Aborted_connects": "string",
  "Bytes_received": "string",
  "Bytes_sent": "string",
  "Com_commit": "string",
  "Com_rollback": "string",
  "Connections": "string",
  "Created_tmp_disk_tables": "string",
  "Created_tmp_tables": "string",
  "File": "string",
  "Innodb_buffer_pool_pages_dirty": "string",
  "Innodb_buffer_pool_read_requests": "string",
  "Innodb_buffer_pool_reads": "string",
  "Key_read_requests": "string",
  "Key_reads": "string",
  "Key_write_requests": "string",
  "Key_writes": "string",
  "Max_used_connections": "string",
  "Open_tables": "string",
  "Opened_files": "string",
  "Opened_tables": "string",
  "Position": "string",
  "Qcache_hits": "string",
  "Qcache_inserts": "string",
  "Questions": "string",
  "Run": "string",
  "Select_full_join": "string",
  "Select_range_check": "string",
  "Sort_merge_passes": "string",
  "Table_locks_waited": "string",
  "Threads_cached": "string",
  "Threads_connected": "string",
  "Threads_created": "string",
  "Threads_running": "string",
  "Uptime": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|Aborted_clients|string|false|none||none|
|Aborted_connects|string|false|none||none|
|Bytes_received|string|false|none||none|
|Bytes_sent|string|false|none||none|
|Com_commit|string|false|none||none|
|Com_rollback|string|false|none||none|
|Connections|string|false|none||none|
|Created_tmp_disk_tables|string|false|none||none|
|Created_tmp_tables|string|false|none||none|
|File|string|false|none||none|
|Innodb_buffer_pool_pages_dirty|string|false|none||none|
|Innodb_buffer_pool_read_requests|string|false|none||none|
|Innodb_buffer_pool_reads|string|false|none||none|
|Key_read_requests|string|false|none||none|
|Key_reads|string|false|none||none|
|Key_write_requests|string|false|none||none|
|Key_writes|string|false|none||none|
|Max_used_connections|string|false|none||none|
|Open_tables|string|false|none||none|
|Opened_files|string|false|none||none|
|Opened_tables|string|false|none||none|
|Position|string|false|none||none|
|Qcache_hits|string|false|none||none|
|Qcache_inserts|string|false|none||none|
|Questions|string|false|none||none|
|Run|string|false|none||none|
|Select_full_join|string|false|none||none|
|Select_range_check|string|false|none||none|
|Sort_merge_passes|string|false|none||none|
|Table_locks_waited|string|false|none||none|
|Threads_cached|string|false|none||none|
|Threads_connected|string|false|none||none|
|Threads_created|string|false|none||none|
|Threads_running|string|false|none||none|
|Uptime|string|false|none||none|

<h2 id="tocS_dto.MysqlVariables">dto.MysqlVariables</h2>

<a id="schemadto.mysqlvariables"></a>
<a id="schema_dto.MysqlVariables"></a>
<a id="tocSdto.mysqlvariables"></a>
<a id="tocsdto.mysqlvariables"></a>

```json
{
  "binlog_cache_size": "string",
  "innodb_buffer_pool_size": "string",
  "innodb_log_buffer_size": "string",
  "join_buffer_size": "string",
  "key_buffer_size": "string",
  "long_query_time": "string",
  "max_connections": "string",
  "max_heap_table_size": "string",
  "query_cache_size": "string",
  "query_cache_type": "string",
  "read_buffer_size": "string",
  "read_rnd_buffer_size": "string",
  "slow_query_log": "string",
  "sort_buffer_size": "string",
  "table_open_cache": "string",
  "thread_cache_size": "string",
  "thread_stack": "string",
  "tmp_table_size": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|binlog_cache_size|string|false|none||none|
|innodb_buffer_pool_size|string|false|none||none|
|innodb_log_buffer_size|string|false|none||none|
|join_buffer_size|string|false|none||none|
|key_buffer_size|string|false|none||none|
|long_query_time|string|false|none||none|
|max_connections|string|false|none||none|
|max_heap_table_size|string|false|none||none|
|query_cache_size|string|false|none||none|
|query_cache_type|string|false|none||none|
|read_buffer_size|string|false|none||none|
|read_rnd_buffer_size|string|false|none||none|
|slow_query_log|string|false|none||none|
|sort_buffer_size|string|false|none||none|
|table_open_cache|string|false|none||none|
|thread_cache_size|string|false|none||none|
|thread_stack|string|false|none||none|
|tmp_table_size|string|false|none||none|

<h2 id="tocS_dto.MysqlVariablesUpdate">dto.MysqlVariablesUpdate</h2>

<a id="schemadto.mysqlvariablesupdate"></a>
<a id="schema_dto.MysqlVariablesUpdate"></a>
<a id="tocSdto.mysqlvariablesupdate"></a>
<a id="tocsdto.mysqlvariablesupdate"></a>

```json
{
  "database": "string",
  "type": "mysql",
  "variables": [
    {
      "param": "string",
      "value": null
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|type|string|true|none||none|
|variables|[[dto.MysqlVariablesUpdateHelper](#schemadto.mysqlvariablesupdatehelper)]|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|mysql|
|type|mariadb|

<h2 id="tocS_dto.MysqlVariablesUpdateHelper">dto.MysqlVariablesUpdateHelper</h2>

<a id="schemadto.mysqlvariablesupdatehelper"></a>
<a id="schema_dto.MysqlVariablesUpdateHelper"></a>
<a id="tocSdto.mysqlvariablesupdatehelper"></a>
<a id="tocsdto.mysqlvariablesupdatehelper"></a>

```json
{
  "param": "string",
  "value": null
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|param|string|false|none||none|
|value|any|false|none||none|

<h2 id="tocS_dto.NetworkCreate">dto.NetworkCreate</h2>

<a id="schemadto.networkcreate"></a>
<a id="schema_dto.NetworkCreate"></a>
<a id="tocSdto.networkcreate"></a>
<a id="tocsdto.networkcreate"></a>

```json
{
  "auxAddress": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "auxAddressV6": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "driver": "string",
  "gateway": "string",
  "gatewayV6": "string",
  "ipRange": "string",
  "ipRangeV6": "string",
  "ipv4": true,
  "ipv6": true,
  "labels": [
    "string"
  ],
  "name": "string",
  "options": [
    "string"
  ],
  "subnet": "string",
  "subnetV6": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|auxAddress|[[dto.SettingUpdate](#schemadto.settingupdate)]|false|none||none|
|auxAddressV6|[[dto.SettingUpdate](#schemadto.settingupdate)]|false|none||none|
|driver|string|true|none||none|
|gateway|string|false|none||none|
|gatewayV6|string|false|none||none|
|ipRange|string|false|none||none|
|ipRangeV6|string|false|none||none|
|ipv4|boolean|false|none||none|
|ipv6|boolean|false|none||none|
|labels|[string]|false|none||none|
|name|string|true|none||none|
|options|[string]|false|none||none|
|subnet|string|false|none||none|
|subnetV6|string|false|none||none|

<h2 id="tocS_dto.NginxAuth">dto.NginxAuth</h2>

<a id="schemadto.nginxauth"></a>
<a id="schema_dto.NginxAuth"></a>
<a id="tocSdto.nginxauth"></a>
<a id="tocsdto.nginxauth"></a>

```json
{
  "remark": "string",
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|remark|string|false|none||none|
|username|string|false|none||none|

<h2 id="tocS_dto.NginxKey">dto.NginxKey</h2>

<a id="schemadto.nginxkey"></a>
<a id="schema_dto.NginxKey"></a>
<a id="tocSdto.nginxkey"></a>
<a id="tocsdto.nginxkey"></a>

```json
"index"

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|*anonymous*|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|*anonymous*|index|
|*anonymous*|limit-conn|
|*anonymous*|ssl|
|*anonymous*|cache|
|*anonymous*|http-per|
|*anonymous*|proxy-cache|

<h2 id="tocS_dto.NginxUpstream">dto.NginxUpstream</h2>

<a id="schemadto.nginxupstream"></a>
<a id="schema_dto.NginxUpstream"></a>
<a id="tocSdto.nginxupstream"></a>
<a id="tocsdto.nginxupstream"></a>

```json
{
  "algorithm": "string",
  "content": "string",
  "name": "string",
  "servers": [
    {
      "failTimeout": "string",
      "flag": "string",
      "maxConns": 0,
      "maxFails": 0,
      "server": "string",
      "weight": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|algorithm|string|false|none||none|
|content|string|false|none||none|
|name|string|false|none||none|
|servers|[[dto.NginxUpstreamServer](#schemadto.nginxupstreamserver)]|false|none||none|

<h2 id="tocS_dto.NginxUpstreamServer">dto.NginxUpstreamServer</h2>

<a id="schemadto.nginxupstreamserver"></a>
<a id="schema_dto.NginxUpstreamServer"></a>
<a id="tocSdto.nginxupstreamserver"></a>
<a id="tocsdto.nginxupstreamserver"></a>

```json
{
  "failTimeout": "string",
  "flag": "string",
  "maxConns": 0,
  "maxFails": 0,
  "server": "string",
  "weight": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|failTimeout|string|false|none||none|
|flag|string|false|none||none|
|maxConns|integer|false|none||none|
|maxFails|integer|false|none||none|
|server|string|false|none||none|
|weight|integer|false|none||none|

<h2 id="tocS_dto.NodeCurrent">dto.NodeCurrent</h2>

<a id="schemadto.nodecurrent"></a>
<a id="schema_dto.NodeCurrent"></a>
<a id="tocSdto.nodecurrent"></a>
<a id="tocsdto.nodecurrent"></a>

```json
{
  "cpuTotal": 0,
  "cpuUsed": 0,
  "cpuUsedPercent": 0,
  "load1": 0,
  "load15": 0,
  "load5": 0,
  "loadUsagePercent": 0,
  "memoryAvailable": 0,
  "memoryTotal": 0,
  "memoryUsed": 0,
  "memoryUsedPercent": 0,
  "swapMemoryAvailable": 0,
  "swapMemoryTotal": 0,
  "swapMemoryUsed": 0,
  "swapMemoryUsedPercent": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cpuTotal|integer|false|none||none|
|cpuUsed|number|false|none||none|
|cpuUsedPercent|number|false|none||none|
|load1|number|false|none||none|
|load15|number|false|none||none|
|load5|number|false|none||none|
|loadUsagePercent|number|false|none||none|
|memoryAvailable|integer|false|none||none|
|memoryTotal|integer|false|none||none|
|memoryUsed|integer|false|none||none|
|memoryUsedPercent|number|false|none||none|
|swapMemoryAvailable|integer|false|none||none|
|swapMemoryTotal|integer|false|none||none|
|swapMemoryUsed|integer|false|none||none|
|swapMemoryUsedPercent|number|false|none||none|

<h2 id="tocS_dto.OllamaBindDomain">dto.OllamaBindDomain</h2>

<a id="schemadto.ollamabinddomain"></a>
<a id="schema_dto.OllamaBindDomain"></a>
<a id="tocSdto.ollamabinddomain"></a>
<a id="tocsdto.ollamabinddomain"></a>

```json
{
  "appInstallID": 0,
  "domain": "string",
  "ipList": "string",
  "sslID": 0,
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appInstallID|integer|true|none||none|
|domain|string|true|none||none|
|ipList|string|false|none||none|
|sslID|integer|false|none||none|
|websiteID|integer|false|none||none|

<h2 id="tocS_dto.OllamaBindDomainReq">dto.OllamaBindDomainReq</h2>

<a id="schemadto.ollamabinddomainreq"></a>
<a id="schema_dto.OllamaBindDomainReq"></a>
<a id="tocSdto.ollamabinddomainreq"></a>
<a id="tocsdto.ollamabinddomainreq"></a>

```json
{
  "appInstallID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appInstallID|integer|true|none||none|

<h2 id="tocS_dto.OllamaBindDomainRes">dto.OllamaBindDomainRes</h2>

<a id="schemadto.ollamabinddomainres"></a>
<a id="schema_dto.OllamaBindDomainRes"></a>
<a id="tocSdto.ollamabinddomainres"></a>
<a id="tocsdto.ollamabinddomainres"></a>

```json
{
  "acmeAccountID": 0,
  "allowIPs": [
    "string"
  ],
  "connUrl": "string",
  "domain": "string",
  "sslID": 0,
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|acmeAccountID|integer|false|none||none|
|allowIPs|[string]|false|none||none|
|connUrl|string|false|none||none|
|domain|string|false|none||none|
|sslID|integer|false|none||none|
|websiteID|integer|false|none||none|

<h2 id="tocS_dto.OllamaModelDropList">dto.OllamaModelDropList</h2>

<a id="schemadto.ollamamodeldroplist"></a>
<a id="schema_dto.OllamaModelDropList"></a>
<a id="tocSdto.ollamamodeldroplist"></a>
<a id="tocsdto.ollamamodeldroplist"></a>

```json
{
  "id": 0,
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_dto.OllamaModelName">dto.OllamaModelName</h2>

<a id="schemadto.ollamamodelname"></a>
<a id="schema_dto.OllamaModelName"></a>
<a id="tocSdto.ollamamodelname"></a>
<a id="tocsdto.ollamamodelname"></a>

```json
{
  "name": "string",
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_dto.Operate">dto.Operate</h2>

<a id="schemadto.operate"></a>
<a id="schema_dto.Operate"></a>
<a id="tocSdto.operate"></a>
<a id="tocsdto.operate"></a>

```json
{
  "operation": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|operation|string|true|none||none|

<h2 id="tocS_dto.OperateByID">dto.OperateByID</h2>

<a id="schemadto.operatebyid"></a>
<a id="schema_dto.OperateByID"></a>
<a id="tocSdto.operatebyid"></a>
<a id="tocsdto.operatebyid"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|

<h2 id="tocS_dto.OperateByType">dto.OperateByType</h2>

<a id="schemadto.operatebytype"></a>
<a id="schema_dto.OperateByType"></a>
<a id="tocSdto.operatebytype"></a>
<a id="tocsdto.operatebytype"></a>

```json
{
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|type|string|false|none||none|

<h2 id="tocS_dto.OperationWithName">dto.OperationWithName</h2>

<a id="schemadto.operationwithname"></a>
<a id="schema_dto.OperationWithName"></a>
<a id="tocSdto.operationwithname"></a>
<a id="tocsdto.operationwithname"></a>

```json
{
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|

<h2 id="tocS_dto.OperationWithNameAndType">dto.OperationWithNameAndType</h2>

<a id="schemadto.operationwithnameandtype"></a>
<a id="schema_dto.OperationWithNameAndType"></a>
<a id="tocSdto.operationwithnameandtype"></a>
<a id="tocsdto.operationwithnameandtype"></a>

```json
{
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.Options">dto.Options</h2>

<a id="schemadto.options"></a>
<a id="schema_dto.Options"></a>
<a id="tocSdto.options"></a>
<a id="tocsdto.options"></a>

```json
{
  "option": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|option|string|false|none||none|

<h2 id="tocS_dto.OsInfo">dto.OsInfo</h2>

<a id="schemadto.osinfo"></a>
<a id="schema_dto.OsInfo"></a>
<a id="tocSdto.osinfo"></a>
<a id="tocsdto.osinfo"></a>

```json
{
  "diskSize": 0,
  "kernelArch": "string",
  "kernelVersion": "string",
  "os": "string",
  "platform": "string",
  "platformFamily": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|diskSize|integer|false|none||none|
|kernelArch|string|false|none||none|
|kernelVersion|string|false|none||none|
|os|string|false|none||none|
|platform|string|false|none||none|
|platformFamily|string|false|none||none|

<h2 id="tocS_dto.PageContainer">dto.PageContainer</h2>

<a id="schemadto.pagecontainer"></a>
<a id="schema_dto.PageContainer"></a>
<a id="tocSdto.pagecontainer"></a>
<a id="tocsdto.pagecontainer"></a>

```json
{
  "excludeAppStore": true,
  "filters": "string",
  "name": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0,
  "state": "all"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|excludeAppStore|boolean|false|none||none|
|filters|string|false|none||none|
|name|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|state|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|name|
|orderBy|createdAt|
|orderBy|state|
|state|all|
|state|created|
|state|running|
|state|paused|
|state|restarting|
|state|removing|
|state|exited|
|state|dead|

<h2 id="tocS_dto.PageCronjob">dto.PageCronjob</h2>

<a id="schemadto.pagecronjob"></a>
<a id="schema_dto.PageCronjob"></a>
<a id="tocSdto.pagecronjob"></a>
<a id="tocsdto.pagecronjob"></a>

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|info|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|name|
|orderBy|status|
|orderBy|createdAt|

<h2 id="tocS_dto.PageInfo">dto.PageInfo</h2>

<a id="schemadto.pageinfo"></a>
<a id="schema_dto.PageInfo"></a>
<a id="tocSdto.pageinfo"></a>
<a id="tocsdto.pageinfo"></a>

```json
{
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

<h2 id="tocS_dto.PageResult">dto.PageResult</h2>

<a id="schemadto.pageresult"></a>
<a id="schema_dto.PageResult"></a>
<a id="tocSdto.pageresult"></a>
<a id="tocsdto.pageresult"></a>

```json
{
  "items": null,
  "total": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|items|any|false|none||none|
|total|integer|false|none||none|

<h2 id="tocS_dto.PageSnapshot">dto.PageSnapshot</h2>

<a id="schemadto.pagesnapshot"></a>
<a id="schema_dto.PageSnapshot"></a>
<a id="tocSdto.pagesnapshot"></a>
<a id="tocsdto.pagesnapshot"></a>

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|info|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|name|
|orderBy|createdAt|

<h2 id="tocS_dto.PortHelper">dto.PortHelper</h2>

<a id="schemadto.porthelper"></a>
<a id="schema_dto.PortHelper"></a>
<a id="tocSdto.porthelper"></a>
<a id="tocsdto.porthelper"></a>

```json
{
  "containerPort": "string",
  "hostIP": "string",
  "hostPort": "string",
  "protocol": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerPort|string|false|none||none|
|hostIP|string|false|none||none|
|hostPort|string|false|none||none|
|protocol|string|false|none||none|

<h2 id="tocS_dto.PortRuleOperate">dto.PortRuleOperate</h2>

<a id="schemadto.portruleoperate"></a>
<a id="schema_dto.PortRuleOperate"></a>
<a id="tocSdto.portruleoperate"></a>
<a id="tocsdto.portruleoperate"></a>

```json
{
  "address": "string",
  "description": "string",
  "operation": "add",
  "port": "string",
  "protocol": "tcp",
  "strategy": "accept"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|false|none||none|
|description|string|false|none||none|
|operation|string|true|none||none|
|port|string|true|none||none|
|protocol|string|true|none||none|
|strategy|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operation|add|
|operation|remove|
|protocol|tcp|
|protocol|udp|
|protocol|tcp/udp|
|strategy|accept|
|strategy|drop|

<h2 id="tocS_dto.PortRuleUpdate">dto.PortRuleUpdate</h2>

<a id="schemadto.portruleupdate"></a>
<a id="schema_dto.PortRuleUpdate"></a>
<a id="tocSdto.portruleupdate"></a>
<a id="tocsdto.portruleupdate"></a>

```json
{
  "newRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "port": "string",
    "protocol": "tcp",
    "strategy": "accept"
  },
  "oldRule": {
    "address": "string",
    "description": "string",
    "operation": "add",
    "port": "string",
    "protocol": "tcp",
    "strategy": "accept"
  }
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|newRule|[dto.PortRuleOperate](#schemadto.portruleoperate)|false|none||none|
|oldRule|[dto.PortRuleOperate](#schemadto.portruleoperate)|false|none||none|

<h2 id="tocS_dto.PostgresqlBindUser">dto.PostgresqlBindUser</h2>

<a id="schemadto.postgresqlbinduser"></a>
<a id="schema_dto.PostgresqlBindUser"></a>
<a id="tocSdto.postgresqlbinduser"></a>
<a id="tocsdto.postgresqlbinduser"></a>

```json
{
  "database": "string",
  "name": "string",
  "password": "string",
  "superUser": true,
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|name|string|true|none||none|
|password|string|true|none||none|
|superUser|boolean|false|none||none|
|username|string|true|none||none|

<h2 id="tocS_dto.PostgresqlDBCreate">dto.PostgresqlDBCreate</h2>

<a id="schemadto.postgresqldbcreate"></a>
<a id="schema_dto.PostgresqlDBCreate"></a>
<a id="tocSdto.postgresqldbcreate"></a>
<a id="tocsdto.postgresqldbcreate"></a>

```json
{
  "database": "string",
  "description": "string",
  "format": "string",
  "from": "local",
  "name": "string",
  "password": "string",
  "superUser": true,
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|description|string|false|none||none|
|format|string|false|none||none|
|from|string|true|none||none|
|name|string|true|none||none|
|password|string|true|none||none|
|superUser|boolean|false|none||none|
|username|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|from|local|
|from|remote|

<h2 id="tocS_dto.PostgresqlDBDelete">dto.PostgresqlDBDelete</h2>

<a id="schemadto.postgresqldbdelete"></a>
<a id="schema_dto.PostgresqlDBDelete"></a>
<a id="tocSdto.postgresqldbdelete"></a>
<a id="tocsdto.postgresqldbdelete"></a>

```json
{
  "database": "string",
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0,
  "type": "postgresql"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|deleteBackup|boolean|false|none||none|
|forceDelete|boolean|false|none||none|
|id|integer|true|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|postgresql|

<h2 id="tocS_dto.PostgresqlDBDeleteCheck">dto.PostgresqlDBDeleteCheck</h2>

<a id="schemadto.postgresqldbdeletecheck"></a>
<a id="schema_dto.PostgresqlDBDeleteCheck"></a>
<a id="tocSdto.postgresqldbdeletecheck"></a>
<a id="tocsdto.postgresqldbdeletecheck"></a>

```json
{
  "database": "string",
  "id": 0,
  "type": "postgresql"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|id|integer|true|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|postgresql|

<h2 id="tocS_dto.PostgresqlDBSearch">dto.PostgresqlDBSearch</h2>

<a id="schemadto.postgresqldbsearch"></a>
<a id="schema_dto.PostgresqlDBSearch"></a>
<a id="tocSdto.postgresqldbsearch"></a>
<a id="tocsdto.postgresqldbsearch"></a>

```json
{
  "database": "string",
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|info|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|name|
|orderBy|createdAt|

<h2 id="tocS_dto.PostgresqlLoadDB">dto.PostgresqlLoadDB</h2>

<a id="schemadto.postgresqlloaddb"></a>
<a id="schema_dto.PostgresqlLoadDB"></a>
<a id="tocSdto.postgresqlloaddb"></a>
<a id="tocsdto.postgresqlloaddb"></a>

```json
{
  "database": "string",
  "from": "local",
  "type": "postgresql"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|from|string|true|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|from|local|
|from|remote|
|type|postgresql|

<h2 id="tocS_dto.RecordFileSize">dto.RecordFileSize</h2>

<a id="schemadto.recordfilesize"></a>
<a id="schema_dto.RecordFileSize"></a>
<a id="tocSdto.recordfilesize"></a>
<a id="tocsdto.recordfilesize"></a>

```json
{
  "id": 0,
  "name": "string",
  "size": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|name|string|false|none||none|
|size|integer|false|none||none|

<h2 id="tocS_dto.RecordSearch">dto.RecordSearch</h2>

<a id="schemadto.recordsearch"></a>
<a id="schema_dto.RecordSearch"></a>
<a id="tocSdto.recordsearch"></a>
<a id="tocsdto.recordsearch"></a>

```json
{
  "detailName": "string",
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|detailName|string|false|none||none|
|name|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.RecordSearchByCronjob">dto.RecordSearchByCronjob</h2>

<a id="schemadto.recordsearchbycronjob"></a>
<a id="schema_dto.RecordSearchByCronjob"></a>
<a id="tocSdto.recordsearchbycronjob"></a>
<a id="tocsdto.recordsearchbycronjob"></a>

```json
{
  "cronjobID": 0,
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cronjobID|integer|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

<h2 id="tocS_dto.RedisConf">dto.RedisConf</h2>

<a id="schemadto.redisconf"></a>
<a id="schema_dto.RedisConf"></a>
<a id="tocSdto.redisconf"></a>
<a id="tocsdto.redisconf"></a>

```json
{
  "containerName": "string",
  "database": "string",
  "maxclients": "string",
  "maxmemory": "string",
  "name": "string",
  "port": 0,
  "requirepass": "string",
  "timeout": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerName|string|false|none||none|
|database|string|true|none||none|
|maxclients|string|false|none||none|
|maxmemory|string|false|none||none|
|name|string|false|none||none|
|port|integer|false|none||none|
|requirepass|string|false|none||none|
|timeout|string|false|none||none|

<h2 id="tocS_dto.RedisConfPersistenceUpdate">dto.RedisConfPersistenceUpdate</h2>

<a id="schemadto.redisconfpersistenceupdate"></a>
<a id="schema_dto.RedisConfPersistenceUpdate"></a>
<a id="tocSdto.redisconfpersistenceupdate"></a>
<a id="tocsdto.redisconfpersistenceupdate"></a>

```json
{
  "appendfsync": "string",
  "appendonly": "string",
  "database": "string",
  "save": "string",
  "type": "aof"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appendfsync|string|false|none||none|
|appendonly|string|false|none||none|
|database|string|true|none||none|
|save|string|false|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|aof|
|type|rbd|

<h2 id="tocS_dto.RedisConfUpdate">dto.RedisConfUpdate</h2>

<a id="schemadto.redisconfupdate"></a>
<a id="schema_dto.RedisConfUpdate"></a>
<a id="tocSdto.redisconfupdate"></a>
<a id="tocsdto.redisconfupdate"></a>

```json
{
  "database": "string",
  "maxclients": "string",
  "maxmemory": "string",
  "timeout": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|database|string|true|none||none|
|maxclients|string|false|none||none|
|maxmemory|string|false|none||none|
|timeout|string|false|none||none|

<h2 id="tocS_dto.RedisPersistence">dto.RedisPersistence</h2>

<a id="schemadto.redispersistence"></a>
<a id="schema_dto.RedisPersistence"></a>
<a id="tocSdto.redispersistence"></a>
<a id="tocsdto.redispersistence"></a>

```json
{
  "appendfsync": "string",
  "appendonly": "string",
  "database": "string",
  "save": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appendfsync|string|false|none||none|
|appendonly|string|false|none||none|
|database|string|true|none||none|
|save|string|false|none||none|

<h2 id="tocS_dto.RedisStatus">dto.RedisStatus</h2>

<a id="schemadto.redisstatus"></a>
<a id="schema_dto.RedisStatus"></a>
<a id="tocSdto.redisstatus"></a>
<a id="tocsdto.redisstatus"></a>

```json
{
  "connected_clients": "string",
  "database": "string",
  "instantaneous_ops_per_sec": "string",
  "keyspace_hits": "string",
  "keyspace_misses": "string",
  "latest_fork_usec": "string",
  "mem_fragmentation_ratio": "string",
  "tcp_port": "string",
  "total_commands_processed": "string",
  "total_connections_received": "string",
  "uptime_in_days": "string",
  "used_memory": "string",
  "used_memory_peak": "string",
  "used_memory_rss": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|connected_clients|string|false|none||none|
|database|string|true|none||none|
|instantaneous_ops_per_sec|string|false|none||none|
|keyspace_hits|string|false|none||none|
|keyspace_misses|string|false|none||none|
|latest_fork_usec|string|false|none||none|
|mem_fragmentation_ratio|string|false|none||none|
|tcp_port|string|false|none||none|
|total_commands_processed|string|false|none||none|
|total_connections_received|string|false|none||none|
|uptime_in_days|string|false|none||none|
|used_memory|string|false|none||none|
|used_memory_peak|string|false|none||none|
|used_memory_rss|string|false|none||none|

<h2 id="tocS_dto.ResourceLimit">dto.ResourceLimit</h2>

<a id="schemadto.resourcelimit"></a>
<a id="schema_dto.ResourceLimit"></a>
<a id="tocSdto.resourcelimit"></a>
<a id="tocsdto.resourcelimit"></a>

```json
{
  "cpu": 0,
  "memory": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cpu|integer|false|none||none|
|memory|integer|false|none||none|

<h2 id="tocS_dto.RuleSearch">dto.RuleSearch</h2>

<a id="schemadto.rulesearch"></a>
<a id="schema_dto.RuleSearch"></a>
<a id="tocSdto.rulesearch"></a>
<a id="tocsdto.rulesearch"></a>

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0,
  "status": "string",
  "strategy": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|info|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|status|string|false|none||none|
|strategy|string|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.SSHConf">dto.SSHConf</h2>

<a id="schemadto.sshconf"></a>
<a id="schema_dto.SSHConf"></a>
<a id="tocSdto.sshconf"></a>
<a id="tocsdto.sshconf"></a>

```json
{
  "file": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|file|string|false|none||none|

<h2 id="tocS_dto.SSHHistory">dto.SSHHistory</h2>

<a id="schemadto.sshhistory"></a>
<a id="schema_dto.SSHHistory"></a>
<a id="tocSdto.sshhistory"></a>
<a id="tocsdto.sshhistory"></a>

```json
{
  "address": "string",
  "area": "string",
  "authMode": "string",
  "date": "string",
  "dateStr": "string",
  "message": "string",
  "port": "string",
  "status": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|false|none||none|
|area|string|false|none||none|
|authMode|string|false|none||none|
|date|string|false|none||none|
|dateStr|string|false|none||none|
|message|string|false|none||none|
|port|string|false|none||none|
|status|string|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_dto.SSHInfo">dto.SSHInfo</h2>

<a id="schemadto.sshinfo"></a>
<a id="schema_dto.SSHInfo"></a>
<a id="tocSdto.sshinfo"></a>
<a id="tocsdto.sshinfo"></a>

```json
{
  "autoStart": true,
  "isActive": true,
  "isExist": true,
  "listenAddress": "string",
  "message": "string",
  "passwordAuthentication": "string",
  "permitRootLogin": "string",
  "port": "string",
  "pubkeyAuthentication": "string",
  "useDNS": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|autoStart|boolean|false|none||none|
|isActive|boolean|false|none||none|
|isExist|boolean|false|none||none|
|listenAddress|string|false|none||none|
|message|string|false|none||none|
|passwordAuthentication|string|false|none||none|
|permitRootLogin|string|false|none||none|
|port|string|false|none||none|
|pubkeyAuthentication|string|false|none||none|
|useDNS|string|false|none||none|

<h2 id="tocS_dto.SSHLog">dto.SSHLog</h2>

<a id="schemadto.sshlog"></a>
<a id="schema_dto.SSHLog"></a>
<a id="tocSdto.sshlog"></a>
<a id="tocsdto.sshlog"></a>

```json
{
  "failedCount": 0,
  "logs": [
    {
      "address": "string",
      "area": "string",
      "authMode": "string",
      "date": "string",
      "dateStr": "string",
      "message": "string",
      "port": "string",
      "status": "string",
      "user": "string"
    }
  ],
  "successfulCount": 0,
  "totalCount": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|failedCount|integer|false|none||none|
|logs|[[dto.SSHHistory](#schemadto.sshhistory)]|false|none||none|
|successfulCount|integer|false|none||none|
|totalCount|integer|false|none||none|

<h2 id="tocS_dto.SSHUpdate">dto.SSHUpdate</h2>

<a id="schemadto.sshupdate"></a>
<a id="schema_dto.SSHUpdate"></a>
<a id="tocSdto.sshupdate"></a>
<a id="tocsdto.sshupdate"></a>

```json
{
  "key": "string",
  "newValue": "string",
  "oldValue": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|true|none||none|
|newValue|string|false|none||none|
|oldValue|string|false|none||none|

<h2 id="tocS_dto.SearchByFilter">dto.SearchByFilter</h2>

<a id="schemadto.searchbyfilter"></a>
<a id="schema_dto.SearchByFilter"></a>
<a id="tocSdto.searchbyfilter"></a>
<a id="tocsdto.searchbyfilter"></a>

```json
{
  "filter": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|filter|string|false|none||none|

<h2 id="tocS_dto.SearchClamWithPage">dto.SearchClamWithPage</h2>

<a id="schemadto.searchclamwithpage"></a>
<a id="schema_dto.SearchClamWithPage"></a>
<a id="tocSdto.searchclamwithpage"></a>
<a id="tocsdto.searchclamwithpage"></a>

```json
{
  "info": "string",
  "order": "null",
  "orderBy": "name",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|info|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|name|
|orderBy|status|
|orderBy|createdAt|

<h2 id="tocS_dto.SearchForSize">dto.SearchForSize</h2>

<a id="schemadto.searchforsize"></a>
<a id="schema_dto.SearchForSize"></a>
<a id="tocSdto.searchforsize"></a>
<a id="tocsdto.searchforsize"></a>

```json
{
  "cronjobID": 0,
  "detailName": "string",
  "info": "string",
  "name": "string",
  "order": "string",
  "orderBy": "string",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cronjobID|integer|false|none||none|
|detailName|string|false|none||none|
|info|string|false|none||none|
|name|string|false|none||none|
|order|string|false|none||none|
|orderBy|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_dto.SearchPageWithType">dto.SearchPageWithType</h2>

<a id="schemadto.searchpagewithtype"></a>
<a id="schema_dto.SearchPageWithType"></a>
<a id="tocSdto.searchpagewithtype"></a>
<a id="tocsdto.searchpagewithtype"></a>

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|info|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|type|string|false|none||none|

<h2 id="tocS_dto.SearchRecord">dto.SearchRecord</h2>

<a id="schemadto.searchrecord"></a>
<a id="schema_dto.SearchRecord"></a>
<a id="tocSdto.searchrecord"></a>
<a id="tocsdto.searchrecord"></a>

```json
{
  "cronjobID": 0,
  "endTime": "string",
  "page": 0,
  "pageSize": 0,
  "startTime": "string",
  "status": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cronjobID|integer|false|none||none|
|endTime|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|startTime|string|false|none||none|
|status|string|false|none||none|

<h2 id="tocS_dto.SearchSSHLog">dto.SearchSSHLog</h2>

<a id="schemadto.searchsshlog"></a>
<a id="schema_dto.SearchSSHLog"></a>
<a id="tocSdto.searchsshlog"></a>
<a id="tocsdto.searchsshlog"></a>

```json
{
  "Status": "Success",
  "info": "string",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|Status|string|true|none||none|
|info|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|Status|Success|
|Status|Failed|
|Status|All|

<h2 id="tocS_dto.SearchTaskLogReq">dto.SearchTaskLogReq</h2>

<a id="schemadto.searchtasklogreq"></a>
<a id="schema_dto.SearchTaskLogReq"></a>
<a id="tocSdto.searchtasklogreq"></a>
<a id="tocsdto.searchtasklogreq"></a>

```json
{
  "page": 0,
  "pageSize": 0,
  "status": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|status|string|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_dto.SearchWithPage">dto.SearchWithPage</h2>

<a id="schemadto.searchwithpage"></a>
<a id="schema_dto.SearchWithPage"></a>
<a id="tocSdto.searchwithpage"></a>
<a id="tocsdto.searchwithpage"></a>

```json
{
  "info": "string",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|info|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

<h2 id="tocS_dto.SettingInfo">dto.SettingInfo</h2>

<a id="schemadto.settinginfo"></a>
<a id="schema_dto.SettingInfo"></a>
<a id="tocSdto.settinginfo"></a>
<a id="tocsdto.settinginfo"></a>

```json
{
  "appStoreLastModified": "string",
  "appStoreSyncStatus": "string",
  "appStoreVersion": "string",
  "defaultNetwork": "string",
  "dockerSockPath": "string",
  "fileRecycleBin": "string",
  "lastCleanData": "string",
  "lastCleanSize": "string",
  "lastCleanTime": "string",
  "localTime": "string",
  "monitorInterval": "string",
  "monitorStatus": "string",
  "monitorStoreDays": "string",
  "ntpSite": "string",
  "snapshotIgnore": "string",
  "systemVersion": "string",
  "timeZone": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appStoreLastModified|string|false|none||none|
|appStoreSyncStatus|string|false|none||none|
|appStoreVersion|string|false|none||none|
|defaultNetwork|string|false|none||none|
|dockerSockPath|string|false|none||none|
|fileRecycleBin|string|false|none||none|
|lastCleanData|string|false|none||none|
|lastCleanSize|string|false|none||none|
|lastCleanTime|string|false|none||none|
|localTime|string|false|none||none|
|monitorInterval|string|false|none||none|
|monitorStatus|string|false|none||none|
|monitorStoreDays|string|false|none||none|
|ntpSite|string|false|none||none|
|snapshotIgnore|string|false|none||none|
|systemVersion|string|false|none||none|
|timeZone|string|false|none||none|

<h2 id="tocS_dto.SettingUpdate">dto.SettingUpdate</h2>

<a id="schemadto.settingupdate"></a>
<a id="schema_dto.SettingUpdate"></a>
<a id="tocSdto.settingupdate"></a>
<a id="tocsdto.settingupdate"></a>

```json
{
  "key": "string",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|true|none||none|
|value|string|false|none||none|

<h2 id="tocS_dto.SnapshotBatchDelete">dto.SnapshotBatchDelete</h2>

<a id="schemadto.snapshotbatchdelete"></a>
<a id="schema_dto.SnapshotBatchDelete"></a>
<a id="tocSdto.snapshotbatchdelete"></a>
<a id="tocsdto.snapshotbatchdelete"></a>

```json
{
  "deleteWithFile": true,
  "ids": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|deleteWithFile|boolean|false|none||none|
|ids|[integer]|true|none||none|

<h2 id="tocS_dto.SnapshotCreate">dto.SnapshotCreate</h2>

<a id="schemadto.snapshotcreate"></a>
<a id="schema_dto.SnapshotCreate"></a>
<a id="tocSdto.snapshotcreate"></a>
<a id="tocsdto.snapshotcreate"></a>

```json
{
  "appData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "backupData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "description": "string",
  "downloadAccountID": 0,
  "id": 0,
  "interruptStep": "string",
  "name": "string",
  "panelData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "secret": "string",
  "sourceAccountIDs": "string",
  "taskID": "string",
  "withLoginLog": true,
  "withMonitorData": true,
  "withOperationLog": true,
  "withSystemLog": true,
  "withTaskLog": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appData|[[dto.DataTree](#schemadto.datatree)]|false|none||none|
|backupData|[[dto.DataTree](#schemadto.datatree)]|false|none||none|
|description|string|false|none||none|
|downloadAccountID|integer|true|none||none|
|id|integer|false|none||none|
|interruptStep|string|false|none||none|
|name|string|false|none||none|
|panelData|[[dto.DataTree](#schemadto.datatree)]|false|none||none|
|secret|string|false|none||none|
|sourceAccountIDs|string|true|none||none|
|taskID|string|false|none||none|
|withLoginLog|boolean|false|none||none|
|withMonitorData|boolean|false|none||none|
|withOperationLog|boolean|false|none||none|
|withSystemLog|boolean|false|none||none|
|withTaskLog|boolean|false|none||none|

<h2 id="tocS_dto.SnapshotData">dto.SnapshotData</h2>

<a id="schemadto.snapshotdata"></a>
<a id="schema_dto.SnapshotData"></a>
<a id="tocSdto.snapshotdata"></a>
<a id="tocsdto.snapshotdata"></a>

```json
{
  "appData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "backupData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "panelData": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "id": "string",
          "isCheck": true,
          "isDisable": true,
          "key": "string",
          "label": "string",
          "name": "string",
          "path": "string",
          "relationItemID": "string",
          "size": 0
        }
      ],
      "id": "string",
      "isCheck": true,
      "isDisable": true,
      "key": "string",
      "label": "string",
      "name": "string",
      "path": "string",
      "relationItemID": "string",
      "size": 0
    }
  ],
  "withLoginLog": true,
  "withMonitorData": true,
  "withOperationLog": true,
  "withSystemLog": true,
  "withTaskLog": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appData|[[dto.DataTree](#schemadto.datatree)]|false|none||none|
|backupData|[[dto.DataTree](#schemadto.datatree)]|false|none||none|
|panelData|[[dto.DataTree](#schemadto.datatree)]|false|none||none|
|withLoginLog|boolean|false|none||none|
|withMonitorData|boolean|false|none||none|
|withOperationLog|boolean|false|none||none|
|withSystemLog|boolean|false|none||none|
|withTaskLog|boolean|false|none||none|

<h2 id="tocS_dto.SnapshotImport">dto.SnapshotImport</h2>

<a id="schemadto.snapshotimport"></a>
<a id="schema_dto.SnapshotImport"></a>
<a id="tocSdto.snapshotimport"></a>
<a id="tocsdto.snapshotimport"></a>

```json
{
  "backupAccountID": 0,
  "description": "string",
  "names": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|backupAccountID|integer|false|none||none|
|description|string|false|none||none|
|names|[string]|false|none||none|

<h2 id="tocS_dto.SnapshotRecover">dto.SnapshotRecover</h2>

<a id="schemadto.snapshotrecover"></a>
<a id="schema_dto.SnapshotRecover"></a>
<a id="tocSdto.snapshotrecover"></a>
<a id="tocsdto.snapshotrecover"></a>

```json
{
  "id": 0,
  "isNew": true,
  "reDownload": true,
  "secret": "string",
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|isNew|boolean|false|none||none|
|reDownload|boolean|false|none||none|
|secret|string|false|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_dto.SwapHelper">dto.SwapHelper</h2>

<a id="schemadto.swaphelper"></a>
<a id="schema_dto.SwapHelper"></a>
<a id="tocSdto.swaphelper"></a>
<a id="tocsdto.swaphelper"></a>

```json
{
  "isNew": true,
  "path": "string",
  "size": 0,
  "used": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|isNew|boolean|false|none||none|
|path|string|true|none||none|
|size|integer|false|none||none|
|used|string|false|none||none|

<h2 id="tocS_dto.Tag">dto.Tag</h2>

<a id="schemadto.tag"></a>
<a id="schema_dto.Tag"></a>
<a id="tocSdto.tag"></a>
<a id="tocsdto.tag"></a>

```json
{
  "key": "string",
  "locales": {
    "en": "string",
    "ja": "string",
    "ms": "string",
    "pt-br": "string",
    "ru": "string",
    "zh": "string",
    "zh-hant": "string"
  },
  "name": "string",
  "sort": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|false|none||none|
|locales|[dto.Locale](#schemadto.locale)|false|none||none|
|name|string|false|none||none|
|sort|integer|false|none||none|

<h2 id="tocS_dto.UpdateByFile">dto.UpdateByFile</h2>

<a id="schemadto.updatebyfile"></a>
<a id="schema_dto.UpdateByFile"></a>
<a id="tocSdto.updatebyfile"></a>
<a id="tocsdto.updatebyfile"></a>

```json
{
  "file": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|file|string|false|none||none|

<h2 id="tocS_dto.UpdateByNameAndFile">dto.UpdateByNameAndFile</h2>

<a id="schemadto.updatebynameandfile"></a>
<a id="schema_dto.UpdateByNameAndFile"></a>
<a id="tocSdto.updatebynameandfile"></a>
<a id="tocsdto.updatebynameandfile"></a>

```json
{
  "file": "string",
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|file|string|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_dto.UpdateDescription">dto.UpdateDescription</h2>

<a id="schemadto.updatedescription"></a>
<a id="schema_dto.UpdateDescription"></a>
<a id="tocSdto.updatedescription"></a>
<a id="tocsdto.updatedescription"></a>

```json
{
  "description": "string",
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|description|string|false|none||none|
|id|integer|true|none||none|

<h2 id="tocS_dto.UpdateFirewallDescription">dto.UpdateFirewallDescription</h2>

<a id="schemadto.updatefirewalldescription"></a>
<a id="schema_dto.UpdateFirewallDescription"></a>
<a id="tocSdto.updatefirewalldescription"></a>
<a id="tocsdto.updatefirewalldescription"></a>

```json
{
  "address": "string",
  "description": "string",
  "port": "string",
  "protocol": "string",
  "strategy": "accept",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|address|string|false|none||none|
|description|string|false|none||none|
|port|string|false|none||none|
|protocol|string|false|none||none|
|strategy|string|true|none||none|
|type|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|strategy|accept|
|strategy|drop|

<h2 id="tocS_dto.VolumeCreate">dto.VolumeCreate</h2>

<a id="schemadto.volumecreate"></a>
<a id="schema_dto.VolumeCreate"></a>
<a id="tocSdto.volumecreate"></a>
<a id="tocsdto.volumecreate"></a>

```json
{
  "driver": "string",
  "labels": [
    "string"
  ],
  "name": "string",
  "options": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|driver|string|true|none||none|
|labels|[string]|false|none||none|
|name|string|true|none||none|
|options|[string]|false|none||none|

<h2 id="tocS_dto.VolumeHelper">dto.VolumeHelper</h2>

<a id="schemadto.volumehelper"></a>
<a id="schema_dto.VolumeHelper"></a>
<a id="tocSdto.volumehelper"></a>
<a id="tocsdto.volumehelper"></a>

```json
{
  "containerDir": "string",
  "mode": "string",
  "sourceDir": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerDir|string|false|none||none|
|mode|string|false|none||none|
|sourceDir|string|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_dto.XPUInfo">dto.XPUInfo</h2>

<a id="schemadto.xpuinfo"></a>
<a id="schema_dto.XPUInfo"></a>
<a id="tocSdto.xpuinfo"></a>
<a id="tocsdto.xpuinfo"></a>

```json
{
  "deviceID": 0,
  "deviceName": "string",
  "memory": "string",
  "memoryUsed": "string",
  "memoryUtil": "string",
  "power": "string",
  "temperature": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|deviceID|integer|false|none||none|
|deviceName|string|false|none||none|
|memory|string|false|none||none|
|memoryUsed|string|false|none||none|
|memoryUtil|string|false|none||none|
|power|string|false|none||none|
|temperature|string|false|none||none|

<h2 id="tocS_files.FileInfo">files.FileInfo</h2>

<a id="schemafiles.fileinfo"></a>
<a id="schema_files.FileInfo"></a>
<a id="tocSfiles.fileinfo"></a>
<a id="tocsfiles.fileinfo"></a>

```json
{
  "content": "string",
  "extension": "string",
  "favoriteID": 0,
  "gid": "string",
  "group": "string",
  "isDetail": true,
  "isDir": true,
  "isHidden": true,
  "isSymlink": true,
  "itemTotal": 0,
  "items": [
    {
      "content": "string",
      "extension": "string",
      "favoriteID": 0,
      "gid": "string",
      "group": "string",
      "isDetail": true,
      "isDir": true,
      "isHidden": true,
      "isSymlink": true,
      "itemTotal": 0,
      "items": [
        {
          "content": "string",
          "extension": "string",
          "favoriteID": 0,
          "gid": "string",
          "group": "string",
          "isDetail": true,
          "isDir": true,
          "isHidden": true,
          "isSymlink": true,
          "itemTotal": 0,
          "items": [
            {}
          ],
          "linkPath": "string",
          "mimeType": "string",
          "modTime": "string",
          "mode": "string",
          "name": "string",
          "path": "string",
          "size": 0,
          "type": "string",
          "uid": "string",
          "updateTime": "string",
          "user": "string"
        }
      ],
      "linkPath": "string",
      "mimeType": "string",
      "modTime": "string",
      "mode": "string",
      "name": "string",
      "path": "string",
      "size": 0,
      "type": "string",
      "uid": "string",
      "updateTime": "string",
      "user": "string"
    }
  ],
  "linkPath": "string",
  "mimeType": "string",
  "modTime": "string",
  "mode": "string",
  "name": "string",
  "path": "string",
  "size": 0,
  "type": "string",
  "uid": "string",
  "updateTime": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|extension|string|false|none||none|
|favoriteID|integer|false|none||none|
|gid|string|false|none||none|
|group|string|false|none||none|
|isDetail|boolean|false|none||none|
|isDir|boolean|false|none||none|
|isHidden|boolean|false|none||none|
|isSymlink|boolean|false|none||none|
|itemTotal|integer|false|none||none|
|items|[[files.FileInfo](#schemafiles.fileinfo)]|false|none||none|
|linkPath|string|false|none||none|
|mimeType|string|false|none||none|
|modTime|string|false|none||none|
|mode|string|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|size|integer|false|none||none|
|type|string|false|none||none|
|uid|string|false|none||none|
|updateTime|string|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_model.App">model.App</h2>

<a id="schemamodel.app"></a>
<a id="schema_model.App"></a>
<a id="tocSmodel.app"></a>
<a id="tocsmodel.app"></a>

```json
{
  "architectures": "string",
  "createdAt": "string",
  "crossVersionUpdate": true,
  "description": "string",
  "document": "string",
  "github": "string",
  "gpuSupport": true,
  "icon": "string",
  "id": 0,
  "key": "string",
  "lastModified": 0,
  "limit": 0,
  "memoryRequired": 0,
  "name": "string",
  "readMe": "string",
  "recommend": 0,
  "required": "string",
  "requiredPanelVersion": 0,
  "resource": "string",
  "shortDescEn": "string",
  "shortDescZh": "string",
  "status": "string",
  "tags": [
    "string"
  ],
  "type": "string",
  "updatedAt": "string",
  "website": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|architectures|string|false|none||none|
|createdAt|string|false|none||none|
|crossVersionUpdate|boolean|false|none||none|
|description|string|false|none||none|
|document|string|false|none||none|
|github|string|false|none||none|
|gpuSupport|boolean|false|none||none|
|icon|string|false|none||none|
|id|integer|false|none||none|
|key|string|false|none||none|
|lastModified|integer|false|none||none|
|limit|integer|false|none||none|
|memoryRequired|integer|false|none||none|
|name|string|false|none||none|
|readMe|string|false|none||none|
|recommend|integer|false|none||none|
|required|string|false|none||none|
|requiredPanelVersion|number|false|none||none|
|resource|string|false|none||none|
|shortDescEn|string|false|none||none|
|shortDescZh|string|false|none||none|
|status|string|false|none||none|
|tags|[string]|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|website|string|false|none||none|

<h2 id="tocS_model.AppInstall">model.AppInstall</h2>

<a id="schemamodel.appinstall"></a>
<a id="schema_model.AppInstall"></a>
<a id="tocSmodel.appinstall"></a>
<a id="tocsmodel.appinstall"></a>

```json
{
  "app": {
    "architectures": "string",
    "createdAt": "string",
    "crossVersionUpdate": true,
    "description": "string",
    "document": "string",
    "github": "string",
    "gpuSupport": true,
    "icon": "string",
    "id": 0,
    "key": "string",
    "lastModified": 0,
    "limit": 0,
    "memoryRequired": 0,
    "name": "string",
    "readMe": "string",
    "recommend": 0,
    "required": "string",
    "requiredPanelVersion": 0,
    "resource": "string",
    "shortDescEn": "string",
    "shortDescZh": "string",
    "status": "string",
    "tags": [
      "string"
    ],
    "type": "string",
    "updatedAt": "string",
    "website": "string"
  },
  "appDetailId": 0,
  "appId": 0,
  "containerName": "string",
  "createdAt": "string",
  "description": "string",
  "dockerCompose": "string",
  "env": "string",
  "httpPort": 0,
  "httpsPort": 0,
  "id": 0,
  "message": "string",
  "name": "string",
  "param": "string",
  "serviceName": "string",
  "status": "string",
  "updatedAt": "string",
  "version": "string",
  "webUI": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|app|[model.App](#schemamodel.app)|false|none||none|
|appDetailId|integer|false|none||none|
|appId|integer|false|none||none|
|containerName|string|false|none||none|
|createdAt|string|false|none||none|
|description|string|false|none||none|
|dockerCompose|string|false|none||none|
|env|string|false|none||none|
|httpPort|integer|false|none||none|
|httpsPort|integer|false|none||none|
|id|integer|false|none||none|
|message|string|false|none||none|
|name|string|false|none||none|
|param|string|false|none||none|
|serviceName|string|false|none||none|
|status|string|false|none||none|
|updatedAt|string|false|none||none|
|version|string|false|none||none|
|webUI|string|false|none||none|

<h2 id="tocS_model.Favorite">model.Favorite</h2>

<a id="schemamodel.favorite"></a>
<a id="schema_model.Favorite"></a>
<a id="tocSmodel.favorite"></a>
<a id="tocsmodel.favorite"></a>

```json
{
  "createdAt": "string",
  "id": 0,
  "isDir": true,
  "isTxt": true,
  "name": "string",
  "path": "string",
  "type": "string",
  "updatedAt": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|createdAt|string|false|none||none|
|id|integer|false|none||none|
|isDir|boolean|false|none||none|
|isTxt|boolean|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|

<h2 id="tocS_model.Runtime">model.Runtime</h2>

<a id="schemamodel.runtime"></a>
<a id="schema_model.Runtime"></a>
<a id="tocSmodel.runtime"></a>
<a id="tocsmodel.runtime"></a>

```json
{
  "appDetailID": 0,
  "codeDir": "string",
  "containerName": "string",
  "createdAt": "string",
  "dockerCompose": "string",
  "env": "string",
  "id": 0,
  "image": "string",
  "message": "string",
  "name": "string",
  "params": "string",
  "port": "string",
  "resource": "string",
  "status": "string",
  "type": "string",
  "updatedAt": "string",
  "version": "string",
  "workDir": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appDetailID|integer|false|none||none|
|codeDir|string|false|none||none|
|containerName|string|false|none||none|
|createdAt|string|false|none||none|
|dockerCompose|string|false|none||none|
|env|string|false|none||none|
|id|integer|false|none||none|
|image|string|false|none||none|
|message|string|false|none||none|
|name|string|false|none||none|
|params|string|false|none||none|
|port|string|false|none||none|
|resource|string|false|none||none|
|status|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|version|string|false|none||none|
|workDir|string|false|none||none|

<h2 id="tocS_model.Website">model.Website</h2>

<a id="schemamodel.website"></a>
<a id="schema_model.Website"></a>
<a id="tocSmodel.website"></a>
<a id="tocsmodel.website"></a>

```json
{
  "IPV6": true,
  "accessLog": true,
  "alias": "string",
  "appInstallId": 0,
  "createdAt": "string",
  "dbID": 0,
  "dbType": "string",
  "defaultServer": true,
  "domains": [
    {
      "createdAt": "string",
      "domain": "string",
      "id": 0,
      "port": 0,
      "ssl": true,
      "updatedAt": "string",
      "websiteId": 0
    }
  ],
  "errorLog": true,
  "expireDate": "string",
  "ftpId": 0,
  "group": "string",
  "httpConfig": "string",
  "id": 0,
  "parentWebsiteID": 0,
  "primaryDomain": "string",
  "protocol": "string",
  "proxy": "string",
  "proxyType": "string",
  "remark": "string",
  "rewrite": "string",
  "runtimeID": 0,
  "siteDir": "string",
  "status": "string",
  "type": "string",
  "updatedAt": "string",
  "user": "string",
  "webSiteGroupId": 0,
  "webSiteSSL": {
    "acmeAccount": {
      "createdAt": "string",
      "eabHmacKey": "string",
      "eabKid": "string",
      "email": "string",
      "id": 0,
      "keyType": "string",
      "type": "string",
      "updatedAt": "string",
      "url": "string"
    },
    "acmeAccountId": 0,
    "autoRenew": true,
    "caId": 0,
    "certURL": "string",
    "createdAt": "string",
    "description": "string",
    "dir": "string",
    "disableCNAME": true,
    "dnsAccount": {
      "createdAt": "string",
      "id": 0,
      "name": "string",
      "type": "string",
      "updatedAt": "string"
    },
    "dnsAccountId": 0,
    "domains": "string",
    "execShell": true,
    "expireDate": "string",
    "id": 0,
    "keyType": "string",
    "message": "string",
    "nameserver1": "string",
    "nameserver2": "string",
    "organization": "string",
    "pem": "string",
    "primaryDomain": "string",
    "privateKey": "string",
    "provider": "string",
    "pushDir": true,
    "shell": "string",
    "skipDNS": true,
    "startDate": "string",
    "status": "string",
    "type": "string",
    "updatedAt": "string",
    "websites": [
      {
        "IPV6": true,
        "accessLog": true,
        "alias": "string",
        "appInstallId": 0,
        "createdAt": "string",
        "dbID": 0,
        "dbType": "string",
        "defaultServer": true,
        "domains": [
          {
            "createdAt": null,
            "domain": null,
            "id": null,
            "port": null,
            "ssl": null,
            "updatedAt": null,
            "websiteId": null
          }
        ],
        "errorLog": true,
        "expireDate": "string",
        "ftpId": 0,
        "group": "string",
        "httpConfig": "string",
        "id": 0,
        "parentWebsiteID": 0,
        "primaryDomain": "string",
        "protocol": "string",
        "proxy": "string",
        "proxyType": "string",
        "remark": "string",
        "rewrite": "string",
        "runtimeID": 0,
        "siteDir": "string",
        "status": "string",
        "type": "string",
        "updatedAt": "string",
        "user": "string",
        "webSiteGroupId": 0,
        "webSiteSSL": {
          "acmeAccount": {},
          "acmeAccountId": 0,
          "autoRenew": true,
          "caId": 0,
          "certURL": "string",
          "createdAt": "string",
          "description": "string",
          "dir": "string",
          "disableCNAME": true,
          "dnsAccount": {},
          "dnsAccountId": 0,
          "domains": "string",
          "execShell": true,
          "expireDate": "string",
          "id": 0,
          "keyType": "string",
          "message": "string",
          "nameserver1": "string",
          "nameserver2": "string",
          "organization": "string",
          "pem": "string",
          "primaryDomain": "string",
          "privateKey": "string",
          "provider": "string",
          "pushDir": true,
          "shell": "string",
          "skipDNS": true,
          "startDate": "string",
          "status": "string",
          "type": "string",
          "updatedAt": "string",
          "websites": [
            null
          ]
        },
        "webSiteSSLId": 0
      }
    ]
  },
  "webSiteSSLId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|IPV6|boolean|false|none||none|
|accessLog|boolean|false|none||none|
|alias|string|false|none||none|
|appInstallId|integer|false|none||none|
|createdAt|string|false|none||none|
|dbID|integer|false|none||none|
|dbType|string|false|none||none|
|defaultServer|boolean|false|none||none|
|domains|[[model.WebsiteDomain](#schemamodel.websitedomain)]|false|none||none|
|errorLog|boolean|false|none||none|
|expireDate|string|false|none||none|
|ftpId|integer|false|none||none|
|group|string|false|none||none|
|httpConfig|string|false|none||none|
|id|integer|false|none||none|
|parentWebsiteID|integer|false|none||none|
|primaryDomain|string|false|none||none|
|protocol|string|false|none||none|
|proxy|string|false|none||none|
|proxyType|string|false|none||none|
|remark|string|false|none||none|
|rewrite|string|false|none||none|
|runtimeID|integer|false|none||none|
|siteDir|string|false|none||none|
|status|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|user|string|false|none||none|
|webSiteGroupId|integer|false|none||none|
|webSiteSSL|[model.WebsiteSSL](#schemamodel.websitessl)|false|none||none|
|webSiteSSLId|integer|false|none||none|

<h2 id="tocS_model.WebsiteAcmeAccount">model.WebsiteAcmeAccount</h2>

<a id="schemamodel.websiteacmeaccount"></a>
<a id="schema_model.WebsiteAcmeAccount"></a>
<a id="tocSmodel.websiteacmeaccount"></a>
<a id="tocsmodel.websiteacmeaccount"></a>

```json
{
  "createdAt": "string",
  "eabHmacKey": "string",
  "eabKid": "string",
  "email": "string",
  "id": 0,
  "keyType": "string",
  "type": "string",
  "updatedAt": "string",
  "url": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|createdAt|string|false|none||none|
|eabHmacKey|string|false|none||none|
|eabKid|string|false|none||none|
|email|string|false|none||none|
|id|integer|false|none||none|
|keyType|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|url|string|false|none||none|

<h2 id="tocS_model.WebsiteDnsAccount">model.WebsiteDnsAccount</h2>

<a id="schemamodel.websitednsaccount"></a>
<a id="schema_model.WebsiteDnsAccount"></a>
<a id="tocSmodel.websitednsaccount"></a>
<a id="tocsmodel.websitednsaccount"></a>

```json
{
  "createdAt": "string",
  "id": 0,
  "name": "string",
  "type": "string",
  "updatedAt": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|createdAt|string|false|none||none|
|id|integer|false|none||none|
|name|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|

<h2 id="tocS_model.WebsiteDomain">model.WebsiteDomain</h2>

<a id="schemamodel.websitedomain"></a>
<a id="schema_model.WebsiteDomain"></a>
<a id="tocSmodel.websitedomain"></a>
<a id="tocsmodel.websitedomain"></a>

```json
{
  "createdAt": "string",
  "domain": "string",
  "id": 0,
  "port": 0,
  "ssl": true,
  "updatedAt": "string",
  "websiteId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|createdAt|string|false|none||none|
|domain|string|false|none||none|
|id|integer|false|none||none|
|port|integer|false|none||none|
|ssl|boolean|false|none||none|
|updatedAt|string|false|none||none|
|websiteId|integer|false|none||none|

<h2 id="tocS_model.WebsiteSSL">model.WebsiteSSL</h2>

<a id="schemamodel.websitessl"></a>
<a id="schema_model.WebsiteSSL"></a>
<a id="tocSmodel.websitessl"></a>
<a id="tocsmodel.websitessl"></a>

```json
{
  "acmeAccount": {
    "createdAt": "string",
    "eabHmacKey": "string",
    "eabKid": "string",
    "email": "string",
    "id": 0,
    "keyType": "string",
    "type": "string",
    "updatedAt": "string",
    "url": "string"
  },
  "acmeAccountId": 0,
  "autoRenew": true,
  "caId": 0,
  "certURL": "string",
  "createdAt": "string",
  "description": "string",
  "dir": "string",
  "disableCNAME": true,
  "dnsAccount": {
    "createdAt": "string",
    "id": 0,
    "name": "string",
    "type": "string",
    "updatedAt": "string"
  },
  "dnsAccountId": 0,
  "domains": "string",
  "execShell": true,
  "expireDate": "string",
  "id": 0,
  "keyType": "string",
  "message": "string",
  "nameserver1": "string",
  "nameserver2": "string",
  "organization": "string",
  "pem": "string",
  "primaryDomain": "string",
  "privateKey": "string",
  "provider": "string",
  "pushDir": true,
  "shell": "string",
  "skipDNS": true,
  "startDate": "string",
  "status": "string",
  "type": "string",
  "updatedAt": "string",
  "websites": [
    {
      "IPV6": true,
      "accessLog": true,
      "alias": "string",
      "appInstallId": 0,
      "createdAt": "string",
      "dbID": 0,
      "dbType": "string",
      "defaultServer": true,
      "domains": [
        {
          "createdAt": "string",
          "domain": "string",
          "id": 0,
          "port": 0,
          "ssl": true,
          "updatedAt": "string",
          "websiteId": 0
        }
      ],
      "errorLog": true,
      "expireDate": "string",
      "ftpId": 0,
      "group": "string",
      "httpConfig": "string",
      "id": 0,
      "parentWebsiteID": 0,
      "primaryDomain": "string",
      "protocol": "string",
      "proxy": "string",
      "proxyType": "string",
      "remark": "string",
      "rewrite": "string",
      "runtimeID": 0,
      "siteDir": "string",
      "status": "string",
      "type": "string",
      "updatedAt": "string",
      "user": "string",
      "webSiteGroupId": 0,
      "webSiteSSL": {
        "acmeAccount": {
          "createdAt": "string",
          "eabHmacKey": "string",
          "eabKid": "string",
          "email": "string",
          "id": 0,
          "keyType": "string",
          "type": "string",
          "updatedAt": "string",
          "url": "string"
        },
        "acmeAccountId": 0,
        "autoRenew": true,
        "caId": 0,
        "certURL": "string",
        "createdAt": "string",
        "description": "string",
        "dir": "string",
        "disableCNAME": true,
        "dnsAccount": {
          "createdAt": "string",
          "id": 0,
          "name": "string",
          "type": "string",
          "updatedAt": "string"
        },
        "dnsAccountId": 0,
        "domains": "string",
        "execShell": true,
        "expireDate": "string",
        "id": 0,
        "keyType": "string",
        "message": "string",
        "nameserver1": "string",
        "nameserver2": "string",
        "organization": "string",
        "pem": "string",
        "primaryDomain": "string",
        "privateKey": "string",
        "provider": "string",
        "pushDir": true,
        "shell": "string",
        "skipDNS": true,
        "startDate": "string",
        "status": "string",
        "type": "string",
        "updatedAt": "string",
        "websites": [
          {
            "IPV6": null,
            "accessLog": null,
            "alias": null,
            "appInstallId": null,
            "createdAt": null,
            "dbID": null,
            "dbType": null,
            "defaultServer": null,
            "domains": null,
            "errorLog": null,
            "expireDate": null,
            "ftpId": null,
            "group": null,
            "httpConfig": null,
            "id": null,
            "parentWebsiteID": null,
            "primaryDomain": null,
            "protocol": null,
            "proxy": null,
            "proxyType": null,
            "remark": null,
            "rewrite": null,
            "runtimeID": null,
            "siteDir": null,
            "status": null,
            "type": null,
            "updatedAt": null,
            "user": null,
            "webSiteGroupId": null,
            "webSiteSSL": null,
            "webSiteSSLId": null
          }
        ]
      },
      "webSiteSSLId": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|acmeAccount|[model.WebsiteAcmeAccount](#schemamodel.websiteacmeaccount)|false|none||none|
|acmeAccountId|integer|false|none||none|
|autoRenew|boolean|false|none||none|
|caId|integer|false|none||none|
|certURL|string|false|none||none|
|createdAt|string|false|none||none|
|description|string|false|none||none|
|dir|string|false|none||none|
|disableCNAME|boolean|false|none||none|
|dnsAccount|[model.WebsiteDnsAccount](#schemamodel.websitednsaccount)|false|none||none|
|dnsAccountId|integer|false|none||none|
|domains|string|false|none||none|
|execShell|boolean|false|none||none|
|expireDate|string|false|none||none|
|id|integer|false|none||none|
|keyType|string|false|none||none|
|message|string|false|none||none|
|nameserver1|string|false|none||none|
|nameserver2|string|false|none||none|
|organization|string|false|none||none|
|pem|string|false|none||none|
|primaryDomain|string|false|none||none|
|privateKey|string|false|none||none|
|provider|string|false|none||none|
|pushDir|boolean|false|none||none|
|shell|string|false|none||none|
|skipDNS|boolean|false|none||none|
|startDate|string|false|none||none|
|status|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|websites|[[model.Website](#schemamodel.website)]|false|none||none|

<h2 id="tocS_request.AppConfigUpdate">request.AppConfigUpdate</h2>

<a id="schemarequest.appconfigupdate"></a>
<a id="schema_request.AppConfigUpdate"></a>
<a id="tocSrequest.appconfigupdate"></a>
<a id="tocsrequest.appconfigupdate"></a>

```json
{
  "installID": 0,
  "webUI": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|installID|integer|true|none||none|
|webUI|string|false|none||none|

<h2 id="tocS_request.AppInstallCreate">request.AppInstallCreate</h2>

<a id="schemarequest.appinstallcreate"></a>
<a id="schema_request.AppInstallCreate"></a>
<a id="tocSrequest.appinstallcreate"></a>
<a id="tocsrequest.appinstallcreate"></a>

```json
{
  "advanced": true,
  "allowPort": true,
  "appDetailId": 0,
  "containerName": "string",
  "cpuQuota": 0,
  "dockerCompose": "string",
  "editCompose": true,
  "gpuConfig": true,
  "hostMode": true,
  "memoryLimit": 0,
  "memoryUnit": "string",
  "name": "string",
  "params": {},
  "pullImage": true,
  "services": {
    "property1": "string",
    "property2": "string"
  },
  "taskID": "string",
  "type": "string",
  "webUI": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|advanced|boolean|false|none||none|
|allowPort|boolean|false|none||none|
|appDetailId|integer|true|none||none|
|containerName|string|false|none||none|
|cpuQuota|number|false|none||none|
|dockerCompose|string|false|none||none|
|editCompose|boolean|false|none||none|
|gpuConfig|boolean|false|none||none|
|hostMode|boolean|false|none||none|
|memoryLimit|number|false|none||none|
|memoryUnit|string|false|none||none|
|name|string|true|none||none|
|params|object|false|none||none|
|pullImage|boolean|false|none||none|
|services|object|false|none||none|
|» **additionalProperties**|string|false|none||none|
|taskID|string|false|none||none|
|type|string|false|none||none|
|webUI|string|false|none||none|

<h2 id="tocS_request.AppInstalledIgnoreUpgrade">request.AppInstalledIgnoreUpgrade</h2>

<a id="schemarequest.appinstalledignoreupgrade"></a>
<a id="schema_request.AppInstalledIgnoreUpgrade"></a>
<a id="tocSrequest.appinstalledignoreupgrade"></a>
<a id="tocsrequest.appinstalledignoreupgrade"></a>

```json
{
  "detailID": 0,
  "operate": "cancel"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|detailID|integer|true|none||none|
|operate|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operate|cancel|
|operate|ignore|

<h2 id="tocS_request.AppInstalledInfo">request.AppInstalledInfo</h2>

<a id="schemarequest.appinstalledinfo"></a>
<a id="schema_request.AppInstalledInfo"></a>
<a id="tocSrequest.appinstalledinfo"></a>
<a id="tocsrequest.appinstalledinfo"></a>

```json
{
  "key": "string",
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|true|none||none|
|name|string|false|none||none|

<h2 id="tocS_request.AppInstalledOperate">request.AppInstalledOperate</h2>

<a id="schemarequest.appinstalledoperate"></a>
<a id="schema_request.AppInstalledOperate"></a>
<a id="tocSrequest.appinstalledoperate"></a>
<a id="tocsrequest.appinstalledoperate"></a>

```json
{
  "backup": true,
  "backupId": 0,
  "deleteBackup": true,
  "deleteDB": true,
  "deleteImage": true,
  "detailId": 0,
  "dockerCompose": "string",
  "forceDelete": true,
  "installId": 0,
  "operate": "string",
  "pullImage": true,
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|backup|boolean|false|none||none|
|backupId|integer|false|none||none|
|deleteBackup|boolean|false|none||none|
|deleteDB|boolean|false|none||none|
|deleteImage|boolean|false|none||none|
|detailId|integer|false|none||none|
|dockerCompose|string|false|none||none|
|forceDelete|boolean|false|none||none|
|installId|integer|true|none||none|
|operate|string|true|none||none|
|pullImage|boolean|false|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_request.AppInstalledSearch">request.AppInstalledSearch</h2>

<a id="schemarequest.appinstalledsearch"></a>
<a id="schema_request.AppInstalledSearch"></a>
<a id="tocSrequest.appinstalledsearch"></a>
<a id="tocsrequest.appinstalledsearch"></a>

```json
{
  "all": true,
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "sync": true,
  "tags": [
    "string"
  ],
  "type": "string",
  "unused": true,
  "update": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|all|boolean|false|none||none|
|name|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|sync|boolean|false|none||none|
|tags|[string]|false|none||none|
|type|string|false|none||none|
|unused|boolean|false|none||none|
|update|boolean|false|none||none|

<h2 id="tocS_request.AppInstalledUpdate">request.AppInstalledUpdate</h2>

<a id="schemarequest.appinstalledupdate"></a>
<a id="schema_request.AppInstalledUpdate"></a>
<a id="tocSrequest.appinstalledupdate"></a>
<a id="tocsrequest.appinstalledupdate"></a>

```json
{
  "advanced": true,
  "allowPort": true,
  "containerName": "string",
  "cpuQuota": 0,
  "dockerCompose": "string",
  "editCompose": true,
  "gpuConfig": true,
  "hostMode": true,
  "installId": 0,
  "memoryLimit": 0,
  "memoryUnit": "string",
  "params": {},
  "pullImage": true,
  "type": "string",
  "webUI": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|advanced|boolean|false|none||none|
|allowPort|boolean|false|none||none|
|containerName|string|false|none||none|
|cpuQuota|number|false|none||none|
|dockerCompose|string|false|none||none|
|editCompose|boolean|false|none||none|
|gpuConfig|boolean|false|none||none|
|hostMode|boolean|false|none||none|
|installId|integer|true|none||none|
|memoryLimit|number|false|none||none|
|memoryUnit|string|false|none||none|
|params|object|true|none||none|
|pullImage|boolean|false|none||none|
|type|string|false|none||none|
|webUI|string|false|none||none|

<h2 id="tocS_request.AppSearch">request.AppSearch</h2>

<a id="schemarequest.appsearch"></a>
<a id="schema_request.AppSearch"></a>
<a id="tocSrequest.appsearch"></a>
<a id="tocsrequest.appsearch"></a>

```json
{
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "recommend": true,
  "resource": "string",
  "showCurrentArch": true,
  "tags": [
    "string"
  ],
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|recommend|boolean|false|none||none|
|resource|string|false|none||none|
|showCurrentArch|boolean|false|none||none|
|tags|[string]|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_request.AppstoreUpdate">request.AppstoreUpdate</h2>

<a id="schemarequest.appstoreupdate"></a>
<a id="schema_request.AppstoreUpdate"></a>
<a id="tocSrequest.appstoreupdate"></a>
<a id="tocsrequest.appstoreupdate"></a>

```json
{
  "defaultDomain": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|defaultDomain|string|false|none||none|

<h2 id="tocS_request.ChangeDatabase">request.ChangeDatabase</h2>

<a id="schemarequest.changedatabase"></a>
<a id="schema_request.ChangeDatabase"></a>
<a id="tocSrequest.changedatabase"></a>
<a id="tocsrequest.changedatabase"></a>

```json
{
  "databaseID": 0,
  "databaseType": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|databaseID|integer|true|none||none|
|databaseType|string|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.CustomRewriteOperate">request.CustomRewriteOperate</h2>

<a id="schemarequest.customrewriteoperate"></a>
<a id="schema_request.CustomRewriteOperate"></a>
<a id="tocSrequest.customrewriteoperate"></a>
<a id="tocsrequest.customrewriteoperate"></a>

```json
{
  "content": "string",
  "name": "string",
  "operate": "create"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|name|string|false|none||none|
|operate|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operate|create|
|operate|delete|

<h2 id="tocS_request.DirSizeReq">request.DirSizeReq</h2>

<a id="schemarequest.dirsizereq"></a>
<a id="schema_request.DirSizeReq"></a>
<a id="tocSrequest.dirsizereq"></a>
<a id="tocsrequest.dirsizereq"></a>

```json
{
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|path|string|true|none||none|

<h2 id="tocS_request.Environment">request.Environment</h2>

<a id="schemarequest.environment"></a>
<a id="schema_request.Environment"></a>
<a id="tocSrequest.environment"></a>
<a id="tocsrequest.environment"></a>

```json
{
  "key": "string",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|false|none||none|
|value|string|false|none||none|

<h2 id="tocS_request.ExposedPort">request.ExposedPort</h2>

<a id="schemarequest.exposedport"></a>
<a id="schema_request.ExposedPort"></a>
<a id="tocSrequest.exposedport"></a>
<a id="tocsrequest.exposedport"></a>

```json
{
  "containerPort": 0,
  "hostIP": "string",
  "hostPort": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerPort|integer|false|none||none|
|hostIP|string|false|none||none|
|hostPort|integer|false|none||none|

<h2 id="tocS_request.FPMConfig">request.FPMConfig</h2>

<a id="schemarequest.fpmconfig"></a>
<a id="schema_request.FPMConfig"></a>
<a id="tocSrequest.fpmconfig"></a>
<a id="tocsrequest.fpmconfig"></a>

```json
{
  "id": 0,
  "params": {}
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|params|object|true|none||none|

<h2 id="tocS_request.FavoriteCreate">request.FavoriteCreate</h2>

<a id="schemarequest.favoritecreate"></a>
<a id="schema_request.FavoriteCreate"></a>
<a id="tocSrequest.favoritecreate"></a>
<a id="tocsrequest.favoritecreate"></a>

```json
{
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|path|string|true|none||none|

<h2 id="tocS_request.FavoriteDelete">request.FavoriteDelete</h2>

<a id="schemarequest.favoritedelete"></a>
<a id="schema_request.FavoriteDelete"></a>
<a id="tocSrequest.favoritedelete"></a>
<a id="tocsrequest.favoritedelete"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|

<h2 id="tocS_request.FileBatchDelete">request.FileBatchDelete</h2>

<a id="schemarequest.filebatchdelete"></a>
<a id="schema_request.FileBatchDelete"></a>
<a id="tocSrequest.filebatchdelete"></a>
<a id="tocsrequest.filebatchdelete"></a>

```json
{
  "isDir": true,
  "paths": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|isDir|boolean|false|none||none|
|paths|[string]|true|none||none|

<h2 id="tocS_request.FileCompress">request.FileCompress</h2>

<a id="schemarequest.filecompress"></a>
<a id="schema_request.FileCompress"></a>
<a id="tocSrequest.filecompress"></a>
<a id="tocsrequest.filecompress"></a>

```json
{
  "dst": "string",
  "files": [
    "string"
  ],
  "name": "string",
  "replace": true,
  "secret": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|dst|string|true|none||none|
|files|[string]|true|none||none|
|name|string|true|none||none|
|replace|boolean|false|none||none|
|secret|string|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.FileContentReq">request.FileContentReq</h2>

<a id="schemarequest.filecontentreq"></a>
<a id="schema_request.FileContentReq"></a>
<a id="tocSrequest.filecontentreq"></a>
<a id="tocsrequest.filecontentreq"></a>

```json
{
  "isDetail": true,
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|isDetail|boolean|false|none||none|
|path|string|true|none||none|

<h2 id="tocS_request.FileCreate">request.FileCreate</h2>

<a id="schemarequest.filecreate"></a>
<a id="schema_request.FileCreate"></a>
<a id="tocSrequest.filecreate"></a>
<a id="tocsrequest.filecreate"></a>

```json
{
  "content": "string",
  "isDir": true,
  "isLink": true,
  "isSymlink": true,
  "linkPath": "string",
  "mode": 0,
  "path": "string",
  "sub": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|isDir|boolean|false|none||none|
|isLink|boolean|false|none||none|
|isSymlink|boolean|false|none||none|
|linkPath|string|false|none||none|
|mode|integer|false|none||none|
|path|string|true|none||none|
|sub|boolean|false|none||none|

<h2 id="tocS_request.FileDeCompress">request.FileDeCompress</h2>

<a id="schemarequest.filedecompress"></a>
<a id="schema_request.FileDeCompress"></a>
<a id="tocSrequest.filedecompress"></a>
<a id="tocsrequest.filedecompress"></a>

```json
{
  "dst": "string",
  "path": "string",
  "secret": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|dst|string|true|none||none|
|path|string|true|none||none|
|secret|string|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.FileDelete">request.FileDelete</h2>

<a id="schemarequest.filedelete"></a>
<a id="schema_request.FileDelete"></a>
<a id="tocSrequest.filedelete"></a>
<a id="tocsrequest.filedelete"></a>

```json
{
  "forceDelete": true,
  "isDir": true,
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|forceDelete|boolean|false|none||none|
|isDir|boolean|false|none||none|
|path|string|true|none||none|

<h2 id="tocS_request.FileDownload">request.FileDownload</h2>

<a id="schemarequest.filedownload"></a>
<a id="schema_request.FileDownload"></a>
<a id="tocSrequest.filedownload"></a>
<a id="tocsrequest.filedownload"></a>

```json
{
  "compress": true,
  "name": "string",
  "paths": [
    "string"
  ],
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|compress|boolean|false|none||none|
|name|string|true|none||none|
|paths|[string]|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.FileEdit">request.FileEdit</h2>

<a id="schemarequest.fileedit"></a>
<a id="schema_request.FileEdit"></a>
<a id="tocSrequest.fileedit"></a>
<a id="tocsrequest.fileedit"></a>

```json
{
  "content": "string",
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|path|string|true|none||none|

<h2 id="tocS_request.FileMove">request.FileMove</h2>

<a id="schemarequest.filemove"></a>
<a id="schema_request.FileMove"></a>
<a id="tocSrequest.filemove"></a>
<a id="tocsrequest.filemove"></a>

```json
{
  "cover": true,
  "name": "string",
  "newPath": "string",
  "oldPaths": [
    "string"
  ],
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cover|boolean|false|none||none|
|name|string|false|none||none|
|newPath|string|true|none||none|
|oldPaths|[string]|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.FileOption">request.FileOption</h2>

<a id="schemarequest.fileoption"></a>
<a id="schema_request.FileOption"></a>
<a id="tocSrequest.fileoption"></a>
<a id="tocsrequest.fileoption"></a>

```json
{
  "containSub": true,
  "dir": true,
  "expand": true,
  "isDetail": true,
  "page": 0,
  "pageSize": 0,
  "path": "string",
  "search": "string",
  "showHidden": true,
  "sortBy": "string",
  "sortOrder": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containSub|boolean|false|none||none|
|dir|boolean|false|none||none|
|expand|boolean|false|none||none|
|isDetail|boolean|false|none||none|
|page|integer|false|none||none|
|pageSize|integer|false|none||none|
|path|string|false|none||none|
|search|string|false|none||none|
|showHidden|boolean|false|none||none|
|sortBy|string|false|none||none|
|sortOrder|string|false|none||none|

<h2 id="tocS_request.FilePathCheck">request.FilePathCheck</h2>

<a id="schemarequest.filepathcheck"></a>
<a id="schema_request.FilePathCheck"></a>
<a id="tocSrequest.filepathcheck"></a>
<a id="tocsrequest.filepathcheck"></a>

```json
{
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|path|string|true|none||none|

<h2 id="tocS_request.FileReadByLineReq">request.FileReadByLineReq</h2>

<a id="schemarequest.filereadbylinereq"></a>
<a id="schema_request.FileReadByLineReq"></a>
<a id="tocSrequest.filereadbylinereq"></a>
<a id="tocsrequest.filereadbylinereq"></a>

```json
{
  "ID": 0,
  "latest": true,
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "resourceID": 0,
  "taskID": "string",
  "taskOperate": "string",
  "taskType": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ID|integer|false|none||none|
|latest|boolean|false|none||none|
|name|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|resourceID|integer|false|none||none|
|taskID|string|false|none||none|
|taskOperate|string|false|none||none|
|taskType|string|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.FileRename">request.FileRename</h2>

<a id="schemarequest.filerename"></a>
<a id="schema_request.FileRename"></a>
<a id="tocSrequest.filerename"></a>
<a id="tocsrequest.filerename"></a>

```json
{
  "newName": "string",
  "oldName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|newName|string|true|none||none|
|oldName|string|true|none||none|

<h2 id="tocS_request.FileRoleReq">request.FileRoleReq</h2>

<a id="schemarequest.filerolereq"></a>
<a id="schema_request.FileRoleReq"></a>
<a id="tocSrequest.filerolereq"></a>
<a id="tocsrequest.filerolereq"></a>

```json
{
  "group": "string",
  "mode": 0,
  "paths": [
    "string"
  ],
  "sub": true,
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|group|string|true|none||none|
|mode|integer|true|none||none|
|paths|[string]|true|none||none|
|sub|boolean|false|none||none|
|user|string|true|none||none|

<h2 id="tocS_request.FileRoleUpdate">request.FileRoleUpdate</h2>

<a id="schemarequest.fileroleupdate"></a>
<a id="schema_request.FileRoleUpdate"></a>
<a id="tocSrequest.fileroleupdate"></a>
<a id="tocsrequest.fileroleupdate"></a>

```json
{
  "group": "string",
  "path": "string",
  "sub": true,
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|group|string|true|none||none|
|path|string|true|none||none|
|sub|boolean|false|none||none|
|user|string|true|none||none|

<h2 id="tocS_request.FileWget">request.FileWget</h2>

<a id="schemarequest.filewget"></a>
<a id="schema_request.FileWget"></a>
<a id="tocSrequest.filewget"></a>
<a id="tocsrequest.filewget"></a>

```json
{
  "ignoreCertificate": true,
  "name": "string",
  "path": "string",
  "url": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ignoreCertificate|boolean|false|none||none|
|name|string|true|none||none|
|path|string|true|none||none|
|url|string|true|none||none|

<h2 id="tocS_request.HostToolConfig">request.HostToolConfig</h2>

<a id="schemarequest.hosttoolconfig"></a>
<a id="schema_request.HostToolConfig"></a>
<a id="tocSrequest.hosttoolconfig"></a>
<a id="tocsrequest.hosttoolconfig"></a>

```json
{
  "content": "string",
  "operate": "get",
  "type": "supervisord"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|operate|string|false|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operate|get|
|operate|set|
|type|supervisord|

<h2 id="tocS_request.HostToolCreate">request.HostToolCreate</h2>

<a id="schemarequest.hosttoolcreate"></a>
<a id="schema_request.HostToolCreate"></a>
<a id="tocSrequest.hosttoolcreate"></a>
<a id="tocsrequest.hosttoolcreate"></a>

```json
{
  "configPath": "string",
  "serviceName": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|configPath|string|false|none||none|
|serviceName|string|false|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.HostToolLogReq">request.HostToolLogReq</h2>

<a id="schemarequest.hosttoollogreq"></a>
<a id="schema_request.HostToolLogReq"></a>
<a id="tocSrequest.hosttoollogreq"></a>
<a id="tocsrequest.hosttoollogreq"></a>

```json
{
  "type": "supervisord"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|supervisord|

<h2 id="tocS_request.HostToolReq">request.HostToolReq</h2>

<a id="schemarequest.hosttoolreq"></a>
<a id="schema_request.HostToolReq"></a>
<a id="tocSrequest.hosttoolreq"></a>
<a id="tocsrequest.hosttoolreq"></a>

```json
{
  "operate": "status",
  "type": "supervisord"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|operate|string|false|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|operate|status|
|operate|restart|
|operate|start|
|operate|stop|
|type|supervisord|

<h2 id="tocS_request.NewAppInstall">request.NewAppInstall</h2>

<a id="schemarequest.newappinstall"></a>
<a id="schema_request.NewAppInstall"></a>
<a id="tocSrequest.newappinstall"></a>
<a id="tocsrequest.newappinstall"></a>

```json
{
  "advanced": true,
  "allowPort": true,
  "appDetailID": 0,
  "containerName": "string",
  "cpuQuota": 0,
  "dockerCompose": "string",
  "editCompose": true,
  "gpuConfig": true,
  "hostMode": true,
  "memoryLimit": 0,
  "memoryUnit": "string",
  "name": "string",
  "params": {},
  "pullImage": true,
  "type": "string",
  "webUI": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|advanced|boolean|false|none||none|
|allowPort|boolean|false|none||none|
|appDetailID|integer|false|none||none|
|containerName|string|false|none||none|
|cpuQuota|number|false|none||none|
|dockerCompose|string|false|none||none|
|editCompose|boolean|false|none||none|
|gpuConfig|boolean|false|none||none|
|hostMode|boolean|false|none||none|
|memoryLimit|number|false|none||none|
|memoryUnit|string|false|none||none|
|name|string|false|none||none|
|params|object|false|none||none|
|pullImage|boolean|false|none||none|
|type|string|false|none||none|
|webUI|string|false|none||none|

<h2 id="tocS_request.NginxAntiLeechUpdate">request.NginxAntiLeechUpdate</h2>

<a id="schemarequest.nginxantileechupdate"></a>
<a id="schema_request.NginxAntiLeechUpdate"></a>
<a id="tocSrequest.nginxantileechupdate"></a>
<a id="tocsrequest.nginxantileechupdate"></a>

```json
{
  "blocked": true,
  "cache": true,
  "cacheTime": 0,
  "cacheUint": "string",
  "enable": true,
  "extends": "string",
  "logEnable": true,
  "noneRef": true,
  "return": "string",
  "serverNames": [
    "string"
  ],
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|blocked|boolean|false|none||none|
|cache|boolean|false|none||none|
|cacheTime|integer|false|none||none|
|cacheUint|string|false|none||none|
|enable|boolean|false|none||none|
|extends|string|true|none||none|
|logEnable|boolean|false|none||none|
|noneRef|boolean|false|none||none|
|return|string|true|none||none|
|serverNames|[string]|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxAuthReq">request.NginxAuthReq</h2>

<a id="schemarequest.nginxauthreq"></a>
<a id="schema_request.NginxAuthReq"></a>
<a id="tocSrequest.nginxauthreq"></a>
<a id="tocsrequest.nginxauthreq"></a>

```json
{
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxAuthUpdate">request.NginxAuthUpdate</h2>

<a id="schemarequest.nginxauthupdate"></a>
<a id="schema_request.NginxAuthUpdate"></a>
<a id="tocSrequest.nginxauthupdate"></a>
<a id="tocsrequest.nginxauthupdate"></a>

```json
{
  "operate": "string",
  "password": "string",
  "remark": "string",
  "username": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|operate|string|true|none||none|
|password|string|false|none||none|
|remark|string|false|none||none|
|username|string|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxBuildReq">request.NginxBuildReq</h2>

<a id="schemarequest.nginxbuildreq"></a>
<a id="schema_request.NginxBuildReq"></a>
<a id="tocSrequest.nginxbuildreq"></a>
<a id="tocsrequest.nginxbuildreq"></a>

```json
{
  "mirror": "string",
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|mirror|string|true|none||none|
|taskID|string|true|none||none|

<h2 id="tocS_request.NginxCommonReq">request.NginxCommonReq</h2>

<a id="schemarequest.nginxcommonreq"></a>
<a id="schema_request.NginxCommonReq"></a>
<a id="tocSrequest.nginxcommonreq"></a>
<a id="tocsrequest.nginxcommonreq"></a>

```json
{
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxConfigFileUpdate">request.NginxConfigFileUpdate</h2>

<a id="schemarequest.nginxconfigfileupdate"></a>
<a id="schema_request.NginxConfigFileUpdate"></a>
<a id="tocSrequest.nginxconfigfileupdate"></a>
<a id="tocsrequest.nginxconfigfileupdate"></a>

```json
{
  "backup": true,
  "content": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|backup|boolean|false|none||none|
|content|string|true|none||none|

<h2 id="tocS_request.NginxConfigUpdate">request.NginxConfigUpdate</h2>

<a id="schemarequest.nginxconfigupdate"></a>
<a id="schema_request.NginxConfigUpdate"></a>
<a id="tocSrequest.nginxconfigupdate"></a>
<a id="tocsrequest.nginxconfigupdate"></a>

```json
{
  "operate": "add",
  "params": null,
  "scope": "index",
  "websiteId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|operate|string|true|none||none|
|params|any|false|none||none|
|scope|[dto.NginxKey](#schemadto.nginxkey)|false|none||none|
|websiteId|integer|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|operate|add|
|operate|update|
|operate|delete|

<h2 id="tocS_request.NginxModuleUpdate">request.NginxModuleUpdate</h2>

<a id="schemarequest.nginxmoduleupdate"></a>
<a id="schema_request.NginxModuleUpdate"></a>
<a id="tocSrequest.nginxmoduleupdate"></a>
<a id="tocsrequest.nginxmoduleupdate"></a>

```json
{
  "enable": true,
  "name": "string",
  "operate": "create",
  "packages": "string",
  "params": "string",
  "script": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|enable|boolean|false|none||none|
|name|string|true|none||none|
|operate|string|true|none||none|
|packages|string|false|none||none|
|params|string|false|none||none|
|script|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|operate|create|
|operate|delete|
|operate|update|

<h2 id="tocS_request.NginxPathAuthUpdate">request.NginxPathAuthUpdate</h2>

<a id="schemarequest.nginxpathauthupdate"></a>
<a id="schema_request.NginxPathAuthUpdate"></a>
<a id="tocSrequest.nginxpathauthupdate"></a>
<a id="tocsrequest.nginxpathauthupdate"></a>

```json
{
  "name": "string",
  "operate": "string",
  "password": "string",
  "path": "string",
  "remark": "string",
  "username": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|operate|string|true|none||none|
|password|string|false|none||none|
|path|string|false|none||none|
|remark|string|false|none||none|
|username|string|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxProxyCacheUpdate">request.NginxProxyCacheUpdate</h2>

<a id="schemarequest.nginxproxycacheupdate"></a>
<a id="schema_request.NginxProxyCacheUpdate"></a>
<a id="tocSrequest.nginxproxycacheupdate"></a>
<a id="tocsrequest.nginxproxycacheupdate"></a>

```json
{
  "cacheExpire": 0,
  "cacheExpireUnit": "string",
  "cacheLimit": 0,
  "cacheLimitUnit": "string",
  "open": true,
  "shareCache": 0,
  "shareCacheUnit": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cacheExpire|integer|true|none||none|
|cacheExpireUnit|string|true|none||none|
|cacheLimit|integer|true|none||none|
|cacheLimitUnit|string|true|none||none|
|open|boolean|false|none||none|
|shareCache|integer|true|none||none|
|shareCacheUnit|string|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxProxyUpdate">request.NginxProxyUpdate</h2>

<a id="schemarequest.nginxproxyupdate"></a>
<a id="schema_request.NginxProxyUpdate"></a>
<a id="tocSrequest.nginxproxyupdate"></a>
<a id="tocsrequest.nginxproxyupdate"></a>

```json
{
  "content": "string",
  "name": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|true|none||none|
|name|string|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxRedirectReq">request.NginxRedirectReq</h2>

<a id="schemarequest.nginxredirectreq"></a>
<a id="schema_request.NginxRedirectReq"></a>
<a id="tocSrequest.nginxredirectreq"></a>
<a id="tocsrequest.nginxredirectreq"></a>

```json
{
  "domains": [
    "string"
  ],
  "enable": true,
  "keepPath": true,
  "name": "string",
  "operate": "string",
  "path": "string",
  "redirect": "string",
  "redirectRoot": true,
  "target": "string",
  "type": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|domains|[string]|false|none||none|
|enable|boolean|false|none||none|
|keepPath|boolean|false|none||none|
|name|string|true|none||none|
|operate|string|true|none||none|
|path|string|false|none||none|
|redirect|string|true|none||none|
|redirectRoot|boolean|false|none||none|
|target|string|true|none||none|
|type|string|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxRedirectUpdate">request.NginxRedirectUpdate</h2>

<a id="schemarequest.nginxredirectupdate"></a>
<a id="schema_request.NginxRedirectUpdate"></a>
<a id="tocSrequest.nginxredirectupdate"></a>
<a id="tocsrequest.nginxredirectupdate"></a>

```json
{
  "content": "string",
  "name": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|true|none||none|
|name|string|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.NginxRewriteReq">request.NginxRewriteReq</h2>

<a id="schemarequest.nginxrewritereq"></a>
<a id="schema_request.NginxRewriteReq"></a>
<a id="tocSrequest.nginxrewritereq"></a>
<a id="tocsrequest.nginxrewritereq"></a>

```json
{
  "name": "string",
  "websiteId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|
|websiteId|integer|true|none||none|

<h2 id="tocS_request.NginxRewriteUpdate">request.NginxRewriteUpdate</h2>

<a id="schemarequest.nginxrewriteupdate"></a>
<a id="schema_request.NginxRewriteUpdate"></a>
<a id="tocSrequest.nginxrewriteupdate"></a>
<a id="tocsrequest.nginxrewriteupdate"></a>

```json
{
  "content": "string",
  "name": "string",
  "websiteId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|name|string|true|none||none|
|websiteId|integer|true|none||none|

<h2 id="tocS_request.NginxScopeReq">request.NginxScopeReq</h2>

<a id="schemarequest.nginxscopereq"></a>
<a id="schema_request.NginxScopeReq"></a>
<a id="tocSrequest.nginxscopereq"></a>
<a id="tocsrequest.nginxscopereq"></a>

```json
{
  "scope": "index",
  "websiteId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|scope|[dto.NginxKey](#schemadto.nginxkey)|true|none||none|
|websiteId|integer|false|none||none|

<h2 id="tocS_request.NodeModuleReq">request.NodeModuleReq</h2>

<a id="schemarequest.nodemodulereq"></a>
<a id="schema_request.NodeModuleReq"></a>
<a id="tocSrequest.nodemodulereq"></a>
<a id="tocsrequest.nodemodulereq"></a>

```json
{
  "ID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ID|integer|true|none||none|

<h2 id="tocS_request.NodePackageReq">request.NodePackageReq</h2>

<a id="schemarequest.nodepackagereq"></a>
<a id="schema_request.NodePackageReq"></a>
<a id="tocSrequest.nodepackagereq"></a>
<a id="tocsrequest.nodepackagereq"></a>

```json
{
  "codeDir": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|codeDir|string|false|none||none|

<h2 id="tocS_request.PHPConfigUpdate">request.PHPConfigUpdate</h2>

<a id="schemarequest.phpconfigupdate"></a>
<a id="schema_request.PHPConfigUpdate"></a>
<a id="tocSrequest.phpconfigupdate"></a>
<a id="tocsrequest.phpconfigupdate"></a>

```json
{
  "disableFunctions": [
    "string"
  ],
  "id": 0,
  "params": {
    "property1": "string",
    "property2": "string"
  },
  "scope": "string",
  "uploadMaxSize": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|disableFunctions|[string]|false|none||none|
|id|integer|true|none||none|
|params|object|false|none||none|
|» **additionalProperties**|string|false|none||none|
|scope|string|true|none||none|
|uploadMaxSize|string|false|none||none|

<h2 id="tocS_request.PHPExtensionInstallReq">request.PHPExtensionInstallReq</h2>

<a id="schemarequest.phpextensioninstallreq"></a>
<a id="schema_request.PHPExtensionInstallReq"></a>
<a id="tocSrequest.phpextensioninstallreq"></a>
<a id="tocsrequest.phpextensioninstallreq"></a>

```json
{
  "ID": 0,
  "name": "string",
  "taskID": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ID|integer|true|none||none|
|name|string|true|none||none|
|taskID|string|false|none||none|

<h2 id="tocS_request.PHPExtensionsCreate">request.PHPExtensionsCreate</h2>

<a id="schemarequest.phpextensionscreate"></a>
<a id="schema_request.PHPExtensionsCreate"></a>
<a id="tocSrequest.phpextensionscreate"></a>
<a id="tocsrequest.phpextensionscreate"></a>

```json
{
  "extensions": "string",
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|extensions|string|true|none||none|
|name|string|true|none||none|

<h2 id="tocS_request.PHPExtensionsDelete">request.PHPExtensionsDelete</h2>

<a id="schemarequest.phpextensionsdelete"></a>
<a id="schema_request.PHPExtensionsDelete"></a>
<a id="tocSrequest.phpextensionsdelete"></a>
<a id="tocsrequest.phpextensionsdelete"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|

<h2 id="tocS_request.PHPExtensionsSearch">request.PHPExtensionsSearch</h2>

<a id="schemarequest.phpextensionssearch"></a>
<a id="schema_request.PHPExtensionsSearch"></a>
<a id="tocSrequest.phpextensionssearch"></a>
<a id="tocsrequest.phpextensionssearch"></a>

```json
{
  "all": true,
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|all|boolean|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

<h2 id="tocS_request.PHPExtensionsUpdate">request.PHPExtensionsUpdate</h2>

<a id="schemarequest.phpextensionsupdate"></a>
<a id="schema_request.PHPExtensionsUpdate"></a>
<a id="tocSrequest.phpextensionsupdate"></a>
<a id="tocsrequest.phpextensionsupdate"></a>

```json
{
  "extensions": "string",
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|extensions|string|true|none||none|
|id|integer|true|none||none|

<h2 id="tocS_request.PHPFileReq">request.PHPFileReq</h2>

<a id="schemarequest.phpfilereq"></a>
<a id="schema_request.PHPFileReq"></a>
<a id="tocSrequest.phpfilereq"></a>
<a id="tocsrequest.phpfilereq"></a>

```json
{
  "id": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.PHPFileUpdate">request.PHPFileUpdate</h2>

<a id="schemarequest.phpfileupdate"></a>
<a id="schema_request.PHPFileUpdate"></a>
<a id="tocSrequest.phpfileupdate"></a>
<a id="tocsrequest.phpfileupdate"></a>

```json
{
  "content": "string",
  "id": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|true|none||none|
|id|integer|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.PHPSupervisorProcessConfig">request.PHPSupervisorProcessConfig</h2>

<a id="schemarequest.phpsupervisorprocessconfig"></a>
<a id="schema_request.PHPSupervisorProcessConfig"></a>
<a id="tocSrequest.phpsupervisorprocessconfig"></a>
<a id="tocsrequest.phpsupervisorprocessconfig"></a>

```json
{
  "command": "string",
  "dir": "string",
  "id": 0,
  "name": "string",
  "numprocs": "string",
  "operate": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|command|string|false|none||none|
|dir|string|false|none||none|
|id|integer|true|none||none|
|name|string|false|none||none|
|numprocs|string|false|none||none|
|operate|string|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_request.PHPSupervisorProcessFileReq">request.PHPSupervisorProcessFileReq</h2>

<a id="schemarequest.phpsupervisorprocessfilereq"></a>
<a id="schema_request.PHPSupervisorProcessFileReq"></a>
<a id="tocSrequest.phpsupervisorprocessfilereq"></a>
<a id="tocsrequest.phpsupervisorprocessfilereq"></a>

```json
{
  "content": "string",
  "file": "out.log",
  "id": 0,
  "name": "string",
  "operate": "get"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|file|string|true|none||none|
|id|integer|true|none||none|
|name|string|true|none||none|
|operate|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|file|out.log|
|file|err.log|
|file|config|
|operate|get|
|operate|clear|
|operate|update|

<h2 id="tocS_request.PortUpdate">request.PortUpdate</h2>

<a id="schemarequest.portupdate"></a>
<a id="schema_request.PortUpdate"></a>
<a id="tocSrequest.portupdate"></a>
<a id="tocsrequest.portupdate"></a>

```json
{
  "key": "string",
  "name": "string",
  "port": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|false|none||none|
|name|string|false|none||none|
|port|integer|false|none||none|

<h2 id="tocS_request.ProcessReq">request.ProcessReq</h2>

<a id="schemarequest.processreq"></a>
<a id="schema_request.ProcessReq"></a>
<a id="tocSrequest.processreq"></a>
<a id="tocsrequest.processreq"></a>

```json
{
  "PID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|PID|integer|true|none||none|

<h2 id="tocS_request.RecycleBinReduce">request.RecycleBinReduce</h2>

<a id="schemarequest.recyclebinreduce"></a>
<a id="schema_request.RecycleBinReduce"></a>
<a id="tocSrequest.recyclebinreduce"></a>
<a id="tocsrequest.recyclebinreduce"></a>

```json
{
  "from": "string",
  "name": "string",
  "rName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|from|string|true|none||none|
|name|string|false|none||none|
|rName|string|true|none||none|

<h2 id="tocS_request.RuntimeCreate">request.RuntimeCreate</h2>

<a id="schemarequest.runtimecreate"></a>
<a id="schema_request.RuntimeCreate"></a>
<a id="tocSrequest.runtimecreate"></a>
<a id="tocsrequest.runtimecreate"></a>

```json
{
  "appDetailId": 0,
  "clean": true,
  "codeDir": "string",
  "environments": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "exposedPorts": [
    {
      "containerPort": 0,
      "hostIP": "string",
      "hostPort": 0
    }
  ],
  "image": "string",
  "install": true,
  "name": "string",
  "params": {},
  "resource": "string",
  "source": "string",
  "type": "string",
  "version": "string",
  "volumes": [
    {
      "source": "string",
      "target": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appDetailId|integer|false|none||none|
|clean|boolean|false|none||none|
|codeDir|string|false|none||none|
|environments|[[request.Environment](#schemarequest.environment)]|false|none||none|
|exposedPorts|[[request.ExposedPort](#schemarequest.exposedport)]|false|none||none|
|image|string|false|none||none|
|install|boolean|false|none||none|
|name|string|false|none||none|
|params|object|false|none||none|
|resource|string|false|none||none|
|source|string|false|none||none|
|type|string|false|none||none|
|version|string|false|none||none|
|volumes|[[request.Volume](#schemarequest.volume)]|false|none||none|

<h2 id="tocS_request.RuntimeDelete">request.RuntimeDelete</h2>

<a id="schemarequest.runtimedelete"></a>
<a id="schema_request.RuntimeDelete"></a>
<a id="tocSrequest.runtimedelete"></a>
<a id="tocsrequest.runtimedelete"></a>

```json
{
  "forceDelete": true,
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|forceDelete|boolean|false|none||none|
|id|integer|false|none||none|

<h2 id="tocS_request.RuntimeOperate">request.RuntimeOperate</h2>

<a id="schemarequest.runtimeoperate"></a>
<a id="schema_request.RuntimeOperate"></a>
<a id="tocSrequest.runtimeoperate"></a>
<a id="tocsrequest.runtimeoperate"></a>

```json
{
  "ID": 0,
  "operate": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ID|integer|false|none||none|
|operate|string|false|none||none|

<h2 id="tocS_request.RuntimeSearch">request.RuntimeSearch</h2>

<a id="schemarequest.runtimesearch"></a>
<a id="schema_request.RuntimeSearch"></a>
<a id="tocSrequest.runtimesearch"></a>
<a id="tocsrequest.runtimesearch"></a>

```json
{
  "name": "string",
  "page": 0,
  "pageSize": 0,
  "status": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|status|string|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_request.RuntimeUpdate">request.RuntimeUpdate</h2>

<a id="schemarequest.runtimeupdate"></a>
<a id="schema_request.RuntimeUpdate"></a>
<a id="tocSrequest.runtimeupdate"></a>
<a id="tocsrequest.runtimeupdate"></a>

```json
{
  "clean": true,
  "codeDir": "string",
  "environments": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "exposedPorts": [
    {
      "containerPort": 0,
      "hostIP": "string",
      "hostPort": 0
    }
  ],
  "id": 0,
  "image": "string",
  "install": true,
  "name": "string",
  "params": {},
  "rebuild": true,
  "source": "string",
  "version": "string",
  "volumes": [
    {
      "source": "string",
      "target": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|clean|boolean|false|none||none|
|codeDir|string|false|none||none|
|environments|[[request.Environment](#schemarequest.environment)]|false|none||none|
|exposedPorts|[[request.ExposedPort](#schemarequest.exposedport)]|false|none||none|
|id|integer|false|none||none|
|image|string|false|none||none|
|install|boolean|false|none||none|
|name|string|false|none||none|
|params|object|false|none||none|
|rebuild|boolean|false|none||none|
|source|string|false|none||none|
|version|string|false|none||none|
|volumes|[[request.Volume](#schemarequest.volume)]|false|none||none|

<h2 id="tocS_request.SearchUploadWithPage">request.SearchUploadWithPage</h2>

<a id="schemarequest.searchuploadwithpage"></a>
<a id="schema_request.SearchUploadWithPage"></a>
<a id="tocSrequest.searchuploadwithpage"></a>
<a id="tocsrequest.searchuploadwithpage"></a>

```json
{
  "page": 0,
  "pageSize": 0,
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|path|string|true|none||none|

<h2 id="tocS_request.SupervisorProcessConfig">request.SupervisorProcessConfig</h2>

<a id="schemarequest.supervisorprocessconfig"></a>
<a id="schema_request.SupervisorProcessConfig"></a>
<a id="tocSrequest.supervisorprocessconfig"></a>
<a id="tocsrequest.supervisorprocessconfig"></a>

```json
{
  "command": "string",
  "dir": "string",
  "name": "string",
  "numprocs": "string",
  "operate": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|command|string|false|none||none|
|dir|string|false|none||none|
|name|string|false|none||none|
|numprocs|string|false|none||none|
|operate|string|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_request.SupervisorProcessFileReq">request.SupervisorProcessFileReq</h2>

<a id="schemarequest.supervisorprocessfilereq"></a>
<a id="schema_request.SupervisorProcessFileReq"></a>
<a id="tocSrequest.supervisorprocessfilereq"></a>
<a id="tocsrequest.supervisorprocessfilereq"></a>

```json
{
  "content": "string",
  "file": "out.log",
  "name": "string",
  "operate": "get"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|file|string|true|none||none|
|name|string|true|none||none|
|operate|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|file|out.log|
|file|err.log|
|file|config|
|operate|get|
|operate|clear|
|operate|update|

<h2 id="tocS_request.Volume">request.Volume</h2>

<a id="schemarequest.volume"></a>
<a id="schema_request.Volume"></a>
<a id="tocSrequest.volume"></a>
<a id="tocsrequest.volume"></a>

```json
{
  "source": "string",
  "target": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|source|string|false|none||none|
|target|string|false|none||none|

<h2 id="tocS_request.WebsiteAcmeAccountCreate">request.WebsiteAcmeAccountCreate</h2>

<a id="schemarequest.websiteacmeaccountcreate"></a>
<a id="schema_request.WebsiteAcmeAccountCreate"></a>
<a id="tocSrequest.websiteacmeaccountcreate"></a>
<a id="tocsrequest.websiteacmeaccountcreate"></a>

```json
{
  "eabHmacKey": "string",
  "eabKid": "string",
  "email": "string",
  "keyType": "P256",
  "type": "letsencrypt"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|eabHmacKey|string|false|none||none|
|eabKid|string|false|none||none|
|email|string|true|none||none|
|keyType|string|true|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|keyType|P256|
|keyType|P384|
|keyType|2048|
|keyType|3072|
|keyType|4096|
|keyType|8192|
|type|letsencrypt|
|type|zerossl|
|type|buypass|
|type|google|

<h2 id="tocS_request.WebsiteBatchDelReq">request.WebsiteBatchDelReq</h2>

<a id="schemarequest.websitebatchdelreq"></a>
<a id="schema_request.WebsiteBatchDelReq"></a>
<a id="tocSrequest.websitebatchdelreq"></a>
<a id="tocsrequest.websitebatchdelreq"></a>

```json
{
  "ids": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ids|[integer]|true|none||none|

<h2 id="tocS_request.WebsiteCACreate">request.WebsiteCACreate</h2>

<a id="schemarequest.websitecacreate"></a>
<a id="schema_request.WebsiteCACreate"></a>
<a id="tocSrequest.websitecacreate"></a>
<a id="tocsrequest.websitecacreate"></a>

```json
{
  "city": "string",
  "commonName": "string",
  "country": "string",
  "keyType": "P256",
  "name": "string",
  "organization": "string",
  "organizationUint": "string",
  "province": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|city|string|false|none||none|
|commonName|string|true|none||none|
|country|string|true|none||none|
|keyType|string|true|none||none|
|name|string|true|none||none|
|organization|string|true|none||none|
|organizationUint|string|false|none||none|
|province|string|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|keyType|P256|
|keyType|P384|
|keyType|2048|
|keyType|3072|
|keyType|4096|
|keyType|8192|

<h2 id="tocS_request.WebsiteCAObtain">request.WebsiteCAObtain</h2>

<a id="schemarequest.websitecaobtain"></a>
<a id="schema_request.WebsiteCAObtain"></a>
<a id="tocSrequest.websitecaobtain"></a>
<a id="tocsrequest.websitecaobtain"></a>

```json
{
  "autoRenew": true,
  "description": "string",
  "dir": "string",
  "domains": "string",
  "execShell": true,
  "id": 0,
  "keyType": "P256",
  "pushDir": true,
  "renew": true,
  "shell": "string",
  "sslID": 0,
  "time": 0,
  "unit": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|autoRenew|boolean|false|none||none|
|description|string|false|none||none|
|dir|string|false|none||none|
|domains|string|true|none||none|
|execShell|boolean|false|none||none|
|id|integer|true|none||none|
|keyType|string|true|none||none|
|pushDir|boolean|false|none||none|
|renew|boolean|false|none||none|
|shell|string|false|none||none|
|sslID|integer|false|none||none|
|time|integer|true|none||none|
|unit|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|keyType|P256|
|keyType|P384|
|keyType|2048|
|keyType|3072|
|keyType|4096|
|keyType|8192|

<h2 id="tocS_request.WebsiteCASearch">request.WebsiteCASearch</h2>

<a id="schemarequest.websitecasearch"></a>
<a id="schema_request.WebsiteCASearch"></a>
<a id="tocSrequest.websitecasearch"></a>
<a id="tocsrequest.websitecasearch"></a>

```json
{
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

<h2 id="tocS_request.WebsiteCommonReq">request.WebsiteCommonReq</h2>

<a id="schemarequest.websitecommonreq"></a>
<a id="schema_request.WebsiteCommonReq"></a>
<a id="tocSrequest.websitecommonreq"></a>
<a id="tocsrequest.websitecommonreq"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|

<h2 id="tocS_request.WebsiteCreate">request.WebsiteCreate</h2>

<a id="schemarequest.websitecreate"></a>
<a id="schema_request.WebsiteCreate"></a>
<a id="tocSrequest.websitecreate"></a>
<a id="tocsrequest.websitecreate"></a>

```json
{
  "IPV6": true,
  "alias": "string",
  "appID": 0,
  "appInstall": {
    "advanced": true,
    "allowPort": true,
    "appDetailID": 0,
    "containerName": "string",
    "cpuQuota": 0,
    "dockerCompose": "string",
    "editCompose": true,
    "gpuConfig": true,
    "hostMode": true,
    "memoryLimit": 0,
    "memoryUnit": "string",
    "name": "string",
    "params": {},
    "pullImage": true,
    "type": "string",
    "webUI": "string"
  },
  "appInstallID": 0,
  "appType": "new",
  "createDb": true,
  "dbFormat": "string",
  "dbHost": "string",
  "dbName": "string",
  "dbPassword": "string",
  "dbUser": "string",
  "domains": [
    {
      "domain": "string",
      "port": 0,
      "ssl": true
    }
  ],
  "enableSSL": true,
  "ftpPassword": "string",
  "ftpUser": "string",
  "parentWebsiteID": 0,
  "port": 0,
  "proxy": "string",
  "proxyType": "string",
  "remark": "string",
  "runtimeID": 0,
  "taskID": "string",
  "type": "string",
  "webSiteGroupID": 0,
  "websiteSSLID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|IPV6|boolean|false|none||none|
|alias|string|true|none||none|
|appID|integer|false|none||none|
|appInstall|[request.NewAppInstall](#schemarequest.newappinstall)|false|none||none|
|appInstallID|integer|false|none||none|
|appType|string|false|none||none|
|createDb|boolean|false|none||none|
|dbFormat|string|false|none||none|
|dbHost|string|false|none||none|
|dbName|string|false|none||none|
|dbPassword|string|false|none||none|
|dbUser|string|false|none||none|
|domains|[[request.WebsiteDomain](#schemarequest.websitedomain)]|false|none||none|
|enableSSL|boolean|false|none||none|
|ftpPassword|string|false|none||none|
|ftpUser|string|false|none||none|
|parentWebsiteID|integer|false|none||none|
|port|integer|false|none||none|
|proxy|string|false|none||none|
|proxyType|string|false|none||none|
|remark|string|false|none||none|
|runtimeID|integer|false|none||none|
|taskID|string|false|none||none|
|type|string|true|none||none|
|webSiteGroupID|integer|true|none||none|
|websiteSSLID|integer|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|appType|new|
|appType|installed|

<h2 id="tocS_request.WebsiteDNSReq">request.WebsiteDNSReq</h2>

<a id="schemarequest.websitednsreq"></a>
<a id="schema_request.WebsiteDNSReq"></a>
<a id="tocSrequest.websitednsreq"></a>
<a id="tocsrequest.websitednsreq"></a>

```json
{
  "acmeAccountId": 0,
  "domains": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|acmeAccountId|integer|true|none||none|
|domains|[string]|true|none||none|

<h2 id="tocS_request.WebsiteDefaultUpdate">request.WebsiteDefaultUpdate</h2>

<a id="schemarequest.websitedefaultupdate"></a>
<a id="schema_request.WebsiteDefaultUpdate"></a>
<a id="tocSrequest.websitedefaultupdate"></a>
<a id="tocsrequest.websitedefaultupdate"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|

<h2 id="tocS_request.WebsiteDelete">request.WebsiteDelete</h2>

<a id="schemarequest.websitedelete"></a>
<a id="schema_request.WebsiteDelete"></a>
<a id="tocSrequest.websitedelete"></a>
<a id="tocsrequest.websitedelete"></a>

```json
{
  "deleteApp": true,
  "deleteBackup": true,
  "forceDelete": true,
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|deleteApp|boolean|false|none||none|
|deleteBackup|boolean|false|none||none|
|forceDelete|boolean|false|none||none|
|id|integer|true|none||none|

<h2 id="tocS_request.WebsiteDnsAccountCreate">request.WebsiteDnsAccountCreate</h2>

<a id="schemarequest.websitednsaccountcreate"></a>
<a id="schema_request.WebsiteDnsAccountCreate"></a>
<a id="tocSrequest.websitednsaccountcreate"></a>
<a id="tocsrequest.websitednsaccountcreate"></a>

```json
{
  "authorization": {
    "property1": "string",
    "property2": "string"
  },
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|authorization|object|true|none||none|
|» **additionalProperties**|string|false|none||none|
|name|string|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.WebsiteDnsAccountUpdate">request.WebsiteDnsAccountUpdate</h2>

<a id="schemarequest.websitednsaccountupdate"></a>
<a id="schema_request.WebsiteDnsAccountUpdate"></a>
<a id="tocSrequest.websitednsaccountupdate"></a>
<a id="tocsrequest.websitednsaccountupdate"></a>

```json
{
  "authorization": {
    "property1": "string",
    "property2": "string"
  },
  "id": 0,
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|authorization|object|true|none||none|
|» **additionalProperties**|string|false|none||none|
|id|integer|true|none||none|
|name|string|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.WebsiteDomain">request.WebsiteDomain</h2>

<a id="schemarequest.websitedomain"></a>
<a id="schema_request.WebsiteDomain"></a>
<a id="tocSrequest.websitedomain"></a>
<a id="tocsrequest.websitedomain"></a>

```json
{
  "domain": "string",
  "port": 0,
  "ssl": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|domain|string|true|none||none|
|port|integer|false|none||none|
|ssl|boolean|false|none||none|

<h2 id="tocS_request.WebsiteDomainCreate">request.WebsiteDomainCreate</h2>

<a id="schemarequest.websitedomaincreate"></a>
<a id="schema_request.WebsiteDomainCreate"></a>
<a id="tocSrequest.websitedomaincreate"></a>
<a id="tocsrequest.websitedomaincreate"></a>

```json
{
  "domains": [
    {
      "domain": "string",
      "port": 0,
      "ssl": true
    }
  ],
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|domains|[[request.WebsiteDomain](#schemarequest.websitedomain)]|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.WebsiteDomainDelete">request.WebsiteDomainDelete</h2>

<a id="schemarequest.websitedomaindelete"></a>
<a id="schema_request.WebsiteDomainDelete"></a>
<a id="tocSrequest.websitedomaindelete"></a>
<a id="tocsrequest.websitedomaindelete"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|

<h2 id="tocS_request.WebsiteDomainUpdate">request.WebsiteDomainUpdate</h2>

<a id="schemarequest.websitedomainupdate"></a>
<a id="schema_request.WebsiteDomainUpdate"></a>
<a id="tocSrequest.websitedomainupdate"></a>
<a id="tocsrequest.websitedomainupdate"></a>

```json
{
  "id": 0,
  "ssl": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|ssl|boolean|false|none||none|

<h2 id="tocS_request.WebsiteHTTPSOp">request.WebsiteHTTPSOp</h2>

<a id="schemarequest.websitehttpsop"></a>
<a id="schema_request.WebsiteHTTPSOp"></a>
<a id="tocSrequest.websitehttpsop"></a>
<a id="tocsrequest.websitehttpsop"></a>

```json
{
  "SSLProtocol": [
    "string"
  ],
  "algorithm": "string",
  "certificate": "string",
  "certificatePath": "string",
  "enable": true,
  "hsts": true,
  "hstsIncludeSubDomains": true,
  "http3": true,
  "httpConfig": "HTTPSOnly",
  "httpsPorts": [
    0
  ],
  "importType": "string",
  "privateKey": "string",
  "privateKeyPath": "string",
  "type": "existed",
  "websiteId": 0,
  "websiteSSLId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|SSLProtocol|[string]|false|none||none|
|algorithm|string|false|none||none|
|certificate|string|false|none||none|
|certificatePath|string|false|none||none|
|enable|boolean|false|none||none|
|hsts|boolean|false|none||none|
|hstsIncludeSubDomains|boolean|false|none||none|
|http3|boolean|false|none||none|
|httpConfig|string|false|none||none|
|httpsPorts|[integer]|false|none||none|
|importType|string|false|none||none|
|privateKey|string|false|none||none|
|privateKeyPath|string|false|none||none|
|type|string|false|none||none|
|websiteId|integer|true|none||none|
|websiteSSLId|integer|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|httpConfig|HTTPSOnly|
|httpConfig|HTTPAlso|
|httpConfig|HTTPToHTTPS|
|type|existed|
|type|auto|
|type|manual|

<h2 id="tocS_request.WebsiteHtmlUpdate">request.WebsiteHtmlUpdate</h2>

<a id="schemarequest.websitehtmlupdate"></a>
<a id="schema_request.WebsiteHtmlUpdate"></a>
<a id="tocSrequest.websitehtmlupdate"></a>
<a id="tocsrequest.websitehtmlupdate"></a>

```json
{
  "content": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|true|none||none|
|type|string|true|none||none|

<h2 id="tocS_request.WebsiteInstallCheckReq">request.WebsiteInstallCheckReq</h2>

<a id="schemarequest.websiteinstallcheckreq"></a>
<a id="schema_request.WebsiteInstallCheckReq"></a>
<a id="tocSrequest.websiteinstallcheckreq"></a>
<a id="tocsrequest.websiteinstallcheckreq"></a>

```json
{
  "InstallIds": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|InstallIds|[integer]|false|none||none|

<h2 id="tocS_request.WebsiteLBCreate">request.WebsiteLBCreate</h2>

<a id="schemarequest.websitelbcreate"></a>
<a id="schema_request.WebsiteLBCreate"></a>
<a id="tocSrequest.websitelbcreate"></a>
<a id="tocsrequest.websitelbcreate"></a>

```json
{
  "algorithm": "string",
  "name": "string",
  "servers": [
    {
      "failTimeout": "string",
      "flag": "string",
      "maxConns": 0,
      "maxFails": 0,
      "server": "string",
      "weight": 0
    }
  ],
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|algorithm|string|false|none||none|
|name|string|true|none||none|
|servers|[[dto.NginxUpstreamServer](#schemadto.nginxupstreamserver)]|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.WebsiteLBDelete">request.WebsiteLBDelete</h2>

<a id="schemarequest.websitelbdelete"></a>
<a id="schema_request.WebsiteLBDelete"></a>
<a id="tocSrequest.websitelbdelete"></a>
<a id="tocsrequest.websitelbdelete"></a>

```json
{
  "name": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.WebsiteLBUpdate">request.WebsiteLBUpdate</h2>

<a id="schemarequest.websitelbupdate"></a>
<a id="schema_request.WebsiteLBUpdate"></a>
<a id="tocSrequest.websitelbupdate"></a>
<a id="tocsrequest.websitelbupdate"></a>

```json
{
  "algorithm": "string",
  "name": "string",
  "servers": [
    {
      "failTimeout": "string",
      "flag": "string",
      "maxConns": 0,
      "maxFails": 0,
      "server": "string",
      "weight": 0
    }
  ],
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|algorithm|string|false|none||none|
|name|string|true|none||none|
|servers|[[dto.NginxUpstreamServer](#schemadto.nginxupstreamserver)]|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.WebsiteLBUpdateFile">request.WebsiteLBUpdateFile</h2>

<a id="schemarequest.websitelbupdatefile"></a>
<a id="schema_request.WebsiteLBUpdateFile"></a>
<a id="tocSrequest.websitelbupdatefile"></a>
<a id="tocsrequest.websitelbupdatefile"></a>

```json
{
  "content": "string",
  "name": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|true|none||none|
|name|string|true|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.WebsiteLogReq">request.WebsiteLogReq</h2>

<a id="schemarequest.websitelogreq"></a>
<a id="schema_request.WebsiteLogReq"></a>
<a id="tocSrequest.websitelogreq"></a>
<a id="tocsrequest.websitelogreq"></a>

```json
{
  "id": 0,
  "logType": "string",
  "operate": "string",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|logType|string|true|none||none|
|operate|string|true|none||none|
|page|integer|false|none||none|
|pageSize|integer|false|none||none|

<h2 id="tocS_request.WebsiteNginxUpdate">request.WebsiteNginxUpdate</h2>

<a id="schemarequest.websitenginxupdate"></a>
<a id="schema_request.WebsiteNginxUpdate"></a>
<a id="tocSrequest.websitenginxupdate"></a>
<a id="tocsrequest.websitenginxupdate"></a>

```json
{
  "content": "string",
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|true|none||none|
|id|integer|true|none||none|

<h2 id="tocS_request.WebsiteOp">request.WebsiteOp</h2>

<a id="schemarequest.websiteop"></a>
<a id="schema_request.WebsiteOp"></a>
<a id="tocSrequest.websiteop"></a>
<a id="tocsrequest.websiteop"></a>

```json
{
  "id": 0,
  "operate": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|operate|string|false|none||none|

<h2 id="tocS_request.WebsitePHPVersionReq">request.WebsitePHPVersionReq</h2>

<a id="schemarequest.websitephpversionreq"></a>
<a id="schema_request.WebsitePHPVersionReq"></a>
<a id="tocSrequest.websitephpversionreq"></a>
<a id="tocsrequest.websitephpversionreq"></a>

```json
{
  "runtimeID": 0,
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|runtimeID|integer|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.WebsiteProxyConfig">request.WebsiteProxyConfig</h2>

<a id="schemarequest.websiteproxyconfig"></a>
<a id="schema_request.WebsiteProxyConfig"></a>
<a id="tocSrequest.websiteproxyconfig"></a>
<a id="tocsrequest.websiteproxyconfig"></a>

```json
{
  "cache": true,
  "cacheTime": 0,
  "cacheUnit": "string",
  "content": "string",
  "enable": true,
  "filePath": "string",
  "id": 0,
  "match": "string",
  "modifier": "string",
  "name": "string",
  "operate": "string",
  "proxyHost": "string",
  "proxyPass": "string",
  "proxySSLName": "string",
  "replaces": {
    "property1": "string",
    "property2": "string"
  },
  "sni": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cache|boolean|false|none||none|
|cacheTime|integer|false|none||none|
|cacheUnit|string|false|none||none|
|content|string|false|none||none|
|enable|boolean|false|none||none|
|filePath|string|false|none||none|
|id|integer|true|none||none|
|match|string|true|none||none|
|modifier|string|false|none||none|
|name|string|true|none||none|
|operate|string|true|none||none|
|proxyHost|string|true|none||none|
|proxyPass|string|true|none||none|
|proxySSLName|string|false|none||none|
|replaces|object|false|none||none|
|» **additionalProperties**|string|false|none||none|
|sni|boolean|false|none||none|

<h2 id="tocS_request.WebsiteProxyReq">request.WebsiteProxyReq</h2>

<a id="schemarequest.websiteproxyreq"></a>
<a id="schema_request.WebsiteProxyReq"></a>
<a id="tocSrequest.websiteproxyreq"></a>
<a id="tocsrequest.websiteproxyreq"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|

<h2 id="tocS_request.WebsiteRealIP">request.WebsiteRealIP</h2>

<a id="schemarequest.websiterealip"></a>
<a id="schema_request.WebsiteRealIP"></a>
<a id="tocSrequest.websiterealip"></a>
<a id="tocsrequest.websiterealip"></a>

```json
{
  "ipFrom": "string",
  "ipHeader": "string",
  "ipOther": "string",
  "open": true,
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ipFrom|string|false|none||none|
|ipHeader|string|false|none||none|
|ipOther|string|false|none||none|
|open|boolean|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_request.WebsiteResourceReq">request.WebsiteResourceReq</h2>

<a id="schemarequest.websiteresourcereq"></a>
<a id="schema_request.WebsiteResourceReq"></a>
<a id="tocSrequest.websiteresourcereq"></a>
<a id="tocsrequest.websiteresourcereq"></a>

```json
{
  "id": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|

<h2 id="tocS_request.WebsiteSSLApply">request.WebsiteSSLApply</h2>

<a id="schemarequest.websitesslapply"></a>
<a id="schema_request.WebsiteSSLApply"></a>
<a id="tocSrequest.websitesslapply"></a>
<a id="tocsrequest.websitesslapply"></a>

```json
{
  "ID": 0,
  "disableLog": true,
  "nameservers": [
    "string"
  ],
  "skipDNSCheck": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ID|integer|true|none||none|
|disableLog|boolean|false|none||none|
|nameservers|[string]|false|none||none|
|skipDNSCheck|boolean|false|none||none|

<h2 id="tocS_request.WebsiteSSLCreate">request.WebsiteSSLCreate</h2>

<a id="schemarequest.websitesslcreate"></a>
<a id="schema_request.WebsiteSSLCreate"></a>
<a id="tocSrequest.websitesslcreate"></a>
<a id="tocsrequest.websitesslcreate"></a>

```json
{
  "acmeAccountId": 0,
  "apply": true,
  "autoRenew": true,
  "description": "string",
  "dir": "string",
  "disableCNAME": true,
  "dnsAccountId": 0,
  "execShell": true,
  "id": 0,
  "keyType": "string",
  "nameserver1": "string",
  "nameserver2": "string",
  "otherDomains": "string",
  "primaryDomain": "string",
  "provider": "string",
  "pushDir": true,
  "shell": "string",
  "skipDNS": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|acmeAccountId|integer|true|none||none|
|apply|boolean|false|none||none|
|autoRenew|boolean|false|none||none|
|description|string|false|none||none|
|dir|string|false|none||none|
|disableCNAME|boolean|false|none||none|
|dnsAccountId|integer|false|none||none|
|execShell|boolean|false|none||none|
|id|integer|false|none||none|
|keyType|string|false|none||none|
|nameserver1|string|false|none||none|
|nameserver2|string|false|none||none|
|otherDomains|string|false|none||none|
|primaryDomain|string|true|none||none|
|provider|string|true|none||none|
|pushDir|boolean|false|none||none|
|shell|string|false|none||none|
|skipDNS|boolean|false|none||none|

<h2 id="tocS_request.WebsiteSSLSearch">request.WebsiteSSLSearch</h2>

<a id="schemarequest.websitesslsearch"></a>
<a id="schema_request.WebsiteSSLSearch"></a>
<a id="tocSrequest.websitesslsearch"></a>
<a id="tocsrequest.websitesslsearch"></a>

```json
{
  "acmeAccountID": "string",
  "page": 0,
  "pageSize": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|acmeAccountID|string|false|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|

<h2 id="tocS_request.WebsiteSSLUpdate">request.WebsiteSSLUpdate</h2>

<a id="schemarequest.websitesslupdate"></a>
<a id="schema_request.WebsiteSSLUpdate"></a>
<a id="tocSrequest.websitesslupdate"></a>
<a id="tocsrequest.websitesslupdate"></a>

```json
{
  "acmeAccountId": 0,
  "apply": true,
  "autoRenew": true,
  "description": "string",
  "dir": "string",
  "disableCNAME": true,
  "dnsAccountId": 0,
  "execShell": true,
  "id": 0,
  "keyType": "string",
  "nameserver1": "string",
  "nameserver2": "string",
  "otherDomains": "string",
  "primaryDomain": "string",
  "provider": "string",
  "pushDir": true,
  "shell": "string",
  "skipDNS": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|acmeAccountId|integer|false|none||none|
|apply|boolean|false|none||none|
|autoRenew|boolean|false|none||none|
|description|string|false|none||none|
|dir|string|false|none||none|
|disableCNAME|boolean|false|none||none|
|dnsAccountId|integer|false|none||none|
|execShell|boolean|false|none||none|
|id|integer|true|none||none|
|keyType|string|false|none||none|
|nameserver1|string|false|none||none|
|nameserver2|string|false|none||none|
|otherDomains|string|false|none||none|
|primaryDomain|string|true|none||none|
|provider|string|true|none||none|
|pushDir|boolean|false|none||none|
|shell|string|false|none||none|
|skipDNS|boolean|false|none||none|

<h2 id="tocS_request.WebsiteSSLUpload">request.WebsiteSSLUpload</h2>

<a id="schemarequest.websitesslupload"></a>
<a id="schema_request.WebsiteSSLUpload"></a>
<a id="tocSrequest.websitesslupload"></a>
<a id="tocsrequest.websitesslupload"></a>

```json
{
  "certificate": "string",
  "certificatePath": "string",
  "description": "string",
  "privateKey": "string",
  "privateKeyPath": "string",
  "sslID": 0,
  "type": "paste"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|certificate|string|false|none||none|
|certificatePath|string|false|none||none|
|description|string|false|none||none|
|privateKey|string|false|none||none|
|privateKeyPath|string|false|none||none|
|sslID|integer|false|none||none|
|type|string|true|none||none|

#### 枚举值

|属性|值|
|---|---|
|type|paste|
|type|local|

<h2 id="tocS_request.WebsiteSearch">request.WebsiteSearch</h2>

<a id="schemarequest.websitesearch"></a>
<a id="schema_request.WebsiteSearch"></a>
<a id="tocSrequest.websitesearch"></a>
<a id="tocsrequest.websitesearch"></a>

```json
{
  "name": "string",
  "order": "null",
  "orderBy": "primary_domain",
  "page": 0,
  "pageSize": 0,
  "websiteGroupId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|order|string|true|none||none|
|orderBy|string|true|none||none|
|page|integer|true|none||none|
|pageSize|integer|true|none||none|
|websiteGroupId|integer|false|none||none|

#### 枚举值

|属性|值|
|---|---|
|order|null|
|order|ascending|
|order|descending|
|orderBy|primary_domain|
|orderBy|type|
|orderBy|status|
|orderBy|createdAt|
|orderBy|expire_date|
|orderBy|created_at|

<h2 id="tocS_request.WebsiteUpdate">request.WebsiteUpdate</h2>

<a id="schemarequest.websiteupdate"></a>
<a id="schema_request.WebsiteUpdate"></a>
<a id="tocSrequest.websiteupdate"></a>
<a id="tocsrequest.websiteupdate"></a>

```json
{
  "IPV6": true,
  "expireDate": "string",
  "id": 0,
  "primaryDomain": "string",
  "remark": "string",
  "webSiteGroupID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|IPV6|boolean|false|none||none|
|expireDate|string|false|none||none|
|id|integer|true|none||none|
|primaryDomain|string|true|none||none|
|remark|string|false|none||none|
|webSiteGroupID|integer|false|none||none|

<h2 id="tocS_request.WebsiteUpdateDir">request.WebsiteUpdateDir</h2>

<a id="schemarequest.websiteupdatedir"></a>
<a id="schema_request.WebsiteUpdateDir"></a>
<a id="tocSrequest.websiteupdatedir"></a>
<a id="tocsrequest.websiteupdatedir"></a>

```json
{
  "id": 0,
  "siteDir": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|true|none||none|
|siteDir|string|true|none||none|

<h2 id="tocS_request.WebsiteUpdateDirPermission">request.WebsiteUpdateDirPermission</h2>

<a id="schemarequest.websiteupdatedirpermission"></a>
<a id="schema_request.WebsiteUpdateDirPermission"></a>
<a id="tocSrequest.websiteupdatedirpermission"></a>
<a id="tocsrequest.websiteupdatedirpermission"></a>

```json
{
  "group": "string",
  "id": 0,
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|group|string|true|none||none|
|id|integer|true|none||none|
|user|string|true|none||none|

<h2 id="tocS_response.AppConfig">response.AppConfig</h2>

<a id="schemaresponse.appconfig"></a>
<a id="schema_response.AppConfig"></a>
<a id="tocSresponse.appconfig"></a>
<a id="tocsresponse.appconfig"></a>

```json
{
  "advanced": true,
  "allowPort": true,
  "containerName": "string",
  "cpuQuota": 0,
  "dockerCompose": "string",
  "editCompose": true,
  "gpuConfig": true,
  "hostMode": true,
  "memoryLimit": 0,
  "memoryUnit": "string",
  "params": [
    {
      "edit": true,
      "key": "string",
      "labelEn": "string",
      "labelZh": "string",
      "multiple": true,
      "required": true,
      "rule": "string",
      "showValue": "string",
      "type": "string",
      "value": null,
      "values": null
    }
  ],
  "pullImage": true,
  "type": "string",
  "webUI": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|advanced|boolean|false|none||none|
|allowPort|boolean|false|none||none|
|containerName|string|false|none||none|
|cpuQuota|number|false|none||none|
|dockerCompose|string|false|none||none|
|editCompose|boolean|false|none||none|
|gpuConfig|boolean|false|none||none|
|hostMode|boolean|false|none||none|
|memoryLimit|number|false|none||none|
|memoryUnit|string|false|none||none|
|params|[[response.AppParam](#schemaresponse.appparam)]|false|none||none|
|pullImage|boolean|false|none||none|
|type|string|false|none||none|
|webUI|string|false|none||none|

<h2 id="tocS_response.AppDTO">response.AppDTO</h2>

<a id="schemaresponse.appdto"></a>
<a id="schema_response.AppDTO"></a>
<a id="tocSresponse.appdto"></a>
<a id="tocsresponse.appdto"></a>

```json
{
  "architectures": "string",
  "createdAt": "string",
  "crossVersionUpdate": true,
  "description": "string",
  "document": "string",
  "github": "string",
  "gpuSupport": true,
  "icon": "string",
  "id": 0,
  "installed": true,
  "key": "string",
  "lastModified": 0,
  "limit": 0,
  "memoryRequired": 0,
  "name": "string",
  "readMe": "string",
  "recommend": 0,
  "required": "string",
  "requiredPanelVersion": 0,
  "resource": "string",
  "shortDescEn": "string",
  "shortDescZh": "string",
  "status": "string",
  "tags": [
    {
      "id": 0,
      "key": "string",
      "name": "string"
    }
  ],
  "type": "string",
  "updatedAt": "string",
  "versions": [
    "string"
  ],
  "website": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|architectures|string|false|none||none|
|createdAt|string|false|none||none|
|crossVersionUpdate|boolean|false|none||none|
|description|string|false|none||none|
|document|string|false|none||none|
|github|string|false|none||none|
|gpuSupport|boolean|false|none||none|
|icon|string|false|none||none|
|id|integer|false|none||none|
|installed|boolean|false|none||none|
|key|string|false|none||none|
|lastModified|integer|false|none||none|
|limit|integer|false|none||none|
|memoryRequired|integer|false|none||none|
|name|string|false|none||none|
|readMe|string|false|none||none|
|recommend|integer|false|none||none|
|required|string|false|none||none|
|requiredPanelVersion|number|false|none||none|
|resource|string|false|none||none|
|shortDescEn|string|false|none||none|
|shortDescZh|string|false|none||none|
|status|string|false|none||none|
|tags|[[response.TagDTO](#schemaresponse.tagdto)]|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|versions|[string]|false|none||none|
|website|string|false|none||none|

<h2 id="tocS_response.AppDetailDTO">response.AppDetailDTO</h2>

<a id="schemaresponse.appdetaildto"></a>
<a id="schema_response.AppDetailDTO"></a>
<a id="tocSresponse.appdetaildto"></a>
<a id="tocsresponse.appdetaildto"></a>

```json
{
  "appId": 0,
  "architectures": "string",
  "createdAt": "string",
  "dockerCompose": "string",
  "downloadCallBackUrl": "string",
  "downloadUrl": "string",
  "enable": true,
  "gpuSupport": true,
  "hostMode": true,
  "id": 0,
  "ignoreUpgrade": true,
  "image": "string",
  "lastModified": 0,
  "lastVersion": "string",
  "memoryRequired": 0,
  "params": null,
  "status": "string",
  "update": true,
  "updatedAt": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appId|integer|false|none||none|
|architectures|string|false|none||none|
|createdAt|string|false|none||none|
|dockerCompose|string|false|none||none|
|downloadCallBackUrl|string|false|none||none|
|downloadUrl|string|false|none||none|
|enable|boolean|false|none||none|
|gpuSupport|boolean|false|none||none|
|hostMode|boolean|false|none||none|
|id|integer|false|none||none|
|ignoreUpgrade|boolean|false|none||none|
|image|string|false|none||none|
|lastModified|integer|false|none||none|
|lastVersion|string|false|none||none|
|memoryRequired|integer|false|none||none|
|params|any|false|none||none|
|status|string|false|none||none|
|update|boolean|false|none||none|
|updatedAt|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_response.AppInstalledCheck">response.AppInstalledCheck</h2>

<a id="schemaresponse.appinstalledcheck"></a>
<a id="schema_response.AppInstalledCheck"></a>
<a id="tocSresponse.appinstalledcheck"></a>
<a id="tocsresponse.appinstalledcheck"></a>

```json
{
  "app": "string",
  "appInstallId": 0,
  "containerName": "string",
  "createdAt": "string",
  "httpPort": 0,
  "httpsPort": 0,
  "installPath": "string",
  "isExist": true,
  "lastBackupAt": "string",
  "name": "string",
  "status": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|app|string|false|none||none|
|appInstallId|integer|false|none||none|
|containerName|string|false|none||none|
|createdAt|string|false|none||none|
|httpPort|integer|false|none||none|
|httpsPort|integer|false|none||none|
|installPath|string|false|none||none|
|isExist|boolean|false|none||none|
|lastBackupAt|string|false|none||none|
|name|string|false|none||none|
|status|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_response.AppItem">response.AppItem</h2>

<a id="schemaresponse.appitem"></a>
<a id="schema_response.AppItem"></a>
<a id="tocSresponse.appitem"></a>
<a id="tocsresponse.appitem"></a>

```json
{
  "description": "string",
  "github": "string",
  "gpuSupport": true,
  "icon": "string",
  "id": 0,
  "installed": true,
  "key": "string",
  "limit": 0,
  "name": "string",
  "recommend": 0,
  "resource": "string",
  "status": "string",
  "tags": [
    {
      "id": 0,
      "key": "string",
      "name": "string"
    }
  ],
  "type": "string",
  "versions": [
    "string"
  ],
  "website": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|description|string|false|none||none|
|github|string|false|none||none|
|gpuSupport|boolean|false|none||none|
|icon|string|false|none||none|
|id|integer|false|none||none|
|installed|boolean|false|none||none|
|key|string|false|none||none|
|limit|integer|false|none||none|
|name|string|false|none||none|
|recommend|integer|false|none||none|
|resource|string|false|none||none|
|status|string|false|none||none|
|tags|[[response.TagDTO](#schemaresponse.tagdto)]|false|none||none|
|type|string|false|none||none|
|versions|[string]|false|none||none|
|website|string|false|none||none|

<h2 id="tocS_response.AppParam">response.AppParam</h2>

<a id="schemaresponse.appparam"></a>
<a id="schema_response.AppParam"></a>
<a id="tocSresponse.appparam"></a>
<a id="tocsresponse.appparam"></a>

```json
{
  "edit": true,
  "key": "string",
  "labelEn": "string",
  "labelZh": "string",
  "multiple": true,
  "required": true,
  "rule": "string",
  "showValue": "string",
  "type": "string",
  "value": null,
  "values": null
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|edit|boolean|false|none||none|
|key|string|false|none||none|
|labelEn|string|false|none||none|
|labelZh|string|false|none||none|
|multiple|boolean|false|none||none|
|required|boolean|false|none||none|
|rule|string|false|none||none|
|showValue|string|false|none||none|
|type|string|false|none||none|
|value|any|false|none||none|
|values|any|false|none||none|

<h2 id="tocS_response.AppRes">response.AppRes</h2>

<a id="schemaresponse.appres"></a>
<a id="schema_response.AppRes"></a>
<a id="tocSresponse.appres"></a>
<a id="tocsresponse.appres"></a>

```json
{
  "items": [
    {
      "description": "string",
      "github": "string",
      "gpuSupport": true,
      "icon": "string",
      "id": 0,
      "installed": true,
      "key": "string",
      "limit": 0,
      "name": "string",
      "recommend": 0,
      "resource": "string",
      "status": "string",
      "tags": [
        {
          "id": 0,
          "key": "string",
          "name": "string"
        }
      ],
      "type": "string",
      "versions": [
        "string"
      ],
      "website": "string"
    }
  ],
  "total": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|items|[[response.AppItem](#schemaresponse.appitem)]|false|none||none|
|total|integer|false|none||none|

<h2 id="tocS_response.AppService">response.AppService</h2>

<a id="schemaresponse.appservice"></a>
<a id="schema_response.AppService"></a>
<a id="tocSresponse.appservice"></a>
<a id="tocsresponse.appservice"></a>

```json
{
  "config": null,
  "from": "string",
  "label": "string",
  "status": "string",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|config|any|false|none||none|
|from|string|false|none||none|
|label|string|false|none||none|
|status|string|false|none||none|
|value|string|false|none||none|

<h2 id="tocS_response.AppUpdateRes">response.AppUpdateRes</h2>

<a id="schemaresponse.appupdateres"></a>
<a id="schema_response.AppUpdateRes"></a>
<a id="tocSresponse.appupdateres"></a>
<a id="tocsresponse.appupdateres"></a>

```json
{
  "appList": {
    "additionalProperties": {
      "tags": [
        {
          "key": "string",
          "locales": {},
          "name": "string",
          "sort": 0
        }
      ],
      "version": "string"
    },
    "apps": [
      {
        "additionalProperties": {
          "Required": [
            null
          ],
          "architectures": [
            null
          ],
          "crossVersionUpdate": true,
          "description": {},
          "document": "string",
          "github": "string",
          "gpuSupport": true,
          "key": "string",
          "limit": 0,
          "memoryRequired": 0,
          "name": "string",
          "recommend": 0,
          "shortDescEn": "string",
          "shortDescZh": "string",
          "tags": [
            null
          ],
          "type": "string",
          "version": 0,
          "website": "string"
        },
        "icon": "string",
        "lastModified": 0,
        "name": "string",
        "readMe": "string",
        "versions": [
          {
            "additionalProperties": null,
            "downloadCallBackUrl": null,
            "downloadUrl": null,
            "lastModified": null,
            "name": null
          }
        ]
      }
    ],
    "lastModified": 0,
    "valid": true,
    "violations": [
      "string"
    ]
  },
  "appStoreLastModified": 0,
  "canUpdate": true,
  "isSyncing": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appList|[dto.AppList](#schemadto.applist)|false|none||none|
|appStoreLastModified|integer|false|none||none|
|canUpdate|boolean|false|none||none|
|isSyncing|boolean|false|none||none|

<h2 id="tocS_response.AppstoreConfig">response.AppstoreConfig</h2>

<a id="schemaresponse.appstoreconfig"></a>
<a id="schema_response.AppstoreConfig"></a>
<a id="tocSresponse.appstoreconfig"></a>
<a id="tocsresponse.appstoreconfig"></a>

```json
{
  "defaultDomain": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|defaultDomain|string|false|none||none|

<h2 id="tocS_response.Database">response.Database</h2>

<a id="schemaresponse.database"></a>
<a id="schema_response.Database"></a>
<a id="tocSresponse.database"></a>
<a id="tocsresponse.database"></a>

```json
{
  "id": 0,
  "name": "string",
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|name|string|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_response.DatabaseConn">response.DatabaseConn</h2>

<a id="schemaresponse.databaseconn"></a>
<a id="schema_response.DatabaseConn"></a>
<a id="tocSresponse.databaseconn"></a>
<a id="tocsresponse.databaseconn"></a>

```json
{
  "containerName": "string",
  "password": "string",
  "port": 0,
  "serviceName": "string",
  "status": "string",
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|containerName|string|false|none||none|
|password|string|false|none||none|
|port|integer|false|none||none|
|serviceName|string|false|none||none|
|status|string|false|none||none|
|username|string|false|none||none|

<h2 id="tocS_response.DirSizeRes">response.DirSizeRes</h2>

<a id="schemaresponse.dirsizeres"></a>
<a id="schema_response.DirSizeRes"></a>
<a id="tocSresponse.dirsizeres"></a>
<a id="tocsresponse.dirsizeres"></a>

```json
{
  "size": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|size|integer|true|none||none|

<h2 id="tocS_response.FileInfo">response.FileInfo</h2>

<a id="schemaresponse.fileinfo"></a>
<a id="schema_response.FileInfo"></a>
<a id="tocSresponse.fileinfo"></a>
<a id="tocsresponse.fileinfo"></a>

```json
{
  "content": "string",
  "extension": "string",
  "favoriteID": 0,
  "gid": "string",
  "group": "string",
  "isDetail": true,
  "isDir": true,
  "isHidden": true,
  "isSymlink": true,
  "itemTotal": 0,
  "items": [
    {
      "content": "string",
      "extension": "string",
      "favoriteID": 0,
      "gid": "string",
      "group": "string",
      "isDetail": true,
      "isDir": true,
      "isHidden": true,
      "isSymlink": true,
      "itemTotal": 0,
      "items": [
        {
          "content": "string",
          "extension": "string",
          "favoriteID": 0,
          "gid": "string",
          "group": "string",
          "isDetail": true,
          "isDir": true,
          "isHidden": true,
          "isSymlink": true,
          "itemTotal": 0,
          "items": [
            {}
          ],
          "linkPath": "string",
          "mimeType": "string",
          "modTime": "string",
          "mode": "string",
          "name": "string",
          "path": "string",
          "size": 0,
          "type": "string",
          "uid": "string",
          "updateTime": "string",
          "user": "string"
        }
      ],
      "linkPath": "string",
      "mimeType": "string",
      "modTime": "string",
      "mode": "string",
      "name": "string",
      "path": "string",
      "size": 0,
      "type": "string",
      "uid": "string",
      "updateTime": "string",
      "user": "string"
    }
  ],
  "linkPath": "string",
  "mimeType": "string",
  "modTime": "string",
  "mode": "string",
  "name": "string",
  "path": "string",
  "size": 0,
  "type": "string",
  "uid": "string",
  "updateTime": "string",
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|extension|string|false|none||none|
|favoriteID|integer|false|none||none|
|gid|string|false|none||none|
|group|string|false|none||none|
|isDetail|boolean|false|none||none|
|isDir|boolean|false|none||none|
|isHidden|boolean|false|none||none|
|isSymlink|boolean|false|none||none|
|itemTotal|integer|false|none||none|
|items|[[files.FileInfo](#schemafiles.fileinfo)]|false|none||none|
|linkPath|string|false|none||none|
|mimeType|string|false|none||none|
|modTime|string|false|none||none|
|mode|string|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|size|integer|false|none||none|
|type|string|false|none||none|
|uid|string|false|none||none|
|updateTime|string|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_response.FileLineContent">response.FileLineContent</h2>

<a id="schemaresponse.filelinecontent"></a>
<a id="schema_response.FileLineContent"></a>
<a id="tocSresponse.filelinecontent"></a>
<a id="tocsresponse.filelinecontent"></a>

```json
{
  "content": "string",
  "end": true,
  "lines": [
    "string"
  ],
  "path": "string",
  "total": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|end|boolean|false|none||none|
|lines|[string]|false|none||none|
|path|string|false|none||none|
|total|integer|false|none||none|

<h2 id="tocS_response.FileTree">response.FileTree</h2>

<a id="schemaresponse.filetree"></a>
<a id="schema_response.FileTree"></a>
<a id="tocSresponse.filetree"></a>
<a id="tocsresponse.filetree"></a>

```json
{
  "children": [
    {
      "children": [
        {
          "children": [
            {}
          ],
          "extension": "string",
          "id": "string",
          "isDir": true,
          "name": "string",
          "path": "string"
        }
      ],
      "extension": "string",
      "id": "string",
      "isDir": true,
      "name": "string",
      "path": "string"
    }
  ],
  "extension": "string",
  "id": "string",
  "isDir": true,
  "name": "string",
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|children|[[response.FileTree](#schemaresponse.filetree)]|false|none||none|
|extension|string|false|none||none|
|id|string|false|none||none|
|isDir|boolean|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|

<h2 id="tocS_response.FileWgetRes">response.FileWgetRes</h2>

<a id="schemaresponse.filewgetres"></a>
<a id="schema_response.FileWgetRes"></a>
<a id="tocSresponse.filewgetres"></a>
<a id="tocsresponse.filewgetres"></a>

```json
{
  "key": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|string|false|none||none|

<h2 id="tocS_response.HostToolConfig">response.HostToolConfig</h2>

<a id="schemaresponse.hosttoolconfig"></a>
<a id="schema_response.HostToolConfig"></a>
<a id="tocSresponse.hosttoolconfig"></a>
<a id="tocsresponse.hosttoolconfig"></a>

```json
{
  "content": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|

<h2 id="tocS_response.HostToolRes">response.HostToolRes</h2>

<a id="schemaresponse.hosttoolres"></a>
<a id="schema_response.HostToolRes"></a>
<a id="tocSresponse.hosttoolres"></a>
<a id="tocsresponse.hosttoolres"></a>

```json
{
  "config": null,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|config|any|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_response.IgnoredApp">response.IgnoredApp</h2>

<a id="schemaresponse.ignoredapp"></a>
<a id="schema_response.IgnoredApp"></a>
<a id="tocSresponse.ignoredapp"></a>
<a id="tocsresponse.ignoredapp"></a>

```json
{
  "detailID": 0,
  "icon": "string",
  "name": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|detailID|integer|false|none||none|
|icon|string|false|none||none|
|name|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_response.NginxAntiLeechRes">response.NginxAntiLeechRes</h2>

<a id="schemaresponse.nginxantileechres"></a>
<a id="schema_response.NginxAntiLeechRes"></a>
<a id="tocSresponse.nginxantileechres"></a>
<a id="tocsresponse.nginxantileechres"></a>

```json
{
  "blocked": true,
  "cache": true,
  "cacheTime": 0,
  "cacheUint": "string",
  "enable": true,
  "extends": "string",
  "logEnable": true,
  "noneRef": true,
  "return": "string",
  "serverNames": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|blocked|boolean|false|none||none|
|cache|boolean|false|none||none|
|cacheTime|integer|false|none||none|
|cacheUint|string|false|none||none|
|enable|boolean|false|none||none|
|extends|string|false|none||none|
|logEnable|boolean|false|none||none|
|noneRef|boolean|false|none||none|
|return|string|false|none||none|
|serverNames|[string]|false|none||none|

<h2 id="tocS_response.NginxAuthRes">response.NginxAuthRes</h2>

<a id="schemaresponse.nginxauthres"></a>
<a id="schema_response.NginxAuthRes"></a>
<a id="tocSresponse.nginxauthres"></a>
<a id="tocsresponse.nginxauthres"></a>

```json
{
  "enable": true,
  "items": [
    {
      "remark": "string",
      "username": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|enable|boolean|false|none||none|
|items|[[dto.NginxAuth](#schemadto.nginxauth)]|false|none||none|

<h2 id="tocS_response.NginxBuildConfig">response.NginxBuildConfig</h2>

<a id="schemaresponse.nginxbuildconfig"></a>
<a id="schema_response.NginxBuildConfig"></a>
<a id="tocSresponse.nginxbuildconfig"></a>
<a id="tocsresponse.nginxbuildconfig"></a>

```json
{
  "mirror": "string",
  "modules": [
    {
      "enable": true,
      "name": "string",
      "packages": "string",
      "params": "string",
      "script": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|mirror|string|false|none||none|
|modules|[[response.NginxModule](#schemaresponse.nginxmodule)]|false|none||none|

<h2 id="tocS_response.NginxFile">response.NginxFile</h2>

<a id="schemaresponse.nginxfile"></a>
<a id="schema_response.NginxFile"></a>
<a id="tocSresponse.nginxfile"></a>
<a id="tocsresponse.nginxfile"></a>

```json
{
  "content": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|

<h2 id="tocS_response.NginxModule">response.NginxModule</h2>

<a id="schemaresponse.nginxmodule"></a>
<a id="schema_response.NginxModule"></a>
<a id="tocSresponse.nginxmodule"></a>
<a id="tocsresponse.nginxmodule"></a>

```json
{
  "enable": true,
  "name": "string",
  "packages": "string",
  "params": "string",
  "script": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|enable|boolean|false|none||none|
|name|string|false|none||none|
|packages|string|false|none||none|
|params|string|false|none||none|
|script|string|false|none||none|

<h2 id="tocS_response.NginxParam">response.NginxParam</h2>

<a id="schemaresponse.nginxparam"></a>
<a id="schema_response.NginxParam"></a>
<a id="tocSresponse.nginxparam"></a>
<a id="tocsresponse.nginxparam"></a>

```json
{
  "name": "string",
  "params": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|params|[string]|false|none||none|

<h2 id="tocS_response.NginxPathAuthRes">response.NginxPathAuthRes</h2>

<a id="schemaresponse.nginxpathauthres"></a>
<a id="schema_response.NginxPathAuthRes"></a>
<a id="tocSresponse.nginxpathauthres"></a>
<a id="tocsresponse.nginxpathauthres"></a>

```json
{
  "name": "string",
  "path": "string",
  "remark": "string",
  "username": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|path|string|false|none||none|
|remark|string|false|none||none|
|username|string|false|none||none|

<h2 id="tocS_response.NginxProxyCache">response.NginxProxyCache</h2>

<a id="schemaresponse.nginxproxycache"></a>
<a id="schema_response.NginxProxyCache"></a>
<a id="tocSresponse.nginxproxycache"></a>
<a id="tocsresponse.nginxproxycache"></a>

```json
{
  "cacheExpire": 0,
  "cacheExpireUnit": "string",
  "cacheLimit": 0,
  "cacheLimitUnit": "string",
  "open": true,
  "shareCache": 0,
  "shareCacheUnit": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|cacheExpire|integer|false|none||none|
|cacheExpireUnit|string|false|none||none|
|cacheLimit|number|false|none||none|
|cacheLimitUnit|string|false|none||none|
|open|boolean|false|none||none|
|shareCache|integer|false|none||none|
|shareCacheUnit|string|false|none||none|

<h2 id="tocS_response.NginxRedirectConfig">response.NginxRedirectConfig</h2>

<a id="schemaresponse.nginxredirectconfig"></a>
<a id="schema_response.NginxRedirectConfig"></a>
<a id="tocSresponse.nginxredirectconfig"></a>
<a id="tocsresponse.nginxredirectconfig"></a>

```json
{
  "content": "string",
  "domains": [
    "string"
  ],
  "enable": true,
  "filePath": "string",
  "keepPath": true,
  "name": "string",
  "path": "string",
  "redirect": "string",
  "redirectRoot": true,
  "target": "string",
  "type": "string",
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|domains|[string]|false|none||none|
|enable|boolean|false|none||none|
|filePath|string|false|none||none|
|keepPath|boolean|false|none||none|
|name|string|false|none||none|
|path|string|false|none||none|
|redirect|string|false|none||none|
|redirectRoot|boolean|false|none||none|
|target|string|false|none||none|
|type|string|false|none||none|
|websiteID|integer|false|none||none|

<h2 id="tocS_response.NginxRewriteRes">response.NginxRewriteRes</h2>

<a id="schemaresponse.nginxrewriteres"></a>
<a id="schema_response.NginxRewriteRes"></a>
<a id="tocSresponse.nginxrewriteres"></a>
<a id="tocsresponse.nginxrewriteres"></a>

```json
{
  "content": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|

<h2 id="tocS_response.NginxStatus">response.NginxStatus</h2>

<a id="schemaresponse.nginxstatus"></a>
<a id="schema_response.NginxStatus"></a>
<a id="tocSresponse.nginxstatus"></a>
<a id="tocsresponse.nginxstatus"></a>

```json
{
  "accepts": 0,
  "active": 0,
  "handled": 0,
  "reading": 0,
  "requests": 0,
  "waiting": 0,
  "writing": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|accepts|integer|false|none||none|
|active|integer|false|none||none|
|handled|integer|false|none||none|
|reading|integer|false|none||none|
|requests|integer|false|none||none|
|waiting|integer|false|none||none|
|writing|integer|false|none||none|

<h2 id="tocS_response.NodeModule">response.NodeModule</h2>

<a id="schemaresponse.nodemodule"></a>
<a id="schema_response.NodeModule"></a>
<a id="tocSresponse.nodemodule"></a>
<a id="tocsresponse.nodemodule"></a>

```json
{
  "description": "string",
  "license": "string",
  "name": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|description|string|false|none||none|
|license|string|false|none||none|
|name|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_response.PHPConfig">response.PHPConfig</h2>

<a id="schemaresponse.phpconfig"></a>
<a id="schema_response.PHPConfig"></a>
<a id="tocSresponse.phpconfig"></a>
<a id="tocsresponse.phpconfig"></a>

```json
{
  "disableFunctions": [
    "string"
  ],
  "params": {
    "property1": "string",
    "property2": "string"
  },
  "uploadMaxSize": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|disableFunctions|[string]|false|none||none|
|params|object|false|none||none|
|» **additionalProperties**|string|false|none||none|
|uploadMaxSize|string|false|none||none|

<h2 id="tocS_response.PHPExtensionRes">response.PHPExtensionRes</h2>

<a id="schemaresponse.phpextensionres"></a>
<a id="schema_response.PHPExtensionRes"></a>
<a id="tocSresponse.phpextensionres"></a>
<a id="tocsresponse.phpextensionres"></a>

```json
{
  "extensions": [
    "string"
  ],
  "supportExtensions": [
    {
      "check": "string",
      "description": "string",
      "file": "string",
      "installed": true,
      "name": "string",
      "versions": [
        "string"
      ]
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|extensions|[string]|false|none||none|
|supportExtensions|[[response.SupportExtension](#schemaresponse.supportextension)]|false|none||none|

<h2 id="tocS_response.PackageScripts">response.PackageScripts</h2>

<a id="schemaresponse.packagescripts"></a>
<a id="schema_response.PackageScripts"></a>
<a id="tocSresponse.packagescripts"></a>
<a id="tocsresponse.packagescripts"></a>

```json
{
  "name": "string",
  "script": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|name|string|false|none||none|
|script|string|false|none||none|

<h2 id="tocS_response.ProcessStatus">response.ProcessStatus</h2>

<a id="schemaresponse.processstatus"></a>
<a id="schema_response.ProcessStatus"></a>
<a id="tocSresponse.processstatus"></a>
<a id="tocsresponse.processstatus"></a>

```json
{
  "PID": "string",
  "msg": "string",
  "name": "string",
  "status": "string",
  "uptime": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|PID|string|false|none||none|
|msg|string|false|none||none|
|name|string|false|none||none|
|status|string|false|none||none|
|uptime|string|false|none||none|

<h2 id="tocS_response.Resource">response.Resource</h2>

<a id="schemaresponse.resource"></a>
<a id="schema_response.Resource"></a>
<a id="tocSresponse.resource"></a>
<a id="tocsresponse.resource"></a>

```json
{
  "detail": null,
  "name": "string",
  "resourceID": 0,
  "type": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|detail|any|false|none||none|
|name|string|false|none||none|
|resourceID|integer|false|none||none|
|type|string|false|none||none|

<h2 id="tocS_response.RuntimeDTO">response.RuntimeDTO</h2>

<a id="schemaresponse.runtimedto"></a>
<a id="schema_response.RuntimeDTO"></a>
<a id="tocSresponse.runtimedto"></a>
<a id="tocsresponse.runtimedto"></a>

```json
{
  "appDetailID": 0,
  "appID": 0,
  "appParams": [
    {
      "edit": true,
      "key": "string",
      "labelEn": "string",
      "labelZh": "string",
      "multiple": true,
      "required": true,
      "rule": "string",
      "showValue": "string",
      "type": "string",
      "value": null,
      "values": null
    }
  ],
  "codeDir": "string",
  "containerStatus": "string",
  "createdAt": "string",
  "environments": [
    {
      "key": "string",
      "value": "string"
    }
  ],
  "exposedPorts": [
    {
      "containerPort": 0,
      "hostIP": "string",
      "hostPort": 0
    }
  ],
  "id": 0,
  "image": "string",
  "message": "string",
  "name": "string",
  "params": {},
  "path": "string",
  "port": "string",
  "resource": "string",
  "source": "string",
  "status": "string",
  "type": "string",
  "version": "string",
  "volumes": [
    {
      "source": "string",
      "target": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appDetailID|integer|false|none||none|
|appID|integer|false|none||none|
|appParams|[[response.AppParam](#schemaresponse.appparam)]|false|none||none|
|codeDir|string|false|none||none|
|containerStatus|string|false|none||none|
|createdAt|string|false|none||none|
|environments|[[request.Environment](#schemarequest.environment)]|false|none||none|
|exposedPorts|[[request.ExposedPort](#schemarequest.exposedport)]|false|none||none|
|id|integer|false|none||none|
|image|string|false|none||none|
|message|string|false|none||none|
|name|string|false|none||none|
|params|object|false|none||none|
|path|string|false|none||none|
|port|string|false|none||none|
|resource|string|false|none||none|
|source|string|false|none||none|
|status|string|false|none||none|
|type|string|false|none||none|
|version|string|false|none||none|
|volumes|[[request.Volume](#schemarequest.volume)]|false|none||none|

<h2 id="tocS_response.SupervisorProcessConfig">response.SupervisorProcessConfig</h2>

<a id="schemaresponse.supervisorprocessconfig"></a>
<a id="schema_response.SupervisorProcessConfig"></a>
<a id="tocSresponse.supervisorprocessconfig"></a>
<a id="tocsresponse.supervisorprocessconfig"></a>

```json
{
  "command": "string",
  "dir": "string",
  "msg": "string",
  "name": "string",
  "numprocs": "string",
  "status": [
    {
      "PID": "string",
      "msg": "string",
      "name": "string",
      "status": "string",
      "uptime": "string"
    }
  ],
  "user": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|command|string|false|none||none|
|dir|string|false|none||none|
|msg|string|false|none||none|
|name|string|false|none||none|
|numprocs|string|false|none||none|
|status|[[response.ProcessStatus](#schemaresponse.processstatus)]|false|none||none|
|user|string|false|none||none|

<h2 id="tocS_response.SupportExtension">response.SupportExtension</h2>

<a id="schemaresponse.supportextension"></a>
<a id="schema_response.SupportExtension"></a>
<a id="tocSresponse.supportextension"></a>
<a id="tocsresponse.supportextension"></a>

```json
{
  "check": "string",
  "description": "string",
  "file": "string",
  "installed": true,
  "name": "string",
  "versions": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|check|string|false|none||none|
|description|string|false|none||none|
|file|string|false|none||none|
|installed|boolean|false|none||none|
|name|string|false|none||none|
|versions|[string]|false|none||none|

<h2 id="tocS_response.TagDTO">response.TagDTO</h2>

<a id="schemaresponse.tagdto"></a>
<a id="schema_response.TagDTO"></a>
<a id="tocSresponse.tagdto"></a>
<a id="tocsresponse.tagdto"></a>

```json
{
  "id": 0,
  "key": "string",
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|key|string|false|none||none|
|name|string|false|none||none|

<h2 id="tocS_response.WebsiteAcmeAccountDTO">response.WebsiteAcmeAccountDTO</h2>

<a id="schemaresponse.websiteacmeaccountdto"></a>
<a id="schema_response.WebsiteAcmeAccountDTO"></a>
<a id="tocSresponse.websiteacmeaccountdto"></a>
<a id="tocsresponse.websiteacmeaccountdto"></a>

```json
{
  "createdAt": "string",
  "eabHmacKey": "string",
  "eabKid": "string",
  "email": "string",
  "id": 0,
  "keyType": "string",
  "type": "string",
  "updatedAt": "string",
  "url": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|createdAt|string|false|none||none|
|eabHmacKey|string|false|none||none|
|eabKid|string|false|none||none|
|email|string|false|none||none|
|id|integer|false|none||none|
|keyType|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|url|string|false|none||none|

<h2 id="tocS_response.WebsiteCADTO">response.WebsiteCADTO</h2>

<a id="schemaresponse.websitecadto"></a>
<a id="schema_response.WebsiteCADTO"></a>
<a id="tocSresponse.websitecadto"></a>
<a id="tocsresponse.websitecadto"></a>

```json
{
  "city": "string",
  "commonName": "string",
  "country": "string",
  "createdAt": "string",
  "csr": "string",
  "id": 0,
  "keyType": "string",
  "name": "string",
  "organization": "string",
  "organizationUint": "string",
  "privateKey": "string",
  "province": "string",
  "updatedAt": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|city|string|false|none||none|
|commonName|string|false|none||none|
|country|string|false|none||none|
|createdAt|string|false|none||none|
|csr|string|false|none||none|
|id|integer|false|none||none|
|keyType|string|false|none||none|
|name|string|false|none||none|
|organization|string|false|none||none|
|organizationUint|string|false|none||none|
|privateKey|string|false|none||none|
|province|string|false|none||none|
|updatedAt|string|false|none||none|

<h2 id="tocS_response.WebsiteDNSRes">response.WebsiteDNSRes</h2>

<a id="schemaresponse.websitednsres"></a>
<a id="schema_response.WebsiteDNSRes"></a>
<a id="tocSresponse.websitednsres"></a>
<a id="tocsresponse.websitednsres"></a>

```json
{
  "domain": "string",
  "err": "string",
  "resolve": "string",
  "value": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|domain|string|false|none||none|
|err|string|false|none||none|
|resolve|string|false|none||none|
|value|string|false|none||none|

<h2 id="tocS_response.WebsiteDTO">response.WebsiteDTO</h2>

<a id="schemaresponse.websitedto"></a>
<a id="schema_response.WebsiteDTO"></a>
<a id="tocSresponse.websitedto"></a>
<a id="tocsresponse.websitedto"></a>

```json
{
  "IPV6": true,
  "accessLog": true,
  "accessLogPath": "string",
  "alias": "string",
  "appInstallId": 0,
  "appName": "string",
  "createdAt": "string",
  "dbID": 0,
  "dbType": "string",
  "defaultServer": true,
  "domains": [
    {
      "createdAt": "string",
      "domain": "string",
      "id": 0,
      "port": 0,
      "ssl": true,
      "updatedAt": "string",
      "websiteId": 0
    }
  ],
  "errorLog": true,
  "errorLogPath": "string",
  "expireDate": "string",
  "ftpId": 0,
  "group": "string",
  "httpConfig": "string",
  "id": 0,
  "parentWebsiteID": 0,
  "primaryDomain": "string",
  "protocol": "string",
  "proxy": "string",
  "proxyType": "string",
  "remark": "string",
  "rewrite": "string",
  "runtimeID": 0,
  "runtimeName": "string",
  "runtimeType": "string",
  "siteDir": "string",
  "sitePath": "string",
  "status": "string",
  "type": "string",
  "updatedAt": "string",
  "user": "string",
  "webSiteGroupId": 0,
  "webSiteSSL": {
    "acmeAccount": {
      "createdAt": "string",
      "eabHmacKey": "string",
      "eabKid": "string",
      "email": "string",
      "id": 0,
      "keyType": "string",
      "type": "string",
      "updatedAt": "string",
      "url": "string"
    },
    "acmeAccountId": 0,
    "autoRenew": true,
    "caId": 0,
    "certURL": "string",
    "createdAt": "string",
    "description": "string",
    "dir": "string",
    "disableCNAME": true,
    "dnsAccount": {
      "createdAt": "string",
      "id": 0,
      "name": "string",
      "type": "string",
      "updatedAt": "string"
    },
    "dnsAccountId": 0,
    "domains": "string",
    "execShell": true,
    "expireDate": "string",
    "id": 0,
    "keyType": "string",
    "message": "string",
    "nameserver1": "string",
    "nameserver2": "string",
    "organization": "string",
    "pem": "string",
    "primaryDomain": "string",
    "privateKey": "string",
    "provider": "string",
    "pushDir": true,
    "shell": "string",
    "skipDNS": true,
    "startDate": "string",
    "status": "string",
    "type": "string",
    "updatedAt": "string",
    "websites": [
      {
        "IPV6": true,
        "accessLog": true,
        "alias": "string",
        "appInstallId": 0,
        "createdAt": "string",
        "dbID": 0,
        "dbType": "string",
        "defaultServer": true,
        "domains": [
          {
            "createdAt": null,
            "domain": null,
            "id": null,
            "port": null,
            "ssl": null,
            "updatedAt": null,
            "websiteId": null
          }
        ],
        "errorLog": true,
        "expireDate": "string",
        "ftpId": 0,
        "group": "string",
        "httpConfig": "string",
        "id": 0,
        "parentWebsiteID": 0,
        "primaryDomain": "string",
        "protocol": "string",
        "proxy": "string",
        "proxyType": "string",
        "remark": "string",
        "rewrite": "string",
        "runtimeID": 0,
        "siteDir": "string",
        "status": "string",
        "type": "string",
        "updatedAt": "string",
        "user": "string",
        "webSiteGroupId": 0,
        "webSiteSSL": {
          "acmeAccount": {},
          "acmeAccountId": 0,
          "autoRenew": true,
          "caId": 0,
          "certURL": "string",
          "createdAt": "string",
          "description": "string",
          "dir": "string",
          "disableCNAME": true,
          "dnsAccount": {},
          "dnsAccountId": 0,
          "domains": "string",
          "execShell": true,
          "expireDate": "string",
          "id": 0,
          "keyType": "string",
          "message": "string",
          "nameserver1": "string",
          "nameserver2": "string",
          "organization": "string",
          "pem": "string",
          "primaryDomain": "string",
          "privateKey": "string",
          "provider": "string",
          "pushDir": true,
          "shell": "string",
          "skipDNS": true,
          "startDate": "string",
          "status": "string",
          "type": "string",
          "updatedAt": "string",
          "websites": [
            null
          ]
        },
        "webSiteSSLId": 0
      }
    ]
  },
  "webSiteSSLId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|IPV6|boolean|false|none||none|
|accessLog|boolean|false|none||none|
|accessLogPath|string|false|none||none|
|alias|string|false|none||none|
|appInstallId|integer|false|none||none|
|appName|string|false|none||none|
|createdAt|string|false|none||none|
|dbID|integer|false|none||none|
|dbType|string|false|none||none|
|defaultServer|boolean|false|none||none|
|domains|[[model.WebsiteDomain](#schemamodel.websitedomain)]|false|none||none|
|errorLog|boolean|false|none||none|
|errorLogPath|string|false|none||none|
|expireDate|string|false|none||none|
|ftpId|integer|false|none||none|
|group|string|false|none||none|
|httpConfig|string|false|none||none|
|id|integer|false|none||none|
|parentWebsiteID|integer|false|none||none|
|primaryDomain|string|false|none||none|
|protocol|string|false|none||none|
|proxy|string|false|none||none|
|proxyType|string|false|none||none|
|remark|string|false|none||none|
|rewrite|string|false|none||none|
|runtimeID|integer|false|none||none|
|runtimeName|string|false|none||none|
|runtimeType|string|false|none||none|
|siteDir|string|false|none||none|
|sitePath|string|false|none||none|
|status|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|user|string|false|none||none|
|webSiteGroupId|integer|false|none||none|
|webSiteSSL|[model.WebsiteSSL](#schemamodel.websitessl)|false|none||none|
|webSiteSSLId|integer|false|none||none|

<h2 id="tocS_response.WebsiteDirConfig">response.WebsiteDirConfig</h2>

<a id="schemaresponse.websitedirconfig"></a>
<a id="schema_response.WebsiteDirConfig"></a>
<a id="tocSresponse.websitedirconfig"></a>
<a id="tocsresponse.websitedirconfig"></a>

```json
{
  "dirs": [
    "string"
  ],
  "msg": "string",
  "user": "string",
  "userGroup": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|dirs|[string]|false|none||none|
|msg|string|false|none||none|
|user|string|false|none||none|
|userGroup|string|false|none||none|

<h2 id="tocS_response.WebsiteHTTPS">response.WebsiteHTTPS</h2>

<a id="schemaresponse.websitehttps"></a>
<a id="schema_response.WebsiteHTTPS"></a>
<a id="tocSresponse.websitehttps"></a>
<a id="tocsresponse.websitehttps"></a>

```json
{
  "SSL": {
    "acmeAccount": {
      "createdAt": "string",
      "eabHmacKey": "string",
      "eabKid": "string",
      "email": "string",
      "id": 0,
      "keyType": "string",
      "type": "string",
      "updatedAt": "string",
      "url": "string"
    },
    "acmeAccountId": 0,
    "autoRenew": true,
    "caId": 0,
    "certURL": "string",
    "createdAt": "string",
    "description": "string",
    "dir": "string",
    "disableCNAME": true,
    "dnsAccount": {
      "createdAt": "string",
      "id": 0,
      "name": "string",
      "type": "string",
      "updatedAt": "string"
    },
    "dnsAccountId": 0,
    "domains": "string",
    "execShell": true,
    "expireDate": "string",
    "id": 0,
    "keyType": "string",
    "message": "string",
    "nameserver1": "string",
    "nameserver2": "string",
    "organization": "string",
    "pem": "string",
    "primaryDomain": "string",
    "privateKey": "string",
    "provider": "string",
    "pushDir": true,
    "shell": "string",
    "skipDNS": true,
    "startDate": "string",
    "status": "string",
    "type": "string",
    "updatedAt": "string",
    "websites": [
      {
        "IPV6": true,
        "accessLog": true,
        "alias": "string",
        "appInstallId": 0,
        "createdAt": "string",
        "dbID": 0,
        "dbType": "string",
        "defaultServer": true,
        "domains": [
          {
            "createdAt": null,
            "domain": null,
            "id": null,
            "port": null,
            "ssl": null,
            "updatedAt": null,
            "websiteId": null
          }
        ],
        "errorLog": true,
        "expireDate": "string",
        "ftpId": 0,
        "group": "string",
        "httpConfig": "string",
        "id": 0,
        "parentWebsiteID": 0,
        "primaryDomain": "string",
        "protocol": "string",
        "proxy": "string",
        "proxyType": "string",
        "remark": "string",
        "rewrite": "string",
        "runtimeID": 0,
        "siteDir": "string",
        "status": "string",
        "type": "string",
        "updatedAt": "string",
        "user": "string",
        "webSiteGroupId": 0,
        "webSiteSSL": {
          "acmeAccount": {},
          "acmeAccountId": 0,
          "autoRenew": true,
          "caId": 0,
          "certURL": "string",
          "createdAt": "string",
          "description": "string",
          "dir": "string",
          "disableCNAME": true,
          "dnsAccount": {},
          "dnsAccountId": 0,
          "domains": "string",
          "execShell": true,
          "expireDate": "string",
          "id": 0,
          "keyType": "string",
          "message": "string",
          "nameserver1": "string",
          "nameserver2": "string",
          "organization": "string",
          "pem": "string",
          "primaryDomain": "string",
          "privateKey": "string",
          "provider": "string",
          "pushDir": true,
          "shell": "string",
          "skipDNS": true,
          "startDate": "string",
          "status": "string",
          "type": "string",
          "updatedAt": "string",
          "websites": [
            null
          ]
        },
        "webSiteSSLId": 0
      }
    ]
  },
  "SSLProtocol": [
    "string"
  ],
  "algorithm": "string",
  "enable": true,
  "hsts": true,
  "hstsIncludeSubDomains": true,
  "http3": true,
  "httpConfig": "string",
  "httpsPort": "string",
  "httpsPorts": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|SSL|[model.WebsiteSSL](#schemamodel.websitessl)|false|none||none|
|SSLProtocol|[string]|false|none||none|
|algorithm|string|false|none||none|
|enable|boolean|false|none||none|
|hsts|boolean|false|none||none|
|hstsIncludeSubDomains|boolean|false|none||none|
|http3|boolean|false|none||none|
|httpConfig|string|false|none||none|
|httpsPort|string|false|none||none|
|httpsPorts|[integer]|false|none||none|

<h2 id="tocS_response.WebsiteHtmlRes">response.WebsiteHtmlRes</h2>

<a id="schemaresponse.websitehtmlres"></a>
<a id="schema_response.WebsiteHtmlRes"></a>
<a id="tocSresponse.websitehtmlres"></a>
<a id="tocsresponse.websitehtmlres"></a>

```json
{
  "content": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|

<h2 id="tocS_response.WebsiteLog">response.WebsiteLog</h2>

<a id="schemaresponse.websitelog"></a>
<a id="schema_response.WebsiteLog"></a>
<a id="tocSresponse.websitelog"></a>
<a id="tocsresponse.websitelog"></a>

```json
{
  "content": "string",
  "enable": true,
  "end": true,
  "path": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|content|string|false|none||none|
|enable|boolean|false|none||none|
|end|boolean|false|none||none|
|path|string|false|none||none|

<h2 id="tocS_response.WebsiteNginxConfig">response.WebsiteNginxConfig</h2>

<a id="schemaresponse.websitenginxconfig"></a>
<a id="schema_response.WebsiteNginxConfig"></a>
<a id="tocSresponse.websitenginxconfig"></a>
<a id="tocsresponse.websitenginxconfig"></a>

```json
{
  "enable": true,
  "params": [
    {
      "name": "string",
      "params": [
        "string"
      ]
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|enable|boolean|false|none||none|
|params|[[response.NginxParam](#schemaresponse.nginxparam)]|false|none||none|

<h2 id="tocS_response.WebsiteOption">response.WebsiteOption</h2>

<a id="schemaresponse.websiteoption"></a>
<a id="schema_response.WebsiteOption"></a>
<a id="tocSresponse.websiteoption"></a>
<a id="tocsresponse.websiteoption"></a>

```json
{
  "alias": "string",
  "id": 0,
  "primaryDomain": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|alias|string|false|none||none|
|id|integer|false|none||none|
|primaryDomain|string|false|none||none|

<h2 id="tocS_response.WebsitePreInstallCheck">response.WebsitePreInstallCheck</h2>

<a id="schemaresponse.websitepreinstallcheck"></a>
<a id="schema_response.WebsitePreInstallCheck"></a>
<a id="tocSresponse.websitepreinstallcheck"></a>
<a id="tocsresponse.websitepreinstallcheck"></a>

```json
{
  "appName": "string",
  "name": "string",
  "status": "string",
  "version": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|appName|string|false|none||none|
|name|string|false|none||none|
|status|string|false|none||none|
|version|string|false|none||none|

<h2 id="tocS_response.WebsiteRealIP">response.WebsiteRealIP</h2>

<a id="schemaresponse.websiterealip"></a>
<a id="schema_response.WebsiteRealIP"></a>
<a id="tocSresponse.websiterealip"></a>
<a id="tocsresponse.websiterealip"></a>

```json
{
  "ipFrom": "string",
  "ipHeader": "string",
  "ipOther": "string",
  "open": true,
  "websiteID": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|ipFrom|string|false|none||none|
|ipHeader|string|false|none||none|
|ipOther|string|false|none||none|
|open|boolean|false|none||none|
|websiteID|integer|true|none||none|

<h2 id="tocS_response.WebsiteSSLDTO">response.WebsiteSSLDTO</h2>

<a id="schemaresponse.websitessldto"></a>
<a id="schema_response.WebsiteSSLDTO"></a>
<a id="tocSresponse.websitessldto"></a>
<a id="tocsresponse.websitessldto"></a>

```json
{
  "acmeAccount": {
    "createdAt": "string",
    "eabHmacKey": "string",
    "eabKid": "string",
    "email": "string",
    "id": 0,
    "keyType": "string",
    "type": "string",
    "updatedAt": "string",
    "url": "string"
  },
  "acmeAccountId": 0,
  "autoRenew": true,
  "caId": 0,
  "certURL": "string",
  "createdAt": "string",
  "description": "string",
  "dir": "string",
  "disableCNAME": true,
  "dnsAccount": {
    "createdAt": "string",
    "id": 0,
    "name": "string",
    "type": "string",
    "updatedAt": "string"
  },
  "dnsAccountId": 0,
  "domains": "string",
  "execShell": true,
  "expireDate": "string",
  "id": 0,
  "keyType": "string",
  "logPath": "string",
  "message": "string",
  "nameserver1": "string",
  "nameserver2": "string",
  "organization": "string",
  "pem": "string",
  "primaryDomain": "string",
  "privateKey": "string",
  "provider": "string",
  "pushDir": true,
  "shell": "string",
  "skipDNS": true,
  "startDate": "string",
  "status": "string",
  "type": "string",
  "updatedAt": "string",
  "websites": [
    {
      "IPV6": true,
      "accessLog": true,
      "alias": "string",
      "appInstallId": 0,
      "createdAt": "string",
      "dbID": 0,
      "dbType": "string",
      "defaultServer": true,
      "domains": [
        {
          "createdAt": "string",
          "domain": "string",
          "id": 0,
          "port": 0,
          "ssl": true,
          "updatedAt": "string",
          "websiteId": 0
        }
      ],
      "errorLog": true,
      "expireDate": "string",
      "ftpId": 0,
      "group": "string",
      "httpConfig": "string",
      "id": 0,
      "parentWebsiteID": 0,
      "primaryDomain": "string",
      "protocol": "string",
      "proxy": "string",
      "proxyType": "string",
      "remark": "string",
      "rewrite": "string",
      "runtimeID": 0,
      "siteDir": "string",
      "status": "string",
      "type": "string",
      "updatedAt": "string",
      "user": "string",
      "webSiteGroupId": 0,
      "webSiteSSL": {
        "acmeAccount": {
          "createdAt": "string",
          "eabHmacKey": "string",
          "eabKid": "string",
          "email": "string",
          "id": 0,
          "keyType": "string",
          "type": "string",
          "updatedAt": "string",
          "url": "string"
        },
        "acmeAccountId": 0,
        "autoRenew": true,
        "caId": 0,
        "certURL": "string",
        "createdAt": "string",
        "description": "string",
        "dir": "string",
        "disableCNAME": true,
        "dnsAccount": {
          "createdAt": "string",
          "id": 0,
          "name": "string",
          "type": "string",
          "updatedAt": "string"
        },
        "dnsAccountId": 0,
        "domains": "string",
        "execShell": true,
        "expireDate": "string",
        "id": 0,
        "keyType": "string",
        "message": "string",
        "nameserver1": "string",
        "nameserver2": "string",
        "organization": "string",
        "pem": "string",
        "primaryDomain": "string",
        "privateKey": "string",
        "provider": "string",
        "pushDir": true,
        "shell": "string",
        "skipDNS": true,
        "startDate": "string",
        "status": "string",
        "type": "string",
        "updatedAt": "string",
        "websites": [
          {
            "IPV6": null,
            "accessLog": null,
            "alias": null,
            "appInstallId": null,
            "createdAt": null,
            "dbID": null,
            "dbType": null,
            "defaultServer": null,
            "domains": null,
            "errorLog": null,
            "expireDate": null,
            "ftpId": null,
            "group": null,
            "httpConfig": null,
            "id": null,
            "parentWebsiteID": null,
            "primaryDomain": null,
            "protocol": null,
            "proxy": null,
            "proxyType": null,
            "remark": null,
            "rewrite": null,
            "runtimeID": null,
            "siteDir": null,
            "status": null,
            "type": null,
            "updatedAt": null,
            "user": null,
            "webSiteGroupId": null,
            "webSiteSSL": null,
            "webSiteSSLId": null
          }
        ]
      },
      "webSiteSSLId": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|acmeAccount|[model.WebsiteAcmeAccount](#schemamodel.websiteacmeaccount)|false|none||none|
|acmeAccountId|integer|false|none||none|
|autoRenew|boolean|false|none||none|
|caId|integer|false|none||none|
|certURL|string|false|none||none|
|createdAt|string|false|none||none|
|description|string|false|none||none|
|dir|string|false|none||none|
|disableCNAME|boolean|false|none||none|
|dnsAccount|[model.WebsiteDnsAccount](#schemamodel.websitednsaccount)|false|none||none|
|dnsAccountId|integer|false|none||none|
|domains|string|false|none||none|
|execShell|boolean|false|none||none|
|expireDate|string|false|none||none|
|id|integer|false|none||none|
|keyType|string|false|none||none|
|logPath|string|false|none||none|
|message|string|false|none||none|
|nameserver1|string|false|none||none|
|nameserver2|string|false|none||none|
|organization|string|false|none||none|
|pem|string|false|none||none|
|primaryDomain|string|false|none||none|
|privateKey|string|false|none||none|
|provider|string|false|none||none|
|pushDir|boolean|false|none||none|
|shell|string|false|none||none|
|skipDNS|boolean|false|none||none|
|startDate|string|false|none||none|
|status|string|false|none||none|
|type|string|false|none||none|
|updatedAt|string|false|none||none|
|websites|[[model.Website](#schemamodel.website)]|false|none||none|

