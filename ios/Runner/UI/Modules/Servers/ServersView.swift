import SwiftUI

struct ServersView: View {
    @StateObject private var viewModel = ServersViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.servers.isEmpty {
                EmptyStateView(
                    icon: "server.rack",
                    message: translations.get("noServersFound", fallback: "No servers found")
                )
            } else {
                List {
                    ForEach(viewModel.servers) { server in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(server.name)
                                    .font(.headline)
                                Spacer()
                                if server.isCurrent {
                                    Text(translations.get("server_status_online", fallback: "Current"))
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .foregroundColor(.green)
                                        .cornerRadius(8)
                                }
                            }
                            Text(server.url)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack(spacing: 16) {
                                HStack(spacing: 4) {
                                    Image(systemName: "cpu")
                                        .foregroundColor(.blue)
                                    Text(String(format: "%.1f%%", server.cpu))
                                        .font(.caption)
                                }
                                HStack(spacing: 4) {
                                    Image(systemName: "memorychip")
                                        .foregroundColor(.purple)
                                    Text(String(format: "%.1f%%", server.memory))
                                        .font(.caption)
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
        .navigationTitle(translations.get("nav_servers", fallback: "Servers"))
        .onAppear {
            viewModel.fetchServers()
        }
    }
}
