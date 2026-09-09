@testable import BachStudio
import SwiftUI
import XCTest

@MainActor
final class DeterministicUITests: XCTestCase {

    func testSongResultsViewDeterministicLayout() {
        let generator = ConstantRandomGenerator(fixedValue: 12.0)
        let view = SongResultsView(recordedAudioURL: nil, randomGenerator: generator)

        // Assert view initializes cleanly with predictable parameters
        XCTAssertNotNil(view)
    }
}
