import SwiftUI
import PharosNav

struct AlbumDetailScreen: View {
    let albumId: String

    private var album: AlbumModel? {
        AlbumModel.all.first { $0.id == albumId }
    }

    var body: some View {
        Group {
            if let album {
                content(album: album)
            } else {
                ContentUnavailableView("Album not found", systemImage: "music.note")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews

private extension AlbumDetailScreen {
    @ViewBuilder
    func content(album: AlbumModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                albumHeaderView(album: album)
                trackListView(album: album)
                artistSectionView(album: album)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle(album.title)
    }

    func albumHeaderView(album: AlbumModel) -> some View {
        VStack(spacing: 16) {
            Text(album.emoji)
                .font(.system(size: 100))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(Color(.systemGray6), in: .rect(cornerRadius: 20))

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(album.artistName)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(album.genre) · \(album.year)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                // Demonstrates sheet(.medium) — a quick artist preview
                NavigationButtonView(target: .sheet(.medium, .library(.artistInfo(id: album.artistId)))) {
                    Label("Artist", systemImage: "person.circle")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.purple.opacity(0.12), in: .capsule)
                        .foregroundStyle(.purple)
                }
            }

            Text(album.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    func trackListView(album: AlbumModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tracks")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(album.tracks) { track in
                // Demonstrates push
                NavigationButtonView(target: .push(.library(.trackDetail(albumId: album.id, trackId: track.id)))) {
                    HStack(spacing: 14) {
                        Text("\(track.trackNumber)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(width: 20, alignment: .center)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(track.title)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Text(track.duration)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 10)
                }

                if track.trackNumber < album.tracks.count {
                    Divider().padding(.leading, 34)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6), in: .rect(cornerRadius: 16))
    }

    func artistSectionView(album: AlbumModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("More from this artist")
                .font(.title2)
                .fontWeight(.bold)

            // Demonstrates sheet(.large)
            NavigationButtonView(target: .sheet(.large, .library(.artistInfo(id: album.artistId)))) {
                HStack(spacing: 12) {
                    Text(album.emoji)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(album.artistName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text("View full artist profile")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.purple)
                }
                .padding(16)
                .background(Color(.systemGray6), in: .rect(cornerRadius: 14))
            }
        }
    }
}

#Preview {
    NavigationStack {
        AlbumDetailScreen(albumId: "album-1")
    }
}
