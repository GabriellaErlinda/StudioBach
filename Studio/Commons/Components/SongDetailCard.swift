import AVFoundation
import Models
import Services
import SwiftUI

struct SongDetailCard: View {
    let entry: Song
    var body: some View {
        let darkPurple = Color(red: 0.05098, green: 0, blue: 0.3137)
        ZStack {
            VStack(spacing: 2) {
                // Album image: remote or local
                if let urlStr = entry.imageURL, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
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
                        .scaledToFill()
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
            .background(darkPurple.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 40)))
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
        let service = AudioSearchService()
        return service.snippetURL(songId: songId, start: start, end: end)
    }
}

#Preview {
    SongDetailCard(entry: Song(imageName: "laufey", title: "Promise", artist: "Laufey", emotion: ["Sadness", "Surprise"], emotionIcon: ["drop", "sparkles"]))
}
