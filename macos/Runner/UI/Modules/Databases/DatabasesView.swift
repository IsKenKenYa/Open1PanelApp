import SwiftUI

struct DatabasesView: View {
    @StateObject private var viewModel = DatabasesViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    @State private var dbToDelete: DatabaseModel?
    @State private var showDeleteConfirm = false

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.databases.isEmpty {
                EmptyStateView(
                    icon: "externaldrive.connected.to.line.below",
                    message: translations.get("noDatabasesFound", fallback: "No databases found")
                )
            } else {
                Table(viewModel.databases) {
                    TableColumn(translations.get("database_name", fallback: "Name")) { db in
                        HStack {
                            Image(systemName: "externaldrive.connected.to.line.below")
                                .foregroundColor(.blue)
                            Text(db.name)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                dbToDelete = db
                                showDeleteConfirm = true
                            } label: {
                                Label(translations.get("delete", fallback: "Delete"), systemImage: "trash")
                            }
                        }
                    }
                    TableColumn(translations.get("database_type", fallback: "Type")) { db in
                        Text(db.type.isEmpty ? "--" : db.type)
                            .foregroundColor(.secondary)
                    }
                    TableColumn(translations.get("database_version", fallback: "Version")) { db in
                        Text(db.version.isEmpty ? "--" : db.version)
                            .foregroundColor(.secondary)
                    }
                    TableColumn(translations.get("app_status", fallback: "Status")) { db in
                        let isRunning = db.status.lowercased() == "running"
                        Text(db.status.isEmpty ? "--" : db.status)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(isRunning ? Color.green.opacity(0.12) : Color.red.opacity(0.12))
                            .foregroundColor(isRunning ? .green : .red)
                            .cornerRadius(4)
                    }
                }
                .tableStyle(.inset)
                .disableAlternatingRowBackgrounds()
            }
        }
        .navigationTitle(translations.get("nav_databases", fallback: "Databases"))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                if viewModel.isProcessing {
                    ProgressView().scaleEffect(0.6)
                } else {
                    Button { viewModel.fetchDatabases() } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help(translations.get("refresh", fallback: "Refresh"))
                }
            }
        }
        .confirmationDialog(
            translations.get("deleteConfirm", fallback: "Delete \"\(dbToDelete?.name ?? "")\"?"),
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button(translations.get("delete", fallback: "Delete"), role: .destructive) {
                if let d = dbToDelete { Task { await viewModel.deleteDatabase(id: d.originalId) } }
            }
            Button(translations.get("commonCancel", fallback: "Cancel"), role: .cancel) {}
        } message: {
            Text(translations.get("deleteDatabaseCannotUndo", fallback: "This will delete the database and all its data. This action cannot be undone."))
        }
        .alert(translations.get("error", fallback: "Error"), isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button(translations.get("ok", fallback: "OK"), role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear { viewModel.fetchDatabases() }
    }
}
