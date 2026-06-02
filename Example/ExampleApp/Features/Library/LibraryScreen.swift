import SwiftUI
import PharosNav

struct LibraryScreen: View {
    @State private var viewModel = LibraryScreen.ViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerView
                albumGridView
                nowPlayingBannerView
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .navigationTitle("My Library")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Subviews

private extension LibraryScreen {
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good evening")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("What are you listening to?")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            Spacer()
            // Demonstrates GenericNavigationButton — points directly to the nowPlaying flow
            GenericNavigationButton(
                target: NavigationTarget<AppDestination>.fullScreenCover(.nowPlaying(.player))
            ) {
                Image(systemName: "headphones.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.purple)
            }
        }
        .padding(.top, 8)
    }

    var albumGridView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Albums")
                .font(.title2)
                .fontWeight(.bold)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(AlbumModel.all) { album in
                    NavigationButtonView(target: .push(.library(.albumDetail(id: album.id)))) {
                        AlbumCardView(album: album)
                    }
                }
            }
        }
    }

    var nowPlayingBannerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.bold)

            // Demonstrates pushMany: jump straight to album + first track in one action
            NavigationButtonView(
                target: .pushMany([
                    .library(.albumDetail(id: "album-1")),
                    .library(.trackDetail(albumId: "album-1", trackId: "t1-1"))
                ])
            ) {
                HStack(spacing: 12) {
                    Image(systemName: "play.rectangle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Resume Last Track")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Text("Midnight Echoes · City Lights")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(16)
                .background(.purple, in: .rect(cornerRadius: 14))
            }

            // Demonstrates sheet(.canFullScreen)
            NavigationButtonView(
                target: .sheet(.canFullScreen, .library(.artistInfo(id: "artist-1")))
            ) {
                HStack(spacing: 12) {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 24))
                        .foregroundStyle(.orange)
                    Text("Discover Luna Fade")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .background(.orange.opacity(0.1), in: .rect(cornerRadius: 14))
            }
        }
    }
}

// MARK: - AlbumCardView

private struct AlbumCardView: View {
    let album: AlbumModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(album.emoji)
                .font(.system(size: 52))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(.systemGray6), in: .rect(cornerRadius: 12))

            Text(album.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundStyle(.primary)

            Text(album.artistName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
}

#Preview("Library — Light") {
    NavigationStack {
        LibraryScreen()
    }
}

#Preview("Library — Dark") {
    NavigationStack {
        LibraryScreen()
    }
    .preferredColorScheme(.dark)
}
