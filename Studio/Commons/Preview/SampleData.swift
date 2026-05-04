import SwiftUI

struct Song: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let artist: String
}

struct RecordHistoryEntry: Identifiable {
    let id = UUID()
    let recordName: String
    let date: String
    let length: String
}

struct SampleData {
    static let songs: [Song] = [
        Song(imageName: "laufey", title: "Promises", artist: "Laufey"),
        Song(imageName: "taylor", title: "You Belong With Me", artist: "Taylor Swift")
    ]
    
    static let recordHistory: [RecordHistoryEntry] = [
        RecordHistoryEntry(recordName: "Take 1", date: "13.04.2026", length: "01:30:05"),
        RecordHistoryEntry(recordName: "Take 2", date: "13.04.2026", length: "01:30:05")
    ]
}
