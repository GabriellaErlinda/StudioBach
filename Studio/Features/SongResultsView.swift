import SwiftUI

struct SongResultsView: View {
    let recordedAudioURL: URL?
    
    @State private var songs: [Song] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var visibleCount = 5
    @State private var currentIndex: Int = 0
    @StateObject private var playerManager = SnippetPlayerManager()
    
    private let service = AudioSearchService.shared
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("blue-ribbon-900"),
                    Color("blue-ribbon-950"),
                    Color("primary-950")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if isLoading {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            } else {
                resultsView
            }
        }
        .onAppear {
            if songs.isEmpty {
                performSearch()
            }
        }
        .onDisappear {
            playerManager.stop()
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 24) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.53, green: 0.6, blue: 0.94)))
                .scaleEffect(1.5)
            
            VStack(spacing: 8) {
                Text("Analyzing your recording...")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Finding songs that match your melody.\nThis may take up to a minute.")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // view kalo error api call
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(.orange)
            
            Text("Something went wrong")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Try Again") {
                performSearch()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Capsule().fill(Color(red: 0.38, green: 0.35, blue: 0.87)))
        }
    }
    
    @State private var scrolledIndex: Int?
    
    // view result
    private var resultsView: some View {
        VStack(spacing: 16) {
            VStack {
                HStack {
                    Image(systemName: "music.note.list")
                    Text("Your reference songs are here. ")
                        .fontWeight(.bold)
                }
                .font(.system(size: 24))
                .foregroundStyle(.white)
                
                VStack {
                    Text("Select the song that best describes your")
                    Text("primary emotion right now.")
                }
            }
            .foregroundStyle(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(songs.prefix(visibleCount).enumerated()), id: \.element.id) { index, entry in
                        SongCard(entry: entry)
                            .id(index)
                            .scrollTransition(.animated) { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
                                    .blur(radius: phase.isIdentity ? 0 : 2)
                            }
                    }
                    
                    if visibleCount < songs.count {
                        ShowMoreCard {
                            withAnimation(.spring()) {
                                visibleCount += 5
                            }
                        }
                        .id(visibleCount) // give it an id too just in case
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrolledIndex)
            .onChange(of: scrolledIndex) { oldIndex, newIndex in
                if let newIndex = newIndex, newIndex < songs.count {
                    if currentIndex != newIndex {
                        currentIndex = newIndex
                        playSnippet(for: songs[newIndex])
                    }
                }
            }
            .safeAreaPadding(.horizontal, 60)
            
            // Now Playing indicator
            if playerManager.isPlaying, currentIndex < songs.count {
                HStack(spacing: 8) {
                    // Animated bars
                    ForEach(0..<3, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(Color(red: 0.53, green: 0.6, blue: 0.94))
                            .frame(width: 3, height: playerManager.isPlaying ? CGFloat.random(in: 8...18) : 6)
                            .animation(
                                .easeInOut(duration: 0.4)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.15),
                                value: playerManager.isPlaying
                            )
                    }
                    
                    Text("Now Playing: \(songs[currentIndex].title)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.08)))
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .offset(y: -40)
    }
    
    // MARK: - Playback
    private func playSnippet(for song: Song) {
        guard let songId = song.songId,
              let start = song.timestampStart,
              let end = song.timestampEnd else { return }
        
        guard let url = AudioSearchService.shared.snippetURL(songId: songId, start: start, end: end) else { return }
        
        playerManager.play(url: url, songId: songId)
    }
    
    // API call
    private func performSearch() {
        guard let audioURL = recordedAudioURL else {
            // Fallback to sample data if no recording (e.g. preview)
            songs = SampleData.songs
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let results = try await service.search(audioURL: audioURL)
                await MainActor.run {
                    songs = results.map { Song(from: $0) }
                    isLoading = false
                    
                    // Auto-play first result
                    if let firstSong = songs.first {
                        playSnippet(for: firstSong)
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

struct ShowMoreCard: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                
                Text("SHOW MORE")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 280, height: 373)
            .glassEffect(.clear, in: .rect(cornerRadius: 40))
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
                    .background(Color.white.opacity(0.05))
            )
        }
    }
}

#Preview {
    SongResultsView(recordedAudioURL: nil)
}
