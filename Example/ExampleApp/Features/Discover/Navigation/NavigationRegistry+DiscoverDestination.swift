import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerDiscoverDestination() {
        self.register(DiscoverDestination.self) { destination in
            switch destination {
            case .home:
                DiscoverScreen()
            case .artistDetail(let id):
                ArtistDetailScreen(artistId: id)
            case .genreAlbums(let genre):
                GenreAlbumsScreen(genre: genre)
            }
        }
    }
}
