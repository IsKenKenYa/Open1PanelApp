import SwiftUI

struct ContainersView: View {
    @StateObject private var viewModel = ContainersViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.containers.isEmpty {
                EmptyStateView(
                    icon: "cube.box",
                    message: translations.get("noContainersFound", fallback: "No containers found")
                )
            } else {
                List {
                    ForEach(viewModel.containers) { container in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(container.name)
                                    .font(.headline)
                                Spacer()
                                Text(container.state)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(stateColor(container.state).opacity(0.2))
                                    .foregroundColor(stateColor(container.state))
                                    .cornerRadius(8)
                            }
                            Text(container.image)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            HStack(spacing: 16) {
                                if let cpu = container.cpuUsage {
                                    HStack(spacing: 4) {
                                        Image(systemName: "cpu")
                                            .foregroundColor(.blue)
                                        Text(String(format: "%.2f%%", cpu))
                                            .font(.caption)
                                    }
                                }
                                if let mem = container.memoryUsage {
                                    HStack(spacing: 4) {
                                        Image(systemName: "memorychip")
                                            .foregroundColor(.purple)
                                        Text(formatSize(Int64(mem)))
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(translations.get("nav_containers", fallback: "Containers"))
        .onAppear {
            viewModel.fetchContainers()
        }
    }

    private func stateColor(_ state: String) -> Color {
        switch state.lowercased() {
        case "running": return .green
        case "exited", "stopped": return .red
        case "paused": return .orange
        default: return .gray
        }
    }

    private func formatSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: bytes)
    }
}
