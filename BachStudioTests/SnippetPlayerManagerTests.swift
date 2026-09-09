@testable import BachStudio
import Foundation
import Models
import Services
import Testing

@MainActor
@Suite("SnippetPlayerManager - formatTime (pure function)")
struct SnippetPlayerManagerFormatTimeTests {

    @Test(
        "formats seconds as m:ss",
        arguments: [
            (0.0, "0:00"),
            (5.0, "0:05"),
            (65.0, "1:05"),
            (599.0, "9:59"),
            (600.0, "10:00")
        ]
    )
    func formatsKnownValues(seconds: Double, expected: String) {
        let manager = SnippetPlayerManager()
        #expect(manager.formatTime(seconds) == expected)
    }

    @Test("returns '0:00' for NaN instead of crashing")
    func handlesNaN() {
        let manager = SnippetPlayerManager()
        #expect(manager.formatTime(.nan) == "0:00")
    }

    @Test("returns '0:00' for infinite values instead of crashing")
    func handlesInfinite() {
        let manager = SnippetPlayerManager()
        #expect(manager.formatTime(.infinity) == "0:00")
    }

    @Test("does not clamp values over an hour to hh:mm:ss — flagging as current behavior, not a spec")
    func noHourFormatting() {
        // 3661s = 1h 1m 1s. Current implementation has no hour bucket, so this
        // renders as "61:01" rather than "1:01:01". Locking in today's behavior;
        // if you want hh:mm:ss for long recordings, formatTime needs a change.
        let manager = SnippetPlayerManager()
        #expect(manager.formatTime(3661.0) == "61:01")
    }

    @Test("negative input produces a malformed string — documenting a real edge case")
    func negativeInputIsMalformed() {
        // currentTime should never legitimately go negative in production use,
        // but formatTime has no guard for it. -5 seconds currently formats as
        // "0:-5", not a crash, but not a sane display value either. Worth a
        // defensive `max(0, time)` guard in formatTime if this is reachable.
        let manager = SnippetPlayerManager()
        #expect(manager.formatTime(-5.0) == "0:-5")
    }
}

@MainActor
@Suite("SnippetPlayerManager - state before any playback has started")
struct SnippetPlayerManagerInitialStateTests {

    @Test("initial published state is all-zero / not playing")
    func initialState() {
        let manager = SnippetPlayerManager()
        #expect(manager.isPlaying == false)
        #expect(manager.currentTime == 0.0)
        #expect(manager.duration == 0.0)
        #expect(manager.progress == 0.0)
        #expect(manager.currentSongId == nil)
    }

    @Test("pause() with nothing loaded is a safe no-op")
    func pauseWithNoPlayerIsSafe() {
        let manager = SnippetPlayerManager()
        manager.pause()
        #expect(manager.isPlaying == false)
    }

    @Test("togglePlayPause() with nothing loaded does not toggle isPlaying")
    func toggleWithNoPlayerDoesNothing() {
        let manager = SnippetPlayerManager()
        manager.togglePlayPause()
        // Guarded by `guard let player = player else { return }` — isPlaying
        // must stay false rather than flipping to true with nothing to play.
        #expect(manager.isPlaying == false)
    }

    @Test("seek(to:) with zero duration is a safe no-op")
    func seekWithZeroDurationIsSafe() {
        let manager = SnippetPlayerManager()
        manager.seek(to: 0.5)
        #expect(manager.currentTime == 0.0)
    }

    @Test("skipForward with nothing loaded is a safe no-op")
    func skipForwardWithNoPlayerIsSafe() {
        let manager = SnippetPlayerManager()
        manager.skipForward(5)
        #expect(manager.currentTime == 0.0)
    }

    @Test("skipBackward with nothing loaded is a safe no-op")
    func skipBackwardWithNoPlayerIsSafe() {
        let manager = SnippetPlayerManager()
        manager.skipBackward(5)
        #expect(manager.currentTime == 0.0)
    }

    @Test("stop() with nothing loaded is a safe no-op and leaves defaults untouched")
    func stopWithNothingLoadedIsSafe() {
        let manager = SnippetPlayerManager()
        manager.stop()
        #expect(manager.isPlaying == false)
        #expect(manager.currentSongId == nil)
        #expect(manager.currentTime == 0.0)
    }
}

@MainActor
@Suite("SnippetPlayerManager - failed audio loading (real AVPlayer, no network)")
struct SnippetPlayerManagerFailedLoadTests {

    @Test("play() with a URL pointing at a nonexistent local file never becomes playing")
    func failedLocalFileNeverPlays() async {
        let manager = SnippetPlayerManager()
        let missingFile = URL(fileURLWithPath: "/tmp/bach-studio-tests-nonexistent-\(UUID().uuidString).m4a")

        manager.play(url: missingFile, songId: "missing-song")

        // currentSongId is set synchronously before the async load attempt.
        #expect(manager.currentSongId == "missing-song")

        // Poll briefly for AVPlayerItem to report .failed. This is a real,
        // deterministic failure (no such file), not a network call, so it
        // should resolve quickly — but AVFoundation's failure timing isn't
        // instant, hence the short poll instead of a single synchronous check.
        var stayedFalse = true
        for _ in 0..<20 { // up to ~2s
            if manager.isPlaying {
                stayedFalse = false
                break
            }
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }

        #expect(stayedFalse, "isPlaying should never become true for a file that doesn't exist")
        #expect(manager.isPlaying == false)

        manager.stop() // cleanup: release player + observers
    }
}
