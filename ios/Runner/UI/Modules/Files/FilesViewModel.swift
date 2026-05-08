import Foundation

struct FileModel: Identifiable {
    let name: String
    let isDir: Bool
    let path: String
    let size: Int64
    let modTime: Int64

    var id: String { path }
}

class FilesViewModel: ObservableObject {
    @Published var files: [FileModel] = []
    @Published var isLoading = false
    @Published var isProcessing = false
    @Published var currentPath: String = "/"
    @Published var errorMessage: String?

    func fetchFiles(path: String? = nil) {
        let targetPath = path ?? currentPath
        isLoading = true
        errorMessage = nil
        ChannelManager.shared.invokeDataMethod("getFiles", arguments: ["path": targetPath]) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.currentPath = targetPath
                guard let dictArray = result as? [[String: Any]] else { return }
                self?.files = dictArray.compactMap { dict in
                    guard let name = dict["name"] as? String else { return nil }
                    let isDir = dict["isDir"] as? Bool ?? false
                    let size = dict["size"] as? Int64 ?? 0
                    let modTime = dict["modTime"] as? Int64 ?? 0
                    let fullPath = (targetPath as NSString).appendingPathComponent(name)
                    return FileModel(name: name, isDir: isDir, path: fullPath, size: size, modTime: modTime)
                }
            }
        }
    }
}
