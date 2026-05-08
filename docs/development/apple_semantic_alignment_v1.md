# Apple Semantic Alignment Report v1

> Date: 2026-05-07
> Scope: iOS ↔ macOS native track semantic alignment

## 1. ChannelManager Alignment

### Method Signatures (Already Aligned)

Both platforms share identical method signatures:

| Method | iOS | macOS | Status |
|--------|-----|-------|--------|
| `setup(binaryMessenger:)` | ✅ | ✅ | Aligned |
| `invokeDataMethod(_:arguments:completion:)` | ✅ | ✅ | Aligned |
| `invokeDataMethodAsync(_:arguments:)` | ✅ | ✅ | Aligned |
| `invokeShellMethod(_:arguments:completion:)` | ✅ | ✅ | Aligned |

### Platform-Specific Differences (Must Remain)

| Aspect | iOS | macOS | Reason |
|--------|-----|-------|--------|
| Import | `Flutter` | `FlutterMacOS` | SDK requirement |
| Shell channel name | `onepanel/ios_channel` | `onepanel/macos_shell` | Platform routing |
| Shell handler | `ping` → `pong` | `setTitle` (window title) | Platform capability |

## 2. Navigation Naming Alignment

### Unified i18n Key Convention

macOS navigation titles were migrated from `serverModule*` / `operations*` keys to the `nav_*` convention used by iOS:

| Module | Old macOS Key | New Unified Key |
|--------|--------------|-----------------|
| Servers | `navServer` | `nav_servers` |
| Apps | `serverModuleApps` | `nav_apps` |
| Containers | `serverModuleContainers` | `nav_containers` |
| Websites | `serverModuleWebsites` | `nav_websites` |
| Files | `navFiles` | `nav_files` |
| Monitoring | `serverModuleMonitoring` | `nav_monitoring` |
| Dashboard | `serverModuleDashboard` | `nav_dashboard` |
| Databases | `serverModuleDatabases` | `nav_databases` |
| Firewall | `serverModuleFirewall` | `nav_firewall` |
| Cron Jobs | `operationsCronjobsTitle` | `nav_cron_jobs` |
| Backups | `operationsBackupsTitle` | `nav_backups` |
| AI | `serverModuleAi` | `nav_ai` |
| Settings | `navSettings` | `nav_settings` (already aligned) |

### Navigation Architecture Difference (Must Remain)

| Aspect | iOS | macOS | Reason |
|--------|-----|-------|--------|
| Navigation container | `TabView` | `NavigationSplitView` (Sidebar) | Platform HIG conventions |
| Content layout | `List` + `InsetGroupedListStyle` | `Table` + `.inset` | Desktop vs mobile UX |

## 3. Loading / Empty / Error State Alignment

### Shared Components Created

Three reusable components were created in `macos/Runner/UI/Components/` matching the iOS counterparts:

| Component | iOS Path | macOS Path | Status |
|-----------|----------|------------|--------|
| `LoadingView` | `ios/Runner/UI/Components/LoadingView.swift` | `macos/Runner/UI/Components/LoadingView.swift` | ✅ Created |
| `ErrorView` | `ios/Runner/UI/Components/ErrorView.swift` | `macos/Runner/UI/Components/ErrorView.swift` | ✅ Created |
| `EmptyStateView` | `ios/Runner/UI/Components/EmptyStateView.swift` | `macos/Runner/UI/Components/EmptyStateView.swift` | ✅ Created |

### State Pattern (Unified)

All modules on both platforms now follow the same state rendering pattern:

```
if viewModel.isLoading {
    LoadingView()
} else if viewModel.data.isEmpty {
    EmptyStateView(icon: "...", message: translations.get("..."))
} else {
    // Content (List on iOS, Table on macOS)
}
```

### Modules Updated

| Module | LoadingView | EmptyStateView | Error i18n |
|--------|-------------|----------------|------------|
| Servers | ✅ | ✅ | ✅ |
| Apps | ✅ | ✅ | ✅ |
| Containers | ✅ | ✅ | ✅ |
| Websites | ✅ | ✅ | ✅ |
| Files | ✅ | ✅ | ✅ |
| Monitoring | ✅ | N/A (no empty) | ✅ |
| Dashboard | ✅ | N/A (no empty) | ✅ |
| Databases | ✅ | ✅ | ✅ |
| Firewall | ✅ | ✅ | ✅ |
| Cron Jobs | ✅ | ✅ | ✅ |
| Backups | ✅ | ✅ | ✅ |
| AI | ✅ | ✅ | ✅ |

