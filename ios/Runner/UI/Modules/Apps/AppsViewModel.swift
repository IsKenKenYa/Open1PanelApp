import Foundation

struct AppModel: Identifiable {
    let originalId: String
    let name: String
    let status: String
    let version: String

    var id: String { originalId }
}

class AppsViewModel: ObservableObject {
    @Published var apps: [AppModel] = []
    @Published var isLoading = false
    @Published var isProcessing = false
    @Published var errorMessage: String?

    func fetchApps() {
        isLoading = true
        errorMessage = nil
        ChannelManager.shared.invokeDataMethod("getApps") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let dictArray = result as? [[String: Any]] else { return }
                self?.apps = dictArray.compactMap { dict in
                    guard let name = dict["name"] as? String,
                          let status = dict["status"] as? String,
                          let version = dict["version"] as? String else { return nil }
                    let originalId = dict["appId"] as? String ?? ""
                    return AppModel(originalId: originalId, name: name, status: status, version: version)
                }
            }
        }
    }
}
