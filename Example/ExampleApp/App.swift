import SwiftUI
import PharosNav

@main
struct ExampleAppApp: App {

    init() {
        NavigationRegistry.shared.registerLibraryDestination()
        NavigationRegistry.shared.registerDiscoverDestination()
        NavigationRegistry.shared.registerNowPlayingDestination()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
