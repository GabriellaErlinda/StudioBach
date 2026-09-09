@testable import BachStudio
import Models
import Services
import XCTest

@MainActor
final class AudioSearchTests: XCTestCase {

    func testSearchSuccessPath() async throws {
        let mockService = MockAudioSearchService()
        mockService.resultsToReturn = [
            SearchResult(
                rank: 1,
                songId: "test_song_1",
                score: 0.99,
                timestamp: Timestamp(start: "0:00", end: "0:10"),
                moods: ["Joy"],
                trackTitle: "Test Track",
                artistName: "Test Artist",
                albumName: "Test Album",
                audioUrl: "https://example.com/audio.mp3",
                albumImageUrl: "",
                artistImageUrl: ""
            )
        ]

        let results = try await mockService.search(audioURL: URL(string: "file:///test.wav")!, alpha: 0.5)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.songId, "test_song_1")
    }

    func testSearchFailureHandling() async {
        let mockService = MockAudioSearchService()
        mockService.shouldFail = true
        mockService.customError = URLError(.timedOut)

        do {
            _ = try await mockService.search(audioURL: URL(string: "file:///test.wav")!, alpha: 0.5)
            XCTFail("Expected error to be thrown, but search succeeded.")
        } catch {
            let urlError = error as? URLError
            XCTAssertEqual(urlError?.code, .timedOut)
        }
    }
}
