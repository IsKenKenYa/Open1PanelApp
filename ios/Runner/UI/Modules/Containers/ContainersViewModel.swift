import Foundation

struct ContainerModel: Identifiable {
    let originalId: String
    let name: String
    let image: String
    let state: String
    let cpuUsage: Double?
    let memoryUsage: Double?

    var id: String { originalId }
}

class ContainersViewModel: ObservableObject {
    @Published var containers: [ContainerModel] = []
    @Published var isLoading = false
    @Published var isProcessing = false
    @Published var errorMessage: String?

    func fetchContainers() {
        isLoading = true
        errorMessage = nil
        ChannelManager.shared.invokeDataMethod("getContainers") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let dictArray = result as? [[String: Any]] else { return }
                self?.containers = dictArray.compactMap { dict in
                    guard let name = dict["name"] as? String,
                          let image = dict["image"] as? String,
                          let state = dict["state"] as? String else { return nil }
                    let originalId = dict["id"] as? String ?? ""
                    let cpuUsage = dict["cpuUsage"] as? Double
                    let memoryUsage = dict["memoryUsage"] as? Double
                    return ContainerModel(originalId: originalId, name: name, image: image, state: state, cpuUsage: cpuUsage, memoryUsage: memoryUsage)
                }
            }
        }
    }
}
