import SwiftUI
import SwiftData

@main
struct ThoughtCaptureApp: App {
    @State private var appearance = AppearanceConfig()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appearanceConfig, appearance)
        }
        .modelContainer(for: ThoughtThread.self)
    }
}
