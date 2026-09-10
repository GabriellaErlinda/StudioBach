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
    private let baseURL: URL

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

    // Accept baseURL via dependency injection, defaulting to an environment/config resolver if needed
    nonisolated public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    public func search(audioURL: URL, alpha: Double = 0.5) async throws -> [SearchResult] {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        await MainActor.run {
            self.searchResults = mockResults
        }
        return mockResults
    }

    public func snippetURL(songId: String, start: String, end: String) -> URL? {
        let targetURL = baseURL.appendingPathComponent("api/v1/audio/\(songId)/snippet")
        var components = URLComponents(url: targetURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "start", value: start),
            URLQueryItem(name: "end", value: end)
        ]
        return components?.url
    }

    public func fullAudioURL(songId: String) -> URL? {
        return baseURL.appendingPathComponent("api/v1/audio/\(songId)")
    }
}
