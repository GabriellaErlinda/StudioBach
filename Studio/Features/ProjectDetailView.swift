//
//  ProjectDetailView.swift
//  projectdetail
//
//  Created by Rendi Septrian on 03/05/26.
//

import SwiftUI

struct ProjectDetailView: View {
    let historyRecords: [RecordHistoryCardModel] = [
        RecordHistoryCardModel(title: "Vocal Take_04 (Harmony Focus)", subtitle: "Today • 14:22 • 0:45s"),
        RecordHistoryCardModel(title: "Vocal Take_03 (Main)", subtitle: "Yesterday • 18:05 • 3:42"),
        RecordHistoryCardModel(title: "Scratch Track_02", subtitle: "Oct 22 • 09:12 • 2:10")
    ]
    let project:ProjectCardModel
    
    @State private var sortOrder: SortOrder = .latest

    enum SortOrder {
        case latest, earliest
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.04, green: 0.03, blue: 0.05).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("LIBRARY / PROJECT 1")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                            Text("Current Status")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        // Current Base Recording
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("CURRENT BASE RECORDING")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("Take 04")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(red: 0.2, green: 0.15, blue: 0.35))
                                    .glassEffect(.clear)
                                    .cornerRadius(12)
                                
                            }
                            CurrentBaseRecordingCard()
                        }
                        .padding(.horizontal)
                        
                        // Selected Emotion
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SELECTED EMOTION")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "drop")
                                    Text("Sadness")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.12, green: 0.09, blue: 0.22))
                                .glassEffect(.clear, in: .capsule)
                                .cornerRadius(24)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Song References
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("SONG REFERENCES")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("2 Versions Generated")
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundColor(Color(red: 0.4, green: 0.5, blue: 0.8))
                            }
                            
                            VStack(spacing: 0) {
                                ForEach(Array(SampleData.songs.enumerated()), id: \.element.id) { index, song in
                                    SavedSongCard(song: song)
                                    if index < SampleData.songs.count - 1 {
                                        Spacer()
                                    }
                                }
                            }
                            .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        
                        // Recording History
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recording History")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Menu {
                                    Button(action: { sortOrder = .latest }) {
                                        Label("Latest", systemImage: "arrow.down")
                                    }
                                    
                                    Button(action: { sortOrder = .earliest }) {
                                        Label("Earliest", systemImage: "arrow.up")
                                    }
                                } label: {
                                    Image(systemName: "line.3.horizontal.decrease")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                                
                            }
                            
                            VStack(spacing: 12) {
                                ForEach(historyRecords) { record in
                                    RecordHistoryCard(model: record)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
                
                // Bottom Buttons
                VStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "waveform")
                            Text("EDIT VISION")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.25, green: 0.25, blue: 0.45)) // Purple-ish blue
                        .glassEffect(.clear, in: .rect(cornerRadius: 24))
                        .cornerRadius(24)
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "mic.fill")
                            Text("RECORD NEW TAKE")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.12, green: 0.09, blue: 0.22)) // Darker purple
                        .glassEffect(.clear, in: .rect(cornerRadius: 24))
                        .cornerRadius(24)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 32)
                .padding(.top, 8)
            }
        }
    }
}
