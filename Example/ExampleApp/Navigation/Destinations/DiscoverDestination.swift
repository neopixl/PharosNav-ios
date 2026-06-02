import PharosNav

enum DiscoverDestination: DestinationItem {
    case home
    case artistDetail(id: String)
    case genreAlbums(genre: String)
}
