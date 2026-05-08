import Flutter
import UIKit
import SwiftUI

@main
struct RunnerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var uiRenderMode: String = "native"
    @State private var modeLoaded: Bool = false

    var body: some Scene {
        WindowGroup {
            if !modeLoaded {
                Color.white.ignoresSafeArea().onAppear {
                    loadRenderMode()
                }
            } else if uiRenderMode == "md3" {
                FlutterViewControllerRepresentable(engine: appDelegate.flutterEngine)
                    .ignoresSafeArea()
            } else {
                AppShellView(engine: appDelegate.flutterEngine)
            }
        }
    }

    private func loadRenderMode() {
        ChannelManager.shared.invokeDataMethod("getUIRenderMode") { result in
            let mode = result as? String ?? "native"
            DispatchQueue.main.async {
                self.uiRenderMode = mode
                self.modeLoaded = true
            }
        }
    }
}

@objc class AppDelegate: FlutterAppDelegate {
    let flutterEngine = FlutterEngine(name: "my flutter engine")

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        ChannelManager.shared.setup(binaryMessenger: flutterEngine.binaryMessenger)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
