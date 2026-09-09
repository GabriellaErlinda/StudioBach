//
//  MockAudio.swift
//  Studio
//
//  Created by Nickson Leviel on 09/09/26.
//

import Foundation
import Models
import Services

public final class MockAudioSearchService: AudioSearchServiceProtocol {
    public var shouldFail: Bool = false
    public var customError: Error = URLError(.timedOut)
    public var resultsToReturn: [SearchResult] = []
    public var mockDelayNanoseconds: UInt64 = 0

    public init() {}

    public func search(audioURL: URL, alpha: Double) async throws -> [SearchResult] {
        if mockDelayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: mockDelayNanoseconds)
        }

        if shouldFail {
            throw customError
        }

        return resultsToReturn
    }

    public func snippetURL(songId: String, start: String, end: String) -> URL? {
        return URL(string: "https://mock.domain.com/snippet/\(songId)")
    }

    public func fullAudioURL(songId: String) -> URL? {
        return URL(string: "https://mock.domain.com/audio/\(songId)")
    }
}
