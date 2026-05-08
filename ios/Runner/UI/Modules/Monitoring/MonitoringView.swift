import SwiftUI

struct MonitoringView: View {
    @StateObject private var viewModel = MonitoringViewModel()
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var translations: TranslationsManager

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.metrics.cpu == 0 {
                LoadingView()
            } else {
                List {
                    Section(header: Text(translations.get("monitoring_system_usage", fallback: "System Usage"))) {
                        MetricRow(
                            title: translations.get("dashboard_cpu_usage", fallback: "CPU"),
                            value: String(format: "%.1f%%", viewModel.metrics.cpu),
                            icon: "cpu",
                            color: .blue
                        )
                        MetricRow(
                            title: translations.get("dashboard_memory_usage", fallback: "Memory"),
                            value: String(format: "%.1f%%", viewModel.metrics.memory),
                            icon: "memorychip",
                            color: .purple
                        )
                        MetricRow(
                            title: translations.get("dashboard_disk_usage", fallback: "Disk"),
                            value: String(format: "%.1f%%", viewModel.metrics.disk),
                            icon: "internaldrive",
                            color: .orange
                        )
                    }
                    Section(header: Text(translations.get("monitoring_load_average", fallback: "Load Average"))) {
                        MetricRow(
                            title: "1 Min",
                            value: String(format: "%.2f", viewModel.metrics.load1),
                            icon: "chart.xyaxis.line",
                            color: .green
                        )
                        MetricRow(
                            title: "5 Min",
                            value: String(format: "%.2f", viewModel.metrics.load5),
                            icon: "chart.xyaxis.line",
                            color: .green
                        )
                        MetricRow(
                            title: "15 Min",
                            value: String(format: "%.2f", viewModel.metrics.load15),
                            icon: "chart.xyaxis.line",
                            color: .green
                        )
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(translations.get("nav_monitoring", fallback: "Monitoring"))
        .onAppear {
            viewModel.startAutoRefresh()
        }
        .onDisappear {
            viewModel.stopAutoRefresh()
        }
    }
}

struct MetricRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            Text(title)
            Spacer()
            Text(value)
                .bold()
        }
        .padding(.vertical, 4)
    }
}
