import SwiftUI
import PharosNav

struct DiscoverScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                featuredSection
                artistsSection
                genresSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Subviews

private extension DiscoverScreen {
    var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Artists")
                .font(.title2)
                .fontWeight(.bold)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(ArtistModel.all) { artist in
                        NavigationButtonView(target: .push(.discover(.artistDetail(id: artist.id)))) {
                            ArtistCardView(artist: artist)
                        }
                    }
                }
            }
        }
    }

    var artistsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Artists")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(ArtistModel.all) { artist in
                NavigationButtonView(target: .push(.discover(.artistDetail(id: artist.id)))) {
                    HStack(spacing: 14) {
                        Text(artist.emoji)
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color(.systemGray6), in: .circle)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(artist.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(artist.genre)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(artist.monthlyListeners)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 6)
                }

                if artist.id != ArtistModel.all.last?.id {
                    Divider().padding(.leading, 64)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6), in: .rect(cornerRadius: 16))
    }

    var genresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Browse by Genre")
                .font(.title2)
                .fontWeight(.bold)

            let genres = Array(Set(ArtistModel.all.map(\.genre))).sorted()
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(genres, id: \.self) { genre in
                    NavigationButtonView(target: .push(.discover(.genreAlbums(genre: genre)))) {
                        Text(genre)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.purple.gradient, in: .rect(cornerRadius: 12))
                    }
                }
            }
        }
    }
}

// MARK: - ArtistCardView

private struct ArtistCardView: View {
    let artist: ArtistModel

    var body: some View {
        VStack(spacing: 10) {
            Text(artist.emoji)
                .font(.system(size: 48))
                .frame(width: 90, height: 90)
                .background(Color(.systemGray6), in: .circle)

            Text(artist.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text(artist.genre)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 100)
    }
}

#Preview("Discover — Light") {
    NavigationStack {
        DiscoverScreen()
    }
}

#Preview("Discover — Dark") {
    NavigationStack {
        DiscoverScreen()
    }
    .preferredColorScheme(.dark)
}
