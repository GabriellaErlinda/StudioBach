import SwiftUI

struct SavedSongCard: View {
    let song: Song
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Album image: remote or local
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
            } else {
                Image(song.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(song.artist)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(1)
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
                .font(.system(size: 20))
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(width: 55, height: 55)
    }
}

#Preview {
    VStack(spacing: 16) {
        ForEach(SampleData.songs) { song in
            SavedSongCard(song: song)
        }
    }
    .padding()
    .background(Color.black)
}
