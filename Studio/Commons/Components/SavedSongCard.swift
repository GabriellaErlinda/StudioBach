import SwiftUI

struct SavedSongCard: View {
    let song: Song
    
    var body: some View {
        HStack(spacing: 12) {
            
            Image(song.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                
                Text(song.artist)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "arrow.up.forward")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(
            ZStack {
                Color("blue-ribbon-950")
                    .opacity(0.2)
                
                RoundedRectangle(cornerRadius: 24)
                    .glassEffect(.clear, in: .rect(cornerRadius: 24))
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
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
