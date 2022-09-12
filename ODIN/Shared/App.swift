import OdinKit
import SwiftUI

@main
struct OdinApp: App {
    @StateObject var room: OdinRoom = .init()
    @StateObject var settings: AppSettings = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(room)
                .environmentObject(settings)
#if os(macOS)
                .frame(minWidth: 840,  minHeight: 480)
#else
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    settings.reload()
                }
#endif
        }

#if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(settings)
        }
#endif
    }
}
