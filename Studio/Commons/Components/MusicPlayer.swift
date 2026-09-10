import Models
import Services
import SwiftUI

struct MusicPlayer: View {
    var title: String = "Midnight City"
    var artist: String = "M83"
    var audioURL: URL?
    var songId: String?
    @StateObject private var player = SnippetPlayerManager()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .lineLimit(nil)
                Text(artist)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(1))
                    .lineLimit(nil)
            }
            // Progress Bar
            VStack {
                Slider(value: Binding(
                    get: { player.progress },
                    set: { newValue in
                        player.seek(to: newValue)
                    }
                ), in: 0...1)
                .tint(Color(red: 0.529, green: 0.6, blue: 0.937))
                .scaleEffect(x: 1, y: 0.8)
                .overlay(
                    GeometryReader { geometry in
                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { value in
                                        let percentage = min(max(0, value.location.x / geometry.size.width), 1)
                                        player.seek(to: percentage)
                                    }
                            )
                    }
                )
                HStack {
                    Text(player.formatTime(player.currentTime))
                    Spacer()
                    Text(player.formatTime(player.duration))
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(1))
                .offset(y: -8)
            }
            // Playback Controls
            HStack(spacing: 40) {
                Button(
                    action: {
                        player.skipBackward()
                    },
                    label: {
                        Image(systemName: "backward.fill")
                            .font(.body)
                    }
                )
                .accessibilityIdentifier("skipBackwardButton")
                Button(
                    action: {
                        if player.isPlaying {
                            player.togglePlayPause()
                        } else if let url = audioURL {
                            // If player hasn't started yet, start it
                            if player.currentSongId == nil {
                                player.play(url: url, songId: songId)
                            } else {
                                player.togglePlayPause()
                            }
                        }
                    },
                    label: {
                        Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                    }
                )
                .accessibilityIdentifier("playPauseButton")
                Button(
                    action: {
                        player.skipForward()
                    },
                    label: {
                        Image(systemName: "forward.fill")
                            .font(.body)
                    }
                )
                .accessibilityIdentifier("skipForwardButton")
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
        // .glassEffect(.clear, in: .rect(cornerRadius: 24))
        .cornerRadius(32)
        .shadow(color: Color.purple.opacity(0.15), radius: 20, x: 0, y: 10)
        .onDisappear { player.pause() }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MusicPlayer()
            .padding()
    }
}
