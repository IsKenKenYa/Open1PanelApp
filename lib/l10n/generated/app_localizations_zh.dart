// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '1Panel Open';

  @override
  String get commonLoading => '加载中...';

  @override
  String get commonRetry => '重试';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonSave => '保存';

  @override
  String get commonSaveSuccess => '保存成功';

  @override
  String get commonSaveFailed => '保存失败';

  @override
  String get commonDelete => '删除';

  @override
  String get commonRefresh => '刷新';

  @override
  String get commonComingSoon => '即将支持';

  @override
  String get commonEmpty => '暂无数据';

  @override
  String get commonLoadFailedTitle => '加载失败';

  @override
  String get monitorNetworkLabel => '网络';

  @override
  String get monitorMetricCurrent => '当前';

  @override
  String get monitorMetricMin => '最小';

  @override
  String get monitorMetricAvg => '平均';

  @override
  String get monitorMetricMax => '最大';

  @override
  String get navServer => '服务器';

  @override
  String get navFiles => '文件';

  @override
  String get navSecurity => '动态验证';

  @override
  String get navSettings => '设置';

  @override
  String get serverPageTitle => '服务器';

  @override
  String get serverSearchHint => '请输入服务器名称或 IP';

  @override
  String get serverAdd => '添加';

  @override
  String get serverListEmptyTitle => '暂无服务器';

  @override
  String get serverListEmptyDesc => '先添加一个 1Panel 服务器开始使用。';

  @override
  String get serverOnline => '在线';

  @override
  String get serverOffline => '离线';

  @override
  String get serverCurrent => '当前';

  @override
  String get serverDefault => '默认';

  @override
  String get serverIpLabel => 'IP';

  @override
  String get serverCpuLabel => 'CPU';

  @override
  String get serverMemoryLabel => '内存';

  @override
  String get serverLoadLabel => '负载';

  @override
  String get serverDiskLabel => '磁盘';

  @override
  String get serverMetricsUnavailable => '监控数据暂不可用';

  @override
  String get serverOpenDetail => '查看详情';

  @override
  String get serverDetailTitle => '服务器详情';

  @override
  String get serverModulesTitle => '功能模块';

  @override
  String get serverModuleDashboard => '概览';

  @override
  String get serverModuleApps => '应用';

  @override
  String get serverModuleContainers => '容器';

  @override
  String get serverModuleWebsites => '网站';

  @override
  String get serverModuleDatabases => '数据库';

  @override
  String get serverModuleFirewall => '防火墙';

  @override
  String get serverModuleTerminal => '终端';

  @override
  String get serverModuleMonitoring => '监控';

  @override
  String get serverModuleFiles => '文件管理';

  @override
  String get serverInsightsTitle => '运行概览';

  @override
  String get serverActionsTitle => '快捷操作';

  @override
  String get serverActionRefresh => '刷新';

  @override
  String get serverActionSwitch => '切换服务器';

  @override
  String get serverActionSecurity => '动态验证';

  @override
  String get serverFormTitle => '添加服务器';

  @override
  String get serverFormName => '服务器名称';

  @override
  String get serverFormNameHint => '例如：生产环境';

  @override
  String get serverFormUrl => '服务器地址';

  @override
  String get serverFormUrlHint => '例如：https://panel.example.com';

  @override
  String get serverFormApiKey => 'API 密钥';

  @override
  String get serverFormApiKeyHint => '请输入 API 密钥';

  @override
  String get serverFormSaveConnect => '保存并继续';

  @override
  String get serverFormTest => '测试连接';

  @override
  String get serverFormRequired => '该字段不能为空';

  @override
  String get serverFormSaveSuccess => '服务器已保存';

  @override
  String serverFormSaveFailed(String error) {
    return '保存服务器失败：$error';
  }

  @override
  String get serverFormTestHint => '连接测试可在 client 适配后接入。';

  @override
  String get serverTestSuccess => '连接成功';

  @override
  String get serverTestFailed => '连接失败';

  @override
  String get serverTestTesting => '正在测试连接...';

  @override
  String get serverMetricsAvailable => '监控数据已加载';

  @override
  String get serverTokenValidity => '接口密钥有效期';

  @override
  String get serverTokenValidityHint => '设置为0时不校验时间戳';

  @override
  String get serverFormMinutes => '分钟';

  @override
  String get filesPageTitle => '文件';

  @override
  String get filesPath => '路径';

  @override
  String get filesRoot => '根目录';

  @override
  String get filesEmptyTitle => '文件页占位已完成';

  @override
  String get filesEmptyDesc => '页面结构已就绪，后续接入文件 API 即可。';

  @override
  String get filesActionUpload => '上传';

  @override
  String get filesActionNewFile => '新建文件';

  @override
  String get filesActionNewFolder => '新建文件夹';

  @override
  String get securityPageTitle => '动态验证';

  @override
  String get securityStatusTitle => 'MFA 状态';

  @override
  String get securityStatusEnabled => '已启用';

  @override
  String get securityStatusDisabled => '未启用';

  @override
  String get securitySecretLabel => '密钥';

  @override
  String get securityCodeLabel => '验证码';

  @override
  String get securityCodeHint => '输入 6 位验证码';

  @override
  String get securityLoadInfo => '加载 MFA 信息';

  @override
  String get securityBind => '绑定 MFA';

  @override
  String get securityBindSuccess => 'MFA 绑定请求已提交';

  @override
  String securityBindFailed(String error) {
    return '绑定 MFA 失败：$error';
  }

  @override
  String get securityMockNotice => '当前页面运行在 UI 适配模式，后续可直接接入 API client。';

  @override
  String get settingsPageTitle => '设置';

  @override
  String get settingsGeneral => '通用';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsServerManagement => '服务器管理';

  @override
  String get settingsResetOnboarding => '重新查看引导';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsResetOnboardingDone => '已重置引导状态';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get languageSystem => '系统';

  @override
  String get languageZh => '中文';

  @override
  String get languageEn => '英文';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingStart => '开始使用';

  @override
  String get onboardingTitle1 => '统一管理 1Panel 服务器';

  @override
  String get onboardingDesc1 => '在移动端完成监控、文件与安全相关操作。';

  @override
  String get onboardingTitle2 => '快速切换与清晰状态';

  @override
  String get onboardingDesc2 => '卡片化信息让你快速判断服务器运行状态。';

  @override
  String get onboardingTitle3 => '先稳 UI，再接 API';

  @override
  String get onboardingDesc3 => '缺失接口会记录在评审文档，便于后续并行适配。';

  @override
  String get coachServerAddTitle => '先添加一个服务器';

  @override
  String get coachServerAddDesc => '点击这里创建服务器配置。';

  @override
  String get coachServerCardTitle => '点击卡片进入详情';

  @override
  String get coachServerCardDesc => '在详情页中访问各个功能模块与快捷操作。';

  @override
  String get dashboardTitle => '仪表盘';

  @override
  String get dashboardLoadFailedTitle => '加载失败';

  @override
  String get dashboardServerInfoTitle => '服务器信息';

  @override
  String get dashboardServerStatusOk => '运行正常';

  @override
  String get dashboardServerStatusConnecting => '连接中...';

  @override
  String get dashboardHostNameLabel => '主机名';

  @override
  String get dashboardOsLabel => '操作系统';

  @override
  String get dashboardUptimeLabel => '运行时间';

  @override
  String dashboardUptimeDaysHours(int days, int hours) {
    return '$days天 $hours小时';
  }

  @override
  String dashboardUptimeHours(int hours) {
    return '$hours小时';
  }

  @override
  String dashboardUpdatedAt(String time) {
    return '更新时间：$time';
  }

  @override
  String get dashboardResourceTitle => '系统资源';

  @override
  String get dashboardCpuUsage => 'CPU 使用率';

  @override
  String get dashboardMemoryUsage => '内存使用率';

  @override
  String get dashboardDiskUsage => '磁盘使用率';

  @override
  String get dashboardQuickActionsTitle => '快捷操作';

  @override
  String get dashboardActionRestart => '重启服务器';

  @override
  String get dashboardActionUpdate => '系统更新';

  @override
  String get dashboardActionBackup => '创建备份';

  @override
  String get dashboardActionSecurity => '安全检查';

  @override
  String get dashboardRestartTitle => '重启服务器';

  @override
  String get dashboardRestartDesc => '确定要重启服务器吗？这将导致所有服务暂时不可用。';

  @override
  String get dashboardRestartSuccess => '重启请求已发送';

  @override
  String dashboardRestartFailed(String error) {
    return '重启失败：$error';
  }

  @override
  String get dashboardUpdateTitle => '系统更新';

  @override
  String get dashboardUpdateDesc => '现在开始系统更新吗？更新期间面板可能暂时不可用。';

  @override
  String get dashboardUpdateSuccess => '更新请求已发送';

  @override
  String dashboardUpdateFailed(String error) {
    return '更新失败：$error';
  }

  @override
  String get dashboardActivityTitle => '最近活动';

  @override
  String get dashboardActivityEmpty => '暂无活动记录';

  @override
  String dashboardActivityDaysAgo(int count) {
    return '$count天前';
  }

  @override
  String dashboardActivityHoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String dashboardActivityMinutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String get dashboardActivityJustNow => '刚刚';

  @override
  String get dashboardTopProcessesTitle => '进程监控';

  @override
  String get dashboardCpuTab => 'CPU';

  @override
  String get dashboardMemoryTab => '内存';

  @override
  String get dashboardNoProcesses => '暂无进程数据';

  @override
  String get authLoginTitle => '1Panel 登录';

  @override
  String get authLoginSubtitle => '请输入您的登录凭据';

  @override
  String get authUsername => '用户名';

  @override
  String get authPassword => '密码';

  @override
  String get authCaptcha => '验证码';

  @override
  String get authLogin => '登录';

  @override
  String get authUsernameRequired => '请输入用户名';

  @override
  String get authPasswordRequired => '请输入密码';

  @override
  String get authCaptchaRequired => '请输入验证码';

  @override
  String get authMfaTitle => '双因素认证';

  @override
  String get authMfaDesc => '请输入您的认证器应用中的验证码';

  @override
  String get authMfaHint => '000000';

  @override
  String get authMfaVerify => '验证';

  @override
  String get authMfaCancel => '返回登录';

  @override
  String get authDemoMode => '演示模式：部分功能受限';

  @override
  String get authLoginFailed => '登录失败';

  @override
  String get authLogoutSuccess => '已成功登出';

  @override
  String get coachDone => '我知道了';

  @override
  String get notFoundTitle => '页面不存在';

  @override
  String get notFoundDesc => '请求的页面不存在或已迁移。';

  @override
  String get legacyRouteRedirect => '该旧路由已跳转到新版主界面。';

  @override
  String get monitorDataPoints => '数据点数量';

  @override
  String monitorDataPointsCount(int count, String time) {
    return '$count个点 ($time)';
  }

  @override
  String get monitorRefreshInterval => '刷新间隔';

  @override
  String monitorSeconds(int count) {
    return '$count秒';
  }

  @override
  String monitorSecondsDefault(int count) {
    return '$count秒 (默认)';
  }

  @override
  String monitorMinute(int count) {
    return '$count分钟';
  }

  @override
  String monitorTimeMinutes(int count) {
    return '$count分钟';
  }

  @override
  String monitorTimeHours(int count) {
    return '$count小时';
  }

  @override
  String monitorDataPointsLabel(int count) {
    return '$count 个数据点';
  }

  @override
  String get monitorSettings => '监控设置';

  @override
  String get monitorEnable => '启用监控';

  @override
  String get monitorInterval => '监控间隔';

  @override
  String get monitorIntervalUnit => '秒';

  @override
  String get monitorRetention => '数据保留时间';

  @override
  String get monitorRetentionUnit => '天';

  @override
  String get monitorCleanData => '清理监控数据';

  @override
  String get monitorCleanConfirm => '确定要清理所有监控数据吗？此操作无法撤销。';

  @override
  String get monitorCleanSuccess => '监控数据清理成功';

  @override
  String get monitorCleanFailed => '清理监控数据失败';

  @override
  String get monitorSettingsSaved => '设置保存成功';

  @override
  String get monitorSettingsFailed => '保存设置失败';

  @override
  String get monitorGPU => 'GPU监控';

  @override
  String get monitorGPUName => '名称';

  @override
  String get monitorGPUUtilization => '利用率';

  @override
  String get monitorGPUMemory => '显存';

  @override
  String get monitorGPUTemperature => '温度';

  @override
  String get monitorGPUNotAvailable => 'GPU监控不可用';

  @override
  String get monitorTimeRange => '时间范围';

  @override
  String get monitorTimeRangeLast1h => '最近1小时';

  @override
  String get monitorTimeRangeLast6h => '最近6小时';

  @override
  String get monitorTimeRangeLast24h => '最近24小时';

  @override
  String get monitorTimeRangeLast7d => '最近7天';

  @override
  String get monitorTimeRangeCustom => '自定义';

  @override
  String get monitorTimeRangeFrom => '从';

  @override
  String get monitorTimeRangeTo => '到';

  @override
  String get systemSettingsTitle => '系统设置';

  @override
  String get systemSettingsRefresh => '刷新';

  @override
  String get systemSettingsLoadFailed => '加载设置失败';

  @override
  String get systemSettingsPanelSection => '面板设置';

  @override
  String get systemSettingsPanelConfig => '面板配置';

  @override
  String get systemSettingsPanelConfigDesc => '面板名称、端口、绑定地址等';

  @override
  String get systemSettingsTerminal => '终端设置';

  @override
  String get systemSettingsTerminalDesc => '终端样式、字体、滚动等';

  @override
  String get systemSettingsSecuritySection => '安全设置';

  @override
  String get systemSettingsSecurityConfig => '安全配置';

  @override
  String get systemSettingsSecurityConfigDesc => 'MFA认证、访问控制等';

  @override
  String get systemSettingsApiKey => 'API密钥';

  @override
  String get systemSettingsBackupSection => '备份恢复';

  @override
  String get systemSettingsSnapshot => '快照管理';

  @override
  String get systemSettingsSnapshotDesc => '创建、恢复、删除系统快照';

  @override
  String get systemSettingsSystemSection => '系统信息';

  @override
  String get systemSettingsUpgrade => '系统升级';

  @override
  String get systemSettingsAbout => '关于';

  @override
  String get systemSettingsAboutDesc => '系统信息与版本';

  @override
  String systemSettingsLastUpdated(String time) {
    return '最后更新: $time';
  }

  @override
  String get systemSettingsPanelName => '1Panel面板';

  @override
  String get systemSettingsSystemVersion => '系统版本';

  @override
  String get systemSettingsMfaStatus => 'MFA状态';

  @override
  String get systemSettingsEnabled => '启用';

  @override
  String get systemSettingsDisabled => '禁用';

  @override
  String get systemSettingsApiKeyManage => 'API密钥管理';

  @override
  String get systemSettingsCurrentStatus => '当前状态';

  @override
  String get systemSettingsUnknown => '未知';

  @override
  String get systemSettingsApiKeyLabel => 'API密钥';

  @override
  String get systemSettingsNotSet => '未设置';

  @override
  String get systemSettingsGenerateNewKey => '生成新密钥';

  @override
  String get systemSettingsApiKeyGenerated => 'API密钥已生成';

  @override
  String get systemSettingsGenerateFailed => '生成失败';

  @override
  String get systemSettingsCurrentVersion => '当前版本';

  @override
  String get systemSettingsCheckingUpdate => '正在检查更新...';

  @override
  String get systemSettingsClose => '关闭';

  @override
  String get panelSettingsTitle => '面板设置';

  @override
  String get panelSettingsBasicInfo => '基本信息';

  @override
  String get panelSettingsPanelName => '面板名称';

  @override
  String get panelSettingsVersion => '系统版本';

  @override
  String get panelSettingsPort => '监听端口';

  @override
  String get panelSettingsBindAddress => '绑定地址';

  @override
  String get panelSettingsInterface => '界面设置';

  @override
  String get panelSettingsTheme => '主题';

  @override
  String get panelSettingsLanguage => '语言';

  @override
  String get panelSettingsMenuTabs => '菜单标签';

  @override
  String get panelSettingsAdvanced => '高级设置';

  @override
  String get panelSettingsDeveloperMode => '开发者模式';

  @override
  String get panelSettingsIpv6 => 'IPv6';

  @override
  String get panelSettingsSessionTimeout => '会话超时';

  @override
  String panelSettingsMinutes(String count) {
    return '$count 分钟';
  }

  @override
  String get terminalSettingsTitle => '终端设置';

  @override
  String get terminalSettingsDisplay => '显示设置';

  @override
  String get terminalSettingsCursorStyle => '光标样式';

  @override
  String get terminalSettingsCursorBlink => '光标闪烁';

  @override
  String get terminalSettingsFontSize => '字体大小';

  @override
  String get terminalSettingsScroll => '滚动设置';

  @override
  String get terminalSettingsScrollSensitivity => '滚动灵敏度';

  @override
  String get terminalSettingsScrollback => '滚动缓冲区';

  @override
  String get terminalSettingsStyle => '样式设置';

  @override
  String get terminalSettingsLineHeight => '行高';

  @override
  String get terminalSettingsLetterSpacing => '字母间距';

  @override
  String get securitySettingsTitle => '安全设置';

  @override
  String get securitySettingsMfaSection => 'MFA认证';

  @override
  String get securitySettingsMfaStatus => 'MFA状态';

  @override
  String get securitySettingsUnbindMfa => '解绑MFA';

  @override
  String get securitySettingsAccessControl => '访问控制';

  @override
  String get securitySettingsSecurityEntrance => '安全入口';

  @override
  String get securitySettingsBindDomain => '绑定域名';

  @override
  String get securitySettingsAllowIPs => '允许IP列表';

  @override
  String get securitySettingsPasswordPolicy => '密码策略';

  @override
  String get securitySettingsComplexityVerification => '复杂度验证';

  @override
  String get securitySettingsExpirationDays => '过期天数';

  @override
  String get securitySettingsEnableMfa => '启用MFA';

  @override
  String get securitySettingsDisableMfa => '禁用MFA';

  @override
  String get securitySettingsEnableMfaConfirm => '确定要启用MFA认证吗？';

  @override
  String get securitySettingsDisableMfaConfirm => '确定要禁用MFA认证吗？';

  @override
  String get securitySettingsEnterMfaCode => '请输入MFA验证码';

  @override
  String get securitySettingsVerifyCode => '验证码';

  @override
  String get securitySettingsMfaCodeHint => '请输入6位验证码';

  @override
  String get securitySettingsMfaUnbound => 'MFA已解绑';

  @override
  String get securitySettingsUnbindFailed => '解绑失败';

  @override
  String get snapshotTitle => '快照管理';

  @override
  String get snapshotCreate => '创建快照';

  @override
  String get snapshotEmpty => '暂无快照';

  @override
  String get snapshotCreatedAt => '创建时间';

  @override
  String get snapshotDescription => '描述';

  @override
  String get snapshotRecover => '恢复';

  @override
  String get snapshotDownload => '下载';

  @override
  String get snapshotDelete => '删除';

  @override
  String get snapshotEnterDesc => '请输入快照描述（可选）';

  @override
  String get snapshotDescLabel => '描述';

  @override
  String get snapshotDescHint => '请输入快照描述';

  @override
  String get snapshotCreateSuccess => '快照创建成功';

  @override
  String get snapshotCreateFailed => '快照创建失败';

  @override
  String get snapshotDownloadDev => '下载功能开发中';

  @override
  String get snapshotRecoverTitle => '恢复快照';

  @override
  String get snapshotRecoverConfirm => '确定要恢复此快照吗？恢复后当前配置将被覆盖。';

  @override
  String get snapshotRecoverSuccess => '快照恢复成功';

  @override
  String get snapshotRecoverFailed => '快照恢复失败';

  @override
  String get snapshotDeleteTitle => '删除快照';

  @override
  String get snapshotDeleteConfirm => '确定要删除选中的快照吗？此操作不可恢复。';

  @override
  String get snapshotDeleteSuccess => '快照删除成功';

  @override
  String get snapshotDeleteFailed => '快照删除失败';

  @override
  String get serverModuleSystemSettings => '系统设置';
}
