import Models
import Services
import SwiftUI

struct SongResultsView: View {
    let recordedAudioURL: URL?
    var randomGenerator: RandomNumberGeneratable

    init(recordedAudioURL: URL?, randomGenerator: RandomNumberGeneratable = SystemRandomGenerator()) {
        self.recordedAudioURL = recordedAudioURL
        self.randomGenerator = randomGenerator
    }

    @State private var songs: [Song] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var visibleCount = 5
    @State private var currentIndex: Int = 0
    @StateObject private var playerManager = SnippetPlayerManager()

    private let service = AudioSearchService()

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
                    .font(.body.bold())
                    .foregroundStyle(.white)

                Text("Finding songs that match your melody.\nThis may take up to a minute.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityIdentifier("loadingView") // Tag container for UI test checks
    }

    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)

            Text("Something went wrong")
                .font(.subheadline.bold())
                .foregroundStyle(.white)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button("Try Again") {
                performSearch()
            }
            .accessibilityIdentifier("tryAgainButton") // Stable identifier for recovery action
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Capsule().fill(Color(red: 0.38, green: 0.35, blue: 0.87)))
        }
        .accessibilityIdentifier("errorView")
    }

    @State private var scrolledIndex: Int?

    private var resultsView: some View {
        VStack(spacing: 16) {
            VStack {
                HStack {
                    Image(systemName: "music.note.list")
                    Text("Your reference songs are here. ")
                        .fontWeight(.bold)
                }
                .font(.title2)
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
                            .accessibilityIdentifier("songCard_\(entry.songId ?? "")") // Unique identifier per card
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
                        .id(visibleCount)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrolledIndex)
            .onChange(of: scrolledIndex) { _, newIndex in
                if let newIndex = newIndex, newIndex < songs.count {
                    if currentIndex != newIndex {
                        currentIndex = newIndex
                        playSnippet(for: songs[newIndex])
                    }
                }
            }
            .safeAreaPadding(.horizontal, 60)

            if playerManager.isPlaying, currentIndex < songs.count {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(Color(red: 0.53, green: 0.6, blue: 0.94))
                            .frame(width: 3, height: playerManager.isPlaying ? randomGenerator.random(in: 8...18) : 6)
                            .animation(
                                .easeInOut(duration: 0.4)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.15),
                                value: playerManager.isPlaying
                            )
                    }

                    Text("Now Playing: \(songs[currentIndex].title)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(nil)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.08)))
                .accessibilityIdentifier("nowPlayingIndicator")
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .offset(y: -40)
    }

    private func playSnippet(for song: Song) {
        guard let songId = song.songId,
              let start = song.timestampStart,
              let end = song.timestampEnd else { return }

        let localService = AudioSearchService()
        guard let url = localService.snippetURL(songId: songId, start: start, end: end) else { return }

        playerManager.play(url: url, songId: songId)
    }

    private func performSearch() {
        guard let audioURL = recordedAudioURL else {
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
                    .font(.largeTitle)
                    .foregroundStyle(.white)

                Text("SHOW MORE")
                    .font(.footnote.bold())
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
        .accessibilityIdentifier("showMoreButton") // Stable target for pagination UI test
    }
}

#Preview {
    SongResultsView(recordedAudioURL: nil)
}
