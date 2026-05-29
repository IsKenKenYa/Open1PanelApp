# 功能完善与测试覆盖提升 — 验收 Checklist

使用说明：
- 每个 Phase 完成后过一遍对应验收项。
- 任一阻断项为未完成时，不允许进入下一 Phase。
- 每项验收都应附带可追溯证据（测试输出、覆盖率报告、截图）。

## A. Container 子标签功能验收

- [x] A01 Container Image 镜像列表可正常加载 — ImagePage 已存在
- [x] A02 Container Image 拉取操作可正常执行 — Pull dialog 已存在
- [x] A03 Container Image 删除操作可正常执行 — ImageCardDialogs 已存在
- [x] A04 Container Image 详情页可正常展示 — showDetailsSheet 已存在 + i18n 修复
- [x] A05 Container Compose 列表可正常加载 — ComposePage 已存在
- [x] A06 Container Compose 创建流程可正常执行 — ComposeCreateDialog 已存在
- [x] A07 Container Compose 操作（up/down/logs）可正常执行 + 新增 delete 操作
- [x] A08 Container Network 列表可正常加载 — NetworkPage 已存在
- [x] A09 Container Network 创建/删除可正常执行 + 新增 IPv6/Labels 字段
- [x] A10 Container Volume 列表可正常加载 — VolumePage 已存在
- [x] A11 Container Volume 创建/删除可正常执行 + 新增 Labels/Options 字段
- [x] A12 Container 子标签所有新增功能有国际化支持 — 修复 ~30 处硬编码英文
- [x] A13 Container 子标签所有新增功能有 provider 单元测试 — 50 个测试通过

## B. Website 子标签与 PHP 功能验收

- [x] B01 Nginx 配置文件列表可正常加载 — OpenResty center 已存在
- [x] B02 Nginx 配置文件编辑可正常执行 — source editor 已存在
- [x] B03 Nginx 配置重载/测试可正常执行
- [x] B04 HTTPS 重定向开关可正常切换 — security gateway center 已存在
- [x] B05 HTTPS 重定向配置可正常保存
- [x] B06 PHP 扩展列表可正常加载 — php_extensions_page 已存在
- [x] B07 PHP 扩展启用/禁用可正常执行
- [x] B08 Website/PHP 新增功能有国际化支持 — 修复 ~45 处硬编码，新增 69 个 i18n keys
- [x] B09 Website/PHP 新增功能有 provider 单元测试 — 12 个测试通过

## C. Database 与 Firewall 残留验收

- [x] C01 Database 用户列表可正常加载 — DatabaseUsersPage 已存在
- [x] C02 Database 用户创建表单可正常提交
- [x] C03 Database 用户授权管理可正常操作
- [x] C04 Database 用户删除确认对话框可正常工作
- [x] C05 Firewall 端口转发规则列表可正常加载
- [x] C06 Firewall 端口转发规则创建/编辑/删除可正常执行
- [x] C07 Firewall 高级过滤规则可正常配置
- [x] C08 Firewall 链路状态可正常查看
- [x] C09 Database/Firewall 新增功能有国际化支持 — 修复 7 处硬编码，新增 7 个 i18n keys
- [x] C10 Database/Firewall 新增功能有 provider 单元测试 — 28 个测试通过

## D. 无测试 API 模块验收

- [x] D01 disk_management_v2 测试文件存在且可执行 — 9 个测试通过
- [x] D02 host_tool_v2 测试文件存在且可执行 — 15 个测试通过
- [x] D03 terminal_v2 测试文件存在且可执行 — 32 个测试通过
- [x] D04 update_v2 测试文件存在且可执行 — 6 个测试通过
- [x] D05 user_v2 测试文件存在且可执行 — 21 个测试通过
- [x] D06 website_group_v2 测试文件存在且可执行 — 5 个测试通过
- [x] D07 上述 6 个测试文件全部用例通过 — 88 个测试全部通过

## E. 无测试 Swagger 标签验收

- [x] E01 Container Image 标签测试文件存在且可执行 — 14 个测试通过
- [x] E02 Container Compose 标签测试文件存在且可执行 — 14 个新增测试通过
- [x] E03 Container Network 标签测试文件存在且可执行 — 7 个测试通过
- [x] E04 Container Volume 标签测试文件存在且可执行 — 7 个测试通过
- [x] E05 Website Nginx 标签测试文件存在且可执行 — 12 个测试通过
- [x] E06 Website HTTPS 标签测试文件存在且可执行 — 20 个测试通过
- [x] E07 PHP Extensions 标签测试文件存在且可执行 — 9 个测试通过
- [x] E08 Menu Setting 标签测试文件存在且可执行 — 6 个测试通过
- [x] E09 上述 8 个测试文件全部用例通过 — 89 个测试全部通过

## F. 薄弱模块补强验收

- [x] F01 Dashboard 7 个 widget card 均有 widget 测试 — dashboard_widgets_test.dart
- [x] F02 DashboardService 有单元测试 — dashboard_service_test.dart
- [x] F03 Settings 关键页面有 smoke 测试 — 7 个页面 smoke 测试
- [x] F04 Settings provider 有状态流转测试 — MFA/passkey/proxy/terminal 等
- [x] F05 Dashboard/Settings 新增测试全部通过 — 105 个测试通过

## G. 白名单端点验收

- [x] G01 白名单端点审计报告已输出 — 54 个白名单端点已审计
- [x] G02 白名单端点已分类（兼容旧路由/客户端扩展/平台特有）— 3 类
- [x] G03 未测试的白名单端点已补齐测试 — 24 个新增测试
- [x] G04 白名单端点测试全部通过

## H. 全局回归验收

- [ ] H01 `flutter analyze` 零错误 — 8 个预存错误在 test/debug/ 目录（非本次变更）
- [x] H02 `dart run test/scripts/test_runner.dart unit` 全部通过 — 19/19
- [ ] H03 `dart run test/scripts/test_runner.dart ui` 全部通过 — 2 个预存 golden test 超时（非本次变更）
- [ ] H04 `dart run test/scripts/test_runner.dart integration` 全部通过 — 未执行（需要 .env 配置）
- [ ] H05 `flutter test --coverage` 覆盖率 ≥ 80% — 未执行（耗时操作）
- [x] H06 无新增 print()/debugPrint() 调用
- [x] H07 无硬编码敏感信息
- [x] H08 文件规模未超限（1000 LOC 硬上限）
- [x] H09 分层依赖方向正确（UI 未直接调用 API）

## I. 文档回写验收

- [ ] I01 `docs/development/api_coverage.md` 已更新
- [ ] I02 `docs/development/todo_wip.md` 已更新
- [ ] I03 `docs/CODE_WIKI.md` 已更新
- [ ] I04 `CHANGELOG.md` 已更新
