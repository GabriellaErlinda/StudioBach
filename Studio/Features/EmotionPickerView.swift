//
//  EmotionPickerView.swift
//  Studio
//
//  Created by Gabriella Erlinda on 04/05/26.
//

import SwiftUI

struct EmotionPickerView: View {
    @State private var selectedIndex = 1
    let emotions = EmotionModel.all
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.07, green: 0.07, blue: 0.07)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack {
                    Spacer()
                    Text("STUDIO")
                        .font(.custom("Urbanist", size: 20).weight(.bold))
                        .foregroundColor(Color(red: 0.53, green: 0.60, blue: 0.94))
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    Button(action: {}) {
                        Text("i")
                            .font(.custom("SF Pro", size: 17).weight(.medium))
                            .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.06))
                            .glassEffect(.clear, in: .circle)
                            .overlay(
                                Circle().stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                // Content
                VStack(alignment: .leading, spacing: 0) {
                    // Header Texts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current State")
                            .font(.custom("Urbanist", size: 24).weight(.semibold))
                            .foregroundColor(Color(red: 0.89, green: 0.89, blue: 0.89))
                        
                        Text("Select the term that best describes your\nprimary emotion right now. \n\(selectedIndex + 1)/\(emotions.count) selected")
                            .font(.custom("Urbanist", size: 16).weight(.medium))
                            .lineSpacing(6)
                            .foregroundColor(Color(red: 0.89, green: 0.89, blue: 0.89))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                    
                    // Emotion Picker (Card Stack)
                    ZStack {
                        ForEach(0..<emotions.count, id: \.self) { index in
                            let distance = index - selectedIndex
                            let isSelected = distance == 0
                            
                            if abs(distance) <= 1 { // Show only adjacent cards to mimic the design
                                LargeEmotionCard(emotion: emotions[index], isActive: isSelected)
                                    .padding(.horizontal, isSelected ? 24 : 60)
                                    .scaleEffect(isSelected ? 1.0 : 0.85)
                                    .opacity(isSelected ? 1.0 : 0.4)
                                    .blur(radius: isSelected ? 0 : 2)
                                    .offset(y: CGFloat(distance * 110))
                                    .zIndex(isSelected ? 1 : 0)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedIndex = index
                                        }
                                    }
                            }
                        }
                    }
                    .frame(height: 320)
                    
                    Spacer()
                    
                    // Continue Button
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("Continue")
                                .font(.custom("SF Pro", size: 17).weight(.medium))
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 40)
                                .background(Color(red: 0.33, green: 0.38, blue: 0.97).opacity(0.4))
                                .glassEffect(.clear, in: .capsule)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                    
                    // Bottom Tab Bar
                    HStack {
                        Spacer()
                        HStack(spacing: 0) {
                            // Record Tab
                            VStack(spacing: 4) {
                                Image(systemName: "mic.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.61, green: 0.69, blue: 1))
                                Text("Record")
                                    .font(.custom("SF Pro", size: 10).weight(.medium))
                                    .foregroundColor(Color(red: 0.61, green: 0.69, blue: 1))
                            }
                            .frame(width: 100, height: 56)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Capsule())
                            
                            // Projects Tab
                            VStack(spacing: 4) {
                                Image(systemName: "folder.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.33, green: 0.38, blue: 0.97))
                                Text("Projects")
                                    .font(.custom("SF Pro", size: 10).weight(.medium))
                                    .foregroundColor(Color(red: 0.33, green: 0.38, blue: 0.97))
                            }
                            .frame(width: 100, height: 56)
                            .opacity(0.6)
                        }
                        .padding(4)
                        .background(Color.white.opacity(0.06))
                        .glassEffect(.clear, in: .capsule)
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    EmotionPickerView()
}
