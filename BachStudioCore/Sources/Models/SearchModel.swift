import Foundation

public struct SearchResponse: Codable, Sendable {
    public let status: String
    public let queryTimeSeconds: Double
    public let results: [SearchResult]

    public enum CodingKeys: String, CodingKey {
        case status
        case queryTimeSeconds = "query_time_seconds"
        case results
    }
}

public struct SearchResult: Codable, Identifiable, Sendable {
    public var id: String { songId }
    public let rank: Int
    public let songId: String
    public let score: Double
    public let timestamp: Timestamp
    public let moods: [String]
    public let trackTitle: String
    public let artistName: String
    public let albumName: String
    public let audioUrl: String
    public let albumImageUrl: String
    public let artistImageUrl: String

    public enum CodingKeys: String, CodingKey {
        case rank
        case songId = "song_id"
        case score
        case timestamp
        case moods
        case trackTitle = "track_title"
        case artistName = "artist_name"
        case albumName = "album_name"
        case audioUrl = "audio_url"
        case albumImageUrl = "album_image_url"
        case artistImageUrl = "artist_image_url"
    }

    public init(
        rank: Int,
        songId: String,
        score: Double,
        timestamp: Timestamp,
        moods: [String],
        trackTitle: String,
        artistName: String,
        albumName: String,
        audioUrl: String,
        albumImageUrl: String,
        artistImageUrl: String
    ) {
        self.rank = rank
        self.songId = songId
        self.score = score
        self.timestamp = timestamp
        self.moods = moods
        self.trackTitle = trackTitle
        self.artistName = artistName
        self.albumName = albumName
        self.audioUrl = audioUrl
        self.albumImageUrl = albumImageUrl
        self.artistImageUrl = artistImageUrl
    }
}

public struct Timestamp: Codable, Sendable {
    public let start: String
    public let end: String

    public init(start: String, end: String) {
        self.start = start
        self.end = end
    }
}
