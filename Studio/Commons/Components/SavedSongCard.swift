import SwiftUI

struct SavedSongCard: View {
    let song: Song
    var body: some View {
        HStack(spacing: 12) {
            if let urlStr = song.imageURL, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        songPlaceholder
                    case .empty:
                        ProgressView()
                            .frame(width: 55, height: 55)
                    @unknown default:
                        songPlaceholder
                    }
                }
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            } else if let uiImage = UIImage(named: song.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
            } else {
                songPlaceholder   // ← guaranteed fallback, same fixed 55x55 frame every time
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(nil)
                Text(song.artist)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(nil)
            }
            Spacer()
            Image(systemName: "arrow.up.forward")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color("blue-ribbon-900").opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
    private var songPlaceholder: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.15, green: 0.12, blue: 0.25))
            Image(systemName: "music.note")
                .font(.body)
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(width: 55, height: 55)
    }
}
