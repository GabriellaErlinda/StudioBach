//
//  MusicPlayer.swift
//  Studio
//
//  Created by Nickson Leviel on 05/05/26.
//

import SwiftUI
import AVFoundation

struct MusicPlayer: View {
    var title: String = "Midnight City"
    var artist: String = "M83"
    var audioURL: URL? = nil  // Optional: use API snippet URL if provided
    
    @State private var isPlaying: Bool = false
    @State private var progress: Double = 0.0
    @State private var player: AVPlayer?
    @State private var duration: Double = 0.0
    @State private var currentTime: Double = 0.0
    
    var body: some View {
        VStack(spacing: 0) { // Matches the card's spacing
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(artist)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
            }
            
            // Progress Bar
            VStack() {
                // Custom Slider styling to match the theme
                Slider(value: $progress, in: 0...1, onEditingChanged: { editing in
                    if !editing {
                        let targetTime = progress * duration
                        player?.seek(to: CMTime(seconds: targetTime, preferredTimescale: 1))
                    }
                })
                .tint(Color(red: 0.529, green: 0.6, blue: 0.937))
                .scaleEffect(x: 1, y: 0.8)
                .overlay(
                    GeometryReader { geometry in
                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let percentage = min(max(0, value.location.x / geometry.size.width), 1)
                                        progress = Double(percentage)
                                    }
                                    .onEnded { value in
                                        let targetTime = progress * duration
                                        player?.seek(to: CMTime(seconds: targetTime, preferredTimescale: 1000))
                                    }
                            )
                    }
                )
                
                HStack {
                    Text(formatTime(currentTime))
                    Spacer()
                    Text(formatTime(duration))
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .offset(y: -8)
            }
            
            // Playback Controls
            HStack(spacing: 40) {
                Button(action: {
                    let target = max(currentTime - 5, 0)
                    player?.seek(to: CMTime(seconds: target, preferredTimescale: 1))
                }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 18))
                }
                
                Button(action: togglePlay) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 40))
                }
                
                Button(action: {
                    let target = min(currentTime + 5, duration)
                    player?.seek(to: CMTime(seconds: target, preferredTimescale: 1))
                }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 18))
                }
            }
            .foregroundColor(.white)
            .offset(y: -10)
        }
        .padding(.horizontal, 15)
        .padding(.top, 15)
        .padding(.bottom, 5)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("blue-ribbon-800"),
                    Color("blue-ribbon-950")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.white, lineWidth: 1)
        )
        //.glassEffect(.clear, in: .rect(cornerRadius: 24))
        .cornerRadius(32)
        .shadow(color: Color.purple.opacity(0.15), radius: 20, x: 0, y: 10)
        .onAppear(perform: setupPlayer)
        .onDisappear { player?.pause()
        }
    }
    
    private func setupPlayer() {
        // Use API snippet URL if provided, otherwise fallback
        let url: URL
        if let provided = audioURL {
            url = provided
        } else if let fallback = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") {
            url = fallback
        } else {
            return
        }
        
        player = AVPlayer(url: url)
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { time in
            self.currentTime = time.seconds
            if let currentItem = self.player?.currentItem {
                self.duration = currentItem.duration.seconds.isNaN ? 0 : currentItem.duration.seconds
                if self.duration > 0 {
                    self.progress = self.currentTime / self.duration
                }
            }
        }
    }
    
    private func togglePlay() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    private func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MusicPlayer()
            .padding()
    }
}
