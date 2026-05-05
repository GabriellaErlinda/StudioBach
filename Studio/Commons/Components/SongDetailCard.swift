import SwiftUI
import AVFoundation

struct SongDetailCard: View {
    
    let entry: Song
    
    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                // Album image: remote or local
                if let urlStr = entry.imageURL, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            imagePlaceholder
                        case .empty:
                            ProgressView()
                                .frame(width: 192, height: 192)
                        @unknown default:
                            imagePlaceholder
                        }
                    }
                    .frame(width: 192, height: 192)
                    .clipShape(Circle())
                    .padding(.bottom)
                } else {
                    Image(entry.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .font(.system(size: 100))
                        .frame(width: 192, height: 192, alignment: .center)
                        .clipShape(Circle())
                        .padding(.bottom)
                        .scaledToFill()
                }
                
                // Build snippet URL for playback
                MusicPlayer(
                    title: entry.title,
                    artist: entry.artist,
                    audioURL: buildSnippetURL(),
                    songId: entry.songId
                )
                .padding(.vertical, 4)
                .padding(.horizontal, 20)
            }
            .frame(width: 280, height: 420)
            .glassEffect(.clear, in: .rect(cornerRadius: 40))
            .background(LinearGradient(colors: [Color(red: 0.050980392156862744, green: 0, blue:0.3137254901960784), Color(red: 0.050980392156862744, green: 0, blue:0.3137254901960784)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 40)))
        }
    }
    
    private var imagePlaceholder: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.15, green: 0.12, blue: 0.25))
            Image(systemName: "music.note")
                .font(.system(size: 50))
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(width: 192, height: 192)
    }
    
    private func buildSnippetURL() -> URL? {
        guard let songId = entry.songId,
              let start = entry.timestampStart,
              let end = entry.timestampEnd else {
            return nil
        }
        return AudioSearchService.shared.snippetURL(songId: songId, start: start, end: end)
    }
}

#Preview {
    SongDetailCard(entry: Song(imageName: "laufey", title: "Promise", artist: "Laufey", emotion: ["Sadness", "Surprise"], emotionIcon: ["drop", "sparkles"]))
}
