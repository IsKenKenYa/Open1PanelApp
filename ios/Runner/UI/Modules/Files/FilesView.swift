import SwiftUI

struct FilesView: View {
    @StateObject private var viewModel = FilesViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.files.isEmpty {
                EmptyStateView(
                    icon: "folder",
                    message: translations.get("noFilesFound", fallback: "No files found")
                )
            } else {
                List {
                    ForEach(viewModel.files) { file in
                        HStack(spacing: 16) {
                            Image(systemName: file.isDir ? "folder.fill" : "doc.fill")
                                .foregroundColor(file.isDir ? .blue : .gray)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(file.name)
                                    .font(.body)
                                HStack {
                                    if file.size > 0 {
                                        Text(formatSize(file.size))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    if file.modTime > 0 {
                                        Text(formatDate(file.modTime))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(translations.get("nav_files", fallback: "Files"))
        .onAppear {
            viewModel.fetchFiles()
        }
    }

    private func formatSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }

    private func formatDate(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
