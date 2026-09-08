//
//  AudioSearchService.swift
//  Studio
//
//  Networking layer for the StudioBach audio retrieval API.
//

import Combine
import Foundation

// model response API nyax`

struct SearchResponse: Codable {
    let status: String
    let queryTimeSeconds: Double
    let results: [SearchResult]
    enum CodingKeys: String, CodingKey {
        case status
        case queryTimeSeconds = "query_time_seconds"
        case results
    }
}

struct SearchResult: Codable, Identifiable {
    var id: String { songId }
    let rank: Int
    let songId: String
    let score: Double
    let timestamp: Timestamp
    let moods: [String]
    let trackTitle: String
    let artistName: String
    let albumName: String
    let audioUrl: String
    let albumImageUrl: String
    let artistImageUrl: String
    enum CodingKeys: String, CodingKey {
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
}

struct Timestamp: Codable {
    let start: String
    let end: String
}

private let mockResults: [SearchResult] = [
    SearchResult(
        rank: 1,
        songId: "mock_song_1",
        score: 0.95,
        timestamp: Timestamp(start: "0:00", end: "0:15"),
        moods: ["Sadness", "Surprise"],
        trackTitle: "Promise (Mock)",
        artistName: "Laufey",
        albumName: "Bewitched",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        albumImageUrl: "https://i.scdn.co/image/ab67616d0000b27313832cc69a78c53b18a8bc10",
        artistImageUrl: ""
    ),
    SearchResult(
        rank: 2,
        songId: "mock_song_2",
        score: 0.88,
        timestamp: Timestamp(start: "0:10", end: "0:25"),
        moods: ["Happiness", "Anger"],
        trackTitle: "You Belong With Me (Mock)",
        artistName: "Taylor Swift",
        albumName: "Fearless",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        albumImageUrl: "https://upload.wikimedia.org/wikipedia/en/8/86/Taylor_Swift_-_Fearless.png",
        artistImageUrl: ""
    ),
    SearchResult(
        rank: 3,
        songId: "mock_song_3",
        score: 0.88,
        timestamp: Timestamp(start: "0:10", end: "0:25"),
        moods: ["Happiness", "Anger"],
        trackTitle: "You Belong With Me (Mock)",
        artistName: "Taylor Swift",
        albumName: "Fearless",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        albumImageUrl: "https://upload.wikimedia.org/wikipedia/en/8/86/Taylor_Swift_-_Fearless.png",
        artistImageUrl: ""
    ),
    SearchResult(
        rank: 4,
        songId: "mock_song_4",
        score: 0.88,
        timestamp: Timestamp(start: "0:10", end: "0:25"),
        moods: ["Happiness", "Anger"],
        trackTitle: "You Belong With Me (Mock)",
        artistName: "Taylor Swift",
        albumName: "Fearless",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        albumImageUrl: "https://upload.wikimedia.org/wikipedia/en/8/86/Taylor_Swift_-_Fearless.png",
        artistImageUrl: ""
    ),
    SearchResult(
        rank: 5,
        songId: "mock_song_5",
        score: 0.88,
        timestamp: Timestamp(start: "0:10", end: "0:25"),
        moods: ["Happiness", "Anger"],
        trackTitle: "You Belong With Me (Mock)",
        artistName: "Taylor Swift",
        albumName: "Fearless",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        albumImageUrl: "https://upload.wikimedia.org/wikipedia/en/8/86/Taylor_Swift_-_Fearless.png",
        artistImageUrl: ""
    ),
    SearchResult(
        rank: 6,
        songId: "mock_song_6",
        score: 0.88,
        timestamp: Timestamp(start: "0:10", end: "0:25"),
        moods: ["Happiness", "Anger"],
        trackTitle: "You Belong With Me (Mock)",
        artistName: "Taylor Swift",
        albumName: "Fearless",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        albumImageUrl: "https://upload.wikimedia.org/wikipedia/en/8/86/Taylor_Swift_-_Fearless.png",
        artistImageUrl: ""
    ),
    SearchResult(
        rank: 7,
        songId: "mock_song_7",
        score: 0.88,
        timestamp: Timestamp(start: "0:10", end: "0:25"),
        moods: ["Happiness", "Anger"],
        trackTitle: "You Belong With Me (Mock)",
        artistName: "Taylor Swift",
        albumName: "Fearless",
        audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        albumImageUrl: "https://upload.wikimedia.org/wikipedia/en/8/86/Taylor_Swift_-_Fearless.png",
        artistImageUrl: ""
    )

]

// service
class AudioSearchService: ObservableObject {
    static let shared = AudioSearchService()
    private let baseURL = "https://api.farrellhrs.dpdns.org"
    @Published var searchResults: [SearchResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    /// Upload an audio file and get cover song matches.
    func search(audioURL: URL, alpha: Double = 0.5) async throws -> [SearchResult] {
        // Simulate network delay (2 seconds)
        try await Task.sleep(nanoseconds: 2_000_000_000)

        // Update published property for UI (if applicable in your original code)
        DispatchQueue.main.async {
            self.searchResults = mockResults
        }

        return mockResults
    }
    /// Build a snippet playback URL for a given song and timestamp range.
    func snippetURL(songId: String, start: String, end: String) -> URL? {
        var components = URLComponents(string: "\(baseURL)/api/v1/audio/\(songId)/snippet")
        components?.queryItems = [
            URLQueryItem(name: "start", value: start),
            URLQueryItem(name: "end", value: end)
        ]
        return components?.url
    }
    /// Build a full audio URL for a given song.
    func fullAudioURL(songId: String) -> URL? {
        return URL(string: "\(baseURL)/api/v1/audio/\(songId)")
    }
}
