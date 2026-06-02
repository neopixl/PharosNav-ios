import SwiftUI
import PharosNav

// NowPlayingScreen is the root of the modal flow. It wraps its content in a
// NavigationStackView(isTabPage: false) so the nowPlaying router is registered
// on appear and unregistered on dismiss — the tab bar is never disturbed.
struct NowPlayingScreen: View {
    private let routerManager: AppRouterManager = .shared

    var body: some View {
        NavigationStackView(
            routerManager: routerManager,
            flow: AppFlow.nowPlaying,
            isTabPage: false
        ) {
            PlayerRootView()
        }
    }
}

// MARK: - PlayerRootView (root content of the Now Playing stack)

private struct PlayerRootView: View {
    private let currentAlbum = AlbumModel.all[0]
    private let currentTrack = AlbumModel.all[0].tracks[0]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                artworkView
                trackInfoView
                controlsView
                sheetActionsView
                dismissExamplesView
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationTitle("Now Playing")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                // Demonstrates DismissBehavior.auto — dismisses the fullScreenCover
                NavigationDismissButton(behavior: .auto) {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    var artworkView: some View {
        Text(currentAlbum.emoji)
            .font(.system(size: 160))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 48)
            .background(
                LinearGradient(
                    colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: .rect(cornerRadius: 32)
            )
    }

    var trackInfoView: some View {
        VStack(spacing: 8) {
            Text(currentTrack.title)
                .font(.title)
                .fontWeight(.bold)
            Text(currentAlbum.artistName)
                .font(.title3)
                .foregroundStyle(.purple)
            Text(currentAlbum.title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    var controlsView: some View {
        HStack(spacing: 40) {
            Button {
            } label: {
                Image(systemName: "backward.fill")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
            .accessibilityLabel("Previous track")

            Button {
            } label: {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.purple)
            }
            .accessibilityLabel("Pause")

            Button {
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
            .accessibilityLabel("Next track")
        }
        .padding(.vertical, 8)
    }

    var sheetActionsView: some View {
        VStack(spacing: 12) {
            // Demonstrates push within the nowPlaying stack
            NavigationButtonView(target: .push(.nowPlaying(.lyrics(trackId: currentTrack.id)))) {
                Label("View Lyrics", systemImage: "text.quote")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.purple.opacity(0.12), in: .rect(cornerRadius: 14))
                    .foregroundStyle(.purple)
                    .fontWeight(.medium)
            }

            // Demonstrates sheet stacked on top of the fullScreenCover
            // The nowPlaying NavigationStackView owns its own sheet slot — SwiftUI
            // stacks this sheet on top of the fullScreenCover naturally.
            NavigationButtonView(
                target: .sheet(.large, .nowPlaying(.queue))
            ) {
                Label("Up Next", systemImage: "list.bullet.below.rectangle")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5), in: .rect(cornerRadius: 14))
                    .foregroundStyle(.primary)
                    .fontWeight(.medium)
            }
        }
    }

    var dismissExamplesView: some View {
        VStack(spacing: 10) {
            Text("Dismiss Variants")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                // Demonstrates DismissBehavior.dismiss — force dismiss even from root
                NavigationDismissButton(behavior: .dismiss) {
                    Label("Dismiss", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5), in: .rect(cornerRadius: 12))
                        .font(.subheadline)
                }

                // Demonstrates DismissBehavior.popToRoot
                NavigationDismissButton(behavior: .popToRoot) {
                    Label("Pop Root", systemImage: "arrow.up.left")
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
    NowPlayingScreen()
}
