import SwiftUI

struct SongCard: View {
    
    let entry: Song
    
    var body: some View {
        ZStack {
            // LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]), startPoint: .top, endPoint: .bottom)
            VStack(spacing: 5) {
                Image(entry.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .font(.system(size: 100))
                    .frame(width: 192, height: 192, alignment: .center)
                    .clipShape(Circle())
                    .padding(.bottom)
                    .scaledToFill()
                
                Text(entry.title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(entry.artist)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(red: 0.5294117647058824, green: 0.6, blue: 0.9372549019607843))
                    .padding(.bottom, 20)
                
                NavigationLink("SEE DETAILS") {
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
                //.foregroundStyle(.white)
                .fontWeight(.bold)
                .glassEffect(.regular.interactive())
                .background(Color(red: 0.050980392156862744, green: 0, blue: 0.3137254901960784).clipShape(RoundedRectangle(cornerRadius: 48)))
                .padding(.leading)
                .padding(.trailing)
            }
            .frame(width: 280, height: 373)
            .glassEffect(.clear, in: .rect(cornerRadius: 40))
            .background(LinearGradient(colors: [Color(red: 0.3568627450980392, green: 0.3764705882352941, blue: 0.9490196078431372), Color(red: 0.023529411764705882, green: 0.027450980392156862, blue: 0.08627450980392157)], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 40)))
        }
    }
}

#Preview {
    SongCard(entry: Song(imageName: "laufey", title: "Promise", artist: "Laufey"))
}
