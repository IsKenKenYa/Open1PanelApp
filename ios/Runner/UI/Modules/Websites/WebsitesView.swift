import SwiftUI

struct WebsitesView: View {
    @StateObject private var viewModel = WebsitesViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.websites.isEmpty {
                EmptyStateView(
                    icon: "globe",
                    message: translations.get("noWebsitesFound", fallback: "No websites found")
                )
            } else {
                List {
                    ForEach(viewModel.websites) { website in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(website.primaryDomain)
                                    .font(.headline)
                                Spacer()
                                Text(website.status)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(statusColor(website.status).opacity(0.2))
                                    .foregroundColor(statusColor(website.status))
                                    .cornerRadius(8)
                            }
                            if !website.remark.isEmpty {
                                Text(website.remark)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(translations.get("nav_websites", fallback: "Websites"))
        .onAppear {
            viewModel.fetchWebsites()
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "running", "active": return .green
        case "stopped": return .red
        default: return .gray
        }
    }
}
