import Foundation

struct ArtistModel: Identifiable {
    let id: String
    let name: String
    let genre: String
    let emoji: String
    let bio: String
    let monthlyListeners: String

    static let all: [ArtistModel] = [
        ArtistModel(id: "artist-1", name: "Luna Fade", genre: "Indie Pop", emoji: "🌙", bio: "Luna Fade blends ethereal vocals with lush production, crafting intimate pop anthems heard around the world.", monthlyListeners: "4.2M"),
        ArtistModel(id: "artist-2", name: "The Amber Tones", genre: "Alternative Rock", emoji: "☀️", bio: "The Amber Tones are a four-piece band from Portland known for their explosive live shows and hook-laden songwriting.", monthlyListeners: "2.8M"),
        ArtistModel(id: "artist-3", name: "Casio Dreams", genre: "Synth Wave", emoji: "🎹", bio: "Solo producer Casio Dreams crafts meticulously layered synth-wave from a Tokyo home studio.", monthlyListeners: "1.5M"),
        ArtistModel(id: "artist-4", name: "Coral & Sea", genre: "Ambient", emoji: "🌊", bio: "Coral & Sea is an ambient duo creating meditative soundscapes inspired by the natural world.", monthlyListeners: "890K"),
        ArtistModel(id: "artist-5", name: "The Embers", genre: "Folk Rock", emoji: "🔥", bio: "The Embers tour relentlessly, delivering genuine folk rock with hard-earned grit and warmth.", monthlyListeners: "3.1M"),
    ]

    var albums: [AlbumModel] {
        AlbumModel.all.filter { $0.artistId == id }
    }
}
