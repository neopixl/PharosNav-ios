import Foundation

struct AlbumModel: Identifiable {
    let id: String
    let title: String
    let artistId: String
    let artistName: String
    let year: Int
    let genre: String
    let emoji: String
    let description: String
    let tracks: [TrackModel]

    static let all: [AlbumModel] = [
        AlbumModel(
            id: "album-1",
            title: "Midnight Echoes",
            artistId: "artist-1",
            artistName: "Luna Fade",
            year: 2023,
            genre: "Indie Pop",
            emoji: "🌙",
            description: "A dreamy indie pop journey through late-night city landscapes and introspective moments.",
            tracks: [
                TrackModel(id: "t1-1", title: "City Lights", duration: "3:42", trackNumber: 1, albumId: "album-1"),
                TrackModel(id: "t1-2", title: "Neon Rain", duration: "4:15", trackNumber: 2, albumId: "album-1"),
                TrackModel(id: "t1-3", title: "Hollow Streets", duration: "3:58", trackNumber: 3, albumId: "album-1"),
                TrackModel(id: "t1-4", title: "Midnight Echoes", duration: "5:02", trackNumber: 4, albumId: "album-1"),
                TrackModel(id: "t1-5", title: "Glass Garden", duration: "3:30", trackNumber: 5, albumId: "album-1"),
            ]
        ),
        AlbumModel(
            id: "album-2",
            title: "Solar Drift",
            artistId: "artist-2",
            artistName: "The Amber Tones",
            year: 2022,
            genre: "Alternative Rock",
            emoji: "☀️",
            description: "Raw energy meets melodic craft on this critically acclaimed alt-rock record.",
            tracks: [
                TrackModel(id: "t2-1", title: "Sunburn", duration: "4:00", trackNumber: 1, albumId: "album-2"),
                TrackModel(id: "t2-2", title: "Molten Roads", duration: "3:47", trackNumber: 2, albumId: "album-2"),
                TrackModel(id: "t2-3", title: "Solar Drift", duration: "5:21", trackNumber: 3, albumId: "album-2"),
                TrackModel(id: "t2-4", title: "Desert Wind", duration: "4:09", trackNumber: 4, albumId: "album-2"),
                TrackModel(id: "t2-5", title: "Afterglow", duration: "3:55", trackNumber: 5, albumId: "album-2"),
            ]
        ),
        AlbumModel(
            id: "album-3",
            title: "Velvet Underground",
            artistId: "artist-3",
            artistName: "Casio Dreams",
            year: 2024,
            genre: "Synth Wave",
            emoji: "🎹",
            description: "Lush synthesizer textures and pulsing rhythms define this synth-wave masterpiece.",
            tracks: [
                TrackModel(id: "t3-1", title: "Boot Sequence", duration: "2:38", trackNumber: 1, albumId: "album-3"),
                TrackModel(id: "t3-2", title: "Velvet Underground", duration: "4:44", trackNumber: 2, albumId: "album-3"),
                TrackModel(id: "t3-3", title: "Neon Grid", duration: "3:59", trackNumber: 3, albumId: "album-3"),
                TrackModel(id: "t3-4", title: "Cascade", duration: "5:13", trackNumber: 4, albumId: "album-3"),
                TrackModel(id: "t3-5", title: "Shutdown Sequence", duration: "3:22", trackNumber: 5, albumId: "album-3"),
            ]
        ),
        AlbumModel(
            id: "album-4",
            title: "Deep Blue",
            artistId: "artist-4",
            artistName: "Coral & Sea",
            year: 2023,
            genre: "Ambient",
            emoji: "🌊",
            description: "Meditative soundscapes inspired by the ocean's depth and stillness.",
            tracks: [
                TrackModel(id: "t4-1", title: "Tide Watcher", duration: "6:20", trackNumber: 1, albumId: "album-4"),
                TrackModel(id: "t4-2", title: "Undercurrent", duration: "5:47", trackNumber: 2, albumId: "album-4"),
                TrackModel(id: "t4-3", title: "Deep Blue", duration: "7:03", trackNumber: 3, albumId: "album-4"),
                TrackModel(id: "t4-4", title: "Reef", duration: "4:55", trackNumber: 4, albumId: "album-4"),
            ]
        ),
        AlbumModel(
            id: "album-5",
            title: "Wildfire",
            artistId: "artist-5",
            artistName: "The Embers",
            year: 2021,
            genre: "Folk Rock",
            emoji: "🔥",
            description: "Heartfelt folk rock stories about love, loss, and the open road.",
            tracks: [
                TrackModel(id: "t5-1", title: "Wildfire", duration: "3:32", trackNumber: 1, albumId: "album-5"),
                TrackModel(id: "t5-2", title: "Ash & Bone", duration: "4:18", trackNumber: 2, albumId: "album-5"),
                TrackModel(id: "t5-3", title: "Mountain Road", duration: "3:50", trackNumber: 3, albumId: "album-5"),
                TrackModel(id: "t5-4", title: "Ember Song", duration: "4:40", trackNumber: 4, albumId: "album-5"),
                TrackModel(id: "t5-5", title: "Last Light", duration: "5:05", trackNumber: 5, albumId: "album-5"),
            ]
        ),
    ]
}
