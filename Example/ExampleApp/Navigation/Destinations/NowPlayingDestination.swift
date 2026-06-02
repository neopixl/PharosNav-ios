import PharosNav

enum NowPlayingDestination: DestinationItem {
    case player
    case lyrics(trackId: String)
    case queue
}
