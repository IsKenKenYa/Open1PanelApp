# Tasks

- [x] Task 1: 优化复制文件到当前目录的逻辑
  - [x] SubTask 1.1: 在 `FilesService.copyFiles` 中检测目标路径是否与源路径相同
  - [x] SubTask 1.2: 如果相同，自动生成新文件名（添加 `(1)` 后缀）
  - [x] SubTask 1.3: 使用 `FileMove` 模型的 `name` 参数传递新文件名到API

- [x] Task 2: 实现新建文件夹功能
  - [x] SubTask 2.1: 检查 `FilesService.createDirectory` 方法是否正确实现
  - [x] SubTask 2.2: 检查 `FilesProvider.createDirectory` 方法是否存在
  - [x] SubTask 2.3: 实现 `_showCreateDirectoryDialog` 对话框，调用API创建文件夹

- [x] Task 3: 实现新建文件功能
  - [x] SubTask 3.1: 检查 `FilesService.createFile` 方法是否正确实现
  - [x] SubTask 3.2: 检查 `FilesProvider.createFile` 方法是否存在
  - [x] SubTask 3.3: 实现 `_showCreateFileDialog` 对话框，调用API创建文件

- [x] Task 4: 实现文件上传功能
  - [x] SubTask 4.1: 添加 `file_picker: ^8.0.0` 依赖到 `pubspec.yaml`
  - [x] SubTask 4.2: 在 `FileV2Api` 中添加 `uploadFile` 方法，使用 `dio` 的 `MultipartFile`
  - [x] SubTask 4.3: 在 `FilesService` 中添加 `uploadFile` 方法
  - [x] SubTask 4.4: 在 `FilesProvider` 中添加 `uploadFiles` 方法
  - [x] SubTask 4.5: 实现 `_showUploadDialog` 对话框，使用 `file_picker` 选择文件并上传

- [x] Task 5: 验证功能
  - [x] SubTask 5.1: 运行 `flutter pub get` 安装依赖
  - [x] SubTask 5.2: 运行 `flutter analyze` 验证代码
  - [ ] SubTask 5.3: 手动测试所有新功能

# Task Dependencies
- Task 2, 3 可以并行执行（检查现有实现）
- Task 4 需要先完成 SubTask 4.1（添加依赖）
- Task 5 依赖 Task 1, 2, 3, 4
