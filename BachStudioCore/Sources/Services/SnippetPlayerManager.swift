import AVFoundation
import Combine
import Foundation

public protocol SnippetPlayerManagerProtocol {
    var isPlaying: Bool { get }
    var currentTime: Double { get }
    var duration: Double { get }
    var progress: Double { get }
    var currentSongId: String? { get }

    func play(url: URL, songId: String?)
    func pause()
    func stop()
    func togglePlayPause()
    func seek(to time: Double)
    func skipForward(_ seconds: Double)
    func skipBackward(_ seconds: Double)
    func formatTime(_ time: Double) -> String
}

public final class SnippetPlayerManager: ObservableObject, SnippetPlayerManagerProtocol {
    @Published public var isPlaying = false
    @Published public var currentTime: Double = 0.0
    @Published public var duration: Double = 0.0
    @Published public var progress: Double = 0.0
    @Published public var currentSongId: String?

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    public init() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    public func play(url: URL, songId: String? = nil) {
        if let currentId = currentSongId, currentId == songId, player != nil {
            player?.play()
            isPlaying = true
            return
        }

        stop()
        currentSongId = songId
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        playerItem.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.player?.play()
                    self?.isPlaying = true
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isPlaying = false
                self?.progress = 0
                self?.currentTime = 0
                self?.player?.seek(to: .zero)
                self?.player?.play()
                self?.isPlaying = true
            }
            .store(in: &cancellables)

        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.25, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            if let item = self.player?.currentItem {
                let dur = item.duration.seconds
                if !dur.isNaN && !dur.isInfinite && dur > 0 {
                    self.duration = dur
                    self.progress = time.seconds / dur
                }
            }
        }
    }

    public func togglePlayPause() {
            guard let player = player else { return }
            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
            isPlaying.toggle()
        }

    public func pause() {
        player?.pause()
        isPlaying = false
    }

    public func stop() {
        player?.pause()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player = nil
        isPlaying = false
        currentTime = 0
        duration = 0
        progress = 0
        currentSongId = nil
        cancellables.removeAll()
    }

    public func seek(to fraction: Double) {
        guard let player = player, duration > 0 else { return }
        let targetTime = CMTime(seconds: fraction * duration, preferredTimescale: 600)
        player.seek(to: targetTime)
    }

    public func skipForward(_ seconds: Double = 5) {
        guard let player = player else { return }
        let target = min(currentTime + seconds, duration)
        player.seek(to: CMTime(seconds: target, preferredTimescale: 600))
    }

    public func skipBackward(_ seconds: Double = 5) {
        guard let player = player else { return }
        let target = max(currentTime - seconds, 0)
        player.seek(to: CMTime(seconds: target, preferredTimescale: 600))
    }

    public func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
