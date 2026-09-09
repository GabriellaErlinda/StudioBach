@testable import BachStudio
import Foundation
import Testing

@MainActor
@Suite("AudioSearchService - current mock behavior")
struct AudioSearchServiceTests {

    @Test("search() returns the full mock result set")
    func returnsMockResults() async throws {
        let service = AudioSearchService.shared
        let results = try await service.search(audioURL: URL(fileURLWithPath: "/tmp/does-not-matter.m4a"))

        #expect(results.count == 7)
        #expect(results.first?.songId == "mock_song_1")
        #expect(results.first?.trackTitle == "Promise (Mock)")
    }

    @Test("search() ignores whether the given audioURL is valid or even exists")
    func ignoresInputURL() async throws {
        let service = AudioSearchService.shared
        // Deliberately bogus path — a real network-backed implementation
        // should reject this. The current mock implementation does not.
        let bogusURL = URL(fileURLWithPath: "/definitely/not/a/real/path.m4a")
        let results = try await service.search(audioURL: bogusURL)
        #expect(results.count == 7)
    }

    @Test("search() throws CancellationError if the calling task is cancelled mid-flight")
    func searchThrowsWhenCancelled() async {
        // This is currently the ONLY reachable error path in AudioSearchService,
        // inherited from Task.sleep's cancellation behavior rather than anything
        // the service itself implements.
        let service = AudioSearchService.shared
        let task = Task {
            try await service.search(audioURL: URL(fileURLWithPath: "/tmp/fake.m4a"))
        }

        // Give the task a moment to enter its 2s sleep before cancelling.
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
        task.cancel()

        do {
            _ = try await task.value
            Issue.record("Expected search() to throw after cancellation, but it completed successfully")
        } catch is CancellationError {
            // expected
        } catch {
            Issue.record("Expected CancellationError, got \(error)")
        }
    }

    @Test("snippetURL builds the expected path with start/end query items")
    func snippetURLIsWellFormed() throws {
        let service = AudioSearchService.shared
        let url = try #require(service.snippetURL(songId: "abc123", start: "0:10", end: "0:25"))

        #expect(url.absoluteString.hasPrefix("https://api.farrellhrs.dpdns.org/api/v1/audio/abc123/snippet"))

        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryDict = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) })
        #expect(queryDict["start"] == "0:10")
        #expect(queryDict["end"] == "0:25")
    }

    @Test("fullAudioURL builds the expected path")
    func fullAudioURLIsWellFormed() throws {
        let service = AudioSearchService.shared
        let url = try #require(service.fullAudioURL(songId: "abc123"))
        #expect(url.absoluteString == "https://api.farrellhrs.dpdns.org/api/v1/audio/abc123")
    }
}

@MainActor
@Suite("SearchResponse / SearchResult - JSON decoding")
struct SearchResponseDecodingTests {

    @Test("decodes a well-formed API response with snake_case keys")
    func decodesValidResponse() throws {
        let json = """
        {
          "status": "ok",
          "query_time_seconds": 1.42,
          "results": [
            {
              "rank": 1,
              "song_id": "song_9",
              "score": 0.91,
              "timestamp": { "start": "0:05", "end": "0:20" },
              "moods": ["Calm", "Nostalgic"],
              "track_title": "Test Track",
              "artist_name": "Test Artist",
              "album_name": "Test Album",
              "audio_url": "https://example.com/audio.mp3",
              "album_image_url": "https://example.com/album.jpg",
              "artist_image_url": "https://example.com/artist.jpg"
            }
          ]
        }
        """
        let data = Data(json.utf8)

        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)

        #expect(decoded.status == "ok")
        #expect(decoded.queryTimeSeconds == 1.42)
        #expect(decoded.results.count == 1)

        let result = try #require(decoded.results.first)
        #expect(result.songId == "song_9")
        #expect(result.id == "song_9") // Identifiable id is derived from songId
        #expect(result.moods == ["Calm", "Nostalgic"])
        #expect(result.timestamp.start == "0:05")
        #expect(result.timestamp.end == "0:20")
    }

    @Test("throws when a required field is missing")
    func throwsOnMissingRequiredField() {
        // "song_id" is missing entirely — decoding must fail, not silently default.
        let json = """
        {
          "status": "ok",
          "query_time_seconds": 1.0,
          "results": [
            {
              "rank": 1,
              "score": 0.5,
              "timestamp": { "start": "0:00", "end": "0:10" },
              "moods": [],
              "track_title": "X",
              "artist_name": "Y",
              "album_name": "Z",
              "audio_url": "https://example.com/a.mp3",
              "album_image_url": "",
              "artist_image_url": ""
            }
          ]
        }
        """
        let data = Data(json.utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode(SearchResponse.self, from: data)
        }
    }

    @Test("throws on empty/garbage data instead of crashing")
    func throwsOnGarbageData() {
        let garbage = Data("not json at all".utf8)
        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode(SearchResponse.self, from: garbage)
        }
    }
}
