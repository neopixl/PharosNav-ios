import Foundation

extension LibraryScreen {
    @Observable @MainActor final class ViewModel {
        private(set) var albums: [AlbumModel] = AlbumModel.all
    }
}
