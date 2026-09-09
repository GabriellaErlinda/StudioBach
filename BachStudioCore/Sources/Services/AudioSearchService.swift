import Combine
import Foundation
import Models

@MainActor
public protocol AudioSearchServiceProtocol {
    func search(audioURL: URL, alpha: Double) async throws -> [SearchResult]
    func snippetURL(songId: String, start: String, end: String) -> URL?
    func fullAudioURL(songId: String) -> URL?
}

@MainActor
public final class AudioSearchService: AudioSearchServiceProtocol, ObservableObject {
    private let baseURL = "https://api.farrellhrs.dpdns.org"

    @Published public var searchResults: [SearchResult] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?

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
        )
    ]

    // Mark the initializer as nonisolated so it can be called from anywhere
    nonisolated public init() {}

    public func search(audioURL: URL, alpha: Double = 0.5) async throws -> [SearchResult] {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        await MainActor.run {
            self.searchResults = mockResults
        }
        return mockResults
    }

    public func snippetURL(songId: String, start: String, end: String) -> URL? {
        var components = URLComponents(string: "\(baseURL)/api/v1/audio/\(songId)/snippet")
        components?.queryItems = [
            URLQueryItem(name: "start", value: start),
            URLQueryItem(name: "end", value: end)
        ]
        return components?.url
    }

    public func fullAudioURL(songId: String) -> URL? {
        return URL(string: "\(baseURL)/api/v1/audio/\(songId)")
    }
}
