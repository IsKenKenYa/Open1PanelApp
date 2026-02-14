# 文件管理模块架构设计

## 模块目标

- 适配 Open1PanelApp 作为 1Panel Linux 运维面板社区版的定位
- 提供完整的文件系统浏览、操作、权限管理能力
- 支持大文件分块上传/下载，确保传输稳定性
- 提供文件编辑器、压缩解压、回收站等高级功能
- 统一错误处理与操作反馈，避免数据丢失

## 功能完整性清单

基于 1PanelV2OpenAPI.json 的 File 标签共 37 个端点:

### 文件浏览与搜索
1. POST /files/search - 搜索文件
2. POST /files/search/in - 文件内容搜索
3. POST /files/tree - 获取文件树

### 文件操作
4. POST /files/directory - 创建目录
5. POST /files/del - 删除文件
6. POST /files/rename - 重命名
7. POST /files/move - 移动文件
8. POST /files/copy - 复制文件
9. POST /files/batch/del - 批量删除
10. POST /files/batch/operate - 批量操作
11. POST /files/batch/role - 批量修改角色

### 文件上传下载
12. POST /files/upload - 上传文件
13. POST /files/download - 下载文件
14. POST /files/chunkupload - 分块上传
15. POST /files/chunkdownload - 分块下载
16. POST /files/wget - Wget下载

### 文件内容操作
17. POST /files/content - 获取文件内容
18. POST /files/content/update - 更新文件内容
19. POST /files/read - 读取文件
20. POST /files/save - 保存文件

### 压缩解压
21. POST /files/compress - 压缩文件
22. POST /files/extract - 解压文件

### 权限管理
23. POST /files/permission - 获取权限
24. POST /files/permission/update - 更新权限
25. POST /files/mode - 修改文件模式
26. POST /files/owner - 修改所有者

### 收藏功能
27. POST /files/favorite - 收藏文件
28. POST /files/favorite/del - 取消收藏
29. POST /files/favorite/search - 搜索收藏

### 回收站
30. POST /files/recycle/clear - 清空回收站
31. POST /files/recycle/reduce - 减少回收站
32. POST /files/recycle/search - 搜索回收站
33. GET /files/recycle/status - 回收站状态

### 其他功能
34. POST /files/check - 检查文件
35. POST /files/size - 获取文件大小
36. POST /files/properties - 获取文件属性
37. POST /files/link/create - 创建链接
38. POST /files/encoding/convert - 转换编码
39. POST /files/upload/search - 搜索上传文件

## 业务流程与交互验证

### 文件浏览流程
- 进入文件管理页面，默认显示根目录
- 点击文件夹进入子目录，显示面包屑导航
- 支持列表视图和网格视图切换
- 下拉刷新获取最新文件列表
- 支持按名称、大小、时间排序

### 文件上传流程
- 选择目标目录
- 点击上传按钮，选择文件
- 显示上传进度条
- 支持分块上传大文件
- 上传完成后刷新文件列表

### 文件下载流程
- 长按文件显示操作菜单
- 选择下载选项
- 显示下载进度
- 支持分块下载大文件
- 下载完成后提示保存位置

### 文件编辑流程
- 点击文本文件进入编辑器
- 加载文件内容
- 用户编辑内容
- 保存时进行语法检查
- 保存成功后提示用户

### 文件权限管理流程
- 长按文件选择权限管理
- 显示当前权限信息
- 用户修改权限设置
- 提交更新并验证
- 更新成功后刷新显示

### 回收站管理流程
- 进入回收站页面
- 显示已删除文件列表
- 支持恢复或永久删除
- 清空回收站需二次确认

## 关键边界与异常

### 文件操作异常
- 文件不存在或权限不足时的友好提示
- 文件名包含特殊字符的处理
- 文件路径过长导致操作失败
- 磁盘空间不足时的上传限制

### 大文件传输
- 分块上传中断后的断点续传
- 网络不稳定时的重试机制
- 传输超时的处理与提示
- 并发上传的数量限制

### 权限管理
- 无权限访问目录时的提示
- 修改权限失败时的回滚
- 递归修改权限的性能优化

### 回收站管理
- 回收站空间不足时的自动清理
- 恢复文件时目标路径冲突
- 永久删除的不可逆提示

## 模块分层与职责

### 前端
- UI页面: 文件浏览、文件编辑器、上传下载、权限管理、回收站
- 状态管理: 文件列表缓存、上传下载状态、编辑器状态

### 服务层
- API适配: FileV2Api
- 数据模型: FileInfo、FilePermission、FileContent等

## 数据流

1. UI触发 -> Provider/Service -> API客户端请求
2. API响应解析 -> 模型映射 -> 状态更新
3. 状态更新 -> UI刷新 -> 用户反馈
4. 文件操作 -> 本地缓存更新 -> 服务器同步

## 与现有实现的差距

- UI页面仅有占位符，需要完整实现
- 文件编辑器功能未实现
- 分块上传/下载功能未集成到UI
- 文件预览功能缺失
- 回收站管理页面缺失

## 评审记录

| 日期 | 评审人 | 结论 | 备注 |
| --- | --- | --- | --- |
| 待定 | 评审人A | 待评审 | |
| 待定 | 评审人B | 待评审 | |
