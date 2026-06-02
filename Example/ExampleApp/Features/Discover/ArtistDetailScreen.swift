import SwiftUI
import PharosNav

struct ArtistDetailScreen: View {
    let artistId: String

    private var artist: ArtistModel? {
        ArtistModel.all.first { $0.id == artistId }
    }

    var body: some View {
        Group {
            if let artist {
                content(artist: artist)
            } else {
                ContentUnavailableView("Artist not found", systemImage: "person.slash")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews

private extension ArtistDetailScreen {
    @ViewBuilder
    func content(artist: ArtistModel) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView(artist: artist)
                albumsSection(artist: artist)
                crossFlowSection(artist: artist)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .navigationTitle(artist.name)
    }

    func headerView(artist: ArtistModel) -> some View {
        VStack(spacing: 16) {
            Text(artist.emoji)
                .font(.system(size: 100))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.2), Color.indigo.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: .rect(cornerRadius: 24)
                )

            VStack(spacing: 6) {
                Text(artist.name)
                    .font(.title2)
                    .fontWeight(.bold)

                Label(artist.genre, systemImage: "music.quarternote.3")
                    .font(.subheadline)
                    .foregroundStyle(.purple)

                Text("\(artist.monthlyListeners) monthly listeners")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(artist.bio)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    func albumsSection(artist: ArtistModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discography")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(artist.albums) { album in
                NavigationButtonView(target: .push(.discover(.genreAlbums(genre: album.genre)))) {
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
                            Text("\(album.year) · \(album.genre) · \(album.tracks.count) tracks")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(12)
                    .background(Color(.systemGray6), in: .rect(cornerRadius: 14))
                }
            }
        }
    }

    func crossFlowSection(artist: ArtistModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Explore in Library")
                .font(.title2)
                .fontWeight(.bold)

            if let firstAlbum = artist.albums.first {
                // Demonstrates RouterManager.navigateToFlow(_:then:) — jump to Library tab + push album detail
                Button {
                    AppRouterManager.shared.navigateToFlow(.library) {
                        AppRouterManager.shared.currentRouter?.push(
                            .library(.albumDetail(id: firstAlbum.id))
                        )
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(.purple, in: .circle)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Go to \"\(firstAlbum.title)\" in Library")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            Text("Switches to Library tab and opens album")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .padding(16)
                    .background(Color(.systemGray6), in: .rect(cornerRadius: 14))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ArtistDetailScreen(artistId: "artist-2")
    }
}
