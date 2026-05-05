//
//  EmotionPickerView.swift
//  Studio
//
//  Created by Gabriella Erlinda on 04/05/26.
//

import SwiftUI

struct EmotionPickerView: View {
    let recordedAudioURL: URL?
    
    @State private var selectedIndex = 1
    @State private var selectedEmotionIDs: Set<Int> = []
    let emotions = EmotionModel.all
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.07, green: 0.07, blue: 0.07)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content
                VStack(alignment: .leading, spacing: 0) {
                    // Header Texts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current State")
                            .font(.custom("Urbanist", size: 24).weight(.semibold))
                            .foregroundColor(Color(red: 0.89, green: 0.89, blue: 0.89))
                        
                        Text("Select the term that best describes your\nprimary emotion right now. \n\(selectedEmotionIDs.count)/3 selected")
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
                                LargeEmotionCard(
                                    emotion: emotions[index],
                                    isActive: isSelected,
                                    isMarked: selectedEmotionIDs.contains(index),
                                    onToggle: {
                                        if selectedEmotionIDs.contains(index) {
                                            selectedEmotionIDs.remove(index)
                                        } else if selectedEmotionIDs.count < 3 {
                                            selectedEmotionIDs.insert(index)
                                        }
                                    }
                                )
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
                        NavigationLink {
                            SongResultsView(recordedAudioURL: recordedAudioURL).studioNavbar()
                        } label: {
                            Text("Continue")
                                .font(.custom("SF Pro", size: 17).weight(.medium))
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 40)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 0.33, green: 0.38, blue: 0.97).opacity(0.4))
                                )
                                .glassEffect(.clear.interactive(), in: .capsule)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    EmotionPickerView(recordedAudioURL: nil)
}