## 4. Error Feedback Alignment

### Unified i18n Keys for Common Actions

All hardcoded strings in macOS views were replaced with `translations.get()` calls:

| Context | i18n Key | Fallback |
|---------|---------|----------|
| Error alert title | `error` | "Error" |
| OK button | `ok` | "OK" |
| Cancel button | `commonCancel` | "Cancel" |
| Delete button | `delete` | "Delete" |
| Delete confirm title | `deleteConfirm` | "Delete \"...\"?" |
| Delete undo message | `deleteCannotUndo` | "This action cannot be undone." |
| Refresh tooltip | `refresh` | "Refresh" |
| Add button | `add` | "Add" |
| Retry button (ErrorView) | `retry` | "Retry" |
| Status column | `app_status` | "Status" |
| Server online status | `server_status_online` | "Connected" |

### Error Alert Pattern (Unified)

Both platforms now use the same alert binding pattern:

```swift
.alert(translations.get("error", fallback: "Error"), isPresented: Binding(
    get: { viewModel.errorMessage != nil },
    set: { if !$0 { viewModel.errorMessage = nil } }
)) {
    Button(translations.get("ok", fallback: "OK"), role: .cancel) { viewModel.errorMessage = nil }
} message: {
    Text(viewModel.errorMessage ?? "")
}
```

## 5. ViewModel Published Properties Alignment

### Unified Properties

All ViewModels on both platforms now share these published properties:

| Property | Type | Purpose |
|----------|------|---------|
| `isLoading` | `Bool` | Initial data loading state |
| `isProcessing` | `Bool` | Action in-progress state |
| `errorMessage` | `String?` | Error feedback |

### Model Alignment

| Model | Change |
|-------|--------|
| `ServerModel` | Added `cpu: Double` and `memory: Double` to macOS (matching iOS) |
| `MonitoringModel` | Changed `cpu`, `memory`, `disk` from `Int` to `Double` on macOS (matching iOS) |
| `MonitoringViewModel` | Added `errorMessage: String?` on macOS (matching iOS) |

## 6. Platform Differences That Must Remain

| Difference | Reason |
|------------|--------|
| iOS uses `List` + `ForEach`, macOS uses `Table` + `TableColumn` | Desktop table UX vs mobile list UX |
| iOS shows `cpu`/`memory` inline in server list, macOS shows in table columns | Layout density expectations |
| macOS has toolbar with `ToolbarItem`, iOS does not | Platform navigation patterns |
| macOS has `confirmationDialog` for destructive actions, iOS uses swipe-to-delete or inline | Platform interaction patterns |
| macOS Settings uses custom card layout, iOS uses `Form` + `Section` | Platform HIG conventions |
| macOS has `VisualEffectView` (vibrancy), iOS does not | Platform-specific material |
| macOS shell channel handles `setTitle`, iOS handles `ping` | Platform-specific capabilities |
| macOS has modules not on iOS: Dashboard, Databases, Firewall, CronJobs, Backups, AI | Desktop-first modules |

## 7. i18n Keys Added (Require ARB Updates)

The following new i18n keys were introduced and need to be added to `app_zh.arb` and `app_en.arb`:

- `nav_servers`, `nav_apps`, `nav_containers`, `nav_websites`, `nav_files`, `nav_monitoring`
- `nav_dashboard`, `nav_databases`, `nav_firewall`, `nav_cron_jobs`, `nav_backups`, `nav_ai`
- `noServersFound`, `noAppsFound`, `noContainersFound`, `noWebsitesFound`, `noFilesFound`
- `noDatabasesFound`, `noFirewallRules`, `noCronJobsFound`, `noBackupsFound`, `noAIModelsFound`
- `deleteConfirm`, `deleteCannotUndo`, `deleteDatabaseCannotUndo`, `deleteBackupCannotUndo`, `deleteModelCannotUndo`
- `uninstallConfirm`, `uninstallCannotUndo`
- `error`, `ok`, `commonCancel`, `refresh`, `add`, `retry`
- `server_status_online`, `server_api_token`
- `goUp`, `newFolder`, `folderName`, `create`
- `addFirewallRule`, `firewallPortHint`, `firewallAddressHint`
- `database_version`, `cronjob_last_result`
- `addRule`
