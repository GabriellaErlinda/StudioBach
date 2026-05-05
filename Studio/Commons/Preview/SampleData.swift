import SwiftUI

struct Song: Identifiable {
    let id: String
    
    // Display fields
    let imageName: String        // Local asset name (for previews)
    let imageURL: String?        // Remote album image URL (from API)
    let artistImageURL: String?  // Remote artist image URL (from API)
    let title: String
    let artist: String
    let albumName: String?
    let emotion: [String]
    let emotionIcon: [String]
    let chords: [String]
    let chordImage: [String]
    
    // API-specific fields
    let songId: String?
    let score: Double?
    let timestampStart: String?
    let timestampEnd: String?
    let audioURL: String?
    
    // Convenience initializer for hardcoded preview data (backward compat)
    init(imageName: String, title: String, artist: String, emotion: [String], emotionIcon: [String]) {
        self.id = UUID().uuidString
        self.imageName = imageName
        self.imageURL = nil
        self.artistImageURL = nil
        self.title = title
        self.artist = artist
        self.albumName = nil
        self.emotion = emotion
        self.emotionIcon = emotionIcon
        self.chords = ["Am", "F", "C"]
        self.chordImage = ["chord", "chord", "chord"]
        self.songId = nil
        self.score = nil
        self.timestampStart = nil
        self.timestampEnd = nil
        self.audioURL = nil
    }
    
    // Initializer from API SearchResult
    init(from result: SearchResult) {
        self.id = result.songId
        self.imageName = ""  // No local asset
        self.imageURL = result.albumImageUrl.isEmpty ? nil : result.albumImageUrl
        self.artistImageURL = result.artistImageUrl.isEmpty ? nil : result.artistImageUrl
        self.title = result.trackTitle
        self.artist = result.artistName
        self.albumName = result.albumName
        self.emotion = result.moods
        self.emotionIcon = result.moods.map { Self.iconForMood($0) }
        self.chords = []
        self.chordImage = []
        self.songId = result.songId
        self.score = result.score
        self.timestampStart = result.timestamp.start
        self.timestampEnd = result.timestamp.end
        self.audioURL = result.audioUrl
    }
    
    /// Map mood strings to SF Symbol icon names
    static func iconForMood(_ mood: String) -> String {
        switch mood.lowercased() {
        case "happy", "joyful":         return "sun.max"
        case "sad", "sadness":          return "drop"
        case "calm", "relaxing":        return "leaf"
        case "energetic":               return "bolt"
        case "nostalgic":               return "clock"
        case "angry", "anger":          return "flame"
        case "surprise":                return "sparkles"
        case "film":                    return "film"
        case "nature":                  return "tree"
        case "warm":                    return "sun.haze"
        case "emotional":               return "heart"
        case "meditative":              return "brain.head.profile"
        case "motivational":            return "star"
        case "corporate", "advertising": return "briefcase"
        default:                        return "music.note"
        }
    }
}

struct RecordHistoryEntry: Identifiable {
    let id = UUID()
    let recordName: String
    let date: String
    let length: String
}

struct SampleData {
    static let songs: [Song] = [
        Song(imageName: "laufey", title: "Promises", artist: "Laufey", emotion: ["Sadness", "Surprise"], emotionIcon: ["drop", "sparkles"]),
        Song(imageName: "taylor", title: "You Belong With Me", artist: "Taylor Swift", emotion: ["Happiness", "Anger"], emotionIcon: ["sun.max", "flame"])
    ]
    
    static let recordHistory: [RecordHistoryEntry] = [
        RecordHistoryEntry(recordName: "Take 1", date: "13.04.2026", length: "01:30:05"),
        RecordHistoryEntry(recordName: "Take 2", date: "13.04.2026", length: "01:30:05")
    ]
    
    static let recentSongs: [RecentSongModel] = [
        .init(imageName: "laufey", dateSaved: .init(timeIntervalSince1970: 0), emotion: .joyful),
        .init(imageName: "taylor", dateSaved: .init(timeIntervalSince1970: 0), emotion: .sadness)
    ]
    
    static let songEmotional: [SongEmotion] = [.joyful, .sadness, .nostalgic, .energetic, .calm, .unknown]
}
