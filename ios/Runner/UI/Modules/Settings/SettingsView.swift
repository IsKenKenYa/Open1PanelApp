import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(translations.get("settings_display", fallback: "Display"))) {
                    Picker(translations.get("settings_ui_render_mode", fallback: "UI Render Mode"), selection: Binding(
                        get: { viewModel.renderMode },
                        set: { viewModel.updateRenderMode($0) }
                    )) {
                        Text(translations.get("settings_ui_render_mode_native", fallback: "Native")).tag("native")
                        Text(translations.get("settings_ui_render_mode_md3", fallback: "MDUI3")).tag("md3")
                    }
                    if viewModel.showRestartHint {
                        Text(translations.get("settings_restart_hint", fallback: "Please restart the app for the UI render mode changes to take effect."))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text(translations.get("settings_storage", fallback: "Storage"))) {
                    HStack {
                        Text(translations.get("settings_cache_title", fallback: "Cache"))
                        Spacer()
                        if viewModel.isClearingCache {
                            ProgressView()
                        } else {
                            Button(translations.get("settings_cache_clear", fallback: "Clear Cache")) {
                                viewModel.clearCache()
                            }
                            .foregroundColor(.red)
                        }
                    }
                    if let msg = viewModel.cacheClearMessage {
                        Text(msg)
                            .font(.caption)
                            .foregroundColor(msg.hasPrefix("✓") ? .green : .red)
                    }
                }
                Section(header: Text(translations.get("settings_about", fallback: "About"))) {
                    HStack {
                        Text(translations.get("settings_version", fallback: "Version"))
                        Spacer()
                        Text("v\(viewModel.appVersion)")
                            .foregroundColor(.secondary)
                    }
                    Button(action: { viewModel.openGitHub() }) {
                        HStack {
                            Text("GitHub")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(translations.get("nav_settings", fallback: "Settings"))
        }
    }
}
