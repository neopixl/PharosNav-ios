import SwiftUI
import PharosNav

struct ContentView: View {
    @State private var appRouterManager: AppRouterManager = .shared

    var body: some View {
        // .nowPlaying is intentionally excluded from the flows array — it is a standalone
        // modal flow presented as fullScreenCover from within any tab.
        NavigationTabView(
            routerManager: appRouterManager,
            flows: [.library, .discover]
        ) { flow in
            switch flow {
            case .library:
                NavigationTabItem {
                    Label("Library", systemImage: "music.note.list")
                } content: {
                    LibraryScreen()
                }
            case .discover:
                NavigationTabItem {
                    Label("Discover", systemImage: "safari")
                } content: {
                    DiscoverScreen()
                }
            case .nowPlaying:
                nil
            }
        }
    }
}

#Preview {
    ContentView()
}
