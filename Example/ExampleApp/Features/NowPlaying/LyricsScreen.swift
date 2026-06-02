import SwiftUI
import PharosNav

struct LyricsScreen: View {
    let trackId: String

    private var track: TrackModel? {
        AlbumModel.all.flatMap(\.tracks).first { $0.id == trackId }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let track {
                    Text(track.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 8)

                    Text(mockLyrics)
                        .font(.body)
                        .lineSpacing(8)
                        .foregroundStyle(.primary)
                } else {
                    ContentUnavailableView("Lyrics not available", systemImage: "text.slash")
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationTitle("Lyrics")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationDismissButton(behavior: .pop) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        // fitContent sheet gets its background from the bgColor passed in SheetStyle
        .background(Color.indigo.opacity(0.05))
    }

    private var mockLyrics: String {
        """
        Verse 1:
        Walking down the city lights
        Neon signs and quiet nights
        Every corner tells a story
        Every shadow holds a memory

        Chorus:
        In the midnight echoes
        I hear your voice again
        Through the silent windows
        Time becomes my friend

        Verse 2:
        Coffee shops and empty chairs
        A thousand strangers, no one cares
        But somewhere in the evening glow
        There's a place that I used to know

        Chorus:
        In the midnight echoes
        I hear your voice again
        Through the silent windows
        Time becomes my friend

        Bridge:
        Let the music carry you away
        Let the rhythm wash the night away
        Every beat a new beginning
        Every note a reason to stay

        Outro:
        In the midnight echoes...
        """
    }
}

#Preview {
    NavigationStack {
        LyricsScreen(trackId: "t1-1")
    }
}
