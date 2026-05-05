import SwiftUI
import AVFoundation

struct SongDetailCard: View {
    
    let entry: Song

    
    var body: some View {
        ZStack {
            // LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: .top, endPoint: .bottom)
            VStack(spacing: 2) {
                Image(entry.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .font(.system(size: 100))
                    .frame(width: 192, height: 192, alignment: .center)
                    .clipShape(Circle())
                    .padding(.bottom)
                    .scaledToFill()
                
                MusicPlayer(title: entry.title, artist: entry.artist)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 20)
            }
            .frame(width: 280, height: 420)
            .glassEffect(.clear, in: .rect(cornerRadius: 40))
            .background(LinearGradient(colors: [Color(red: 0.050980392156862744, green: 0, blue:0.3137254901960784), Color(red: 0.050980392156862744, green: 0, blue:0.3137254901960784)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 40)))
        }
    }
}

#Preview {
    SongDetailCard(entry: Song(imageName: "laufey", title: "Promise", artist: "Laufey", emotion: ["Sadness", "Surprise"], emotionIcon: ["drop", "sparkles"]))
}
