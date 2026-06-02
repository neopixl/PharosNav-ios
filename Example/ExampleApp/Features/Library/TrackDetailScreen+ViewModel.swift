import Foundation
import PharosNav

extension TrackDetailScreen {
    @Observable @MainActor final class ViewModel: Routable {
        // Demonstrates cross-flow navigation driven by a Routable conformer.
        func navigateToArtistInDiscover(artistId: String) {
            AppRouterManager.shared.navigateToFlow(.discover) {
                AppRouterManager.shared.currentRouter?.push(.discover(.artistDetail(id: artistId)))
            }
        }
    }
}
