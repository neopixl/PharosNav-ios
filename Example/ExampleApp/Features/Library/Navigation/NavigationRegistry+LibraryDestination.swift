import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerLibraryDestination() {
        self.register(LibraryDestination.self) { destination in
            switch destination {
            case .home:
                LibraryScreen()
            case .albumDetail(let id):
                AlbumDetailScreen(albumId: id)
            case .trackDetail(let albumId, let trackId):
                TrackDetailScreen(albumId: albumId, trackId: trackId)
            case .artistInfo(let id):
                ArtistInfoScreen(artistId: id)
            }
        }
    }
}
