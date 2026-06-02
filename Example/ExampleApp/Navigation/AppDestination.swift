import Foundation
import PharosNav

@RecursiveDestination
enum AppDestination: AppDestinationProtocol {
    case library(LibraryDestination)
    case discover(DiscoverDestination)
    case nowPlaying(NowPlayingDestination)
}
