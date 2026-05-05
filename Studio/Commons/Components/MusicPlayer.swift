//
//  MusicPlayer.swift
//  Studio
//
//  Created by Nickson Leviel on 05/05/26.
//

import SwiftUI

struct MusicPlayer: View {
    var title: String = "Midnight City"
    var artist: String = "M83"
    var audioURL: URL? = nil
    var songId: String? = nil
    
    @StateObject private var player = SnippetPlayerManager()
    
    var body: some View {
        VStack(spacing: 0) {
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
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .offset(y: -8)
            }
            
            // Playback Controls
            HStack(spacing: 40) {
                Button(action: {
                    player.skipBackward()
                }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 18))
                }
                
                Button(action: {
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
                }) {
                    Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 40))
                }
                
                Button(action: {
                    player.skipForward()
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
