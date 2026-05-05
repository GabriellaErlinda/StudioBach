import SwiftUI

struct SongCard: View {
    
    let entry: Song
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                // Album image: use remote URL if available, otherwise local asset
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
                
                Text(entry.title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(entry.artist)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(red: 0.5294117647058824, green: 0.6, blue: 0.9372549019607843))
                    .padding(.bottom, 20)
                    .lineLimit(1)
                
                NavigationLink("SEE DETAILS") {
                    SongDetailView(entry: entry)
                        .studioNavbar()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .glassEffect(.regular.interactive())
                .background(Color(red: 0.050980392156862744, green: 0, blue: 0.3137254901960784).clipShape(RoundedRectangle(cornerRadius: 48)))
                .overlay(
                    RoundedRectangle(cornerRadius: 48)
                        .stroke(Color.white, lineWidth: 0.5)
                )
                .padding(.leading)
                .padding(.trailing)
            }
            .frame(width: 280, height: 373)
            .glassEffect(.clear, in: .rect(cornerRadius: 40))
            .background(LinearGradient(colors: [Color(red: 0.3568627450980392, green: 0.3764705882352941, blue: 0.9490196078431372), Color(red: 0.023529411764705882, green: 0.027450980392156862, blue: 0.08627450980392157)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 40)))
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
}

#Preview {
    SongCard(entry: Song(imageName: "laufey", title: "Promise", artist: "Laufey", emotion: ["Happy", "Sad"], emotionIcon: ["face.smiling", "drop.fill"]))
}
