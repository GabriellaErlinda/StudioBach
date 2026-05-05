import SwiftUI

struct SongDetailView: View {
    
    let entry: Song
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color(red: 0.07450980392156863, green: 0.07450980392156863, blue: 0.07450980392156863), Color(red: 0.0196078431372549, green: 0, blue: 0.047058823529411764)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                SongDetailCard(entry: entry)
                
                VStack (alignment: .leading){
                    Text("EMOTION")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    HStack(spacing: 8) {
                        ForEach(entry.emotion.indices, id: \.self) { index in
                            EmotionDetailCard(emotion: entry.emotion[index], iconName: entry.emotionIcon[index])
                        }
                    }
                }
                
                VStack (alignment: .leading) {
                    Text("MATCHING CHORDS")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 8) {
                        ForEach(entry.chords.indices, id: \.self) { index in
                            ChordCard(chord: entry.chords[index], chordImage: entry.chordImage[index])
                        }
                    }
                }
                
                Button(action: {
                    print("Button tapped!")
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "folder.fill")
                        Text("Add to Project")
                    }
                    .padding()
                    .frame(width: 280)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .glassEffect(.regular.interactive())
                    .background(Color(red: 0.050980392156862744, green: 0, blue: 0.3137254901960784).clipShape(RoundedRectangle(cornerRadius: 48)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 48)
                            .stroke(Color.white, lineWidth: 0.5)
                    )
                }
            }
        }
    }
}

#Preview {
    SongDetailView(entry: Song(imageName: "laufey", title: "Promise", artist: "Laufey", emotion: ["Happy", "Sad"], emotionIcon: ["face.smiling", "drop.fill"]))
}
