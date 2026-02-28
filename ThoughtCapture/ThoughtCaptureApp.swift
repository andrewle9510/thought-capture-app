import SwiftUI
import SwiftData

@main
struct ThoughtCaptureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ThoughtThread.self)
    }
}
