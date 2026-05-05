import SwiftUI

struct Song: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let artist: String
    let emotion: [String]
    let emotionIcon: [String]
    let chords: [String] = ["Am", "F", "C"]
    let chordImage: [String] = ["chord", "chord", "chord"]
}

struct RecordHistoryEntry: Identifiable {
    let id = UUID()
    let recordName: String
    let date: String
    let length: String
}

struct SampleData {
    static let songs: [Song] = [
        Song(imageName: "laufey", title: "Promises", artist: "Laufey", emotion: ["Happy", "Sad"], emotionIcon: ["face.smiling", "drop.fill"]),
        Song(imageName: "taylor", title: "You Belong With Me", artist: "Taylor Swift", emotion: ["Happy", "Sad"], emotionIcon: ["face.smiling", "drop.fill"])
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
