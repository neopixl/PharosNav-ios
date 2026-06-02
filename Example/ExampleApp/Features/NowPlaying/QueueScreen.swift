import SwiftUI
import PharosNav

struct QueueScreen: View {
    private let upNextTracks: [TrackModel] = AlbumModel.all[0].tracks

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            List(upNextTracks) { track in
                HStack(spacing: 14) {
                    Image(systemName: "music.note")
                        .font(.subheadline)
                        .foregroundStyle(.purple)
                        .frame(width: 32)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(track.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Midnight Echoes · Luna Fade")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(track.duration)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Up Next")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // DismissBehavior.dismiss — close the sheet on top of the fullScreenCover
                NavigationDismissButton(behavior: .dismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    var headerView: some View {
        HStack {
            Image(systemName: "list.bullet.below.rectangle")
                .foregroundStyle(.purple)
            Text("\(upNextTracks.count) tracks in queue")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        QueueScreen()
    }
}
