import SwiftUI
import PharosNav

struct TrackDetailScreen: View {
    let albumId: String
    let trackId: String

    @State private var viewModel = TrackDetailScreen.ViewModel()

    private var album: AlbumModel? {
        AlbumModel.all.first { $0.id == albumId }
    }

    private var track: TrackModel? {
        album?.tracks.first { $0.id == trackId }
    }

    var body: some View {
        Group {
            if let album, let track {
                content(album: album, track: track)
            } else {
                ContentUnavailableView("Track not found", systemImage: "music.note")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews

private extension TrackDetailScreen {
    @ViewBuilder
    func content(album: AlbumModel, track: TrackModel) -> some View {
        ScrollView {
            VStack(spacing: 32) {
                artworkView(album: album)
                trackInfoView(album: album, track: track)
                playbackActionsView(album: album, track: track)
                dismissActionsView
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationTitle(track.title)
    }

    func artworkView(album: AlbumModel) -> some View {
        Text(album.emoji)
            .font(.system(size: 140))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                LinearGradient(
                    colors: [Color.purple.opacity(0.15), Color.indigo.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: .rect(cornerRadius: 28)
            )
    }

    func trackInfoView(album: AlbumModel, track: TrackModel) -> some View {
        VStack(spacing: 8) {
            Text(track.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(album.artistName)
                .font(.title3)
                .foregroundStyle(.purple)

            Text("\(album.title) · Track \(track.trackNumber) · \(track.duration)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    func playbackActionsView(album: AlbumModel, track: TrackModel) -> some View {
        VStack(spacing: 12) {
            // Demonstrates fullScreenCover to open the Now Playing flow
            NavigationButtonView(
                target: .fullScreenCover(.nowPlaying(.player))
            ) {
                Label("Open Now Playing", systemImage: "play.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.purple, in: .rect(cornerRadius: 14))
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }

            // Demonstrates sheet(.fitContent) with a visible background color
            NavigationButtonView(
                target: .sheet(.fitContent(bgColor: .indigo), .nowPlaying(.lyrics(trackId: track.id)))
            ) {
                Label("Show Lyrics", systemImage: "text.quote")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.indigo.opacity(0.12), in: .rect(cornerRadius: 14))
                    .foregroundStyle(.indigo)
                    .fontWeight(.medium)
            }

            // Demonstrates cross-flow navigation from ViewModel
            Button {
                viewModel.navigateToArtistInDiscover(artistId: album.artistId)
            } label: {
                Label("Find Artist in Discover", systemImage: "arrow.triangle.2.circlepath")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5), in: .rect(cornerRadius: 14))
                    .foregroundStyle(.primary)
                    .fontWeight(.medium)
            }
        }
    }

    var dismissActionsView: some View {
        VStack(spacing: 10) {
            Text("Dismiss Examples")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                // Demonstrates DismissBehavior.pop
                NavigationDismissButton(behavior: .pop) {
                    Label("Pop", systemImage: "arrow.left")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5), in: .rect(cornerRadius: 12))
                        .font(.subheadline)
                }

                // Demonstrates DismissBehavior.popToRoot
                NavigationDismissButton(behavior: .popToRoot) {
                    Label("Root", systemImage: "arrow.up.left")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5), in: .rect(cornerRadius: 12))
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TrackDetailScreen(albumId: "album-1", trackId: "t1-1")
    }
}
