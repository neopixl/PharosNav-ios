import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerNowPlayingDestination() {
        self.register(NowPlayingDestination.self) { destination in
            switch destination {
            case .player:
                NowPlayingScreen()
            case .lyrics(let trackId):
                LyricsScreen(trackId: trackId)
            case .queue:
                QueueScreen()
            }
        }
    }
}
