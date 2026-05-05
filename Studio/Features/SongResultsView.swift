import SwiftUI

struct SongResultsView: View {
    
    @State private var entries = SampleData.songs
    @State private var visibleCount = 5
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.07450980392156863, green: 0.07450980392156863, blue: 0.07450980392156863), Color(red: 0.0196078431372549, green: 0, blue: 0.047058823529411764)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 10) {
                    ForEach(entries.prefix(visibleCount)) { entry in
                        SongCard(entry: entry)
                            .scrollTransition(.animated) { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
                                    .blur(radius: phase.isIdentity ? 0 : 2)
                            }
                    }
                    
                    if visibleCount < entries.count {
                        ShowMoreCard {
                            withAnimation(.spring()) {
                                visibleCount += 5
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 60)
            .offset(y: -40)
        }
    }
}

struct ShowMoreCard: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                
                Text("SHOW MORE")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 280, height: 373)
            .glassEffect(.clear, in: .rect(cornerRadius: 40))
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
                    .background(Color.white.opacity(0.05))
            )
        }
    }
}

#Preview {
    SongResultsView()
}
