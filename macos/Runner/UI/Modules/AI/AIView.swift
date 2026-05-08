import SwiftUI

struct AIView: View {
    @StateObject private var viewModel = AIViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    @State private var modelToDelete: AIModel?
    @State private var showDeleteConfirm = false

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.models.isEmpty {
                EmptyStateView(
                    icon: "cpu.fill",
                    message: translations.get("noAIModelsFound", fallback: "No AI models found")
                )
            } else {
                Table(viewModel.models) {
                    TableColumn(translations.get("ai_model_name", fallback: "Model")) { model in
                        HStack {
                            Image(systemName: "cpu.fill")
                                .foregroundColor(.purple)
                            Text(model.name)
                                .fontWeight(.medium)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                modelToDelete = model
                                showDeleteConfirm = true
                            } label: {
                                Label(translations.get("delete", fallback: "Delete"), systemImage: "trash")
                            }
                        }
                    }
                    TableColumn(translations.get("ai_model_size", fallback: "Size")) { model in
                        Text(model.size.isEmpty ? "--" : model.size)
                            .foregroundColor(.secondary)
                    }
                    TableColumn(translations.get("ai_model_modified", fallback: "Modified")) { model in
                        Text(model.modified.isEmpty ? "--" : model.modified)
                            .foregroundColor(.secondary)
                    }
                }
                .tableStyle(.inset)
                .disableAlternatingRowBackgrounds()
            }
        }
        .navigationTitle(translations.get("nav_ai", fallback: "AI"))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                if viewModel.isProcessing {
                    ProgressView().scaleEffect(0.6)
                } else {
                    Button { viewModel.fetchModels() } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help(translations.get("refresh", fallback: "Refresh"))
                }
            }
        }
        .confirmationDialog(
            translations.get("deleteConfirm", fallback: "Delete model \"\(modelToDelete?.name ?? "")\"?"),
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button(translations.get("delete", fallback: "Delete"), role: .destructive) {
                if let m = modelToDelete { Task { await viewModel.deleteModel(id: m.originalId) } }
            }
            Button(translations.get("commonCancel", fallback: "Cancel"), role: .cancel) {}
        } message: {
            Text(translations.get("deleteModelCannotUndo", fallback: "The model weights will be permanently deleted."))
        }
        .alert(translations.get("error", fallback: "Error"), isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button(translations.get("ok", fallback: "OK"), role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear { viewModel.fetchModels() }
    }
}
