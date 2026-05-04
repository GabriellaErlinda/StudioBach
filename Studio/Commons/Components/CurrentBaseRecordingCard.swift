//
//  CurrentBaseRecordingCard.swift
//  Studio
//
//  Created by Gabriella Erlinda on 04/05/26.
//


import SwiftUI

struct CurrentBaseRecordingCard: View {
    var body: some View {
        VStack(spacing: 24) {
            // Fake Visualizer
            HStack(alignment: .center, spacing: 4) {
                ForEach(0..<40, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.8, green: 0.4, blue: 0.8), Color(red: 0.4, green: 0.5, blue: 0.9)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 3, height: CGFloat.random(in: 10...40))
                }
            }
            .frame(height: 50)
            
            // Controls
            HStack(spacing: 24) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .glassEffect(.clear)
                
                Image(systemName: "pause.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Image(systemName: "backward.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("01:24:05")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                Text(" / 04:30:00")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.18, green: 0.12, blue: 0.35), Color(red: 0.08, green: 0.06, blue: 0.18)]),
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
        CurrentBaseRecordingCard()
            .padding()
    }
}
