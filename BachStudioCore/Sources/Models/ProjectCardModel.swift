import Foundation

public enum SongEmotion: String {
    case joyful = "Joyful"
    case sadness = "Sadness"
    case nostalgic = "Nostalgic"
    case energetic = "Energetic"
    case calm = "Calm"
    case unknown = "Unknown"
}

public struct RecentSongModel: Identifiable {
    public let id = UUID()
    public let imageName: String
    public let dateSaved: Date
    public let emotion: SongEmotion

    public init(imageName: String, dateSaved: Date, emotion: SongEmotion) {
        self.imageName = imageName
        self.dateSaved = dateSaved
        self.emotion = emotion
    }
}

public struct ProjectCardModel: Identifiable {
    public let id = UUID()
    public var title: String
    public var recentSongs: [RecentSongModel]

    public init(title: String, recentSongs: [RecentSongModel] = []) {
        self.title = title
        self.recentSongs = recentSongs
    }

    public var subtitle: String {
        if let latestSong = recentSongs.sorted(by: { $0.dateSaved > $1.dateSaved }).first {
            return latestSong.emotion.rawValue
        } else {
            return "Empty Project"
        }
    }
}
