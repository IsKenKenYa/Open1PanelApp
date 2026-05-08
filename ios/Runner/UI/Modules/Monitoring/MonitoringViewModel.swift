import Foundation

struct MonitoringModel {
    var cpu: Double = 0
    var memory: Double = 0
    var disk: Double = 0
    var load1: Double = 0
    var load5: Double = 0
    var load15: Double = 0
}

class MonitoringViewModel: ObservableObject {
    @Published var metrics = MonitoringModel()
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var refreshTimer: Timer?
    private let refreshInterval: TimeInterval = 5

    func fetchMonitoring() {
        isLoading = true
        errorMessage = nil
        ChannelManager.shared.invokeDataMethod("getMonitoring") { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let dict = result as? [String: Any] else { return }

                func toDouble(_ v: Any?) -> Double {
                    if let d = v as? Double { return d }
                    if let i = v as? Int { return Double(i) }
                    return 0
                }

                self?.metrics.cpu = toDouble(dict["cpu"])
                self?.metrics.memory = toDouble(dict["memory"])
                self?.metrics.disk = toDouble(dict["disk"])
                self?.metrics.load1 = toDouble(dict["load1"])
                self?.metrics.load5 = toDouble(dict["load5"])
                self?.metrics.load15 = toDouble(dict["load15"])
            }
        }
    }

    func startAutoRefresh() {
        fetchMonitoring()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            self?.fetchMonitoring()
        }
    }

    func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    deinit { stopAutoRefresh() }
}
