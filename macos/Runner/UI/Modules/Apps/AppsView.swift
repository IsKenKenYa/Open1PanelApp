import SwiftUI

struct AppsView: View {
    @StateObject private var viewModel = AppsViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    @State private var appToUninstall: AppModel?
    @State private var showUninstallConfirm = false

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.apps.isEmpty {
                EmptyStateView(
                    icon: "app.badge",
                    message: translations.get("noAppsFound", fallback: "No apps found")
                )
            } else {
                Table(viewModel.apps) {
                    TableColumn(translations.get("server_name", fallback: "Name")) { app in
                        HStack {
                            Image(systemName: "app.badge")
                                .foregroundColor(.blue)
                            Text(app.name)
                        }
                        .contextMenu {
                            let isRunning = app.status.lowercased() == "running"
                            Button {
                                Task { await viewModel.toggleAppStatus(id: app.originalId, currentStatus: app.status) }
                            } label: {
                                Label(
                                    isRunning ? translations.get("stop", fallback: "Stop") : translations.get("start", fallback: "Start"),
                                    systemImage: isRunning ? "stop.fill" : "play.fill"
                                )
                            }
                            Divider()
                            Button(role: .destructive) {
                                appToUninstall = app
                                showUninstallConfirm = true
                            } label: {
                                Label(translations.get("uninstall", fallback: "Uninstall"), systemImage: "trash")
                            }
                        }
                    }
                    TableColumn(translations.get("app_version", fallback: "Version")) { app in
                        Text(app.version.isEmpty ? "--" : app.version)
                            .foregroundColor(.secondary)
                    }
                    TableColumn(translations.get("app_status", fallback: "Status")) { app in
                        let isRunning = app.status.lowercased() == "running"
                        Text(app.status)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(isRunning ? Color.green.opacity(0.12) : Color.gray.opacity(0.12))
                            .foregroundColor(isRunning ? .green : .gray)
                            .cornerRadius(4)
                    }
                }
                .tableStyle(.inset)
                .disableAlternatingRowBackgrounds()
            }
        }
        .navigationTitle(translations.get("nav_apps", fallback: "Apps"))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                if viewModel.isProcessing {
                    ProgressView().scaleEffect(0.6)
                } else {
                    Button { viewModel.fetchApps() } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help(translations.get("refresh", fallback: "Refresh"))
                }
            }
        }
        .confirmationDialog(
            translations.get("uninstallConfirm", fallback: "Uninstall \"\(appToUninstall?.name ?? "")\"?"),
            isPresented: $showUninstallConfirm,
            titleVisibility: .visible
        ) {
            Button(translations.get("uninstall", fallback: "Uninstall"), role: .destructive) {
                if let a = appToUninstall { Task { await viewModel.uninstallApp(id: a.originalId) } }
            }
            Button(translations.get("commonCancel", fallback: "Cancel"), role: .cancel) {}
        } message: {
            Text(translations.get("uninstallCannotUndo", fallback: "This will remove the app and its data. This action cannot be undone."))
        }
        .alert(translations.get("error", fallback: "Error"), isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button(translations.get("ok", fallback: "OK"), role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear { viewModel.fetchApps() }
    }
}
