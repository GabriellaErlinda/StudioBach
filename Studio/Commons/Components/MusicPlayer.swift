//
//  MusicPlayer.swift
//  Studio
//
//  Created by Nickson Leviel on 05/05/26.
//

import SwiftUI

struct MusicPlayer: View {
    @State private var isPlaying: Bool = false
    @State private var progress: Double = 0.3 // Dummy progress value
    
    var body: some View {
        VStack(spacing: 30) {
            // Song Info
            VStack(spacing: 8) {
                Text("Midnight City")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("M83")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            // Progress Bar
            VStack {
                Slider(value: $progress, in: 0...1)
                    .tint(.blue)
                HStack {
                    Text("1:12")
                    Spacer()
                    Text("4:03")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            // Playback Controls
            HStack(spacing: 50) {
                // Backward Button
                Button(action: { /* Logic for previous track */ }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 30))
                }
                
                // Play/Pause Button
                Button(action: { isPlaying.toggle() }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 80))
                }
                
                // Forward Button
                Button(action: { /* Logic for next track */ }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 30))
                }
            }
            .foregroundColor(.primary)
        }
        .padding()
    }
}

#Preview {
    MusicPlayer()
}
