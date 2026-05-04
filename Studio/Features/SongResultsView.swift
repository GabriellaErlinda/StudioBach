import SwiftUI

struct SongResultsView: View {
    
    @State private var entries = SampleData.songs
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.07450980392156863, green: 0.07450980392156863, blue: 0.07450980392156863), Color(red: 0.0196078431372549, green: 0, blue: 0.047058823529411764)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(entries) { entry in
                        SongCard(entry: entry)
                    }
                }
            }
        }
    }
}

#Preview {
    SongResultsView()
}
