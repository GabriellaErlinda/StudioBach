//
//  SnippetPlayerManager.swift
//  Studio
//
//  Manages AVPlayer for snippet playback across views.
//

import Foundation
import AVFoundation
import Combine

class SnippetPlayerManager: ObservableObject {
    static let shared = SnippetPlayerManager()
    
    @Published var isPlaying = false
    @Published var currentTime: Double = 0.0
    @Published var duration: Double = 0.0
    @Published var progress: Double = 0.0
    @Published var currentSongId: String?
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Configure audio session for playback
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    /// Play a snippet from a URL. If the same song is already playing, does nothing.
    func play(url: URL, songId: String? = nil) {
        // If same song is already playing, just resume
        if let currentId = currentSongId, currentId == songId, player != nil {
            player?.play()
            isPlaying = true
            return
        }
        
        // Stop current playback
        stop()
        
        currentSongId = songId
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Observe when the item is ready to play
        playerItem.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.player?.play()
                    self?.isPlaying = true
                }
            }
            .store(in: &cancellables)
        
        // Observe when playback ends
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isPlaying = false
                self?.progress = 0
                self?.currentTime = 0
                // Loop: seek back and play again
                self?.player?.seek(to: .zero)
                self?.player?.play()
                self?.isPlaying = true
            }
            .store(in: &cancellables)
        
        // Add periodic time observer
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
    
    func togglePlayPause() {
        guard let player = player else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
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
    
    func seek(to fraction: Double) {
        guard let player = player, duration > 0 else { return }
        let targetTime = CMTime(seconds: fraction * duration, preferredTimescale: 600)
        player.seek(to: targetTime)
    }
    
    func skipForward(_ seconds: Double = 5) {
        guard let player = player else { return }
        let target = min(currentTime + seconds, duration)
        player.seek(to: CMTime(seconds: target, preferredTimescale: 600))
    }
    
    func skipBackward(_ seconds: Double = 5) {
        guard let player = player else { return }
        let target = max(currentTime - seconds, 0)
        player.seek(to: CMTime(seconds: target, preferredTimescale: 600))
    }
    
    func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
