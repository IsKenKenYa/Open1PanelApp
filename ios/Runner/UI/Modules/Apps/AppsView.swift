import SwiftUI

struct AppsView: View {
    @StateObject private var viewModel = AppsViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

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
                List {
                    ForEach(viewModel.apps) { app in
                        HStack(spacing: 16) {
                            Image(systemName: "app.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(app.name)
                                    .font(.headline)
                                Text(app.version)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(app.status)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(statusColor(app.status).opacity(0.2))
                                .foregroundColor(statusColor(app.status))
                                .cornerRadius(8)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(translations.get("nav_apps", fallback: "Apps"))
        .onAppear {
            viewModel.fetchApps()
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "installed", "running", "active": return .green
        case "error", "failed": return .red
        default: return .gray
        }
    }
}
