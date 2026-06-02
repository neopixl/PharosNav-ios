import PharosNav

enum LibraryDestination: DestinationItem {
    case home
    case albumDetail(id: String)
    case trackDetail(albumId: String, trackId: String)
    case artistInfo(id: String)
}
