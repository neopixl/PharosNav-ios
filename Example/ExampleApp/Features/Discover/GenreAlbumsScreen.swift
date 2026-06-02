import SwiftUI
import PharosNav

struct GenreAlbumsScreen: View {
    let genre: String

    private var albums: [AlbumModel] {
        AlbumModel.all.filter { $0.genre == genre }
    }

    var body: some View {
        Group {
            if albums.isEmpty {
                ContentUnavailableView("No albums", systemImage: "music.note.list")
            } else {
                List(albums) { album in
                    NavigationButtonView(target: .push(.discover(.genreAlbums(genre: genre)))) {
                        HStack(spacing: 14) {
                            Text(album.emoji)
                                .font(.title2)
                                .frame(width: 52, height: 52)
                                .background(Color(.systemGray6), in: .rect(cornerRadius: 10))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(album.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                Text("\(album.artistName) · \(album.year)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            // DismissBehavior.auto — pops because this is a pushed screen
                            NavigationDismissButton(behavior: .auto) {
                                Image(systemName: "arrow.left.circle")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(genre)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GenreAlbumsScreen(genre: "Indie Pop")
    }
}
