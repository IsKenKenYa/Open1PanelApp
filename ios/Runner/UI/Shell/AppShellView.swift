import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
    let engine: FlutterEngine

    func makeUIViewController(context: Context) -> FlutterViewController {
        let controller = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        controller.isViewOpaque = false
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {
    }
}

struct AppShellView: View {
    let engine: FlutterEngine
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var translations = TranslationsManager.shared

    var body: some View {
        TabView {
            ServersView()
                .tabItem {
                    Label(translations.get("nav_servers", fallback: "Servers"), systemImage: "server.rack")
                }

            FilesView()
                .tabItem {
                    Label(translations.get("nav_files", fallback: "Files"), systemImage: "folder")
                }

            ContainersView()
                .tabItem {
                    Label(translations.get("nav_containers", fallback: "Containers"), systemImage: "cube.box")
                }

            AppsView()
                .tabItem {
                    Label(translations.get("nav_apps", fallback: "Apps"), systemImage: "app.badge")
                }

            WebsitesView()
                .tabItem {
                    Label(translations.get("nav_websites", fallback: "Websites"), systemImage: "globe")
                }

            MonitoringView()
                .tabItem {
                    Label(translations.get("nav_monitoring", fallback: "Monitoring"), systemImage: "chart.xyaxis.line")
                }

            ZStack {
                Color(UIColor.systemBackground).ignoresSafeArea()
                FlutterViewControllerRepresentable(engine: engine)
                    .ignoresSafeArea()
            }
            .tabItem {
                Label("Flutter", systemImage: "ellipsis.circle")
            }

            SettingsView()
                .tabItem {
                    Label(translations.get("nav_settings", fallback: "Settings"), systemImage: "gearshape")
                }
        }
        .environmentObject(theme)
        .environmentObject(translations)
        .onAppear {
            translations.load { }
        }
    }
}
