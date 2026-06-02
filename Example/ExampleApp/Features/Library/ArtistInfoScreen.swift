import SwiftUI
import PharosNav

struct ArtistInfoScreen: View {
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
    }
}

// MARK: - Subviews

private extension ArtistInfoScreen {
    @ViewBuilder
    func content(artist: ArtistModel) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // Dismiss button in toolbar (sheet presentation)
                artistHeaderView(artist: artist)
                bioSection(artist: artist)
                albumsSection(artist: artist)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle(artist.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Demonstrates DismissBehavior.dismiss (force close the sheet)
                NavigationDismissButton(behavior: .dismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    func artistHeaderView(artist: ArtistModel) -> some View {
        VStack(spacing: 12) {
            Text(artist.emoji)
                .font(.system(size: 80))
                .frame(width: 120, height: 120)
                .background(Color(.systemGray6), in: .circle)

            Text(artist.name)
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: 16) {
                Label(artist.genre, systemImage: "music.quarternote.3")
                    .font(.caption)
                    .foregroundStyle(.purple)
                Label("\(artist.monthlyListeners) listeners", systemImage: "headphones")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }

    func bioSection(artist: ArtistModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.headline)
            Text(artist.bio)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemGray6), in: .rect(cornerRadius: 14))
    }

    func albumsSection(artist: ArtistModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Albums")
                .font(.headline)

            ForEach(artist.albums) { album in
                NavigationButtonView(target: .push(.library(.albumDetail(id: album.id)))) {
                    HStack(spacing: 12) {
                        Text(album.emoji)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray5), in: .rect(cornerRadius: 8))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(album.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            Text("\(album.year) · \(album.tracks.count) tracks")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6), in: .rect(cornerRadius: 14))
    }
}

#Preview {
    NavigationStack {
        ArtistInfoScreen(artistId: "artist-1")
    }
}
