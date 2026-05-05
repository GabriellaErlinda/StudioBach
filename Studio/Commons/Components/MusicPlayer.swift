//
//  MusicPlayer.swift
//  Studio
//
//  Created by Nickson Leviel on 05/05/26.
//

import SwiftUI

struct MusicPlayer: View {
    @State private var isPlaying: Bool = false
    @State private var progress: Double = 0.3
    
    var body: some View {
        VStack(spacing: 0) { // Matches the card's spacing
            VStack(spacing: 4) {
                Text("Midnight City")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("M83")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Progress Bar
            VStack() {
                // Custom Slider styling to match the theme
                Slider(value: $progress, in: 0...1)
                    .tint(Color(red: 0.529, green: 0.6, blue: 0.937))
                    .scaleEffect(x: 1, y: 0.8)
                
                HStack {
                    Text("1:12")
                    Spacer()
                    Text("4:03")
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .offset(y: -8)
            }
            
            // Playback Controls
            HStack(spacing: 40) {
                Button(action: { }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 18))
                }
                
                Button(action: { isPlaying.toggle() }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 40))
                }
                
                Button(action: { }) {
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
                    Color(red: 0.18, green: 0.12, blue: 0.35),
                    Color(red: 0.08, green: 0.06, blue: 0.18)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .glassEffect(.clear, in: .rect(cornerRadius: 24))
        .cornerRadius(24)
        .shadow(color: Color.purple.opacity(0.15), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MusicPlayer()
            .padding()
    }
}
